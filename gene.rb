require 'levenshtein'
class Gene
  attr_accessor :score
  attr_accessor :text

  #初期化
  def initialize(textlen, mutationrate = 5)
    @score = 0.0
    @mutationrate = mutationrate

    #ランダムな文字列を作る
    o = (('a'..'z').to_a + ('A'..'Z').to_a)

    @text = (0...textlen).map { o[rand(o.length)] }.join
  end

  def getcharlist
    charlist = [('a'..'z'), ('A'..'Z'), (' ')].map { |i|
      i.to_a
    }.flatten

    return charlist
  end

  # TODO: 評価方法は後で分かりやすく
  #評価関数 実数で評価を返し、自身のscoreにも格納する
  def evaluation
    answerarr = GeneticAlgorithm::ANSWERTEXT.split(//)
    textarr = @text.split(//)

    total = 0
    textarr.each_with_index do |chr, i|
      total += (answerarr[i].ord - textarr[i].ord).abs
    end
    # score = Levenshtein.normalized_distance(GeneticAlgorithm::ANSWERTEXT, @text)

    @score = total
    return total
  end

  #交叉
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

  #突然変異
  def mutation!
    #増やすか減らすか 0なら減らし、1なら増やす
    updown = rand(2)

    # 文字列のコードポイントを取得し、前後のどちらかにズラす
    textarr = @text.split(//)
    pos = rand(textarr.size)

    #変異前の文字を取得
    srcchar = textarr[pos].ord

    if (srcchar == "Z".ord && updown == 1) then
      srcchar = "a".ord
    elsif(srcchar == "z".ord) then
      srcchar -= 1
    elsif(srcchar == "A".ord && updown != 1) then
      srcchar = "z".ord
    elsif(srcchar == "a".ord && updown != 1) then
      srcchar = "Z".ord
    else
      if(updown == 1) then
        srcchar += 1
      else
        srcchar -= 1
      end
    end

    textarr[pos] = srcchar.chr("UTF-8")

    @text = textarr.join
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
end
