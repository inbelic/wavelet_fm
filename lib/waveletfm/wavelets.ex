defmodule WaveletFM.Wavelets do
  @moduledoc """
  The Wavelets context.
  """

  import Ecto.Query, warn: false
  alias WaveletFM.Repo

  alias WaveletFM.FMs.FM
  alias WaveletFM.Posts
  alias WaveletFM.Wavelets.Wavelet

  @doc """
  Returns the list of wavelets.

  ## Examples

      iex> list_wavelets()
      [%Wavelet{}, ...]

  """
  def list_wavelets do
    Repo.all(Wavelet)
  end

  @doc """
  Gets a single wavelet.

  Raises `Ecto.NoResultsError` if the Wavelet does not exist.

  ## Examples

      iex> get_wavelet!(123)
      %Wavelet{}

      iex> get_wavelet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wavelet!(id), do: Repo.get!(Wavelet, id)

  @doc """
  Gets a single wavelet from the title and artist.
  
  Raises `Ecto.NoResultsError` if the Wavelet does not exist.
  """
  def get_wavelet!(artist, title) do
      :crypto.hash(:md5, title <> artist)
      |> Base.encode64
      |> get_wavelet!()
  end

  @doc """
  Gets all current wavelets extracted from the posts associated to the fm.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_wavelets_by_fm(fm)
      [%Wavelet{}]

      iex> get_wavelets_by_fm(fm)
      ** (Ecto.NoResultsError)

  """
  def get_wavelets_by_fm(%FM{} = fm) do
    wavelet_ids =
      fm
      |> Posts.get_posts_by_fm()
      |> Enum.map(fn post -> post.wavelet end)

    query =
      from wavelet in Wavelet,
        where: wavelet.id in ^wavelet_ids,
        select: wavelet

    Repo.all(query)
  end

  @doc """
  Creates a wavelet.

  ## Examples

      iex> create_wavelet(%{field: value})
      {:ok, %Wavelet{}}

      iex> create_wavelet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wavelet(wavelet_or_attrs \\ %{})

  def create_wavelet(%Wavelet{} = wavelet) do
    wavelet
    |> insert_id()
    |> Wavelet.changeset(%{})
    |> Repo.insert()
  end

  def create_wavelet(attrs ) do
    %Wavelet{}
    |> Wavelet.changeset(insert_id(attrs))
    |> Repo.insert()
  end

  @doc """
  Updates a wavelet.

  ## Examples

      iex> update_wavelet(wavelet, %{field: new_value})
      {:ok, %Wavelet{}}

      iex> update_wavelet(wavelet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wavelet(%Wavelet{} = wavelet, attrs) do
    wavelet
    |> Wavelet.changeset(insert_id(attrs))
    |> Repo.update()
  end

  @doc """
  Deletes a wavelet.

  ## Examples

      iex> delete_wavelet(wavelet)
      {:ok, %Wavelet{}}

      iex> delete_wavelet(wavelet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wavelet(%Wavelet{} = wavelet) do
    Repo.delete(wavelet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wavelet changes.

  ## Examples

      iex> change_wavelet(wavelet)
      %Ecto.Changeset{data: %Wavelet{}}

  """
  def change_wavelet(%Wavelet{} = wavelet, attrs \\ %{}) do
    Wavelet.changeset(wavelet, insert_id(attrs))
  end

  defp insert_id(%Wavelet{:title => title, :artist => artist} = attrs) do
    insert_id_helper(attrs, title, artist)
  end

  defp insert_id(%{"title" => title, "artist" => artist} = attrs) do
    insert_id_helper(attrs, title, artist)
  end

  defp insert_id(attrs) do
    attrs
  end

  defp insert_id_helper(attrs, title, artist) do
    hashed_id =
      :crypto.hash(:md5, title <> artist)
      |> Base.encode64
    Map.put(attrs, "id", hashed_id)
  end
end
