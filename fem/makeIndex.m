function LM = makeIndex( elems, ndof, nel, nen )

## LM配列の作成
## example: ndof=2のとき，全体行列の解ベクトルの並び方は，
## 奇数がx,偶数がyとなる．
##  node(1)                  node(2)
##  node(1).x = 1	     node(1).y = 2 
##  node(2).x = 3	     node(2).y = 4
##  ...                      ...  
##  node(n).x = 2*(n-1) + 1  node(n).y = 2*(n-1) +2
##       ^nodeID                     ndof^        ^m
LM = zeros(nen*ndof, nel);
for e = 1:nel
  for j = 1:nen
    for m = 1:ndof
      ind = (j-1)*ndof+m;
      LM(ind,e)=ndof*( elems(j,e) - 1 ) + m;
    end
  end
end




