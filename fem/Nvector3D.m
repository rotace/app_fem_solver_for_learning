# 要素形状関数を計算座標(xi,et,zt)で評価
function N = Nvector3D(xi,et,zt,nen)
# INPUT
#  (xi,et,zt) : -1~+1 ガウスルジャンドル積分の計算座標
#     nen     : 形状関数の数 (1次要素=8 or 2次要素=20)
# OUTPUT
#  N  : 形状関数ベクトル [N1,N2,...,Nn]

if nen == 8      # 1次要素(形状関数が1次)
  N = 0.125 * [(1.0+xi)*(1.0-et)*(1.0-zt),
	       (1.0+xi)*(1.0+et)*(1.0-zt),
	       (1.0-xi)*(1.0+et)*(1.0-zt),
	       (1.0-xi)*(1.0-et)*(1.0-zt),
               (1.0+xi)*(1.0-et)*(1.0+zt),
	       (1.0+xi)*(1.0+et)*(1.0+zt),
	       (1.0-xi)*(1.0+et)*(1.0+zt),
	       (1.0-xi)*(1.0-et)*(1.0+zt)]';
  
elseif nen == 20  # 2次要素(形状関数が2次)
  error('not implimented')
end

	 
