require 'pry-byebug'
require './gene'
require './score'

class KikukawaReiGenerator
  attr_reader :generation
  attr_reader :genes

  KIKUKAWA_REI = "KikukawaRei"
  def initialize(gene_count, mutationrate = 5)
    @generation = 1
    @textlen = KIKUKAWA_REI.split(//).size
    @genes =[]

    # 世代数の数だけ遺伝子を作成する
    gene_count.times do |i|
      @genes << Gene.new(@textlen, mutationrate)
    end

    # 遺伝子の評価を行う
    Score::calculation(KIKUKAWA_REI, @genes)
    Score::sort(@genes)


    # 解答が一致するまで繰り返す
    while Score::top_score(@genes) > 0
      log
      next_generation
      Score::calculation(KIKUKAWA_REI, @genes)
      Score::sort(@genes)
    end

    log
  end

  def breed(a, b)
    child = a.breed(b)

    return child
  end

  def next_generation
    @generation += 1
    (3...@genes.size).each do |i|
      # 子を作る
      @genes[i] = breed(@genes[0], @genes[1])
    end
  end

  def log
    puts "generation : " + @generation.to_s
    @genes.each do |gene|
      puts "#{gene.text} score : #{gene.score.to_s}"
    end
    puts "*******************************"
  end

end

# mutationrate → 突然変異率
kikukawa_rei = KikukawaReiGenerator.new(20, 15)
p "Answer: #{kikukawa_rei.genes.first.text}"
