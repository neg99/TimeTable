class Part
  include HappyMapper

  attribute :type, String
  attribute :hours, Integer
  has_one :instructor, Instructor, :tag => 'prof'
end
