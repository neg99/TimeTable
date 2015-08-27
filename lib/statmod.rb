require_relative './timetable.rb'

require 'json'

# The class responsible for gluing together information from different XML files
class Statmod

  # parse list of courses for a particular specialty
  def loadSpecData(filename)
    spec = CourseList.parse(File.read(filename))
    @courses ||= {}
    spec.courses.each do |course|
      @courses[course.semester] ||= {}
      @courses[course.semester][course.alias] = course
    end
  end

  # parse staff data, resolving current course instructor ids
  # to person information
  def loadStaffData(filename)
    @staff = Staff.parse(File.read(filename))
    @courses.each do |semester, courses|
      courses.each do |id, course|
        next if course.instructor.nil?
        id = course.instructor.id 
        next if @staff[id].nil?
        course.instructor = @staff[id]

        if course.parts
          course.parts.each do |part|
            id = part.instructor.id
            next if @staff[id].nil?
            part.instructor = @staff[id]
          end
        end
      end
    end
  end

  # parse time table from a given file, resolving course aliases
  # to course information
  def getTimeTable(filename)
    timetable = TimeTable.parse(File.read(filename))
    timetable.updateCourseInfo(@courses[timetable.semester])
    timetable
  end

  # map: semester -> alias -> course information
  def getAllCourses
    @courses
  end

  # map: id -> person information
  def getAllStaff
    @staff
  end

  def jsonToTimetable(hash)
    json = hash
    timetable = TimeTable.new
    timetable.year = json['year'].to_i
    timetable.semester = json['semester'].to_i
    timetable.weekday_tables = []
    
    json['weekdays'].each do |id, classes|
      wd_table = WeekdayTable.new
      wd_table.id = id
      wd_table.double_classes = []
      5.times do |index|
        lessons = classes[index]
        double_class = DoubleClass.new
        double_class.index = index.to_i + 1
        double_class.lessons = []
        lessons.each do |lesson_json|
          lesson = Lesson.new
          lesson.spec = lesson_json['spec']
          lesson.type = if lesson.spec == 'all' then 'dep' else 'chair' end
          lesson.location = lesson_json['location']
          fn = lesson_json['fortnightly']
          unless fn.nil?
            lesson.fortnightly = Fortnightly.new
            lesson.fortnightly.type = fn
          end
          
          lesson.course = Course.new
          lesson.course.id = lesson_json['course']['id']
          lesson.course.part = lesson_json['course']['part']
          if lesson.course.id.nil?
            lesson.course.name = lesson_json['course']['name']
            lesson.course.prof = lesson_json['course']['prof']
          end
          
          double_class.lessons << lesson
        end
        wd_table.double_classes << double_class
      end
      timetable.weekday_tables << wd_table
    end
    timetable
  end

  def getCourseInfo(semester, id)
    semester = semester.to_i
    if @courses[semester].nil?
      nil
    else
      @courses[semester][id]
    end
  end
end
