require 'rubygems'
require 'mechanize'
require 'json'
require './coma'

def find_time page
  [*page.search('td'), nil].each_cons(2) do |t, t_next|
    return t_next.text if t.text == '(曜時限)'
  end
end

def find_name page
  [*page.search('td'), nil].each_cons(2) do |t, t_next|
    return t_next.text if t.text == '(科目名)'
  end
end

def get_login_info 
  buffer = []
  File.open('login.txt').each do |line|
	buffer << line.split(':')[1].strip
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

coma_buffer = []

search1 = agent.get('https://www.k.kyoto-u.ac.jp/student/u/s/syllabus/detail?no=3958')
time_str = find_time search1
name = find_name search1
comas = Coma.parse(name, time_str)
coma_buffer += comas

coma_json = coma_buffer.map(&:to_hash).to_json
File.open("../assets/data.json", "w") do |f|
  f.write coma_json
end
