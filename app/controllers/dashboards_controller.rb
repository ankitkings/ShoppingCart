# app/controllers/dashboards_controller.rb
class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    if current_user.admin?
      render :admin
    else
      render :customer
    end
  end
end
