defmodule TimeManagerWeb.ErrorView do
  import Plug.Conn

  # Rendre une réponse JSON pour l'erreur 401 Unauthorized
  def render("401.json", _assigns) do
    %{error: "Unauthorized access"}
  end

  # Rendre une réponse JSON pour l'erreur 404 Not Found
  def render("404.json", _assigns) do
    %{error: "Not Found"}
  end

  # Rendre une réponse JSON pour l'erreur 500 Internal Server Error
  def render("500.json", _assigns) do
    %{error: "Internal Server Error"}
  end

  # Catch-all pour toute vue non trouvée (génère une erreur interne par défaut)
  def template_not_found(_template, _assigns) do
    %{error: "Internal Server Error"}
  end
end
