#!/usr/bin/ruby

class Array
  def sum
    s = 0
    self.each do |v|
      s += v
    end
    return s
  end
end

class Fixnum
  # 刻子
  def anko
    num = self+1
    "(#{num},#{num},#{num})"
  end
  
  # 順子
  def shuntsu
    num = self+1
    "(#{num},#{num+1},#{num+2})"
  end

  # アタマ
  def atama
    num = self+1
    "(#{num},#{num})"
  end

  # 単騎
  def tanki
    num = self+1
    "[#{num}]"
  end

  # リャンメン(ペンチャンも兼ねる)
  def ryanmen
    num = self+1
    "[#{num},#{num+1}]"
  end

  # カンチャン
  def kanchan
    num = self+1
    "[#{num},#{num+2}]"
  end

  # シャボ
  def shabo
    num = self+1
    "[#{num},#{num}]"
  end
end

#
# 雀牌を表す数字列を解析し、0〜8の配列に与えられた個数を入れて返す
#
def parsePai(str)
  pai = Array.new(9, 0)
  str.split(//).each do |p|
    pai[p.to_i-1] += 1
  end

  # 入力の妥当性チェック
  if pai.sum != 13 then
    # 与えられる牌は13枚
    raise RuntimeError
  else
    pai.each do |val|
      if val > 4 then
        # 1種類の牌が4枚より多いことはない
        raise RuntimeError
      end
    end
  end

  return pai
end

#
# 手牌を再帰的に解析し待ちを表示する
#
def analyzeTehai(pai, from=0, mentsu=[])
  if pai.sum > 4 then
    # 面子を揃える
    
    # 刻子
    from.upto(8).each do |i|
      if pai[i] >= 3 then
        tmp = pai.dup
        tmp[i] -= 3
        analyzeTehai(tmp, i+1, mentsu+[i.anko])
      end
    end
  
    # 順子
    [0, from-9].max.upto(6).each do |i|
      if pai[i]>=1 && pai[i+1]>=1 && pai[i+2]>=1 then
        tmp = pai.dup
        tmp[i] -= 1
        tmp[i+1] -= 1
        tmp[i+2] -= 1
        analyzeTehai(tmp, i+9, mentsu+[i.shuntsu])
      end
    end

  else
    # 残った4枚から待ちを絞る
    
    # アタマを探す
    0.upto(8).each do |i|
      if pai[i] >= 2 then
        tmp = pai.dup
        tmp[i] -= 2
        analyzeMachi(tmp, mentsu+[i.atama])
      end
    end

    # 面子(刻子 or 順子)があれば単騎待ち
    # 刻子
    from.upto(8).each do |i|
      if pai[i] >= 3 then
        tmp = pai.dup
        tmp[i] -= 3
        analyzeTanki(tmp, mentsu+[i.anko])
      end
    end
  
    # 順子
    [0, from-9].max.upto(6).each do |i|
      if pai[i]>=1 && pai[i+1]>=1 && pai[i+2]>=1 then
        tmp = pai.dup
        tmp[i] -= 1
        tmp[i+1] -= 1
        tmp[i+2] -= 1
        analyzeTanki(tmp, mentsu + [i.shuntsu])
      end
    end
  end
end

#
# 4枚から待ちを絞る
#
def analyzeMachi(pai, mentsu)
  0.upto(8).each do |i|
    # リャンメン(ペンチャン)
    if pai[i]==1 && pai[i+1]==1 then
      puts mentsu.sort.to_s + i.ryanmen
    end

    # カンチャン
    if pai[i]==1 && pai[i+2]==1 then
      puts mentsu.sort.to_s + i.kanchan
    end

    # シャボ
    if pai[i]==2 then
      puts mentsu.sort.to_s + i.shabo
    end
  end
end

#
# 単騎待ちの数字を調べて待ちを表示する
#
def analyzeTanki(pai, mentsu)
  # 単騎待ち
  0.upto(8).each do |i|
    if pai[i] == 1 then
      puts mentsu.sort.to_s + i.tanki
    end
  end
end

# 以下実際の処理
pai = parsePai ARGV[0] unless ARGV[0] == nil
analyzeTehai(pai)

