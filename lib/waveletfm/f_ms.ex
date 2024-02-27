defmodule WaveletFM.FMs do
  @moduledoc """
  The FMs context.
  """

  import Ecto.Query, warn: false
  alias WaveletFM.Repo

  alias WaveletFM.FMs.FM

  @doc """
  Returns the list of fms.

  ## Examples

      iex> list_fms()
      [%FM{}, ...]

  """
  def list_fms do
    Repo.all(FM)
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
  def update_fm(%FM{} = fm, attrs) do
    fm
    |> FM.changeset(attrs)
    |> Repo.update()
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
  def change_fm(%FM{} = fm, attrs \\ %{}) do
    FM.changeset(fm, attrs)
  end
end
