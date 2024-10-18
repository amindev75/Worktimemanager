defmodule TimeManager.Token do
  alias Joken.Config
  alias Joken.Signer

  def verify_and_validate_token(token) do
    # Utilise le signer par défaut configuré dans config.exs
    signer = Joken.Signer.parse_config(:default_signer)

    case Joken.verify(token, signer) do
      {:ok, claims} ->
        {:ok, claims}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
