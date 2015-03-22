# encoding: utf-8

module ApplicationHelper
  def score_options
    Assessment::SCORES.map do |entry|
      [entry[0], entry[1]]
    end.reverse
  end

  def attribute_to_term_set
    @@attribute_to_term_set ||= {
      group_activity: Assessment::GROUP_ACTIVITIES,
      test_styles: Assessment::TEST_STYLES,
      homework_workload: Assessment::HOMEWORK_WORKLOADS,
      exams: Assessment::EXAMS
    }
  end

  def translate_assessment_items(assessment, item_name)
    value = assessment.send item_name
    term_set = attribute_to_term_set[item_name]

    if value.is_a? Array
      value.map { |v| term_set[v] }.join ', '
    else
      term_set[value]
    end
  end

  def item_label_and_content(label, content)
    content_tag(:div, content_tag(:span, label, class: 'item-label') +
      content_tag(:span, content, class: 'item-content'), class: 'item-content-container')
  end

  def s(score, options = {})
    if current_user && (current_user.id == options[:user_id] || current_user.finished_registration?)
      if score.is_a? Float
        '%.2f' % score
      elsif options[:translate]
        Assessment.scores_label_hash[score]
      else
        score.to_s
      end
    else
      I18n.t('assessments.blinded_score')
    end
  end

  def c(content, options = {})
    if current_user && (current_user.id == options[:user_id] || current_user.finished_registration?)
      content
    else
      I18n.t('assessments.blinded_content')
    end
  end

  def assessment_to_label(assessment)
    labels = {
      elective_common: '',
      elective_core: 'label-primary',
      elective_general: 'label-success',
      required_core: 'label-warning',
      required_advanced: 'label-important'
    }

    abbrs = {
      elective_common: '공통',
      elective_core: '핵교',
      elective_general: '일교',
      required_core: '핵전',
      required_advanced: '전심'
    }

    content_tag :span, abbrs[assessment.category.to_sym], class: "label #{labels[assessment.category.to_sym]}"
  end
end
