defmodule PfuWeb.PostLive.PostComponent do
  use PfuWeb, :live_component

  # plug :authenticate_user when action in [:index, :show]

  def render(assigns) do
    ~L"""
    <div id="post-<%= @post.id %>" class="post">
      <div class="row">
        <div class="column column-10">
          <div class="post-avatar">
            <img src="https://avatarfiles.alphacoders.com/103/103373.png" height="32" alt="<%= @post.username %>">
          </div>
        </div>
        <div class="column column-90 post-body">
          <b>@<%= @post.username %></b>
          <br/>
          <%= @post.body %>
        </div>
      </div>

      <div class="row">
        <div class=column>
          <button href="#" phx-click="like" phx-target="<%= @myself %>">
            <i class="fa fa-heart"></i> <%= @post.likes_count %>
            Like
          </button>
        </div>
        <div class=column>
          <button href="#" phx-click="repost" phx-target="<%= @myself %>">
            <i class="fa fa-retweet"></i> <%= @post.reposts_count %>
            Retweet
          </button>
        </div>
        <div class="column">
          <%= live_patch to: Routes.post_index_path(@socket, :edit, @post.id) do %>
            <button>Edit</button>
          <% end %>
          <%= link to: "#", phx_click: "delete", phx_value_id: @post.id, data: [confirm: "Are you sure?"] do %>
            <button>Delete</button>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("like", _, socket) do
    Pfu.Timeline.inc_likes(socket.assigns.post)
    {:noreply, socket}
  end
  def handle_event("repost", _, socket) do
    Pfu.Timeline.inc_reposts(socket.assigns.post)
    {:noreply, socket}
  end
end
