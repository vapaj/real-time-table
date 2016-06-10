require 'sinatra'
require 'json'
require 'erb'
require './lib/real_time_tables'

get '/' do
  timetable_kapyla  = RealTimeTables::Stop.new('kapyla')
  timetable_maunula = RealTimeTables::Stop.new('maunula')

  @kapyla_to_helsinki  = construct_response(timetable_kapyla.get_next_20_departures)
  @maunula_to_helsinki =  construct_response(timetable_maunula.get_next_20_departures)
  erb :index
end

helpers do
  def construct_response(timetable)
    timetable.map do |departure|
      get_correct_timestamp(departure)
    end
  end

  def get_correct_timestamp(departure)
    if departure.rtime.is_a?(String)
      {
        time: departure.time,
        line: departure.line,
        real_time: departure.rtime,
      }
    else
      {
        time: departure.time,
        line: departure.line,
      }
    end
  end
end
