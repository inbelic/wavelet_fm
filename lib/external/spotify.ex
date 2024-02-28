defmodule External.Spotify do

  alias External.Spotify # To use the struct
  alias WaveletFM.Wavelets.Wavelet
  alias HTTPoison.Response

  defstruct token: %{access: nil, type: "Bearer", expires: 0}

  defp client_id, do: Application.get_env(:waveletfm, :spotify_client_id)
  defp client_secret, do: Application.get_env(:waveletfm, :spotify_client_secret)
  defp credentials, do: "client_id=#{client_id()}&client_secret=#{client_secret()}"

  defp authenticate(%Spotify{} = spotify) do
    case valid_token?(spotify.token) do
      :true -> {:ok, spotify}
      _ ->
        {:ok, token} = request_token()
        {:ok, %Spotify{spotify | token: token}}
    end
  end

  defp valid_token?(%{access: access, type: "Bearer", expires: expires}) do
    expires > 60 && access != nil
  end

  defp valid_token?(_) do
    :false
  end

  defp request_token() do
    url = "https://accounts.spotify.com/api/token"
    body = "grant_type=client_credentials&#{credentials()}"
    headers = [ {"Content-Type", "application/x-www-form-urlencoded"} ]
    with {:ok, %Response{body: body}} <- HTTPoison.post(url, body, headers),
         {:ok, response} <- Poison.decode(body) do
      case response do
        %{"access_token" => access, "expires_in" => expires, "token_type" => type} ->
          {:ok, %{access: access, type: type, expires: expires}}
        %{"error_description" => _error} -> {:error, nil} # to handle
      end
    end
    {:ok, %{access: nil, type: "Bearer", expires: 0}}
  end


  @doc """
  search the Spotify WebAPI for a list of track given the title and artist

  track_search(socket, "Down By The River", "Milky Chance") -> [%Wavelet{}]

  """
  def track_search(spotify, title, artist) do
    {:ok, _} = authenticate(spotify)
    []
  end
end
