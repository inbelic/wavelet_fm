defmodule WaveletFM.WaveletsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WaveletFM.Wavelets` context.
  """

  @doc """
  Generate a wavelet.
  """
  def wavelet_fixture(attrs \\ %{}) do
    {:ok, wavelet} =
      attrs
      |> Enum.into(%{
        artist: "some artist",
        cover: "some cover",
        hashed_id: "some hashed_id",
        links: ["option1", "option2"],
        title: "some title"
      })
      |> WaveletFM.Wavelets.create_wavelet()

    wavelet
  end
end
