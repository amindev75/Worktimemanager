defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.TimeManagement
  alias TimeManager.TimeManagement.Clock

  action_fallback TimeManagerWeb.FallbackController


  def index(conn, %{"userId" => user_id}) do
    case TimeManagement.get_user_by_id(user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      _user ->
        case TimeManagement.get_clock_for_user(user_id) do
          nil ->
            conn
            |> put_status(:not_found)
            |> json(%{error: "No clock found for this user."})

          clock ->
            render(conn, "show.json", clock: clock)
        end
    end
  end


  def create(conn, %{"clock" => clock_params, "userId" => user_id}) do
    updated_params = Map.put(clock_params, "user_id", String.to_integer(user_id))

    with {:ok, %Clock{} = clock} <- TimeManagement.create_clock(updated_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock}")
      |> render(:show, clock: clock)
    end
  end

  def change_status_clock(clock_id) do
    clock = Repo.get(Clock, clock_id)

    case clock do
      nil ->
        {:error, "Clock not found"}

      %Clock{status: current_status} = clock ->
        new_status = not current_status  # Toggle the current status
        changeset = Clock.changeset(clock, %{status: new_status})

        case Repo.update(changeset) do
          {:ok, updated_clock} ->
            {:ok, updated_clock}  # Return the updated clock
          {:error, changeset} ->
            {:error, changeset}  # Return the changeset in case of an error
        end
    end
  end




  def show(conn, %{"id" => id}) do
    clock = TimeManagement.get_clock!(id)
    render(conn, :show, clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = TimeManagement.get_clock!(id)

    with {:ok, %Clock{} = clock} <- TimeManagement.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = TimeManagement.get_clock!(id)

    with {:ok, %Clock{}} <- TimeManagement.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
