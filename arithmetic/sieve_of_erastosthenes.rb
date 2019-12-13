

def sieve_of_erastosthenes(max)
    cand_list=Array.new(max+1,true)
    rmax=Math.sqrt(max).floor
    rmax+=1 if (rmax+1)**2<=max
    ret=[]
    (2..rmax).each do |div|
      next if cand_list[div]==false
      ret << div
      i=div
      while i<=max
        cand_list[i]=false
        i+=div
      end
    end
    for i in 2..max do
      next if !cand_list[i]
      ret << i
    end
    return ret
end
