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
