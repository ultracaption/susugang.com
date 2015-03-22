class VotesController < ApplicationController
  def create
    assessment = Assessment.find params[:assessment_id]

    vote = Vote.where(assessment_id: assessment.id, user_id: current_user.id).first

    unless vote
      vote = Vote.new
      vote.assessment = assessment
      vote.user = current_user
    end

    if params[:vote] && params[:vote][:positive]
      vote.positive = true
    else
      vote.positive = false
    end

    vote.save

    redirect_to assessment
  end
end
