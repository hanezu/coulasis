require 'json'

class Coma
  def self.parse page, url
    url.strip!

    new_coma = -> subcoma do
      coma_times = subcoma.find_time_in page
      name = subcoma.find_name_in page
	  puts name.strip
      coma_arr = []
      coma_times.each do |parse_param|
        coma_arr << {
            name: name.strip,
            day: parse_param[0],
            time: parse_param[1],
            url: url
        }
      end
      coma_arr
    end

    if url.start_with? "https://www.k.kyoto-u.ac.jp/student/u/s/syllabus/"
      new_coma.call ScienceComa
    elsif url.start_with? "http://www.t.kyoto-u.ac.jp/syllabus-s/"
      new_coma.call EngineeringComa
    else
      raise ParseComaError, "No according coma with url #{url}"
    end
  end
  
  def self.find(page, str)
	[*page.search('td'), nil].each_cons(2) do |t, t_next|
	  return t_next.text if t.text == str
	end
	raise ParseComaError, "find #{str} failed"
  end


end

class ScienceComa < Coma

  def self.find_time_in page
    time_str = Coma.find(page, '(曜時限)')
    datetimes = time_str.split(',')
    buffer = []
    datetimes.each do |datetime|
      datetime.strip!
      buffer << [datetime[0], datetime[1]]
    end
    buffer
  end

  def self.find_name_in page
    Coma.find(page, '(科目名)')
  end

end

class EngineeringComa < Coma

  def self.find_time_in page
    time_str = nil
    page.search('tr').each do |t|
      table_head = t.search('th')[0]
      if table_head != nil && table_head.text == '曜時限'
        time_str = t.search('td')[0].text
      end
    end
    if time_str == nil
      raise ParseComaError, "find #{str} failed"
    end
    buffer = []
    splitted_time = time_str.split('・')
    buffer << [splitted_time[0].strip[0], splitted_time[1].strip[0]]
  end

  def self.find_name_in page
    page.search('h2').each do |t|
      return t.text.split(':')[-1].strip if t.text =~ /授業科目名/
    end
    raise ParseComaError, "find name failed"
  end
end

class ParseComaError < StandardError

end
