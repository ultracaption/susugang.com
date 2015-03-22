class LecturesController < ApplicationController
  before_filter :fetch_top_standings

  def index
    @assessments = Assessment.paginate(page: params[:page] || 1)
  end

  def search
    @query = params[:query]
    @query.gsub!(/[+\-|!(){}\[\]\^"~*?:\\]/, "\\\\\\0") if @query
    @query.gsub!(/\s+/, "") if @query

    if @query && @query.length > 0
      @result = Lecture.search("*#{@query}*", page: params[:page] || 1, per_page: 10, load: true)
    else
      @result = Lecture.paginate page: params[:page] || 1
    end
  end

  def show
    @lecture = Lecture.find params[:id]
    @lecture.update_hit_count

    @assessment = current_user.assessment_for(@lecture) || Assessment.new
    @assessments = @lecture.assessments.all
  end

  private
    def fetch_top_standings
      @lectures = Lecture.where('assessment_count >= ?', Lecture::MIN_NUMBER_OF_ASSESSMENTS).order('overall_score DESC').first(20)
    end
end
