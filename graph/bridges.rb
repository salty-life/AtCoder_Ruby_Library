

def dfs(edges,v,from,dfs_order_count,lowest_reachable_index,dfs_order_index,ret)
    dfs_order_index[v]=dfs_order_count[0]
    dfs_order_count[0]+=1
    lowest_reachable_index[v]=dfs_order_index[v]
    edges[v].each do |to|
        next if from==to
        if dfs_order_index[to].nil?
            dfs(edges,to,v,dfs_order_count,lowest_reachable_index,dfs_order_index,ret)
            ret << [v,to] if lowest_reachable_index[to]==dfs_order_index[to]
        end
        lowest_reachable_index[v]=[
            lowest_reachable_index[v],
            lowest_reachable_index[to]
        ].min
    end
end

def find_bridge(edges)
    ret=[]
    dfs(edges,0,-1,[0],Array.new(edges.size,Float::INFINITY),Array.new(edges.size),ret)
    p ret
end

edges=[
    [1],
    [0,2,3,8],
    [1],
    [1,4,6],
    [3,5,8],
    [4,6],
    [3,5,7],
    [6],
    [1,4]
]
edges=[
    [1],
    [2,3],
    [],
    [4],
    [5,8],
    [6],
    [3,7],
    [],
    [1]
]
find_bridge(edges)


