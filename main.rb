# frozen_string_literal: true

require 'sinatra'
require_relative 'lib/cybersoc'

set :bind, '0.0.0.0'

db = CyberSoc::DataBase.new

include CyberSoc::TimeHandler

get '/' do
  @dates = dates

  db.all_talks(after: start_of_day(Time.now)).each do |t|
    start = start_of_day(t.date)
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
