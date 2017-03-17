require 'json'

class Coma

  def initialize(name, day, time)
	@name = name
    @day = day
    @time = time
  end

  def self.parse name, time_str
    parse_result = self.parse_weekday time_str
	coma_arr = []
	parse_result.each do |parse_param|
	  coma_arr << Coma.new(name.strip, parse_param[0], parse_param[1])
    end
	coma_arr
  end

  def self.parse_weekday time_str
    datetimes = time_str.split(',')
    buffer = []
    datetimes.each do |datetime|
	  datetime.strip!
      buffer << [datetime[0], datetime[1]]
    end
    buffer
  end

  def to_hash
	{
	  name: @name,
	  day: @day,
	  time: @time
	}
  end
end
