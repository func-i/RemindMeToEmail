class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :sort_by?, :sort_by

  protected

  def sort_by
    params[:sort_by]
  end

  def sort_by?(f)
    sort_by == f.to_s
  end


end
