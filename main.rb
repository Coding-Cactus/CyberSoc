# frozen_string_literal: true

require 'sinatra'
require_relative 'lib/cybersoc'

set :bind, '0.0.0.0'

db = CyberSoc::DataBase.new
time_handler = CyberSoc::TimeHandler.new

get '/' do
  @dates = time_handler.dates.clone

  db.all_talks(after: time_handler.start_of_day(Time.now)).each do |t|
    start = time_handler.start_of_day(t.date)
    @dates[start] = t if @dates.include?(start)
  end

  @msg = 'You entered something incorrectly' if params.include?('i')

  erb :index
end

post '/talk/create' do
  redirect(
    "/#{db.add_talk(params[:title], params[:author], Time.at(params[:date].to_i), params[:email]) ? '' : '?i'}"
  )
end
