# セグメントツリーの実装
class SegmentTree
  def initialize(n,v=nil)
    @size=n  # 要素数
    @realsize=1  # ２の累乗までパディングした要素数
    while @realsize<@size do
      @realsize*=2
    end
    @default=Float::INFINITY  # ツリーのデフォルト値（タスクによって変更する）
    @tree=Array.new(2*@realsize,@default)
    build(v) if v
  end

  # 配列を最下層にそれぞれ導入し、上層をそのあとで更新する
  # 一つずつ追加するより効率的
  def build(v)
    @tree[@realsize,v.size]=v
    (@realsize-1).downto(1) do |parent|
      @tree[parent]=merge(@tree[2*parent],@tree[2*parent+1])
    end
  end

  # 二つの子ノードの値から親ノードの値を決定する
  # タスクによって処理を変更する
  # この例では最小値を返す
  def merge(a,b)
    return a<b ? a : b 
  end

  # 一点での変更
  def change(i,x)
    i+=@realsize
    @tree[i]=x
    while i>1 do
      parent=i/2
      brother=i^1
      @tree[parent]=merge(@tree[i],@tree[brother])
      i=parent
    end
  end

  # [a,b)における結果を返す
  def get_result(a,b)
    return _get_result(a,b,1,0,@realsize)
  end

  # 内部メソッド
  def _get_result(a,b,k,l,r)
    return @default if r<=a || b<=l
    return @tree[k] if a<=l && r<=b
    vl=_get_result(a,b,2*k,l,(l+r)/2)
    vr=_get_result(a,b,2*k+1,(l+r)/2,r)
    return merge(vl,vr)
  end
end


# 遅延評価を行うセグメントツリーの実装
class LazySegmentTree
  def initialize(n,v=nil)
    @size=n  # 要素数
    @realsize=1
    while @realsize<@size do
      @realsize*=2
    end
    @tree_default=Float::INFINITY  # ツリーのデフォルト値（タスクによって変更する）
    @change_default=nil  # 変更ツリーに値が設定されていないことを表す値（タスクによって変更する）
    @tree=Array.new(2*@realsize,@tree_default)
    # 変更ツリーに値が設定されている場合、ツリーの対応するインデックスは変更ツリーの値として扱う
    @change=Array.new(2*@realsize,@change_default)
    build(v) if v
  end

  # 配列を最下層にそれぞれ導入し、上層をそのあとで更新する
  # 一つずつ追加するより効率的
  def build(v)
    @tree[@realsize,v.size]=v
    (@realsize-1).downto(1) do |parent|
      @tree[parent]=merge(@tree[2*parent],@tree[2*parent+1],@change[parent])
    end
  end
 
 
  # 二つの子ノードと、変更ツリーの値から親ノードの値を決定する
  # タスクによって処理を変更する
  # この例では最小値を返す
  def merge(a,b,c)
    #  変更ツリーに値が設定されていればその値、そうでなければ最小値
    return c!=@change_default ? c : (a<b ? a : b)
  end
 

  def change_range(a,b,x)
    _change_range(a,b,1,0,@realsize,x,@change_default)
  end
  # 内部関数
  # a,b: 変更範囲
  # k: 現在見ているノードのインデックス
  # l,r: 現在見ているノードの範囲
  # x: 変更値
  # propergate_x: 上層から伝播してきた変更値
  # @tree[k]を更新後、@change[k]はリセットされる
  def _change_range(a,b,k,l,r,x,propergate_x)
    # 現在見ているノードが変更範囲に含まれていなければ
    # 親ノードから伝播してきた値で更新して再帰終了
    # @change[k]に値が入っていようが、伝播してきた値を優先する
    if r<=a || b<=l
      @change[k]=propergate_x if propergate_x!=@change_default
      @tree[k]=merge(@tree[k],@tree_default,@change[k])
      return
    end
    # 現在見ているノードが変更範囲に完全にカバーされていれば
    # 変更値で更新して再帰終了
    # @change[k]に値が入っていようが、変更値を優先する
    if a<=l && r<=b
      @change[k]=x
      @tree[k]=merge(@tree[k],@tree_default,@change[k])
      return
    end
    # そうでなければ再帰を行った後で、更新
    propergate_x=@change[k] if propergate_x==@change_default
    @change[k]=@change_default
    _change_range(a,b,2*k,l,(l+r)/2,x,propergate_x)
    _change_range(a,b,2*k+1,(l+r)/2,r,x,propergate_x)
    @tree[k]=merge(@tree[2*k],@tree[2*k+1],@change_default)
    return
  end

 
  # [a,b)に対する結果を返す
  def get_result(a,b)
    return _get_result(a,b,1,0,@realsize)
  end
 
  # 内部関数
  def _get_result(a,b,k,l,r)
    return @tree_default if r<=a || b<=l
    return @tree[k] if a<=l && r<=b
    vl=_get_result(a,b,2*k,l,(l+r)/2)
    vr=_get_result(a,b,2*k+1,(l+r)/2,r)
    return merge(vl,vr,@change[k])
  end
end

def test
  arr=(0..8).to_a
  lst=LazySegmentTree.new(arr.length,arr)
  print "input task > "
  ARGF.each do |line|
    task,*args=line.chomp.split
    if task=="change"
      lst.change_range(*args.map(&:to_i))
    elsif task=="min"
      p lst.get_result(*args.map(&:to_i))
    elsif task=="exit"
      break
    else
      puts "change X Y Z or min X Y or exit"
    end
    print "input task > "
  end
end

test if $0==__FILE__
