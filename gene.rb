class Gene
  attr_accessor :score
  attr_accessor :text
  attr_accessor :dic

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
    textarr = @text.split("")
    objarr = objgene.text.split("")
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
    up = rand(2).zero?

    textarr = @text.split(//)
    pos = rand(textarr.size)

    if (@dic[textarr[pos]] == "Z" && up)
      num = 0
    elsif (@dic[textarr[pos]] == "a" && !up)
      num = 51
    else
      num = up ? @dic[textarr[pos]] + 1 : @dic[textarr[pos]] - 1
    end

    textarr[pos] = @dic.invert[num]
    @text = textarr.join
  end

end
