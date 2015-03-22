#encoding=utf-8
class Registration < ActiveRecord::Base
  attr_accessor :username, :password

  attr_accessible :username, :password, :step

  after_initialize :initialize_with_defaults
  before_create :retrieve_transaction_id
  
  VALIDATION_QUESTIONS = [
    ["성신여대 학생들을 부르는 별칭은? <strong>ㅇㅇㅇ</strong>", "수정이"],
    ["이번에 새로 생긴 성신여대 제2캠퍼스의 이름은? <strong>ㅇㅇ</strong>캠퍼스", "운정"],
    ["성신관에 있는 카페 이름은? <strong>ㅇㅇㅇ</strong>", "수하루"],
    ["수정관과 성신관이 이어지는 층수는? <strong>ㅇ</strong>층", "4"],
    ["성신여대 학생들이 한 달에 한번, 한 학기에 총 세 번을 쓸 수 있는 결석계 이름은? <strong>ㅇㅇㅇㅇ</strong>결석계", "생리유고"]
  ]

  def initialize_with_defaults
    self.step ||= 1
  end

  def retrieve_transaction_id
    begin
      user = User.find_or_new_verified_user username: username, password: password,
        organization: VERIFIER_ORGANIZATION
    rescue Exception => e
      puts e.backtrace
      return false
    end

    self.transaction_id = user.transaction_id

    true
  end

  def proceed
    update_attribute :step, step + 1
  end

  def best_or_worst
    step < 3 ? 'best' : 'worst'
  end

  def best?
    best_or_worst == 'best'
  end

  def worst?
    best_or_worst == 'worst'
  end

  def current_step
    if step < 2
      :new
    elsif step < 3
      :welcome
    elsif step < 4
      :assess
    else
      :finished
    end
  end
end
