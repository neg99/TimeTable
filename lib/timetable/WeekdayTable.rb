# coding: utf-8

class WeekdayTable
  include HappyMapper

  tag 'weekday'

  attribute :id, String
  has_many :double_classes, DoubleClass, :tag => 'two_hours'

  def name
    {:mon => 'Понедельник', :tue => 'Вторник', :wed => 'Среда',
     :thu => 'Четверг', :fri => 'Пятница', :sat => 'Суббота',
     :sun => 'Воскресенье'}[id.to_sym];
  end

  def getDoubleClass(index)
    @index_to_double_class ||= Hash[*(double_classes.map{|dc| [dc.index, dc]}.flatten)]
    result = @index_to_double_class[index]
    if result.nil?
      result = DoubleClass.new
      result.index = index
      result.lessons = []
    end
    result
  end

end
