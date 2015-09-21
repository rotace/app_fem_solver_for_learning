# 要素形状関数を計算座標(xi,et)で評価
function N = Nvector2D(xi,et,nen)
# INPUT
#  (xi,et) : -1~+1 ガウスルジャンドル積分の計算座標
#     nen  : 形状関数の数 (1次要素=4 or 2次要素=9)
# OUTPUT
#  N  : 形状関数ベクトル [N1,N2,...,Nn]

if nen == 4      # 1次要素(形状関数が1次)
  N = 0.25 * [(1.0-xi)*(1.0-et),
	      (1.0+xi)*(1.0-et),
	      (1.0+xi)*(1.0+et),
	      (1.0-xi)*(1.0+et)]';
  
elseif nen == 9  # 2次要素(形状関数が2次)
  error('not implimented')
end

	 
