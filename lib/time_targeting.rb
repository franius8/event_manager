require 'csv'

class BestHoursChecker
    def initialize
        @contents = CSV.open(
            'event_attendees.csv',
            headers: true,
            header_converters: :symbol
          )
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
        @contents.each {|row| @registration_hours << DateTime.strptime(row[:regdate], '%m/%d/%y %k:%M').hour}
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
         
         print "The best hours for adverstising are #{@best_hours.join(', ')}"
    end
end

BestHoursChecker.new