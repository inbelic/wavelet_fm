defmodule WaveletFM.FMs do
  @moduledoc """
  The FMs context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias WaveletFM.Repo

  alias WaveletFM.FMs.FM
  alias WaveletFM.Accounts.User

  @doc """
  Returns the list of fms.

  ## Examples

      iex> list_fms()
      [%FM{}, ...]

  """
  def list_fms do
    query =
      from fm in FM,
        select: fm,
        preload: [posts: [:wavelet]]
    Repo.all(query)
  end

  @doc """
  Gets a single fm with assocs preloaded.

  ## Examples

      iex> get_fm(123)
      %FM{}

      iex> get_fm(456)
      ** (Ecto.NoResultsError)

  """
  def get_fm(id) do
    fm = Repo.get(FM, id)
    Repo.preload fm, posts: [:wavelet]
  end

  @doc """
  Gets a single fm.

  Raises `Ecto.NoResultsError` if the Fm does not exist.

  ## Examples

      iex> get_fm!(123)
      %FM{}

      iex> get_fm!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fm!(id), do: Repo.get!(FM, id)

  @doc """
  Gets a single fm through the user_assoc.

  Raises `Ecto.NoResultsError` if the Fm does not exist.

  ## Examples

      iex> get_fm_by_user!(user)
      %FM{}

      iex> get_fm_by_user!(user)
      ** (Ecto.NoResultsError)

  """
  def get_fm_by_user(%User{id: id}) do
    query =
      from fm in FM, where: [user_id: ^id],
        select: fm

    Repo.one(query)
  end

  @doc """
  Creates a fm.

  ## Examples

      iex> create_fm(user, %{field: value})
      {:ok, %FM{}}

      iex> create_fm(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fm(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:fms)
    |> FM.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fm.

  ## Examples

      iex> update_fm(fm, %{field: new_value})
      {:ok, %FM{}}

      iex> update_fm(fm, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fm(%FM{} = fm, user, password, attrs) do
    changeset = fm |> FM.changeset(attrs)
    if User.valid_password?(user, password) do
      changeset |> Repo.update()
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  @doc """
  Deletes a fm.

  ## Examples

      iex> delete_fm(fm)
      {:ok, %FM{}}

      iex> delete_fm(fm)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fm(%FM{} = fm) do
    Repo.delete(fm)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fm changes.

  ## Examples

      iex> change_fm(fm)
      %Ecto.Changeset{data: %FM{}}

  """
  def change_fm(%FM{} = fm, attrs \\ %{}, opts \\ []) do
    FM.changeset(fm, attrs, opts)
  end

  alias WaveletFM.FMs.Follow

  @doc """
  Returns the list of follow.

  ## Examples

      iex> list_follow()
      [%Follow{}, ...]

  """
  def list_follow do
    Repo.all(Follow)
  end

  @doc """
  Gets a single follow.

  Raises `Ecto.NoResultsError` if the Follow does not exist.

  ## Examples

      iex> get_follow!(123)
      %Follow{}

      iex> get_follow!(456)
      ** (Ecto.NoResultsError)

  """
  def get_follow!(id), do: Repo.get!(Follow, id)

  @doc """
  Creates a follow.

  ## Examples

      iex> create_follow(%{field: value})
      {:ok, %Follow{}}

      iex> create_follow(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_follow(%FM{} = to, %FM{} = from) do
    id = follow_id(to.id, from.id)
    %Follow{id: id, to: to.id, from: from.id}
    |> Follow.changeset(%{})
    |> Repo.insert()
  end

  @doc """
  Deletes a follow.

  ## Examples

      iex> delete_follow(follow)
      {:ok, %Follow{}}

      iex> delete_follow(follow)
      {:error, %Ecto.Changeset{}}

  """
  def delete_follow(%Follow{} = follow) do
    Repo.delete(follow)
  end

  defp follow_id(to_id, from_id) do
    :crypto.hash(:sha256, to_id <> from_id)
    |> Base.encode64
  end
end
