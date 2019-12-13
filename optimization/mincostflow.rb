
module MinCostFlow
    class Edge
        attr_accessor :revedge_index,:from,:to,:capacity,:initial_capacity,:cost,:initial_cost
        def initialize(rev,f,t,cap,cos)
          @revedge_index=rev # nodes[to]における自身と逆向きの辺を指すインデックス
          @from=f
          @to=t
          @capacity=cap # フローが流れている状態での容量
          @initial_capacity=cap # 初期容量（有向辺と同じ向きならその容量、逆なら0）
          @cost=cos # ポテンシャルを考慮したコスト
          @initial_cost=cos # 初期コスト（有向辺と同じ向きならそのコスト、逆なら負の値）
        end
    
        def to_s()
            flag=true
            return "" if  @capacity==0 && !flag
            type=@initial_capacity==0 ? "REV" : "NOR"
            return type+" #{@from}->#{to} by (#{@capacity} #{@cost})"
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
        def addedge(from,to,cap,cos)
          normal_edge=Edge.new(@nodes[to].length,from,to,cap,cos)
          reverse_edge=Edge.new(@nodes[from].length,to,from,0,-cos)
          @nodes[from] << normal_edge
          @nodes[to] << reverse_edge
        end

        # 全てのエッジについてループを行う
        def alledge_each()
            @nodes.each do |node|
                node.each do |edge|
                    yield edge
                end
            end
        end
    end
    module Dijkstra
        class PriorityQueue
            class Node
            include Comparable
            attr_reader :id
            attr_accessor :priority, :value
            @@next_id=0
            def initialize(priority,value=nil)
                @id=@@next_id
                @@next_id+=1
                @priority=priority
                @value=value
            end
            def <=>(other)
                return @priority<=>other.priority
            end
            def to_s
                return "#{@id}(#{@priority},#{@value})"
            end
            end
        
            def initialize
            @nodes = [nil]
            @id2index = {}
            end

            def to_s
                @id2index.each.map{ |id,index|
                    "at #{index} #{@nodes[index]}"
                }.join("\n")
            end
        
            def <<(new_node)
            @nodes << new_node
            @id2index[new_node.id]=@nodes.size - 1
            bubble_up(@nodes.size - 1)
            end
        
            def pop
            return nil if empty?
            exchange(1, @nodes.size - 1)
            max = @nodes.pop
            @id2index.delete(max.id)
            bubble_down(1)
            max
            end
        
            def push(new_node)
            self << new_node
            end
        
            def empty?
            return @nodes.size==1
            end
        
            def change_priority(id, new_priority)
            index=@id2index[id]
            return false if index.nil?
            @nodes[index].priority=new_priority
            bubble_up(index)
            bubble_down(index)
            return true
            end
        
            def bubble_up(index)
            parent_index = index/2
            return if index <= 1
            return if @nodes[parent_index] >= @nodes[index]
        
            exchange(index, parent_index)
            bubble_up(parent_index)
            end
            def bubble_down(index)
            child_index = (index * 2)
            return if child_index > @nodes.size - 1
            child_index += 1 if child_index<@nodes.size-1 && @nodes[child_index+1]>@nodes[child_index]
            return if @nodes[index] > @nodes[child_index]
            
            exchange(index, child_index)
            bubble_down(child_index)
            end
            
            def exchange(source, target)
            @id2index[@nodes[source].id], @id2index[@nodes[target].id] = @id2index[@nodes[target].id], @id2index[@nodes[source].id]
            @nodes[source], @nodes[target] = @nodes[target], @nodes[source]
            end
        end
        
        def dijkstra(graph,source)
            n=graph.length
            dist=Array.new(n,Float::INFINITY)
            dist[source]=0
            prev=Array.new(n,nil)
            q=PriorityQueue.new
            graphnode_index2id={}
            n.times do |i|
                pqnod=PriorityQueue::Node.new(-dist[i],i)
                q << pqnod
                graphnode_index2id[i]=pqnod.id
            end
            while !q.empty? do
                min=q.pop
                min_v=min.value
                dist[min_v]=-min.priority
                graph[min_v].each do |edge|
                    next if edge.capacity<=0
                    if dist[edge.to]>dist[min_v]+edge.cost
                        prev[edge.to]=graph.revedge(edge)
                        dist[edge.to]=dist[min_v]+edge.cost
                        q.change_priority(graphnode_index2id[edge.to],-dist[edge.to])
                    end
                end
            end
            return prev,dist
        end
        module_function :dijkstra
    end

    # ダイクストラ法で得られた結果を基にシンクからソースまで逆順にたどる
    def traceback(graph,prev,sink)
        revedge=prev[sink]
        while revedge
            yield revedge
            revedge=prev[revedge.to]
        end
    end

    def min_cost_flow(graph,source,sink,flow)
        rem_flow=flow
        count=0
        while rem_flow>0
            # コストを基準にダイクストラ
            prev,dist=Dijkstra::dijkstra(graph,source)
            #puts prev.each_with_index.map{|edge,i| "#{i}: "+edge.to_s}.join("\n")
            #pp dist
            
            # 最小コストの道に流せる最大フローを求める
            diff_flow=rem_flow
            traceback(graph,prev,sink) do |revedge|
                diff_flow=[diff_flow,graph.revedge(revedge).capacity].min
            end
            #p diff_flow

            # フローによるグラフの辺の修正
            rem_flow-=diff_flow
            traceback(graph,prev,sink) do |revedge|
                graph.revedge(revedge).capacity-=diff_flow
                revedge.capacity+=diff_flow
            end

            # 各辺のコストをポテンシャルを基に修正
            # ノードポテンシャル＝各イテレーションにおけるソースからの対象ノードへの最短距離（dist[n]）の総和＊（－１）
            # ノードポテンシャルの変化量＝-dist[n]
            # 修正コスト＝初期コスト+終点ノードポテンシャル-始点ノードポテンシャル
            # 修正コストの変化量=終点ノードポテンシャルの変化量-始点ノードポテンシャルの変化量
            # 　　　　　　　　　=-dist[edge.to]-(-dist[edge.from])
            graph.alledge_each do |edge|
                edge.cost+=dist[edge.from]-dist[edge.to]
            end
            puts graph.to_s
        end
        # コストの総和を計算
        sum_cost=0
        graph.alledge_each do |edge|
            sum_cost+=edge.initial_cost*edge.flow
        end
        p sum_cost
        return sum_cost
    end
    module_function :min_cost_flow, :traceback
end

def main()
    edges=[
        [0,1,2,2],
        [0,3,7,4],
        [1,2,4,6],
        [1,3,2,1],
        [2,5,7,2],
        [3,2,1,6],
        [3,4,6,2],
        [4,2,3,2],
        [4,5,2,7],
    ]
    graph=MinCostFlow::Graph.new(6)
    edges.each do |from,to,cap,cost|
        graph.addedge(from,to,cap,cost)
    end
    puts graph.to_s
    MinCostFlow::min_cost_flow(graph,0,5,4)
end

main