class MainController < ApplicationController
  def index
    @assessment = Assessment.new
    @assessments_for_major = Assessment.major.limit(20)
    @assessments_for_non_major = Assessment.non_major.limit(20)
  end
end
