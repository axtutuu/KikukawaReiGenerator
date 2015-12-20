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
    Score::get_score(KIKUKAWA_REI, @genes)
    Score::sort(@genes)


    while Score::top_score(@genes) > 0
      dump
      next_generation
      Score::get_score(KIKUKAWA_REI, @genes)
      Score::sort(@genes)
    end

    dump
  end

  #その世代の全遺伝子を出力
  def dump
    puts "generation : " + @generation.to_s
    @genes.each do |gene|
      puts gene.text + "  distance : " + gene.score.to_s
    end
    puts "----------"
  end

  #子を返す
  def breed(a, b)
    child = a.breed(b)

    return child
  end

  #世代を進める
  def next_generation
    @generation += 1
    (3...@genes.size).each do |i|
      # トップ2の遺伝子を交配する
      @genes[i] = breed(@genes[0], @genes[1])
    end
  end

  #実行
  def exec
    while Score::top_score(@genes) > 0
      dump
      next_generation
      Score::get_score(KIKUKAWA_REI, @genes)
      Score::sort(@genes)
    end

    dump
  end
end

# mutationrate → 突然変異率
kikukawa_rei = KikukawaReiGenerator.new(20, 15)
p kikukawa_rei.genes.first.text
