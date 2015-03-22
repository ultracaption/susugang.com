class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery
  before_filter :authenticate_user!

  def after_sign_in_path_for(resource)
    assessments_path
  end
end
