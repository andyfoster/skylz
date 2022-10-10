class StaticPagesController < ApplicationController
  def home
    render :layout => "guest"
  end
end
