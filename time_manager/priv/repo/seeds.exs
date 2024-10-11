alias TimeManager.Accounts.User
alias TimeManager.TimeManagement.Workingtime
alias TimeManager.Repo
import Ecto.Query
import Enum

# Générer une fonction anonyme pour générer des heures aléatoires de début et de fin
generate_random_working_time = fn base_date, day ->
  # Génère un décalage aléatoire pour l'heure de début (entre 6h et 10h)
  random_start_hour = Enum.random(6..10)
  start_time = NaiveDateTime.add(base_date, day * 86400 + random_start_hour * 3600, :second)

  # Durée aléatoire de travail entre 6 et 10 heures
  random_work_duration = Enum.random(6..10)
  end_time = NaiveDateTime.add(start_time, random_work_duration * 3600, :second)

  {start_time, end_time}
end

# Créer des utilisateurs
users = [
  %{
    username: "user1",
    email: "user1@example.com"
  },
  %{
    username: "user2",
    email: "user2@example.com"
  },
  %{
    username: "user3",
    email: "user3@example.com"
  }
]

Enum.each(users, fn user_attrs ->
  user = %User{}
  |> User.changeset(user_attrs)
  |> Repo.insert!()

  base_date = ~N[2023-01-01 00:00:00]

  # Générer 365 working times pour chaque utilisateur avec des heures variées
  working_times = for day <- 1..365 do
    {start_time, end_time} = generate_random_working_time.(base_date, day)

    %{
      start: start_time,
      end_w: end_time,
      user_id: user.id
    }
  end

  Enum.each(working_times, fn wt_attrs ->
    %Workingtime{}
    |> Workingtime.changeset(wt_attrs)
    |> Repo.insert!()
  end)
end)
