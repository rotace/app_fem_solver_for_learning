# 要素形状関数を計算座標xiで評価
function N = Nvector1D(xi,nen)
# INPUT
#  xi : -1~+1 ガウスルジャンドル積分の計算座標
#  nen: 形状関数の数 (1次要素=2 or 2次要素=3)
# OUTPUT
#  N  : 形状関数ベクトル [N1,N2,...,Nn]

if nen == 2      # 1次要素(形状関数が1次)
  N(1) = 0.5*(1-xi);
  N(2) = 0.5*(1+xi);
elseif nen == 3  # 2次要素(形状関数が2次)
  N(1) = 0.5*xi*(xi-1);
  N(2) = (1+xi)*(1-xi);
  N(3) = 0.5*xi*(1+xi);
end

	 
