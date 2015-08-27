class CourseInfo
  include HappyMapper

  tag 'course'

  attribute :alias, String
  attribute :semester, Integer
  attribute :year, Integer

  has_one :name, String
  has_one :instructor, Instructor, :tag => 'prof'
  has_many :parts, Part, :tag => 'part'

  def getInstructor(part)
    return nil if parts.nil?
    parts.each do |p|
      return p.instructor if p.type == part
    end
    nil
  end
end
