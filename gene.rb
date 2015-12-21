class Gene
  attr_accessor :score
  attr_accessor :text

  #  初期化
  def initialize(textlen, mutationrate = 5)
    @score = 0.0
    @mutationrate = mutationrate

    #  辞書
    @dic = Hash[[*'a'..'z', *'A'..'Z'].map.with_index{|val,i| [val, i]}]
    @text = (0...textlen).map { @dic.invert[rand(@dic.size)] }.join
  end

  #交叉の結果できた遺伝子を返す
  def crossover(objgene)
    textarr = @text.split(//)
    objarr = objgene.text.split(//)
    crosspos = rand(textarr.size)

    (crosspos...textarr.size).each do |i|
      textarr[i] = objarr[i]
    end

    child = clone
    child.text = textarr.join
    return child
  end

  #  子を返す
  def breed(objgene)
    #  交叉する
    child = crossover(objgene)

    #  突然変異
    if rand(100) < @mutationrate then
      child.mutation!
    end

    return child
  end

  #突然変異
  def mutation!
    #増やすか減らすか 0なら減らし、1なら増やす
    up = rand(2).zero?

    # 文字列のコードポイントを取得し、前後のどちらかにズラす
    textarr = @text.split(//)
    pos = rand(textarr.size)

    #変異前の文字を取得
    srcchar = textarr[pos].ord

    if (srcchar == "Z".ord && up) then
      srcchar = "a".ord
    elsif(srcchar == "z".ord) then
      srcchar -= 1
    elsif(srcchar == "A".ord && !up) then
      srcchar = "z".ord
    elsif(srcchar == "a".ord && !up) then
      srcchar = "Z".ord
    else
      if(up) then
        srcchar += 1
      else
        srcchar -= 1
      end
    end

    textarr[pos] = srcchar.chr("UTF-8")

    @text = textarr.join
  end

end
