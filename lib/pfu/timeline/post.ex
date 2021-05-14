defmodule Pfu.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  # schema "posts" do
  #   field :body, :string
  #   field :likes_count, :integer, default: 0
  #   field :reposts_count, :integer, default: 0
  #   field :username, :string
  #   belongs_to :user, Pfu.User

  #   timestamps()
  # end

  schema "posts" do
    field :body, :string
    field :likes_count, :integer, default: 0
    field :reposts_count, :integer, default: 0
    belongs_to :user, Pfu.User
    #field :user_id, :id

    timestamps()
  end

  # @doc false
  # def changeset(post, attrs) do
  #   post
  #   |> cast(attrs, [:body])
  #   |> validate_required([:body])
  #   |> validate_length(:body, min: 2, max: 250)
  # end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :user_id])
    |> validate_required([:body, :user_id])
    |> validate_length(:body, min: 3, max: 8192)
  end
end
