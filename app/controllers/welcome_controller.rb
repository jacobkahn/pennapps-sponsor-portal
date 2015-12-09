class WelcomeController < ApplicationController
  def index
    redirect_to current_user if logged_in?
  end
end
