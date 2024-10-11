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

  def toggle_status(conn, %{"userId" => user_id}) do
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
            case TimeManagement.change_status_clock(clock) do
              {:ok, updated_clock} ->
                conn
                |> put_status(:ok)
                |> json(%{
                  success: "Clock status updated and workingtime created and updated",
                  clock: updated_clock
                })

              {:error, reason} ->
                conn
                |> put_status(:bad_request)
                |> json(%{error: "Failed to update clock", reason: reason})
            end
        end
    end
  end





end
