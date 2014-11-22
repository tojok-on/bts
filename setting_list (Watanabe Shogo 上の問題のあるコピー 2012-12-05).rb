# coding: utf-8
# 
# PDF生成ライブラリ  prawn を使用
# http://prawn.majesticseacreature.com/
# 
# Prawn API document
# http://prawn.majesticseacreature.com/docs/0.11.1/Prawn.html


class SettingList
  Halogen = {
    :red => "赤",
    :blue => "青",
    :yellow => "黄",
    :white => "白",
    :black => "無"
  }

  def initialize(band, time, order, representative, set_list, drummer)
    @band = band
    @time = time
    @order = order
    @representative = representative
    @set_list = set_list
    @drummer = drummer
  end

  # page 1: セットリスト
  def make_set_list(pdf)
    print_title(pdf, "Set List", false)

    # 表の内容
    set_list = []
    20.times do |i|
      set_list << [i + 1, @set_list[i] ? @set_list[i][:title] : ""]
    end
    
    # 表の出力
    pdf.table(set_list) do |t|
      t.width = @width #表の幅
      t.columns(0).width = 40 # 1列目の幅
      t.columns(0..1).style :borders => [] # 1列目～2列目のスタイル
    end
  end

  # page 2: PA用
  def make_pa_setting_list(pdf)
    print_title(pdf, "PA")

    headers = %w[曲順 曲名 Vo. Mar Yam Tra. Ds. Key. 他 曲ごとの注文]
    setting_list = []
    20.times do |i|
      setting_list << [
        i + 1,
        @set_list[i] ? @set_list[i][:title] : "",
        "", "", "", "", "", "", "", ""
      ]
    end

    pdf.font_size 10
    pdf.table([headers] + setting_list) do |table|
      table.width = @width
      table.row_colors = %w[ffffff eeeeee]
      table.header = 0
      table.rows(0).style :background_color => 'cccccc', :size => 8, :align => :center
      table.columns(0).align = :right
      table.columns(1).align = :center
      table.rows(1..19).style :borders => [:left, :right]
      table.rows(20).style :borders => [:left, :right, :bottom]
      table.column_widths = {
        0 => 25,
        1 => 150,
        2 => 25,
        3 => 25,
        4 => 25,
        5 => 25,
        6 => 25,
        7 => 25,
        8 => 25
      }
    end

    #pdf.move_down 10
    pdf.bounding_box([0, 200],
      :width => @width/2 ,
      :height => 100
    ) do
      pdf.text "出音要望", :size => 10
      pdf.stroke_bounds
    end
    pdf.bounding_box([0, 100],
      :width => @width/2 ,
      :height => 100
    ) do
      pdf.text "返し要望", :size => 10
      pdf.stroke_bounds
    end
    pdf.bounding_box([@width/2,200],
      :width => @width/2 ,
      :height => 200
    ) do
      pdf.text "my機材・その他要望等", :size => 10
      pdf.stroke_bounds
    end
  end

  # page 3, 4: FR用, FR+TK用
  def make_frontroadie_setting_list(pdf)
    ["上手", "下手"].each do |part|
      print_title(pdf, "#{part}フロントローディー")

      pdf.bounding_box([0,620], :width => @width/2, :height => 100) do
        pdf.text "my機材", :size => 10
        pdf.stroke_bounds
      end
      pdf.bounding_box([@width/2,620], :width => @width/2, :height => 100) do
        pdf.text "要望等", :size => 10
        pdf.stroke_bounds
      end

      pdf.move_down 5
      pdf.table([
          ["使用者", "", "", "", "", "", "", ""],
          ["機材", "", "Marshall", "YAMAHA", "VOX", "Trace", "", ""],
          ["Mic等", "Vo.Mic", "", "", "", "", "", ""]
        ]) do |t|
        t.width = @width
        t.rows(0..2).style :size => 10
        t.columns(0).width = 40
        t.columns(1..7).width = (@width - 40) / 7
        t.columns(1..7).style :align => :center
      end

      setting_list = []
      special = ""
      if part == "上手"
        special = "上手ハロゲン"
      elsif part == "下手"
        special = "合計(分)"
      end
      headers = ["曲順", "曲名", "時間(分)", special, "その他"]
      sum = 0
      20.times do |i|
        set = []
        if @set_list[i]
          set << i + 1
          set << @set_list[i][:title]
          set << @set_list[i][:time]
          sum += @set_list[i][:time].to_f
          if part == "上手"
            set << Halogen[@set_list[i][:halogen_front]]
          elsif part == "下手"
            set << "#{sum}"
          end
          set << ""
        else
          set = [i + 1, "", "", "", ""]
        end
        setting_list << set
      end
      
      pdf.move_down 5
      pdf.table([headers] + setting_list) do |t|
        t.width = @width
        t.header = 0
        t.rows(0..20).style :size => 8, :padding => 3, :align => :center
        t.rows(1..19).style :borders => [:right, :left]
        t.rows(20).style :borders => [:right, :left, :bottom]
        t.column_widths = {0 => 30, 1 => 200, 2 => 40, 3 => 60}
        t.row_colors = %w[ffffff eeeeee]
        t.rows(0).style :background_color => 'cccccc', :size => 8, :align => :center
      end

      pdf.bounding_box([0,150], :width => @width, :height => 150) do
        pdf.stroke_bounds
        pdf.text "ローディーMemo", :size => 10

      end


    end
  end

  # page 5: DR用
  def make_drumroadie_setting_list(pdf)
    print_title(pdf, "ドラムローディー")

    pdf.move_down 5
    pdf.bounding_box([0,610], :width => @width/2, :height => 150) do
      pdf.stroke_bounds
      pdf.text "my機材", :size => 10
    end
    pdf.bounding_box([@width/2,610], :width => @width/2, :height => 150) do
      pdf.stroke_bounds
      pdf.text "要望等", :size => 10
    end

    headers = %w[曲順 曲名 マイク 下手ハロゲン その他]
    setting_list = []
    20.times do |i|
      set = if @set_list[i]
        [
          i + 1,
          @set_list[i][:title],
          "",
          Halogen[@set_list[i][:halogen_drum]], ""
        ]
      else
        [i + 1, "", "", "", ""]
      end
      setting_list << set
    end

    pdf.move_down 10
    pdf.table([headers] + setting_list) do |t|
      t.width = @width
      t.header = 0
      t.rows(0..20).style :size => 8, :align => :center, :padding => 3
      t.rows(1..19).style :borders => [:right, :left]
      t.rows(20).style :borders => [:right, :left, :bottom]
      t.column_widths = {0 => 30, 1 => 200, 2 => 50, 3 => 60}
      t.row_colors = %w[ffffff eeeeee]
      t.rows(0).style :background_color => 'cccccc', :size => 8, :align => :center
    end

    pdf.bounding_box([0,150], :width => @width, :height => 150) do
      pdf.stroke_bounds
      pdf.text "ローディーMemo", :size => 10
    end
  end

  # page 6: カメラ, ビデオ用
  def make_camera_setting_list(pdf)
    print_title(pdf, "撮影")
    headers = %w[曲順 曲名 ソロ 映像について 写真について]
    setting_list = []
    20.times do |i|
      set = if @set_list[i]
        [i + 1, @set_list[i][:title], "", "", ""]
      else
        [i + 1, "", "", "", ""]
      end
      setting_list << set
    end
    pdf.table([headers] + setting_list) do |t|
      t.width = @width
      t.header = 0
      t.rows(0..20).style :size => 10, :align => :center
      t.rows(0).style(
        :background_color => 'cccccc',
        :size => 8,
        :align => :center,
        :borders => [:top, :bottom])
      t.columns(0).style :borders => [:left, :right, :top, :bottom]
      t.columns(2).style :borders => [:left, :top, :bottom]
      t.columns(3).style :borders => [:right, :top, :bottom]
      t.columns(4).style :borders => [:left, :top, :bottom, :right]
      t.rows(1..19).style :borders => [:right, :left]
      t.rows(20).style :borders => [:right, :left, :bottom]
      t.column_widths = {0 => 30, 2 => 40}
      t.row_colors = %w[ffffff eeeeee]
    end

    pdf.bounding_box([0,190], :width => @width, :height => 170) do
      pdf.stroke_bounds
      pdf.text "その他要望", :size => 10
    end
  end

  # page 7: 照明用
  def make_lighting_setting_list(pdf)
    # ページヘッダ出力
    print_title(pdf, "照明")
    
    # 表のヘッダ
    headers = %w[曲順 曲名 時間 曲調・雰囲気 フットライト スポット ハロゲン ミラーボール ストロボ その他要望]
    
    # 表内容生成
    setting_list = []
    20.times do |i|
      set = if @set_list[i]
        [
          i + 1,
          @set_list[i][:title],
          @set_list[i][:time],
          "", "赤　青　黄　緑",  "", "", "", "", ""]
      else
        [i + 1, "", "", "", "赤　青　黄　緑", "", "", "", "", ""]
      end
      setting_list << set
    end
    
    # 表出力
    pdf.table([headers] + setting_list) do |t|
      t.width = @width # 表の幅
      t.header = 0 # ヘッダの指定
      t.rows(0..20).style :size => 9, :align => :center, :padding => 5 # 全行のスタイル
      t.rows(0).style(
        :background_color => 'cccccc',
        :size => 7,
        :align => :center) # ヘッダ行のスタイル
      t.rows(1..19).style :borders => [:right, :left] # ヘッダと最終行以外の行のスタイル
      t.rows(20).style :borders => [:right, :left, :bottom] # 最終行のスタイル
      t.column_widths = {0 => 20, 2 => 30, 4 => 80,
        5 => 20, 6 => 20, 7 => 20, 8 => 20} # 各列の幅
      t.row_colors = %w[ffffff eeeeee] # 行の色 cycle
    end

    # その他要望欄ボックス
    # [0,180] ボックスの左上座標（左下が[0,0]だったはず？）
    # :width 幅
    # :height 高さ
    pdf.bounding_box([0,180], :width => @width, :height => 170) do
      pdf.stroke_bounds
      pdf.text "その他要望", :size => 10
    end
  end

  private
  # 各ページのヘッダ出力メソッド
  def print_title(pdf, title, nl = true)
    @margin ||= {
      :left_margin => 30,
      :right_margin => 30,
      :top_margin => 30,
      :bottom_margin => 30
    }
    pdf.start_new_page(@margin) if nl
    pdf.font "VL-Gothic-Regular.ttf"
    pdf.text title, :align => :center, :size => 20
    pdf.move_down 5
    pdf.stroke_horizontal_line pdf.bounds.left, pdf.bounds.right
    pdf.move_down 5
    pdf.font_size 16
    pdf.text "バンド名: " + @band
    pdf.text "代表者　: " + @representative
    pdf.text "演奏順　: " + @order + " (#{@time}分)"
    pdf.text "ドラマー: " + @drummer if title == "ドラムローディー"
    pdf.text "シフト　: " unless title == "Set List"
    pdf.move_down 5
    pdf.stroke_horizontal_line pdf.bounds.left, pdf.bounds.right
    pdf.move_down 10
    @width = pdf.bounds.right - pdf.bounds.left
  end

  # 
  def make_position_box(pdf, pos, name)
    pdf.bounding_box(pos, :width => 100, :height => 30) do
      pdf.stroke_bounds
      pdf.text name, :size => 10
    end
  end
end
