defmodule WaveletFM.WaveletsTest do
  use WaveletFM.DataCase

  alias WaveletFM.Wavelets

  describe "wavelets" do
    alias WaveletFM.Wavelets.Wavelet

    import WaveletFM.WaveletsFixtures

    @invalid_attrs %{links: nil, title: nil, cover: nil, artist: nil, hashed_id: nil}

    test "list_wavelets/0 returns all wavelets" do
      wavelet = wavelet_fixture()
      assert Wavelets.list_wavelets() == [wavelet]
    end

    test "get_wavelet!/1 returns the wavelet with given id" do
      wavelet = wavelet_fixture()
      assert Wavelets.get_wavelet!(wavelet.id) == wavelet
    end

    test "create_wavelet/1 with valid data creates a wavelet" do
      valid_attrs = %{links: ["option1", "option2"], title: "some title", cover: "some cover", artist: "some artist", hashed_id: "some hashed_id"}

      assert {:ok, %Wavelet{} = wavelet} = Wavelets.create_wavelet(valid_attrs)
      assert wavelet.links == ["option1", "option2"]
      assert wavelet.title == "some title"
      assert wavelet.cover == "some cover"
      assert wavelet.artist == "some artist"
      assert wavelet.hashed_id == "some hashed_id"
    end

    test "create_wavelet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wavelets.create_wavelet(@invalid_attrs)
    end

    test "update_wavelet/2 with valid data updates the wavelet" do
      wavelet = wavelet_fixture()
      update_attrs = %{links: ["option1"], title: "some updated title", cover: "some updated cover", artist: "some updated artist", hashed_id: "some updated hashed_id"}

      assert {:ok, %Wavelet{} = wavelet} = Wavelets.update_wavelet(wavelet, update_attrs)
      assert wavelet.links == ["option1"]
      assert wavelet.title == "some updated title"
      assert wavelet.cover == "some updated cover"
      assert wavelet.artist == "some updated artist"
      assert wavelet.hashed_id == "some updated hashed_id"
    end

    test "update_wavelet/2 with invalid data returns error changeset" do
      wavelet = wavelet_fixture()
      assert {:error, %Ecto.Changeset{}} = Wavelets.update_wavelet(wavelet, @invalid_attrs)
      assert wavelet == Wavelets.get_wavelet!(wavelet.id)
    end

    test "delete_wavelet/1 deletes the wavelet" do
      wavelet = wavelet_fixture()
      assert {:ok, %Wavelet{}} = Wavelets.delete_wavelet(wavelet)
      assert_raise Ecto.NoResultsError, fn -> Wavelets.get_wavelet!(wavelet.id) end
    end

    test "change_wavelet/1 returns a wavelet changeset" do
      wavelet = wavelet_fixture()
      assert %Ecto.Changeset{} = Wavelets.change_wavelet(wavelet)
    end
  end
end
