

def _diameter(connections,this,parent)
    if connections[this].size==1 && connections[this][0]==parent # leaf
        #p [this,0,0]
        return 0,0
    else
        connected_max=-1
        connected_max2=-1
        all_max=-1
        connections[this].each do |child|
            next if child==parent
            c_temp,a_temp=_diameter(connections,child,this)
            connected_max,connected_max2= 
                c_temp>connected_max ? [c_temp,connected_max] :
                c_temp>connected_max2 ? [connected_max,c_temp] :
                    [connected_max,connected_max2]
            all_max=a_temp if a_temp>all_max
        end
        # if this has one child then a_temp will be connected_max+1
        a_temp=connected_max+connected_max2+2
        all_max=a_temp if a_temp>all_max
        #p [this,connected_max+1,all_max]
        return connected_max+1,all_max
	end
end

def diameter(connections)
    return _diameter(connections,0,-1)[1]
    12.times do |i|
        puts _diameter(connections,i,-1)[1]
    end
end

edges=[
    [1,2],
    [2,3],
    [2,4],
    [4,5],
    [5,6],
    [6,7],
    [7,8],
    [4,9],
    [9,10],
    [10,11],
    [11,12]
]

connections=Array.new(12){Array.new}
edges.each do |a,b|
    connections[a-1] << b-1
    connections[b-1] << a-1
end
p diameter(connections)
