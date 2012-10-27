require 'sinatra'
require 'haml'

require_relative 'lib/statmod.rb'

statmod = Statmod.new
statmod.loadSpecData(File.dirname(__FILE__) + '/data/_courses/sm_spec.xml')
statmod.loadSpecData(File.dirname(__FILE__) + '/data/_courses/mm_spec.xml')
statmod.loadSpecData(File.dirname(__FILE__) + '/data/_courses/sa_spec.xml')
statmod.loadStaffData(File.dirname(__FILE__) + '/data/_staff/prof.xml')

timetable3 = statmod.getTimeTable(File.dirname(__FILE__) + '/data/_courses/3course.xml')
timetable4 = statmod.getTimeTable(File.dirname(__FILE__) + '/data/_courses/4course.xml')
timetable5 = statmod.getTimeTable(File.dirname(__FILE__) + '/data/_courses/5course.xml')

get '/3course' do
  @timetable = timetable3
  @course = 3
  haml :timetable
end

get '/4course' do
  @timetable = timetable4
  @course = 4
  haml :timetable
end

get '/5course' do
  @timetable = timetable5
  @course = 5
  haml :timetable
end

get '/' do
  redirect '/3course'
end
