defmodule TimeManagerWeb.SessionJSON do
  # Fonction pour renvoyer le JSON lors d'une connexion réussie
  def login(%{token: token}) do
    %{
      success: true,
      message: "Login Successful",
      token: token
    }
  end

  # Fonction pour renvoyer le JSON en cas d'erreur
  def error(%{error: error_message}) do
    %{
      success: false,
      error: error_message
    }
  end
end
