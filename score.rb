module Score extend self
  def get_score(rei, genes)
    genes.each do |gene|
      rei_arr = rei.split(//)
      gene_text_arr = gene.text.split(//)

      # スコアの初期化
      total = 0
      # コードポイントで距離の評価
      gene_text_arr.each_with_index do |chr, i|
        total += (rei_arr[i].ord - gene_text_arr[i].ord).abs
      end

      gene.score = total
    end
  end

  def top_score(genes)
    return genes.first.score
  end

  def sort(genes)
    genes.sort! do |a, b|
      a.score <=> b.score
    end
  end
end
