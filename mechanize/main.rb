require 'rubygems'
require 'mechanize'
require 'json'
require './coma'

def get_login_info 
  buffer = []
  File.open('../login.txt').each do |line|
	buffer << line.split(':')[1].strip
  end
  buffer
end

def get_course_urls
  buffer = []
  File.open("../course_urls.txt").each do |line|
	buffer << line unless line =~ /^ *#/ or line.strip.length == 0
  end
  buffer
end

agent = Mechanize.new
page = agent.get('https://www.k.kyoto-u.ac.jp/student/la/top?server=ganymede')

kyo_form = page.form
username, password = get_login_info
kyo_form.j_username = username
kyo_form.j_password = password
middle_page = agent.submit(kyo_form, kyo_form.buttons.first)
homepage = middle_page.form.click_button

# url = 'https://www.k.kyoto-u.ac.jp/student/u/s/syllabus/detail?no=3958'
coma_buffer = []
get_course_urls.each do |url|
  course_page = agent.get(url)
  comas = Coma.parse(course_page, url)
  coma_buffer += comas
end

coma_json = coma_buffer.map(&:to_hash).to_json
File.open("../assets/data.json", "w") do |f|
  f.write coma_json
end
