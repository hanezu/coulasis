# Coulasis -- create course schedule from kulasis

A Ruby Mechanize scraper + Angular app for auto-create course schedule of Kyoto Univ Kulasis. 

# Quick Start

1. Fill in your username and password of 学生アカウント(ECS-ID) in the file **login.txt** (just as you would fill in for 京都大学統合認証システム).

2. Fill in **urls** that direct to courses you would like to pick up in **course\_urls.txt**. You may check the file for examples.

3. Run `ruby mechanize/main.rb` in your commandline. Make sure [Mechanize](https://rubygems.org/gems/mechanize/versions/2.7.5) is installed in your gems. 

4. go to assets (`cd assets`) and run the Angular application (for example, on your local host). You can run it in anyway you like, and simple command such as `python -m SimpleHTTPServer` is enough.

5. Go to your local host and check your course schedule! (`http://0.0.0.0:8000/` if you are using SimpleHTTPServer)

# Update your Schedule

To update, change the urls and go through steps 3~5.
