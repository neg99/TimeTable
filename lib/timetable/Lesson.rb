class Fortnightly
  include HappyMapper
  attribute :type, Integer
end

class Lesson
  include HappyMapper

  attribute :type, String
  attribute :spec, String
  has_one :location, String
  has_one :course, Course
  has_one :fortnightly, Fortnightly

  def numerator?
    fortnightly.nil? || fortnightly.type == 1
  end

  def denominator?
    fortnightly.nil? || fortnightly.type == 2
  end
end
