# frozen_string_literal: true

require 'mongo'

module CyberSoc
  class DataBase
    def initialize
      @client = Mongo::Client.new(ENV.fetch('mongo_uri', nil), database: 'cybersoc')[:talks]
    end

    def all_talks(after: 0)
      @client.find({ date: { '$gte' => after } }).map { |d| Talk.new(d) }
    end

    def add_talk(title, author, date, email)
      return false unless valid_talk?(title, author, date, email)

      @client.insert_one({
                           title: title,
                           author: author,
                           date: date,
                           email: email
                         })

      true
    end

    private

    def valid_talk?(title, author, date, email)
      valid_types?({ title => String, author => String, date => Time, email => String }) &&
        all_present?([title, author, email]) && valid_day?(date) && valid_email?(email)
    end

    def valid_day?(date) = TimeHandler.new.valid_date?(date) && @client.find({ date: date }).first.nil?
    def all_present?(strings) = strings.all? { |s| !s.nil? && !s.gsub(' ', '').empty? }
    def valid_types?(values_to_types) = values_to_types.all? { |value, type| value.is_a?(type) }

    def valid_email?(email)
      email.match(URI::MailTo::EMAIL_REGEXP) && email.split('@')[-1] == ENV.fetch('email_provider', nil)
    end
  end
end
