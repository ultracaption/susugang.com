class AssessmentsController < ApplicationController
  before_filter :fetch_top_standings
  before_filter :find_lecture

  def new
    @assessment = Assessment.new
  end

  def edit
    @assessment = Assessment.find params[:id]
    render :new
  end

  def destroy
    @assessment = Assessment.find params[:id]
    @assessment.destroy
    redirect_to root_path
  end

  def index
    @assessments = case params[:category]
    when 'major' then Assessment.major.paginate(page: params[:page] || 1)
    when 'non-major' then Assessment.non_major.paginate(page: params[:page] || 1)
    when 'mine' then @hide_categories_menu = true; Assessment.by(current_user).paginate(page: params[:page] || 1)
    else Assessment.paginate(page: params[:page] || 1)
    end
  end

  def my
    @assessments = current_user.assessments.paginate(page: params[:page] || 1)

    render 'index'
  end

  def create
    @assessment = Assessment.new params[:assessment]
    @assessment.user = current_user

    if @assessment.save
      redirect_to @assessment
    else
      flash[:alert] = @assessment.errors.full_messages.first
      render 'new'
    end
  end

  def update
    @assessment = Assessment.find params[:id]

    unless @assessment.update_attributes params[:assessment]
      flash[:alert] = @assessment.errors.full_messages.first
    end

    render :show
  end

  def show
    @assessment = Assessment.find params[:id]
    @assessment.update_hit_count
  end

  def search
    @query = params[:query]
    @query.gsub!(/[+\-|!(){}\[\]\^"~*?:\\]/, "\\\\\\0") if @query

    if @query && @query.length > 0
      @assessments = Assessment.search("*#{@query}*", page: params[:page] || 1, per_page: 10, load: true)
    else
      @assessments = Assessment.paginate page: params[:page] || 1
    end

    render :index
  end

  private
    def find_lecture
      if params[:lecture_id]
        @lecture = Lecture.find params[:lecture_id]
      end
    end

    def fetch_top_standings
      @lectures = Lecture.where('assessment_count >= ?', Lecture::MIN_NUMBER_OF_ASSESSMENTS).order('overall_score DESC').first(20)
    end
end
