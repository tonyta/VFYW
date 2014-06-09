class HomeController < ApplicationController
  def index
  end

  def show
    render json: View.find(params[:id]).get_info
  end
end
