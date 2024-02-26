defmodule WaveletFM.FMsTest do
  use WaveletFM.DataCase

  alias WaveletFM.FMs

  describe "fms" do
    alias WaveletFM.FMs.FM

    import WaveletFM.FMsFixtures

    @invalid_attrs %{username: nil, freq: nil, wavelets: nil}

    test "list_fms/0 returns all fms" do
      fm = fm_fixture()
      assert FMs.list_fms() == [fm]
    end

    test "get_fm!/1 returns the fm with given id" do
      fm = fm_fixture()
      assert FMs.get_fm!(fm.id) == fm
    end

    test "create_fm/1 with valid data creates a fm" do
      valid_attrs = %{username: "some username", freq: 120.5, wavelets: ["option1", "option2"]}

      assert {:ok, %FM{} = fm} = FMs.create_fm(valid_attrs)
      assert fm.username == "some username"
      assert fm.freq == 120.5
      assert fm.wavelets == ["option1", "option2"]
    end

    test "create_fm/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FMs.create_fm(@invalid_attrs)
    end

    test "update_fm/2 with valid data updates the fm" do
      fm = fm_fixture()
      update_attrs = %{username: "some updated username", freq: 456.7, wavelets: ["option1"]}

      assert {:ok, %FM{} = fm} = FMs.update_fm(fm, update_attrs)
      assert fm.username == "some updated username"
      assert fm.freq == 456.7
      assert fm.wavelets == ["option1"]
    end

    test "update_fm/2 with invalid data returns error changeset" do
      fm = fm_fixture()
      assert {:error, %Ecto.Changeset{}} = FMs.update_fm(fm, @invalid_attrs)
      assert fm == FMs.get_fm!(fm.id)
    end

    test "delete_fm/1 deletes the fm" do
      fm = fm_fixture()
      assert {:ok, %FM{}} = FMs.delete_fm(fm)
      assert_raise Ecto.NoResultsError, fn -> FMs.get_fm!(fm.id) end
    end

    test "change_fm/1 returns a fm changeset" do
      fm = fm_fixture()
      assert %Ecto.Changeset{} = FMs.change_fm(fm)
    end
  end
end
