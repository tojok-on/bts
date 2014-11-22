# coding: utf-8
class SettingList
  Halogen = {
    :red => "赤",
    :blue => "青",
    :yellow => "黄",
    :green => "緑",
    :lightblue => "水色",
    :purple => "紫",
    :orange => "橙",
    :pink => "桃",
    :white => "白"
  }

  def initialize(band, time, orderday, ordernum, representative, set_list, drummer)
    @band = band
    @time = time
    @orderday = orderday
    @ordernum = ordernum
    @representative = representative
    @set_list = set_list
    @drummer = drummer
    @margin = {
      :left_margin => 30,
      :right_margin => 30,
      :top_margin => 30,
      :bottom_margin => 30
    }
  end

  def make_set_list(pdf)
    print_title(pdf, "Set List", false)

    set_list = []
    15.times do |i|
      set_list << [i + 1, @set_list[i] ? @set_list[i][:title] : ""]
    end
    pdf.table(set_list) do |t|
      t.width = @width
      t.columns(0).width = 40
      t.columns(0..1).style :borders => []
      t.rows(0..15).style :size => 18, :padding => 10
    end
  end

  def make_pa_setting_list(pdf)
    print_title(pdf, "PA")
    pdf.font_size 10
	pdf.text "※アンプの使用者を記入してください"
	pdf.table([
          ["使用者", "", "", "", "", "", "", ""],
          ["機材",  "Marshall", "YAMAHA", "VOX", "JC", "Hartke", "", ""],
        ]) do |t|
        t.width = @width
        t.rows(0..1).style :size => 10
        t.columns(0).width = 40
        t.columns(1..7).width = (@width - 40) / 7
        #t.columns(0).style :borders => [:left, :right]
        t.columns(1..7).style :align => :center
        #t.rows(0).style :borders => [:left, :right, :top]
        #t.rows(2).style :borders => [:left, :right, :bottom]
	end

	pdf.move_down 10
	pdf.text "※コーラスマイクを使用する場合は使用する位置に○をつけてください"
    headers = %w[曲順 曲名 Vo. 上手 下手 Dr. Key. 他 曲ごとの注文]
	
    setting_list = []
    15.times do |i|
      setting_list << [
        i + 1,
        @set_list[i] ? @set_list[i][:title] : "",
        "", "", "", "", "", "", ""
      ]
    end


    pdf.table([headers] + setting_list) do |table|
      table.width = @width
      table.row_colors = %w[ffffff eeeeee]
      table.header = 0
      table.rows(0).style :background_color => 'cccccc', :size => 8, :align => :center
      table.columns(0).align = :right
      table.columns(1).align = :center
      table.rows(1..15).style :size => 16, :padding => 5, :align => :center
      table.rows(1..14).style :borders => [:left, :right]
      table.rows(15).style :borders => [:left, :right, :bottom]
      table.columns(1).style :size => 12
      table.column_widths = {
        0 => 25,
        2 => 25,
        3 => 25,
        4 => 25,
        5 => 25,
        6 => 25,
        7 => 25,
      }
    end

    #pdf.move_down 10
    pdf.bounding_box([0, 140],
      :width => @width/2 ,
      :height => 70
    ) do
      pdf.text "出音要望", :size => 10
      pdf.stroke_bounds
    end
    pdf.bounding_box([0, 70],
      :width => @width/2 ,
      :height => 70
    ) do
      pdf.text "返し要望", :size => 10
      pdf.stroke_bounds
    end
    pdf.bounding_box([@width/2,140],
      :width => @width/2 ,
      :height => 70
    ) do
      pdf.text "my機材・その他要望等", :size => 10
      pdf.stroke_bounds
    end
    pdf.bounding_box([@width/2,70],
      :width => @width/2 ,
      :height => 70
    ) do
      pdf.text "MEMO", :size => 10
      pdf.stroke_bounds
    end
  end

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
          ["機材", "", "Marshall", "YAMAHA", "VOX", "JC", "Hartke", ""],
          ["Mic等", "Vo.Mic", "", "", "", "", "", ""]
        ]) do |t|
        t.width = @width
        t.rows(0..2).style :size => 10
        t.columns(0).width = 40
        t.columns(1..7).width = (@width - 40) / 7
        #t.columns(0).style :borders => [:left, :right]
        t.columns(1..7).style :align => :center
        #t.rows(0).style :borders => [:left, :right, :top]
        #t.rows(2).style :borders => [:left, :right, :bottom]
      end

      setting_list = []
      headers = ["曲順", "曲名", "時間(分)", "合計(分)", "その他"]
      sum = 0
      15.times do |i|
        set = []
        if @set_list[i]
          set << i + 1
          set << @set_list[i][:title]
          set << @set_list[i][:time]
          sum += @set_list[i][:time].to_f
		  set << "#{sum}"
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
        t.rows(0).style :size => 10, :padding => 3, :align => :center
        t.rows(1..15).style :size => 11, :padding => 4, :align => :center
        t.rows(1..14).style :borders => [:right, :left]
        t.rows(15).style :borders => [:right, :left, :bottom]
        t.column_widths = {0 => 30,  2 => 40, 3 => 60}
        t.row_colors = %w[ffffff eeeeee]
        t.rows(0).style :background_color => 'cccccc', :size => 8, :align => :center
		t.columns(0).align = :center
      end

      pdf.bounding_box([0,140], :width => @width, :height => 140) do
        pdf.stroke_bounds
        pdf.text "MEMO", :size => 10

      end


    end
  end

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

    headers = %w[曲順 曲名 マイク その他]
    setting_list = []
	sum = 0
    15.times do |i|
      set = if @set_list[i]
        [
          i + 1,
          @set_list[i][:title],
          "", ""
        ]
      else
        [i + 1, "", "", ""]
      end
      setting_list << set
    end

    pdf.move_down 5
    pdf.table([headers] + setting_list) do |t|
      t.width = @width
      t.header = 0
      t.rows(0).style :size => 10, :padding => 3, :align => :center
      t.rows(1..15).style :size => 11, :padding => 4, :align => :center
      t.rows(1..14).style :borders => [:right, :left]
      t.rows(15).style :borders => [:right, :left, :bottom]
      t.column_widths = {0 => 30, 2 => 50}
      t.row_colors = %w[ffffff eeeeee]
      t.rows(0).style :background_color => 'cccccc', :size => 8, :align => :center
    end
    pdf.bounding_box([0,150], :width => @width/5*3, :height => 150) do
      pdf.stroke_bounds
      pdf.text "MEMO", :size => 10
    end
    pdf.bounding_box([@width/5*3+1,150], :width => @width/5*2, :height => 150) do
      pdf.stroke_bounds
      pdf.text "セッティング", :size => 10
      pdf.text "観客席側", :align => :center, :size => 8
      pdf.image(DRUM_IMG, :scale => 0.4, :align => :center) 
    end

  end

  def make_camera_setting_list(pdf)
    print_title(pdf, "撮影")
    headers = %w[曲順 曲名 ソロ 映像について 写真について]
    setting_list = []
    15.times do |i|
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
      t.rows(0).style :size => 12, :padding => 5, :align => :center
      t.rows(1..15).style :size => 16, :padding => 6, :align => :center
      t.rows(0).style(
        :background_color => 'cccccc',
        :size => 8,
        :align => :center,
        :borders => [:top, :bottom])
      t.columns(0).style :borders => [:left, :right, :top, :bottom]
      t.columns(2).style :borders => [:left, :top, :bottom, :right]
      t.columns(3).style :borders => [:right, :top, :bottom]
      t.columns(4).style :borders => [:left, :top, :bottom, :right]
      t.rows(1..14).style :borders => [:right, :left]
      t.rows(15).style :borders => [:right, :left, :bottom]
      t.column_widths = {0 => 30, 2 => 40}
      t.row_colors = %w[ffffff eeeeee]
    end

    pdf.bounding_box([0,190], :width => @width, :height => 170) do
      pdf.stroke_bounds
      pdf.text "その他要望", :size => 10
    end
  end

  def make_lighting_setting_list(pdf)
    print_title(pdf, "照明")
	pdf.text "※「逆」 = 逆光　「ミ」 = ミラーボール　「ス」 = ストロボ　「全」 = 全消し", :size => 10
    headers = %w[曲順 曲名 時間 曲調・雰囲気 色のイメージ 逆 ミ ス 全 その他要望]
    setting_list = []
    15.times do |i|
      set = []
        if @set_list[i]
          set << i + 1
          set << @set_list[i][:title]
          set << @set_list[i][:time]
		  set << ""
          if @set_list[i][:title] == "MC" || @set_list[i][:title] == "ＭＣ"
		    set << ""
		  else
			set << @set_list[i][:halogen_front].map {|col| Halogen[col.to_sym]}.join(" ")
		  end
		  if @set_list[i][:backlight] == "1"
			set << "○"
          else
		    set << "×"
		  end
		  if @set_list[i][:mirror] == "1"
			set << "○"
          else
		    set << "×"
		  end
		  if @set_list[i][:strobo] == "1"
			set << "○"
          else
		    set << "×"
		  end
		  if @set_list[i][:blackout] == "1"
			set << "○"
          else
		    set << "×"
		  end
          set << ""
        else
          set = [i + 1, "", "", "", "", "", "", "", "", ""]
        end
      setting_list << set

    end
    pdf.table([headers] + setting_list) do |t|
      t.width = @width
      t.header = 0
      t.rows(0).style :size => 12, :padding => 5, :align => :center
      t.rows(1..15).style :size => 10, :padding => 12, :align => :center, :height => 38
      t.rows(0).style(
        :background_color => 'cccccc',
        :size => 8,
        :align => :center,
        :borders => [:top, :bottom])
        
      t.rows(0).style :borders => [:top, :right, :left, :bottom]
      t.rows(1..14).style :borders => [:right, :left]
      t.rows(15).style :borders => [:right, :left, :bottom]

      t.column(0).style :width => 20, :padding => 3, :padding_top => 12
      t.column(2).style :width => 30, :padding => 3, :padding_top => 12
      t.column(4).style :width => 80, :padding => 3, :padding_top => 12
      t.column(5..8).style :width => 20, :padding => 3, :padding_top => 12
      t.rows(0).style :padding_top => 10
      t.row_colors = %w[ffffff eeeeee]
    end


  end

  private
  def print_title(pdf, title, nl = true)
    pdf.start_new_page(@margin) if nl
    pdf.font "VL-Gothic-Regular.ttf"
    pdf.text title, :align => :center, :size => 20
    pdf.move_down 5
	pdf.font_size 10
	if title == "ドラムローディー"
	pdf.text "担当ドラムローディーはリハ時に運ぶ機材やセッティングを確認しておいてください！！"
	elsif title == "照明"
	pdf.text "全消しに関しては担当バンドのプレーヤーにタイミング等を確認してください！！"
	end
    pdf.stroke_horizontal_line pdf.bounds.left, pdf.bounds.right
    pdf.move_down 5
    pdf.font_size 16
    pdf.text "バンド名: " + @band
    pdf.text "代表者　: " + @representative
    pdf.text "演奏順　: #{@orderday}日目 #{@ordernum}番目  (#{@time}分)"
    pdf.text "ドラマー: " + @drummer if title == "ドラムローディー"
    pdf.move_down 5
    pdf.stroke_horizontal_line pdf.bounds.left, pdf.bounds.right
    pdf.move_down 10
    @width = pdf.bounds.right - pdf.bounds.left
  end

  def make_position_box(pdf, pos, name)
    pdf.bounding_box(pos, :width => 100, :height => 30) do
      pdf.stroke_bounds
      pdf.text name, :size => 10
    end
  end
end
