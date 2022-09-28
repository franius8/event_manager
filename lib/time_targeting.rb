# frozen_string_literal: true

require 'csv'

module CommonElements
  def define_contents
    CSV.open(
      @filename,
      headers: true,
      header_converters: :symbol
    )
  end

  def convert_to_date(row)
    DateTime.strptime(row[:regdate], '%m/%d/%y %k:%M')
  end
end


# Check for best hours to use in advertising
class BestHoursChecker
  include CommonElements
  def initialize(filename)
    @filename = filename
    @contents = define_contents
    @registration_hours = []
    @hours = Array.new(23)
    @highest_number_registered = 0
    @best_hours = []

    perform_check
  end

  def perform_check
    convert_hours
    print_hours
    check_best_hours
  end

  def convert_hours
    @contents.each { |row| @registration_hours << convert_to_date(row).hour }
  end

  def print_hours
    @hours.each_index do |index|
      @hours[index] = @registration_hours.count(index)
      puts "#{index}: \t#{@hours[index]} users registered"
    end
  end

  def check_best_hours
    @hours.each_with_index do |number, hour|
      if @highest_number_registered < number
        @highest_number_registered = number
        @best_hours = []
        @best_hours << hour
      elsif @highest_number_registered == number
        @best_hours << hour
      end
    end

    print "The best hours for advertising are #{@best_hours.join(', ')}"
  end
end

class BestWeekdayChecker
  include CommonElements
  def initialize(filename)
    @filename = filename
    @contents = define_contents
    @registration_weekdays = []
    @weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
    @highest_number_registered = 0
    @best_weekdays = []
    
    perform_check
  end

  def perform_check
    convert_dates
    print_weekdays
    check_best_days
  end

  def convert_dates
    @contents.each { |row| @registration_weekdays << convert_to_date(row).strftime('%A') }
  end

  def print_weekdays
    @weekdays.each do |day|
      puts "#{day}: \t#{@registration_weekdays.count(day)} users registered."
    end
  end

  def check_best_days
    @weekdays.each do |day|
      number = @registration_weekdays.count(day)
      if @highest_number_registered < number
        @highest_number_registered = number
        @best_weekdays = []
        @best_weekdays << day
      elsif @highest_number_registered == number
        @best_weekdays << day
      end
    end
    print "The best weekdays for advertising are #{@best_weekdays.join(', ')}"
  end
end

BestWeekdayChecker.new('event_attendees.csv')
