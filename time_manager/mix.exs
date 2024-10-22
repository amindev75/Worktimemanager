defmodule TimeManager.MixProject do
  use Mix.Project

  def project do
    [
      app: :time_manager_api,  # Nom de l'application
      version: "0.1.0",
      elixir: "~> 1.13",  # Version d'Elixir
      elixirc_paths: elixirc_paths(Mix.env()),  # Chemins à compiler en fonction de l'environnement
      start_permanent: Mix.env() == :prod,  # Démarrage permanent en production
      aliases: aliases(),  # Alias pour les tâches Mix
      deps: deps()  # Dépendances du projet
    ]
  end

  # Configuration de l'application OTP
  def application do
    [
      mod: {TimeManager.Application, []},  # Module principal de l'application
      extra_applications: [:logger, :runtime_tools]  # Applications supplémentaires
    ]
  end

  # Spécifie les chemins à compiler par environnement
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Spécifie les dépendances du projet
  defp deps do
    [
      {:phoenix, "~> 1.7.14"},  # Framework Phoenix
      {:phoenix_ecto, "~> 4.5"},  # Intégration d'Ecto avec Phoenix
      {:cors_plug, "~> 3.0"},  # Support CORS
      {:ecto_sql, "~> 3.10"},  # Gestion des bases de données avec Ecto
      {:postgrex, ">= 0.0.0"},  # Adaptateur PostgreSQL pour Ecto
      {:bcrypt_elixir, "~> 3.0"},  # Hashing des mots de passe
      {:comeonin, "~> 5.0"},  # Gestion des mots de passe
      {:phoenix_live_dashboard, "~> 0.8.3"},  # Tableau de bord en direct pour Phoenix
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},  # Outil de construction JavaScript
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},  # Framework CSS
      {:tzdata, "~> 1.1"},  # Données de fuseau horaire
      {:joken, "~> 2.0"},  # Gestion des JSON Web Tokens
      {:jose, "~> 1.11"},  # Bibliothèque JWT
      {:heroicons, "~> 0.5.5"},  # Icônes Heroicons
      {:swoosh, "~> 1.5"},  # Envoi d'e-mails
      {:finch, "~> 0.13"},  # Client HTTP
      {:telemetry_metrics, "~> 1.0"},  # Outils de métriques de télémétrie
      {:telemetry_poller, "~> 1.0"},  # Outils de poller de télémétrie
      {:gettext, "~> 0.20"},  # Internationalisation
      {:jason, "~> 1.2"},  # Décodeur JSON
      {:dns_cluster, "~> 0.1.1"},  # Client DNS
      {:bandit, "~> 1.5"},  # Serveur HTTP
      {:phoenix_html, "~> 3.0"}  # Vues HTML pour Phoenix
    ]
  end

  # Aliases pour des tâches spécifiques au projet
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind time_manager_api", "esbuild time_manager_api"],
      "assets.deploy": [
        "tailwind time_manager_api --minify",
        "esbuild time_manager_api --minify",
        "phx.digest"
      ]
    ]
  end
end
