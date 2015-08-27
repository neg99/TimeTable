class Course
  include HappyMapper

  attribute :id, String
  has_one :name, String
  has_one :prof, String

  attribute :part, String
end
