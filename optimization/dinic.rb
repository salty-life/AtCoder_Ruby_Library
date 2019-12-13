#!/usr/bin/ruby
# -*- coding: utf-8 -*-


module Dinic
  class Edge
    attr_accessor :revedge_index,:from,:to,:capacity,:initial_capacity
    def initialize(rev,f,t,cap)
      @revedge_index=rev # nodes[to]における自身と逆向きの辺を指すインデックス
      @from=f
      @to=t
      @capacity=cap # フローが流れている状態での容量
      @initial_capacity=cap # 初期容量（有向辺と同じ向きならその容量、逆なら0）
    end

    def to_s()
      return "#{@from}->#{to} (#{flow()} in #{@capacity})"
    end

    def flow()
      return [@initial_capacity-@capacity,0].max
    end
  end

  class Graph
    def initialize(n)
      @nodes=Array.new(n){Array.new}
    end

    def length()
      return @nodes.length
    end

    def [](i)
      return @nodes[i]
    end

    def to_s()
      @nodes.each_with_index.map{|node,node_index|
        "node:#{node_index} / "+node.map(&:to_s).join(" / ")
      }.join("\n")
    end

    # 逆向きの辺を返す
    def revedge(e)
      if e.from!=e.to
        return @nodes[e.to][e.revedge_index]
      else
        raise "hoge"
        return @nodes[e.to][e.revedge_index+1]
      end
    end

    # fromからtoまで容量capの辺を張り、逆向きに容量0の辺を張る
    def addedge(from,to,cap)
      normal_edge=Edge.new(@nodes[to].length,from,to,cap)
      reverse_edge=Edge.new(@nodes[from].length,to,from,0)
      @nodes[from] << normal_edge
      @nodes[to] << reverse_edge
    end
  end

  # 幅優先探索によってソースから各ノードまで容量に余裕のあるルートのみを通る道を探す
  # ソースから何本の辺をたどればそのノードに届くかをlevelsとして返す
  def bfs(graph,source)
    levels=Array.new(graph.length,-1)
    levels[source]=0
    queue=[source]
    while !queue.empty?
      v=queue.shift
      graph[v].each do |edge|
        if levels[edge.to]==-1 && edge.capacity>0
          levels[edge.to]=levels[v]+1
          queue.push(edge.to)
        end
      end
    end
    return levels
  end

  # ソースからシンクまでをつなぐ容量が正の辺のみを用いた一つの道を深さ優先探索し
  # その道に属する全ての辺の容量を減らしつつ、フローの値を返す
  # 既に見た辺を再び通らないように、next_indexesに
  # 各ノードについて次に見るべき辺のインデックスを保存しておく
  def dfs(graph,v,sink,temp_diff_flow,levels,next_indexes)
    return temp_diff_flow if v==sink
    while next_indexes[v]<graph[v].length
      edge=graph[v][next_indexes[v]]
      revedge=graph.revedge(edge)
      if levels[v] < levels[edge.to] && edge.capacity>0
        diff_flow=dfs(graph,edge.to,sink,[temp_diff_flow,edge.capacity].min,levels,next_indexes)
        if diff_flow>0
          edge.capacity-=diff_flow
          revedge.capacity+=diff_flow
          return diff_flow
        end
      end
      next_indexes[v]+=1
    end
    return 0
  end

  # dinicのアルゴリズムを用いて最大流を求める
  def dinic(graph,source,sink)
    ret=0
    while true
      levels=bfs(graph,source)
      break if levels[sink]<0
      while true
        flow=dfs(graph,source,sink,Float::INFINITY,levels,Array.new(graph.length,0))
        break if flow==0
        ret+=flow
      end
    end
    return ret
  end

  module_function :dinic, :bfs, :dfs
end

def maximum_bipartite_matching(a_size,b_size,edges)
  source_index=a_size+b_size
  sink_index=source_index+1
  node_full_size=sink_index+1
  graph=Dinic::Graph.new(node_full_size)

  edges.each do |from,to|
    graph.addedge(from,to+a_size,1)
  end
  a_size.times do |i|
    graph.addedge(source_index,i,1)
  end
  b_size.times do |i|
    graph.addedge(i+a_size,sink_index,1)
  end

  max_flow=Dinic::dinic(graph,source_index,sink_index)

  ret=[]
  a_size.times do |i|
    graph[i].each do |edge|
      if edge.initial_capacity==1 && edge.capacity==0
        ret << [edge.from,edge.to-a_size] 
        puts edge
      end 
    end
  end


end

edges=[
  [0,0],
  [0,3],
  [0,8],
  [1,3],
  [1,6],
  [2,1],
  [2,5],
  [2,9],
  [3,3],
  [4,2],
  [4,5],
  [4,9],
  [5,0],
  [5,4],
  [5,7],
  [6,3],
  [6,6],
  [7,0],
  [7,2],
  [7,8],
  [8,1],
  [8,4],
  [9,3],
]


maximum_bipartite_matching(10,10,edges)
