# 要素形状関数の微分を計算座標xiで評価
function [B,detJ] = Bmatrix1D(xi,C,nen)
# INPUT
#  xi : -1~+1 ガウスルジャンドル積分の計算座標
#  C  : 要素節点の座標行列 [x1 x2 ... xn]
#  nen: 形状関数の数 (1次要素=2 or 2次要素=3)
# OUTPUT
#  B  : 形状関数微分行列 [dN1/dx dN2/dx ... dNn/dx]
#       (1Dなので 1 x nen の行行列になる)

if nen == 2      # 1次要素(形状関数が1次)
  
  GN   = 0.5*[-1 1];  # 勾配行列の計算   [dN1/dxi      dN2/dxi   ]
  detJ = GN*C';       # ヤコビアンの計算  dN1/dxi*x1 + dN2/dxi*x2
  B    = GN/detJ;     # 形状関数微分行列 [dN1/dx       dN2/dx]

elseif nen == 3  # 2次要素(形状関数が2次)
       
  # 勾配行列の計算      [dN1/dxi      dN2/dxi      dN3/dxi    ]
  GN   = [xi-0.5, -2*xi, xi+0.5];
  # ヤコビアン dx/dxi = dN1/dxi*x1 + dN2/dxi*x2 + dN3/dxi*x3
  detJ = GN*C';
  # 形状関数微分行列    [dN1/dx       dN2/dx       dN3/dx     ]
  B    = GN/detJ;
end

	 
