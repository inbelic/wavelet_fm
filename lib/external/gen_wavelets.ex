defmodule External.GenWavelets do
  alias WaveletFM.Wavelets.Wavelet

  @doc """
  proxy function that will return some garbage wavelets to emulate external API
  searches.
  """
  def gen_search(title, artist) do
    proxies =
      [ {title, artist} | [
        {"Whispers in the Rain", "Luna Shadows"},
        {"Electric Dreams", "Nova Pulse"},
        {"Midnight Serenade", "Stella Starlight"},
        {"Neon Nights", "Echo Synth"},
        {"Solar Symphony", "Aurora Blaze"} ] ]
        |> Enum.map(fn {title, artist} ->
          %Wavelet{id: nil, title: title, artist: artist,
            cover: "", links: []}
        end)
    proxies
  end
end
