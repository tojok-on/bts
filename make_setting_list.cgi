#!/usr/local/bin/ruby
# coding: utf-8

require 'prawn'
require 'cgi'

require './setting_list'

cgi = CGI.new

set_list = []

15.times do |i|
  break if cgi["tune#{i}"] == "" || cgi["halogen_front#{i}"] == ""
  set_list << {
    :title => cgi["tune#{i}"],
    :time => cgi["time#{i}"],
    :halogen_front => cgi.params["halogen_front#{i}"],
    :backlight => cgi["backlight#{i}"],
    :strobo => cgi["strobo#{i}"],
    :mirror => cgi["mirror#{i}"],
    :blackout => cgi["blackout#{i}"]
  }
end

setting_list = SettingList.new(
  cgi["band"],
  cgi["time"],
  cgi["orderday"],
  cgi["ordernum"],
  cgi["representative"],
  set_list,
  cgi["drummer"]
)

pdf_file = "pdf/" + Time.now.strftime("%Y%m%d%H%M%S#{rand(100)}") + ".pdf"

Prawn::Document.generate(pdf_file) do |pdf|
  setting_list.make_set_list(pdf)
  setting_list.make_pa_setting_list(pdf)
  setting_list.make_frontroadie_setting_list(pdf)
  setting_list.make_drumroadie_setting_list(pdf)
  setting_list.make_camera_setting_list(pdf)
  setting_list.make_lighting_setting_list(pdf)
end

puts "Content-Type: text/html\n\n"
puts <<HTML
<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="UTF-8" />
    <title>こまどりおねえちゃんしすてむ（鉄）　ーセッティング表ができたよ！ー</title>
    <meta name="ROBOTS" content="NONE" />
    <meta name="GOOGLEBOT" content="NONE" />
    <link rel="stylesheet" type="text/css" href="css/sister.css" />
    <script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
    <!--[if lt IE 9]>
      <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js" type="text/javascript"></script>
    <![endif]-->
    <script type="text/javascript" src="js/title.js" /></script>
  </head>
  <body>

    <div id="container">
      <header>
	      <h1>こまどりおねえちゃんしすてむ　（鉄）</h1>
        <div class="title_iron">        <a href="http://tojok-on.com/bts"><img src="images/iron.png"></a></div>

      </header>
      <section>

        <p class="info">
        	セッティング表ができたよっ☆<br>
        	<a href="#{pdf_file}" class="set">こちら</a>
        </p>
      </section>
       <footer>(c) TOJO K-ON</footer>

    </div>
  </body>
</html>

HTML
