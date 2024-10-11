defmodule TimeManager.TimeManagement do
  @moduledoc """
  The TimeManagement context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.TimeManagement.{Clock, Workingtime}
  alias TimeManager.Accounts.User

  def list_clocks do
    Repo.all(Clock)
  end



  def get_clock!(id), do: Repo.get!(Clock, id)

  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  def get_clocks_for_user(user_id) do
    IO.puts("Recherche des horloges pour l'utilisateur avec ID: #{user_id}")

    clocks = Repo.all(
      from c in Clock,
      where: c.user_id == ^user_id
    )

    IO.puts("Résultat de la requête: #{inspect(clocks)}")

    case clocks do
      [] ->
        IO.puts("Aucune horloge trouvée pour cet utilisateur.")
        {:error, "Aucune horloge trouvée pour cet utilisateur."}
      _ ->
        IO.puts("Horloges trouvées : #{inspect(clocks)}")
        {:ok, clocks}
    end
  end


  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  def list_workingtimes do
    Repo.all(Workingtime)
  end

  def get_workingtime!(id), do: Repo.get!(Workingtime, id)

  def get_workingtimes_for_user(user_id) do
    query = from w in Workingtime,
      where: w.user_id == ^user_id,
      order_by: [asc: w.start]

    Repo.all(query)
  end

  def get_clock_for_user(user_id) do
    query = from w in Clock,
      where: w.user_id == ^user_id

    Repo.one(query)
  end


  def get_workingtimes_for_user_by_id(user_id, id) do
    query = from w in Workingtime,
      where: w.user_id == ^user_id and w.id == ^id

    Repo.one(query)
  end


  def list_workingtimes_with_params(start, end_w) do
    Repo.all(
      from u in Workingtime,
      where: u.start == ^start and u.end_w == ^end_w
    )
  end

  def create_workingtime(attrs \\ %{}) do
    %Workingtime{}
    |> Workingtime.changeset(attrs)
    |> Repo.insert()
  end

  def update_workingtime(%Workingtime{} = workingtime, attrs) do
    workingtime
    |> Workingtime.changeset(attrs)
    |> Repo.update()
  end

  def delete_workingtime(%Workingtime{} = workingtime) do
    Repo.delete(workingtime)
  end

  def change_workingtime(%Workingtime{} = workingtime, attrs \\ %{}) do
    Workingtime.changeset(workingtime, attrs)
  end

  def get_user_by_id(user_id) do
    Repo.get(User, user_id)
  end


  def change_status_clock(%Clock{} = clock) do
    if clock.status == true do
      current_time = clock.time

      {:ok, workingtime} = create_workingtime(%{
        user_id: clock.user_id,
        start: current_time
      })

      new_status = !clock.status
      updated_time = NaiveDateTime.utc_now()

      updated_clock =
        clock
        |> Clock.changeset(%{status: new_status, time: nil})
        |> Repo.update!()

      update_workingtime(workingtime, %{end_w: updated_time})

      {:ok, updated_clock}
    else
      new_status = !clock.status
      current_time = NaiveDateTime.utc_now()

      updated_clock =
        clock
        |> Clock.changeset(%{status: new_status, time: current_time})
        |> Repo.update!()

      {:ok, updated_clock}
    end
  end


end
