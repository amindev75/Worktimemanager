defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.TimeManagement
  alias TimeManager.TimeManagement.Clock

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    clocks = TimeManagement.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- TimeManagement.create_clock(clock_params) do
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
end
