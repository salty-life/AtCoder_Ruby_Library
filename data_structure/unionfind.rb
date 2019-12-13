
# https://qiita.com/k_karen/items/5349a25c3eb7b4697f58 のもの
class UnionFind
    def initialize(size)
      @rank = Array.new(size, 0)
      @parent = Array.new(size, &:itself)
    end
  
    def unite(id_x, id_y)
      x_parent = get_parent(id_x)
      y_parent = get_parent(id_y)
      return if x_parent == y_parent
  
      if @rank[x_parent] > @rank[y_parent]
        @parent[y_parent] = x_parent
      else
        @parent[x_parent] = y_parent
        @rank[y_parent] += 1 if @rank[x_parent] == @rank[y_parent]
      end
    end
  
    def get_parent(id_x)
      @parent[id_x] == id_x ? id_x : (@parent[id_x] = get_parent(@parent[id_x]))
    end
  
    def same_parent?(id_x, id_y)
      get_parent(id_x) == get_parent(id_y)
    end
end



# こちらは自作
class WeightedUnionFind
    @par=[] # 親の番号
    @ws=[]  # 親との重みの差
    
    def initialize(n)
        @par = (0...n).to_a
        @ws  = Array.new(n,0)
    end
    
    def find(x)
        if @par[x]==x
            return x
        else
            parent = find(@par[x])
            @ws[x] += @ws[@par[x]]
            @par[x]=parent
            return parent
        end
    end
    
    def weight(x)
        find(x) 
        return @ws[x]
    end
    
    def union(x,y,w) # x <-(w)- y (x + w = y)
        w += weight(x)
        w -= weight(y)
        x = find(x)
        y = find(y)
        
        if x != y
            @par[y] = x
            @ws[y] = w
            return true
        else
            return false
        end
    end
    
    def same(x, y)
        return find(x) == find(y)
    end
    
    def diff(x,y) # x - y を求める. 比較不能ならnil
        return nil if !same(x, y)
        return weight(x) - weight(y)
    end
end
