class CommentsController < ApplicationController
  def create
    assessment = Assessment.find params[:assessment_id]
    comment = Comment.new params[:comment]
    comment.user = current_user
    comment.assessment = assessment

    unless comment.save
      flash[:alert] = comment.errors.full_messages.first
    end

    redirect_to assessment
  end
end
