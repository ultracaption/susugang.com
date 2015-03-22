#encoding=utf-8
class RegistrationsController < ApplicationController
  skip_before_filter :authenticate_user!

  def new
    @user = User.new
    session[:validation_question_number] = rand(Registration::VALIDATION_QUESTIONS.length)
  end

  # POST /resource
  def create
    @user = User.new params[:user]
   
    @validation_passed = params[:validation_answer] == Registration::VALIDATION_QUESTIONS[session[:validation_question_number]][1]
    @validation_error_message = "인증 퀴즈 정답이 틀렸습니다." unless @validation_passed
    session[:validation_question_number] = rand(Registration::VALIDATION_QUESTIONS.length)
    
    if @validation_passed
     if @user.save
      sign_in(:user, @user)
      redirect_to root_path
     else
       render :new
     end
    else
      render :new
    end
  end
end

