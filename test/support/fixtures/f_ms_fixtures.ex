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

  @doc """
  Generate a follow.
  """
  def follow_fixture(attrs \\ %{}) do
    {:ok, follow} =
      attrs
      |> Enum.into(%{

      })
      |> WaveletFM.FMs.create_follow()

    follow
  end
end
