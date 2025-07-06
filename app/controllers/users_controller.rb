class UsersController < ApplicationController
  def index
    @users = User.where(role: "customer").order(created_at: :desc)
  end
end
