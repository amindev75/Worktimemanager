alias TimeManager.TimeManagement.Workingtime
alias TimeManager.Repo
alias TimeManager.Accounts
import Enum

generate_random_working_time = fn base_date, day ->
  random_start_hour = Enum.random(6..10)
  start_time = NaiveDateTime.add(base_date, day * 86400 + random_start_hour * 3600, :second)
  random_work_duration = Enum.random(6..10)
  end_time = NaiveDateTime.add(start_time, random_work_duration * 3600, :second)
  {start_time, end_time}
end

users = [
  %{
    username: "user1",
    email: "user1@test.com",
    password: "123456",
    role: 0
  },
  %{
    username: "user2",
    email: "user2@test.com",
    password: "123456",
    role: 1
  },
  %{
    username: "user3",
    email: "user3@test.com",
    password: "123456",
    role: 2
  }
]

Enum.each(users, fn user_attrs ->
  case Accounts.create_user(user_attrs) do
    {:ok, user} ->
      base_date = ~N[2023-01-01 00:00:00]

      for month <- 1..12 do
        days_in_month = Enum.to_list(1..30)
        missed_days = Enum.take_random(days_in_month, Enum.random(2..5))
        worked_days = Enum.filter(days_in_month, fn day -> not Enum.member?(missed_days, day) end)

        Enum.each(worked_days, fn day ->
          {start_time, end_time} = generate_random_working_time.(base_date, (month - 1) * 30 + day)

          wt_attrs = %{
            start: start_time,
            end_w: end_time,
            user_id: user.id
          }

          %Workingtime{}
          |> Workingtime.changeset(wt_attrs)
          |> Repo.insert!()
        end)
      end

    {:error, changeset} ->
      IO.puts("Failed to create user: #{inspect(changeset)}")
  end
end)
