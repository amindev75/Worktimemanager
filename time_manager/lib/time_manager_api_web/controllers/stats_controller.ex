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

  def calculate_percentage_working_times_outside_standard_hours(conn, %{"userId" => user_id}) do
    start_standard_time = ~T[08:00:00]
    end_standard_time = ~T[16:00:00]
    query = from w in Workingtime,
            where: w.user_id == ^user_id,
            select: {w.start, w.end_w}
    working_times = Repo.all(query)
    total_working_times = length(working_times)
    outside_standard_hours =
      working_times
      |> Enum.filter(fn {start_time, end_time} ->
        start_time_hour = Time.truncate(NaiveDateTime.to_time(start_time), :second)
        end_time_hour = Time.truncate(NaiveDateTime.to_time(end_time), :second)
        start_time_hour < start_standard_time or start_time_hour > end_standard_time or
        end_time_hour < start_standard_time or end_time_hour > end_standard_time
      end)
    total_outside_standard_hours = length(outside_standard_hours)
    percentage_outside_standard_hours =
      if total_working_times > 0 do
        total_outside_standard_hours * 100 / total_working_times
      else
        0
      end
    json(conn, %{percentage_outside_standard_hours: percentage_outside_standard_hours})
  end

  def calculate_average_hours_worked_by_month(conn, %{"userId" => user_id}) do
    current_date = NaiveDateTime.utc_now()
    start_date = ~N[2023-01-01 00:00:00]
    end_date = ~N[2024-01-01 00:00:00]
    query = from w in Workingtime,
            where: w.user_id == ^user_id and w.start >= ^start_date and w.start <= ^end_date,
            select: {fragment("date_part('month', ?)", w.start), w.start, w.end_w}
    working_times = Repo.all(query)
    working_times_by_month = working_times
    |> Enum.group_by(fn {month, _start, _end_w} -> month end)
    average_hours_by_month = for month <- 1..12 do
      case Map.get(working_times_by_month, month |> Kernel.+(0.0)) do
        nil ->
          0
        times ->
          total_hours = Enum.reduce(times, 0, fn {_month, start_time, end_time}, acc ->
            diff_in_seconds = NaiveDateTime.diff(end_time, start_time)
            acc + div(diff_in_seconds, 3600)
          end)
          total_days = Enum.uniq_by(times, fn {_month, start_time, _end_w} -> NaiveDateTime.to_date(start_time) end) |> length()
          if total_days > 0 do
            div(total_hours, total_days)
          else
            0
          end
      end
    end
    json(conn, %{average_hours_by_month: average_hours_by_month})
  end
end
