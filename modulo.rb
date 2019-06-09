
# a**b%mを繰り返し二乗法で計算する
def modpow(a,b,m)
  return b==0 ? 1 : b%2==1 ? (modpow(a,b-1,m)*a)%m : modpow(a**2%m,b/2,m) 
end
# n!%mを計算する
def fact(n,m)
  return (1..n).inject(1){|a,b| a*b%m}
end
# n*x%m=1となるxをフェルマーの小定理を用いて計算する
def inv(n,m)
  return modpow(n,m-2,m)
end
# _nC_r%mを計算する
def comb(n,r,m)
  return fact(n,m)*inv(fact(r,m),m)*inv(fact(n-r,m),m)%m
end

#階乗とその逆数のキャッシュを作成する
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
