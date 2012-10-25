class Person
  include HappyMapper

  namespace 'http://statmod.ru/staff'
  tag 'person'

  has_one :first_name, String, :tag => 'fn'
  has_one :middle_name, String, :tag => 'mn'
  has_one :last_name, String, :tag => 'ln'

  attribute :id, String
end
