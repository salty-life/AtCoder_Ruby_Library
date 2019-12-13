
# pq.rb が必要

def dijkstra_algorithm(graph,s)
  n=graph.size
  d=Array.new(n,Float::INFINITY)
  d[s]=0
  prev=Array.new(n,-1)
  q=PriorityQueue.new
  n.times do |i|
    q << PriorityQueue::Node.new(-d[i])
  end
  while !q.empty? do
    min=q.pop
    min_v=min.id
    d[min_v]=-min.priority
    graph[min_v].each do |to,to_cost|
      if d[to]>d[min_v]+to_cost
        prev[to]=min_v
        d[to]=d[min_v]+to_cost
        q.change_priority(to,-d[to])
      end
    end
  end
  return prev,d
end

graph=[
  {1=>3,2=>7,4=>3},
  {0=>3,2=>1,3=>3},
  {0=>7,1=>1,3=>1},
  {1=>3,2=>1,4=>1},
  {0=>3,3=>1}
]

prev,d=dijkstra_algorithm(graph,0)

pp prev
pp d