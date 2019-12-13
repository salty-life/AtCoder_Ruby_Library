MOD=10**9+7

def modpow(a,b,m)
  return b==0 ? 1 : b%2==1 ? (modpow(a,b-1,m)*a)%m : modpow(a**2%m,b/2,m) 
end
def fact(n,m)
  return (1..n).inject(1){|a,b| a*b%m}
end
def inv(n,m)
  return modpow(n,m-2,m)
end
def comb(n,r,m)
  return 0 if n<0 || r<0 || n<r
  return fact(n,m)*inv(fact(r,m),m)*inv(fact(n-r,m),m)%m
end


def generate_mod_cache(fact, inv_fact,max,m)
    fact[0]=1
    max.times do |i|
        fact[i+1]=(fact[i]*(i+1))%m
    end
    inv_fact[max]=modpow(fact[max],m-2,m)
    max.downto(1) do |i|
        inv_fact[i-1]=(inv_fact[i]*i)%m
    end
end


def modcomb(n,r,m,fact,inv_fact)
    return 0 if n<0 || r<0 || n<r
    return ((fact[n]*inv_fact[r]%m)*inv_fact[n-r])%m
end

def test2()
    fact=[]
    inv_fact=[]
    generate_mod_cache(fact,inv_fact,10,97)
    p fact
    p inv_fact
    puts modcomb(10,4,97,fact,inv_fact)
end