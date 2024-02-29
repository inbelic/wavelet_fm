defmodule External.Spotify do

  alias External.Spotify # To use the struct
  alias WaveletFM.Wavelets.Wavelet
  alias HTTPoison.Response

  defstruct access: nil, type: "Bearer", expires: 0

  defp client_id, do: Application.get_env(:waveletfm, :spotify_client_id)
  defp client_secret, do: Application.get_env(:waveletfm, :spotify_client_secret)
  defp credentials, do: "client_id=#{client_id()}&client_secret=#{client_secret()}"

  defp authenticate(%Spotify{} = spotify) do
    if spotify.expires > 60 && spotify.access != nil do
      {:ok, spotify}
    else
      case request_token() do
        {:error, _} ->
          # client_id and client_secret are not loaded properly in
          # application, hence an unrecoverable error
          {:error, :unrecoverable}
        {:ok, spotify} -> {:ok, spotify}
      end
    end
  end

  defp request_token() do
    url = "https://accounts.spotify.com/api/token"
    body = "grant_type=client_credentials&#{credentials()}"
    headers = [ {"Content-Type", "application/x-www-form-urlencoded"} ]
    with {:ok, %Response{body: body}} <- HTTPoison.post(url, body, headers),
         {:ok, response} <- Poison.decode(body) do
      case response do
        %{"access_token" => access, "expires_in" => expires, "token_type" => type} ->
          {:ok, %Spotify{access: access, type: type, expires: expires}}
        %{"error_description" => error} ->
          {:error, error}
      end
    end
  end

  @doc """
  search the Spotify WebAPI for a list of track given the title and artist

  track_search(socket, "Down By The River", "Milky Chance") -> [%Wavelet{}]

  """
  def track_search(spotify, title, artist) do
    url = 'https://api.spotify.com/v1/search?q='
    query =
      URI.encode(title)
      <> "%20"
      <> URI.encode(artist)
      <> "%2520track%3A"
      <> URI.encode(title)
      <> "%2520artist%3A"
      <> URI.encode(artist)
      <> "&type=track"
      <> "&limit=25"
    search = url ++ to_charlist(URI.encode(query))

    {:ok, spotify} = authenticate(spotify)
    headers = [ spotify_header(spotify) ]
    with {:ok, %Response{body: body}} <- HTTPoison.get(search, headers),
         {:ok, response} = Poison.decode(body) do
      case response do
        %{"error_description" => _error} -> :error # to handle
        _ ->
          wavelets = parse_body(response)
          {:ok, spotify, wavelets}
      end
    end
  end

  defp spotify_header(%{access: access, type: type}) do
    {"Authorization", "#{type} #{access}"}
  end

  defp parse_body(%{"tracks" => %{"items" => items}}) do
    items
    |> Enum.reduce([], fn x, acc -> [parse_wavelet(x)| acc] end)
    |> Enum.reverse()
  end

  defp parse_wavelet(item) do
    %{"name" => title, "id" => track_id, "artists" => artist_objs,
      "album" => %{"images" => [%{"url" => cover}|_]}} = item
    [artist | _] = Enum.map(artist_objs, fn obj -> obj["name"] end)
    link = "http://open.spotify.com/track/" <> track_id
    %Wavelet{title: title, artist: artist, cover: cover, links: [link]}
  end
end
