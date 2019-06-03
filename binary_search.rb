
# return leftest index where array[index]>value
def _upper_bound(array,value,l,r)
    return l if r==l
    ind=(r+l)/2
    return value<array[ind] ? _upper_bound(array,value,l,ind) : _upper_bound(array,value,ind+1,r)
end
def upper_bound(array,value)
    return value>=array[-1] ? array.length : _upper_bound(array,value,0,array.length-1)
end

# return leftest index where array[index]>=value
def _lower_bound(array,value,l,r)
    return l if r==l
    ind=(r+l)/2
    return value<=array[ind] ? _lower_bound(array,value,l,ind) : _lower_bound(array,value,ind+1,r)
end
def lower_bound(array,value)
    return value>array[-1] ? array.length : _lower_bound(array,value,0,array.length-1)
end


def test()
    a=(1..4).to_a
    for i in 1..(2*a.length+1) do
        p [i/2.0,lower_bound(a,i/2.0),upper_bound(a,i/2.0)]
    end
end
test if $0==__FILE__
