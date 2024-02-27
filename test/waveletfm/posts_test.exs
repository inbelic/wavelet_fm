defmodule WaveletFM.PostsTest do
  use WaveletFM.DataCase

  alias WaveletFM.Posts

  describe "post" do
    alias WaveletFM.Posts.Post

    import WaveletFM.PostsFixtures

    @invalid_attrs %{wavelet: nil, heat: nil, love: nil, wacky: nil, mood: nil}

    test "list_post/0 returns all post" do
      post = post_fixture()
      assert Posts.list_post() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{wavelet: "some wavelet", heat: 42, love: 42, wacky: 42, mood: 42}

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.wavelet == "some wavelet"
      assert post.heat == 42
      assert post.love == 42
      assert post.wacky == 42
      assert post.mood == 42
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{wavelet: "some updated wavelet", heat: 43, love: 43, wacky: 43, mood: 43}

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.wavelet == "some updated wavelet"
      assert post.heat == 43
      assert post.love == 43
      assert post.wacky == 43
      assert post.mood == 43
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
