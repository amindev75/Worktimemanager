defmodule TimeManagerWeb.StatsController do
  use TimeManagerWeb, :controller
  alias TimeManager.TimeManagement.Workingtime
  alias TimeManager.Repo
  import Ecto.Query

  def calculate_worked_days_by_month(conn, %{"userId" => user_id}) do
    start_of_year = ~N[2023-01-01 00:00:00]
    end_of_year = ~N[2024-01-01 00:00:00]

    query = from w in Workingtime,
            where: w.user_id == ^user_id and w.start >= ^start_of_year and w.start < ^end_of_year,
            select: {fragment("date_part('month', ?)", w.start), fragment("date(?)", w.start)}

    working_times = Repo.all(query)

    if Enum.empty?(working_times) do

    end

    working_times_by_month = working_times
    |> Enum.group_by(fn {month, _date} -> month end, fn {_month, date} -> date end)

    worked_days_by_month = for month <- 1..12 do
      unique_days =
        case Map.get(working_times_by_month, month |> Kernel.+(0.0)) do
          nil -> 0
          dates ->
            unique_dates = Enum.uniq(dates)
            length(unique_dates)
        end
      unique_days
    end

    json(conn, %{worked_days_by_month: worked_days_by_month})
  end



end
