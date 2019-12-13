
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

# return leftest index where arr[index]>value
# if arr[-1]<=value returns arr.size
def ubound(arr,value)
	ng,ok=-1,arr.size
	while((ng-ok).abs>1) do
		mid=(ng+ok)/2
		if(arr[mid]>value)
			ok=mid
		else
			ng=mid
		end
	end
	return ok
end

# return lefttest index where arr[index]>=value
# if arr[-1]<value returns arr.size
def lbound(arr,value)
	ng,ok=-1,arr.size
	while((ng-ok).abs>1) do
		mid=(ng+ok)/2
		if(arr[mid]>=value)
			ok=mid
		else
			ng=mid
		end
	end
	return ok
end


# return x where
#   (when trueside<falseside)
#     [trueside,falseside) and yield(x)==true and (yield(x+tol)==false or falseside <= x+tol)
#   (when falseside<trueside)
#     (falseside,trueside] and yield(x)==true and (yield(x-tol)==false or x-tol <= falseside) 
# if trueside and falseside and tol is integer then do integer binary search
# note: neither yield(trueside) nor yield(falseside) were not called
def bsearch(trueside,falseside,tol=10**(-9))
    ok,ng=trueside,falseside
    div=tol.is_a?(Integer) ? 2 : 2.0
    while((ok-ng).abs>tol) do
        mid=(ng+ok)/div
        if(yield(mid))
            ok=mid
        else
            ng=mid
        end
    end
    return ok
end

def bsearch_int(trueside,falseside,&block)
    return bsearch(trueside,falseside,1,&block)
end

def test
    p bsearch(0,100){|x| x<42}
    p bsearch(100,0){|x| x>42}
    p bsearch(0,100,1){|x| x<42}
    p bsearch(100,0,1){|x| x>42}

    p

    a=(1..9).to_a
    a=(a+a).sort
    p a
    for i in 1..(a.length+1) do
        t=i/2.0
        p [t,lower_bound(a,t),upper_bound(a,t),
            bsearch_int(a.size,-1){|x| a[x]>=t},bsearch_int(a.size,-1){|x| a[x]>t}
        ]
    end
end
test if $0==__FILE__
