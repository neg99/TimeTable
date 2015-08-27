class TimeTable
    include HappyMapper

    attribute :year, Integer
    attribute :semester, Integer

    def course
      if semester.nil?
        ''
      else
        (semester + 1) / 2
      end
    end

    has_many :weekday_tables, WeekdayTable, :tag => 'weekday'

    def updateCourseInfo(courses)
      weekday_tables.each do |day|
        day.double_classes.each do |dc|
          dc.lessons.each do |lesson|
            if lesson.course.name.nil? and not lesson.course.id.nil?
              course_info = courses[lesson.course.id]
              next if course_info.nil?

              prof = if lesson.course.part then
                course_info.getInstructor(lesson.course.part)
              else
                course_info.instructor
              end

              lesson.course.name = course_info.name
              lesson.course.prof = prof.name unless prof.nil?
            end
          end
        end
      end
    end

    def courseNames
      weekday_tables.map{|w| w.double_classes.map {|dc| dc.lessons.map{|l| l.course.name }}}.flatten
    end
end
