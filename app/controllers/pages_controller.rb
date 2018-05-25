class PagesController < ApplicationController
  before_action :verify_page

  def show
    @root_status = 'active' if @page == 'home'
    @about_status = 'active' if @page == 'about'
    render @page
  end

  private

  def verify_page
    # redirect_to root_path unless valid_pages.include?(params[:name])
    @page = params[:name]
  end

  def valid_pages
    %w[about home]
  end

end
