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

  def change_status_clock(user_id) do
    IO.puts("Fetching clock for user ID: #{user_id}")

    # Supposons que chaque utilisateur a un seul clock, sinon il faudra ajuster cette requête.
    clock = Repo.get_by(Clock, user_id: user_id)

    case clock do
      nil ->
        IO.puts("Clock not found for user ID: #{user_id}")
        {:error, "Clock not found"}

      %Clock{status: current_status} = clock ->
        new_status = not current_status  # Toggle the current status
        changeset = Clock.changeset(clock, %{status: new_status})

        case Repo.update(changeset) do
          {:ok, updated_clock} ->
            IO.puts("Clock updated successfully for user ID: #{user_id}")
            {:ok, updated_clock}

          {:error, changeset} ->
            IO.puts("Failed to update clock for user ID: #{user_id}")
            {:error, changeset}
        end
    end
  end


  def toggle_status(conn, %{"user_id" => user_id}) do
    IO.puts("Received request to toggle status for user ID: #{user_id}")

    case TimeManager.change_status_clock(user_id) do
      {:ok, updated_clock} ->
        IO.puts("Successfully toggled status for user ID: #{user_id}")
        json(conn, %{data: updated_clock})

      {:error, reason} ->
        IO.puts("Error toggling status for user ID: #{user_id}, Reason: #{reason}")
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
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
