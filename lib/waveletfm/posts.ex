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
        preload: :wavelet,
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
    %Post{fm_id: fm.id, wavelet_id: wavelet.id}
    |> Post.changeset(%{})
    |> Repo.insert()
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

  alias WaveletFM.Posts.Reaction

  @doc """
  Returns the list of reaction.

  ## Examples

      iex> list_reaction()
      [%Reaction{}, ...]

  """
  def list_reaction do
    Repo.all(Reaction)
  end

  @doc """
  Gets the reactions on a post, done by fm.

  Returns a Reaction with all values set to false if the Reaction does not exist.

  ## Examples

      iex> get_reaction(post, fm)
      %Reaction{}

      iex> get_reaction(post, fm)
      nil

  """
  def get_reaction(post, fm) do
    query =
      from reaction in Reaction,
        where: reaction.fm_id == ^fm.id,
        where: reaction.post_id == ^post.id,
        select: reaction
    case Repo.one(query) do
      nil -> %Reaction{love: false, heat: false}
      reaction -> reaction
    end
  end

  @doc """
  Creates a reaction.

  ## Examples

      iex> create_reaction(%{field: value})
      {:ok, %Reaction{}}

      iex> create_reaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reaction(fm, post, attrs \\ %{}) do
    %Reaction{fm_id: fm.id, post_id: post.id}
    |> Reaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reaction.

  ## Examples

      iex> update_reaction(reaction, %{field: new_value})
      {:ok, %Reaction{}}

      iex> update_reaction(reaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reaction(%Reaction{} = reaction, attrs) do
    reaction
    |> Reaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reaction.

  ## Examples

      iex> delete_reaction(reaction)
      {:ok, %Reaction{}}

      iex> delete_reaction(reaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reaction(%Reaction{} = reaction) do
    Repo.delete(reaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reaction changes.

  ## Examples

      iex> change_reaction(reaction)
      %Ecto.Changeset{data: %Reaction{}}

  """
  def change_reaction(%Reaction{} = reaction, attrs \\ %{}) do
    Reaction.changeset(reaction, attrs)
  end
end
