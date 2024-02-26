defmodule WaveletFM.FMsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WaveletFM.FMs` context.
  """

  @doc """
  Generate a fm.
  """
  def fm_fixture(attrs \\ %{}) do
    {:ok, fm} =
      attrs
      |> Enum.into(%{
        freq: 120.5,
        username: "some username",
        wavelets: ["option1", "option2"]
      })
      |> WaveletFM.FMs.create_fm()

    fm
  end
end
