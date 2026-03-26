class Api::V1::RelationshipsController < ApplicationController
  def create
    current_user = User.includes(date_spot_reviews: :date_spot, courses: {date_spots: :date_spot_reviews}).find(params[:current_user_id])
    followed_user = User.includes(date_spot_reviews: :date_spot, courses: {date_spots: :date_spot_reviews}).find(params[:followed_user_id])
    following = current_user.follow(followed_user)

    if following.nil?
      render status: :unprocessable_entity, json: {error_messages: ["自分自身をフォローすることはできません"]}
      return
    end

    if following.save
      users = User.includes(:followers, :followings, date_spot_reviews: :date_spot, courses: {date_spots: :date_spot_reviews}).non_admins

      render status: :created, json: {
        users: users.map { |user| UserSerializer.new(user).attributes },
        current_user: UserSerializer.new(current_user).attributes,
        followed_user: UserSerializer.new(followed_user).attributes
      }
    else
      render status: :unprocessable_entity, json: {error_messages: following.errors.full_messages}
    end
  end

  def destroy
    current_user = User.includes(date_spot_reviews: :date_spot, courses: {date_spots: :date_spot_reviews}).find(params[:current_user_id])
    unfollowed_user = User.includes(date_spot_reviews: :date_spot, courses: {date_spots: :date_spot_reviews}).find(params[:other_user_id])
    unfollowing = current_user.unfollow(unfollowed_user)

    if unfollowing.destroy
      users = User.includes(:followers, :followings, date_spot_reviews: :date_spot, courses: {date_spots: :date_spot_reviews}).non_admins

      render status: :ok, json: {
        users: users.map { |user| UserSerializer.new(user).attributes },
        current_user: UserSerializer.new(current_user).attributes,
        unfollowed_user: UserSerializer.new(unfollowed_user).attributes
      }
    else
      render status: :unprocessable_entity, json: {error_messages: unfollowing.errors.full_messages}
    end
  end

  def followings
    user = User.find(params[:user_id])

    followings = user.followings.includes(:followers, :followings, date_spot_reviews: :date_spot, courses: {date_spots: :date_spot_reviews}).non_admins

    render status: :ok, json: {user_name: user.name, users: followings.map { |user| UserSerializer.new(user).attributes }}
  end

  def followers
    user = User.find(params[:user_id])

    followers = user.followers.includes(:followers, :followings, date_spot_reviews: :date_spot, courses: {date_spots: :date_spot_reviews}).non_admins

    render status: :ok, json: {user_name: user.name, users: followers.map { |user| UserSerializer.new(user).attributes }}
  end
end
