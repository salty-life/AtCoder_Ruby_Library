module RBST
  class Node
    def initialize(value)
      @value=value
      @lchild=nil
      @rchild=nil
      @size=1
    end
  end

  def update(n)
    lcs=size(n.lchild)
    rcs=size(n.rchild)
    n.size=lcs+rcs+1
    return n
  end

  def size(n)
    return n.nil? ? 0 : n.size
  end

  def merge(l,r)
    return l if r.nil?
    return r if l.nil?

    if rand<l.size.to_f/(l.size+r.size)
      l.rchild=merge(l.rchild,r)
      return update(l)
    else
      r.lchild=merge(l,r.lchild)
      return update(r)
    end
  end

  def split(n,k)
    return nil,nil if n.nil?

    lcs=size(n.lchild)
    if k<=lcs
      l,r=split(n.lchild,k)
      n.lchild=r
      return l,update(n)
    else
      l,r=split(n.rchild,k-lcs-1)
      n.rchild=l
      return update(n),r
    end
  end

  def get(n,k)
    return nil if k<=0 || n.size<k
    lcs=size(n.lchild)
    if k<=lcs
      return get(n.lchild,k)
    elsif k==lcs+1
      return n.value
    else
      return get(n.rchild,k-lcs-1)
    end
  end

  def insert(n,k,v)
    l,r=n.split(k)
    return merge(merge(l,v),r)
  end

  def erace(n,k)
    l,r=split(n,k)
    l1,l2=split(l,k-1)
    return merge(l1,r)
  end
end
