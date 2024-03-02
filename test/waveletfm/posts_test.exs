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

  describe "reaction" do
    alias WaveletFM.Posts.Reaction

    import WaveletFM.PostsFixtures

    @invalid_attrs %{heat: nil, love: nil}

    test "list_reaction/0 returns all reaction" do
      reaction = reaction_fixture()
      assert Posts.list_reaction() == [reaction]
    end

    test "get_reaction!/1 returns the reaction with given id" do
      reaction = reaction_fixture()
      assert Posts.get_reaction!(reaction.id) == reaction
    end

    test "create_reaction/1 with valid data creates a reaction" do
      valid_attrs = %{heat: true, love: true}

      assert {:ok, %Reaction{} = reaction} = Posts.create_reaction(valid_attrs)
      assert reaction.heat == true
      assert reaction.love == true
    end

    test "create_reaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_reaction(@invalid_attrs)
    end

    test "update_reaction/2 with valid data updates the reaction" do
      reaction = reaction_fixture()
      update_attrs = %{heat: false, love: false}

      assert {:ok, %Reaction{} = reaction} = Posts.update_reaction(reaction, update_attrs)
      assert reaction.heat == false
      assert reaction.love == false
    end

    test "update_reaction/2 with invalid data returns error changeset" do
      reaction = reaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_reaction(reaction, @invalid_attrs)
      assert reaction == Posts.get_reaction!(reaction.id)
    end

    test "delete_reaction/1 deletes the reaction" do
      reaction = reaction_fixture()
      assert {:ok, %Reaction{}} = Posts.delete_reaction(reaction)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_reaction!(reaction.id) end
    end

    test "change_reaction/1 returns a reaction changeset" do
      reaction = reaction_fixture()
      assert %Ecto.Changeset{} = Posts.change_reaction(reaction)
    end
  end
end
