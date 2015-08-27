# encoding: UTF-8

require 'bundler/setup'

require 'sinatra'
require 'haml'
require 'cgi'
require 'set'
require 'json'

require_relative 'lib/statmod.rb'
require_relative 'lib/id_select_option_gen.rb'

class StatmodWebApp < Sinatra::Base

  use Rack::Session::Pool

  set :environment, :production

  configure do
    @@specs = ['sa', 'sm', 'mm']
    @@specnames = ['САПР', 'СМ', 'ММ']

    @@statmod = Statmod.new
    @@statmod.loadSpecData(File.dirname(__FILE__) + '/data/_courses/sm_spec.xml')
    @@statmod.loadSpecData(File.dirname(__FILE__) + '/data/_courses/mm_spec.xml')
    @@statmod.loadSpecData(File.dirname(__FILE__) + '/data/_courses/sa_spec.xml')
    @@statmod.loadStaffData(File.dirname(__FILE__) + '/data/_staff/prof.xml')

    TABLE_DIR = File.dirname(__FILE__) + '/data/tables/'

    @@timetable3 = @@statmod.getTimeTable(TABLE_DIR + '3course.xml')
    @@timetable4 = @@statmod.getTimeTable(TABLE_DIR + '4course.xml')
    @@timetable5 = @@statmod.getTimeTable(TABLE_DIR + '5course.xml')

    @@newlesson = Lesson.new
    course = Course.new
    course.prof = 'Преподаватель'
    course.name = 'Название предмета'
    @@newlesson.fortnightly = nil
    @@newlesson.course = course
    @@newlesson.location = 'Аудитория'

    all_courses = @@statmod.getAllCourses

    # map: semester -> course ids
    courseidlist = {}
    all_courses.each do |semester, courses|
      courseidlist[semester] = []
      courses.each do |id, info|
        if info.parts and not info.parts.empty? then
          info.parts.each do |part|
            courseidlist[semester] << idEncode(id, part.type)
          end
        else
          courseidlist[semester] << id
        end
      end
    end
    
    # map: semester -> course names
    courselist = @@statmod.getAllCourses.map{|k, v| {k => v.values.map(&:name)}}.reduce(:merge)
    [@@timetable3, @@timetable4, @@timetable5].each do |timetable|
      courselist[timetable.semester] += timetable.courseNames
      courselist[timetable.semester] << ''
      courselist[timetable.semester].sort!
      courselist[timetable.semester].uniq!
    end

    stafflist = @@statmod.getAllStaff
    @@courseidlist_json = courseidlist.map{|k, v| {k => optionsToHtml(v, all_courses[k])}}.reduce(:merge).to_json
    @@courselist_json = courselist.to_json
    @@stafflist_json = stafflist.persons.map(&:name).to_json
  end

  before do
    content_type :html, 'charset' => 'utf-8'
    @buffer = session[:buffer]
    Dir.chdir TABLE_DIR do
      @filenames = Dir["*.xml"].sort
    end
    @specs = @@specs
    @specnames = @@specnames
    @courseidlist_json = @@courseidlist_json
    @courselist_json = @@courselist_json
    @stafflist_json = @@stafflist_json 
  end

  private

  def rowSpan(l)
    if l.nil?
      2
    elsif l.fortnightly.nil?
      2
    else
      1
    end
  end

  public

  get '/3course' do
    @filename = '3course.xml'
    @timetable = @@timetable3
    haml :timetable
  end

  get '/4course' do
    @filename = '4course.xml'
    @timetable = @@timetable4
    haml :timetable
  end

  get '/5course' do
    @filename = '5course.xml'
    @timetable = @@timetable5
    haml :timetable
  end

  get '/edit/:filename' do |fn|
    @filename = fn
    @timetable = @@statmod.getTimeTable(File.dirname(__FILE__) + "/data/tables/#{CGI::unescape fn}") 
    haml :timetable
  end

  get '/' do
    redirect "/#{3 + (rand 3)}course"
  end

  get '/new' do
    @timetable = @@statmod.getTimeTable(File.dirname(__FILE__) + '/immutable_data/tables/empty.xml')
    haml :timetable
  end

  post '/renderjson' do
    json = params[:jsondata]
    if json then
      begin
        @timetable = @@statmod.jsonToTimetable(json)
      rescue
        return 'invalid JSON'
      end
      haml :timetable
    end
  end

  def jsonToXml(statmod, json)
    timetable = statmod.jsonToTimetable json

    builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8')
    pi = Nokogiri::XML::ProcessingInstruction.new(builder.doc, 
                                                 'xml-stylesheet',
                                                 'type="text/xsl" href="timetable.xsl"')
    timetable.to_xml(builder)
    builder.doc.root.add_previous_sibling pi
    builder.to_xml(:indent => 4)
  end

  post '/save' do
    json = JSON.parse params[:jsondata] 
    session[:buffer] = json['buffer']
    begin
      fn = params[:filename]
      File.write(TABLE_DIR + fn, jsonToXml(@@statmod, json['timetable']))
      redirect "/edit/#{CGI::escape fn}"
    rescue
      "Ошибка сохранения XML-файла"
    end
  end

  post '/download' do
    content_type 'application/octet-stream'
    attachment params[:filename]
    json = JSON.parse params[:jsondata]
    session[:buffer] = json['buffer']
    jsonToXml @@statmod, json['timetable']
  end

  get '/newlesson' do
    @newlessonresponse ||= haml :newlesson, :locals => { :lesson => @@newlesson }
  end

  get '/newlesson/:semester/:courseid' do |semester, id|
    id, part = idDecode id
    
    lesson = Lesson.new
    lesson.course = Course.new
    lesson.course.id = id
    courseinfo = @@statmod.getCourseInfo semester, id
    unless courseinfo.nil?
      lesson.course.name = courseinfo.name
      if part
        lesson.course.prof = courseinfo.getInstructor(part).name
        lesson.course.part = part
      else
        lesson.course.prof = courseinfo.instructor.name
      end
    end
    @newlessonresponse ||= haml :newlesson, :locals => { :lesson => lesson }
  end

  post '/loadfile' do
    json = JSON.parse params[:jsondata]
    session[:buffer] = json['buffer']
    redirect "/edit/#{CGI::escape params['filename']}"
  end
end

StatmodWebApp.run!
