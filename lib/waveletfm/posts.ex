defmodule WaveletFM.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias WaveletFM.Repo

  alias WaveletFM.FMs.FM
  alias WaveletFM.Posts.Post
  alias WaveletFM.Wavelets.Wavelet

  @doc """
  Returns the list of post.

  ## Examples

      iex> list_post()
      [%Post{}, ...]

  """
  def list_post do
    Repo.all(Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Gets all current posts associated to the fm.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_posts_by_fm(fm)
      [%Post{}]

      iex> get_posts_by_fm(fm)
      ** (Ecto.NoResultsError)

  """
  def get_posts_by_fm(%FM{} = fm) do
    query =
      from post in Post,
        join: fm in assoc(post, :fm),
        where: fm.id == ^fm.id,
        select: post,
        order_by: [desc: :inserted_at],
        limit: 5

    Repo.all(query)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%FM{} = fm, %Wavelet{} = wavelet)
      {:ok, %Post{}}

      iex> create_post(%FM{} = fm, %Wavelet{} = wavelet)
      {:error, %Ecto.Changeset{}}

  """
  def create_post(%FM{} = fm, %Wavelet{} = wavelet) do
    attrs = init_attrs(wavelet.id)

    fm
    |> Ecto.build_assoc(:posts)
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  defp init_attrs(id) do
    %{"wavelet" => id, "heat" => 0, "love" => 0, "wacky" => 0, "mood" => 0}
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
