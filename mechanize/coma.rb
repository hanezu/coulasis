require 'json'

class Coma

  def initialize(data)
	@data = data
  end

  def self.parse page, url
	time_str = self.find_time page
	if time_str != nil
	  time_parse_result = self.parse_weekday time_str
	else
	  time_parse_result = ['','']
	end
	name = self.find_name page
	if name == nil
	  name = ''
	end
	coma_arr = []
	time_parse_result.each do |parse_param|
	  coma_arr << Coma.new({
	    name: name.strip,
	    day: parse_param[0],
		time: parse_param[1],
		url: url
	  })
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

  def self.find_time page
	[*page.search('td'), nil].each_cons(2) do |t, t_next|
	  return t_next.text if t.text == '(曜時限)'
	end
  end

  def self.find_name page
	[*page.search('td'), nil].each_cons(2) do |t, t_next|
	  return t_next.text if t.text == '(科目名)'
	end
  end

  def to_hash
	@data
  end
end
