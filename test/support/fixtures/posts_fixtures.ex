defmodule WaveletFM.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WaveletFM.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        heat: 42,
        love: 42,
        mood: 42,
        wacky: 42,
        wavelet: "some wavelet"
      })
      |> WaveletFM.Posts.create_post()

    post
  end
end
