#!/usr/bin/ruby

class Fixnum
  # 面子の出力用
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

  # 待ちの出力用
  # 単騎
  def tanki
    num = self+1
    "[#{num}]"
  end

  # リャンメン(ペンチャンもかねる)
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
# 引数として指定された数字列を解析
#
def parsePai(str)
  pai = Array.new(9, 0)
  str.split(//).each do |p|
    pai[p.to_i-1] += 1
  end

  return pai
end

#
# 手牌を解析して待ちを表示する
#
def analyzeTehai(pai, mentsu=0, from=0, str="")
  if mentsu < 3 then
    # 面子を揃える
   
    # 刻子
    from.upto(8).each do |i|
      if pai[i] >= 3 then
        tmp = pai.dup
        tmp[i] -= 3
        analyzeTehai(tmp, mentsu+1, i+1, str + i.anko)
      end
    end
  
    # 順子
    [0, from-9].max.upto(6).each do |i|
      if pai[i]>=1 && pai[i+1]>=1 && pai[i+2]>=1 then
        tmp = pai.dup
        tmp[i] -= 1
        tmp[i+1] -= 1
        tmp[i+2] -= 1
        analyzeTehai(tmp, mentsu+1, i+9, str + i.shuntsu)
      end
    end

  else
    # 待ちを絞る

    # アタマを探す
    0.upto(8).each do |i|
      if pai[i] >= 2 then
        tmp = pai.dup
        tmp[i] -= 2
        analyzeMachi(tmp, str + i.atama)
      end
    end

    # 面子(刻子 or 順子)があれば単騎待ち
    # 刻子
    from.upto(8).each do |i|
      if pai[i] >= 3 then
        tmp = pai.dup
        tmp[i] -= 3
        analyzeTanki(tmp, str + i.anko)
      end
    end
  
    # 順子
    [0, from-9].max.upto(6).each do |i|
      if pai[i]>=1 && pai[i+1]>=1 && pai[i+2]>=1 then
        tmp = pai.dup
        tmp[i] -= 1
        tmp[i+1] -= 1
        tmp[i+2] -= 1
        analyzeTanki(tmp, str + i.shuntsu)
      end
    end
  end
end

def analyzeMachi(pai, str)
  # リャンメン(ペンチャン)
  0.upto(7).each do |i|
    if pai[i]==1 && pai[i+1]==1 then
      puts str + i.ryanmen
    end
  end

  # カンチャン
  0.upto(6).each do |i|
    if pai[i]==1 && pai[i+2]==1 then
      puts str + i.kanchan
    end
  end

  # シャボ
  0.upto(8).each do |i|
    if pai[i]==2 then
      puts str + i.shabo
    end
  end
end

def analyzeTanki(pai, str)
  # 単騎待ち
  0.upto(8).each do |i|
    if pai[i] == 1 then
      puts str + i.tanki
    end
  end
end


# 以下実際の処理
pai = parsePai ARGV[0] unless ARGV[0] == nil
analyzeTehai(pai)

