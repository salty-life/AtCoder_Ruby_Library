
def get_cycle(edges)
    check=Array.new(edges.size,:not_visited)
    groups=[]
    for v in 1...edges.size do
        chain=[]
        to=v
        cyclic_flag=false
        while true
            chain << to
            if check[to]==:visited
                break
            end
            if check[to]==:visiting
                cyclic_flag=true
                break
            end
            check[to]=:visiting
            to=edges[to]
            break if to==-1
        end
        break if to==-1
        groups << [] if cyclic_flag
        chain.reverse_each do |c|
            cyclic_flag=false if check[c]==:visited
            groups[-1] << c if cyclic_flag
            check[c]=:visited
        end
    end
    return groups
end

edges=[
    11,
    2,
    12,
    4,
    9,
    1,
    18,
    8,
    0,
    3,
    7,
    -1,
    1,
    7,
    16,
    19,
    19,
    12,
    0,
    5,
]

p get_cycle(edges)