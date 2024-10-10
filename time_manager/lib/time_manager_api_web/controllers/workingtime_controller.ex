defmodule TimeManagerWeb.WorkingtimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.TimeManagement
  alias TimeManager.TimeManagement.Workingtime

  action_fallback TimeManagerWeb.FallbackController

  # def index(conn, _params) do
  #   workingtimes = TimeManagement.list_workingtimes()
  #   render(conn, :index, workingtimes: workingtimes)
  # end

  def index(conn, params) do
    workingtimes = case params do
      %{"start" => start, "end_w" => end_w} ->
        TimeManagement.list_workingtimes_with_params(start, end_w)
      _ ->
        TimeManagement.list_workingtimes()
    end

    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create(conn, %{"workingtime" => workingtime_params, "userId" => user_id}) do
    updated_params = Map.put(workingtime_params, "user_id", String.to_integer(user_id))

    with {:ok, %Workingtime{} = workingtime} <- TimeManagement.create_workingtime(updated_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{workingtime}")
      |> render(:show, workingtime: workingtime)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end


  def get_workingtimes(conn, %{"userId" => user_id}) do
    case TimeManagement.get_user_by_id(user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      _user ->
        workingtimes = TimeManagement.get_workingtimes_for_user(user_id)
        render(conn, "index.json", workingtimes: workingtimes)
    end
  end


  def get_workingtimes_by_id(conn, %{"userId" => user_id,"id" => id }) do
    workingtimes = TimeManagement.get_workingtimes_for_user_by_id(user_id, id)

    render(conn, "index.json", workingtimes: workingtimes)
  end



  def show(conn, %{"id" => id}) do
    workingtime = TimeManagement.get_workingtime!(id)
    render(conn, :show, workingtime: workingtime)
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = TimeManagement.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <- TimeManagement.update_workingtime(workingtime, workingtime_params) do
      render(conn, :show, workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = TimeManagement.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- TimeManagement.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end
end
