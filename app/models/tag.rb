class Tag
  attr_reader :id, :image_file_name, :category, :content

  def initialize(attrs = {})
    @id = attrs[:id]
    @image_file_name = attrs[:image_file_name]
    @category = attrs[:category]
    @content = attrs[:content]
  end

  def self.predefined_set
    TAGS
  end

  def self.category(category, lecture = nil, user = nil)
    if lecture && user
      tagged_ids = Tagging.where(lecture_id: lecture.id, user_id: user.id).map(&:tag_id)
    end
    predefined_set.select { |tag| tag.category == category && !tagged_ids.include?(tag.id) }
  end

  def self.find(id)
    Tag.predefined_set.select { |tag| tag.id == id }.first
  end
end
