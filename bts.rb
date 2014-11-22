require 'sinatra'
require 'prawn'
require 'prawn/table'
require './setting_list'

# 設定
MAX_TUNES = 15
PDF_DIR   = File.expand_path("./public/pdf", File.dirname(__FILE__))
DRUM_IMG  = File.expand_path("./public/images/drum.png", File.dirname(__FILE__))

# セットリスト配列作成メソッド
def tunes
  (0...MAX_TUNES).to_a.map do |i|
    next unless params["tune#{i}"] and params["tune#{i}"] != ""
    next unless params["halogen_front#{i}"]
    {
      title: params["tune#{i}"],
      time: params["time#{i}"],
      halogen_front: params["halogen_front#{i}"],
      backlight: params["backlight#{i}"],
      strobo: params["strobo#{i}"],
      mirror: params["mirror#{i}"],
      blackout: params["blackout#{i}"]
    }
  end.compact
end

# SettingListオブジェクトを返すメソッド
def get_setting_list(tunes)
  SettingList.new(
    params["band"],
    params["time"].to_i,
    params["orderday"].to_i,
    params["ordernum"].to_i,
    params["representative"],
    tunes,
    params["drummer"]
  )
end

# ファイル名作成メソッド
def get_pdf_path
  loop do
    filename = Time.now.strftime("%Y%m%d%H%M%S#{rand(10000)}") + ".pdf"
    full_path = File.join(PDF_DIR, filename)
    return full_path unless File.exist?(full_path)
  end
end

# PDF作成メソッド
def generate_pdf(pdf_path, setting_list)
  Prawn::Document.generate(pdf_path) do |pdf|
    setting_list.make_set_list(pdf)
    setting_list.make_pa_setting_list(pdf)
    setting_list.make_frontroadie_setting_list(pdf)
    setting_list.make_drumroadie_setting_list(pdf)
    setting_list.make_camera_setting_list(pdf)
    setting_list.make_lighting_setting_list(pdf)
  end
end

get "/" do
  redirect "/index.html"
end

post "/" do
  sl = get_setting_list(tunes)
  pdf_path = get_pdf_path
  generate_pdf(pdf_path, sl)

  redirect "/index.html"
end

