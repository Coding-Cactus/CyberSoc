# frozen_string_literal: true

module CyberSoc
  module TimeHandler
    HOLIDAYS = [
      Time.new(2022, 10, 5)..Time.new(2022, 10, 6),   # CPD day
      Time.new(2022, 10, 17)..Time.new(2022, 10, 28), # Michaelmas half term holiday
      Time.new(2022, 12, 14)..Time.new(2023, 1, 4),   # Michaelmas term holiday
      Time.new(2023, 1, 18)..Time.new(2023, 1, 19),   # Entrance exam day
      Time.new(2023, 2, 13)..Time.new(2023, 2, 17),   # Lent half term holiday
      Time.new(2023, 3, 31)..Time.new(2023, 4, 17),   # Lent term holiday
      Time.new(2023, 5, 22)..Time.new(2023, 6, 10),   # Exams + Summer half term holiday
      Time.new(2023, 6, 25)..Time.new(2023, 9, 1)     # Activities week + summer holiday
    ].freeze

    def holiday?(date) = HOLIDAYS.any? { |h| h.include?(date) }

    def start_of_day(date)
      Time.new(date.strftime('%Y').to_i, date.strftime('%m').to_i, date.strftime('%d').to_i, 0, 0, 0, '+00:00')
    end
    
    def dates
      today = Time.now
      num = %w[Sun Mon Tue Wed Thu Fri Sat].index(today.strftime('%a'))

      throw RuntimeError('strftime did not return expected string') if num.nil?

      current_wed = start_of_day(Time.now + ((num > 3 ? 10 - num : 3 - num) * 86_400))

      d = {}
      until current_wed > Time.new(2023, 9, 1)
        d[current_wed] = nil unless holiday?(current_wed)
        current_wed = start_of_day(current_wed + 630_000)
      end
      d
    end

    def valid_date?(date) = dates.include?(date)
  end
end
