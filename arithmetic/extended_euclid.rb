

# return a (ax%m=gcd(x,m))
# if gcd(x,m)==m then return 0
def inv(x,m)
  y=m
  a,b=1,0
  while(y!=0)
    a,b=b,a-x/y*b
    x,y=y,x%y
  end
  return a<0 ? a+m : a
end

def crt(eqs)
  mod=eqs.inject(1){|x,e| x*e[1]}
  ans=0
  eqs.each do |a,m|
    temp=mod/m
    ans+=inv(temp,m)*temp*a
  end
  return ans%mod
end


p inv(64,32)
p inv(10,25)
p inv(3,5)
p crt([[1,3],[4,5],[5,7]])
