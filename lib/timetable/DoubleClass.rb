class DoubleClass
  include HappyMapper

  tag 'two_hours'

  attribute :index, Integer, :tag => 'no'
  has_many :lessons, Lesson, :tag => 'lesson'

  def topLessons
    @top ||= toDict(lessons.select {|lesson| lesson.numerator? })
    @top
  end

  def bottomLessons
    @btm ||= toDict(lessons.select {|lesson| lesson.denominator? and not lesson.numerator? })
    @btm 
  end

  private 
  def toDict(lessons)
    Hash[*(lessons.map{|lesson| [lesson.spec, lesson]}.flatten)]
  end
end
