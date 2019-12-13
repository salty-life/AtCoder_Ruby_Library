

class PRBIT
  def initialize(n)
    @size=n
    @tree=Array.new(@size+1,0)
  end

  def sum(i)
    i=@size if i>@size
    s=0
    while i>0 do
      s+=@tree[i]
      i-=i&-i
    end
    return s
  end

  def add(i,x)
    return if i<=0
    while i<=@size do
      @tree[i]+=x
      i+=i&-i
    end
  end
end


# PRBITとして微分値を保存しておくことで、範囲足し込みを2点の操作に変更する
# sumで積分をとることで値を得る
class RPBIT < PRBIT
  # [i,j]にxを足しこむ
  def add_between(i,j,x)
    return if !(j<i && 0<i && i<=@size && 0<j && j<=@size)
    add(i,x)
    add(j+1,-x)
  end
  def get(i)
    return sum(i)
  end
end

# PRBITを２つ用い、範囲変更と範囲クエリの両方に対応
class RRBIT
  def initialize(n)
    @size=n
    @a=PRBIT.new(n)　# 一次の項
    @b=PRBIT.new(n)  # 定数項
  end

  # [i,j]にxを足しこむ
  def add_between(i,j,x)
    return if !(j<i && 0<i && i<=@size && 0<j && j<=@size)
    @a.add(i,x)
    @a.add(j+1,-x)
    @b.add(i,-x*(i-1))
    @b.add(j+1,x*j)
    return @a.sum(i)*i+@b.sum(i)
  end
end


# 数字列について各数字の出現回数をカウントし、k番目の要素が何であるかを返す
class CounterBIT < PRBIT
  def initialize(n)
    super(n)
    @counter=Array.new(n+1,0)
  end

  def get_kth(k)
    return 0 if k<=0
    return 1 if @size==1
    return @size+1 if k>sum(@size)
    diff=@size/2
    index=diff

    while diff!=1 # k will be in [index-diff+1, index+diff]
      diff/=2
      if k<=@tree[index]
        index-=diff
      else
        k-=@tree[index]
        index+=diff
      end
    end
    index+=1 if @tree[index]<k
    return index
  end

  alias :super_add :add
  def add(i)
    super_add(i,1)
    @counter[i]+=1
  end
  def remove(i)
    return if @counter[i]==0
    super_add(i,-1)
    @counter[i]-=1
  end
end


