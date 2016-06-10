require 'sinatra'
require 'json'
require './lib/real_time_tables'

get '/' do
  content_type :json
  timetable_kapyla  = RealTimeTables::Stop.new('kapyla')
  timetable_maunula = RealTimeTables::Stop.new('maunula')

  response = {
    kapyla_to_helsinki:  construct_response(timetable_kapyla.get_next_20_departures),
    maunula_to_helsinki: construct_response(timetable_maunula.get_next_20_departures),
  }
  
  response.to_json
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
