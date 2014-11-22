#!/usr/local/bin/ruby
# coding: utf-8

require 'cgi'
require 'prawn'
require './setting_list'

cgi = CGI.new

set_list = []

20.times do |i|
  break if cgi["tune#{i}"] == "" || cgi["halogen_front#{i}"] == ""
  set_list << {
    :title => cgi["tune#{i}"],
    :time => cgi["time#{i}"],
    :halogen_front => cgi["halogen_front#{i}"].to_sym,
    :halogen_drum => cgi["halogen_drum#{i}"].to_sym
  }
end

setting_list = SettingList.new(
  cgi["band"],
  cgi["time"],
  cgi["order"],
  cgi["representative"],
  set_list,
  cgi["drummer"]
)

pdf_file = "pdf/" + Time.now.strftime("%Y%m%d%H%M%S#{rand(100)}") + ".pdf"

# TODO DBを使って時間がたっても見れるようにする

Prawn::Document.generate(pdf_file) do |pdf|
  # page 1: セットリスト
  setting_list.make_set_list(pdf)
  # page 2: PA用
  setting_list.make_pa_setting_list(pdf)
  # page 3, 4: FR用、FR+TK用
  setting_list.make_frontroadie_setting_list(pdf)
  # page 5: DR用
  setting_list.make_drumroadie_setting_list(pdf)
  # page 6: カメラ、ビデオ用
  setting_list.make_camera_setting_list(pdf)
  # page 7: 照明用
  setting_list.make_lighting_setting_list(pdf)
end

puts "Content-Type: text/html\n\n"
puts <<HTML
<!DOCTYPE html>
<html lang="ja">
  <head>
      <meta charset="UTF-8" />
      <title>You Are Iron Too!</title>
      <meta name="ROBOTS" content="NONE" />
      <meta name="GOOGLEBOT" content="NONE" />
      <!--[if lt IE 9]>
      <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js" type="text/javascript"></script>
      <![endif]-->
  </head>
  <body>
    <header>
        <h1>セッティング表</h1>
    </header>
    <p>あなたのセッティング表は<a href="#{pdf_file}">こちら</a></p>
  </body>
</html>
HTML
