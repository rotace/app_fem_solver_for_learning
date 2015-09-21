# 要素形状関数の微分を計算座標(xi,et)で評価
function [B,detJ] = Bmatrix2D(xi,et,C,nen,nsd)


  ### 2Dimentional	 
if nsd == 2	 
  # INPUT
  #  (xi,et) : -1~+1 ガウスルジャンドル積分の計算座標
  #  C  : 要素節点の座標行列 [ x1 x2 ... xn ;
  #                           y1 y2 ... yn ]
  # 
  #      nen : 形状関数の数 (1次要素=4 or 2次要素=9)
  # OUTPUT
  #  B  : 形状関数微分行列 [ dN1/dx dN2/dx ... dNn/dx ;
  #                         dN1/dy dN2/dy ... dNn/dy ]

  if nen == 4      # 1次要素(形状関数が1次)

    # 勾配行列の計算 GN = [ dN1/dxi dN2/dxi dN3/dxi dN4/dxi ;
    #                      dN1/det dN2/det dN3/det dN4/det ]
    GN = 0.25 * [ et-1, 1-et, 1+et,-et-1 ;
                  xi-1,-1-xi, 1+xi, 1-xi ];
    # ヤコビ行列  dx/dxi = dN1/dxi*x1 + dN2/dxi*x2 ...
    #            dy/dxi = dN1/dxi*y1 + dN2/dxi*y2 ...
    #            dx/det = dN1/det*x1 + dN2/det*x2 ...
    #            dy/det = dN1/det*y1 + dN2/det*y2 ...
    J  = GN*C';
    # 行列値
    detJ = det(J);
    # 形状関数微分行列  [J][B]=[GN]
    B    = J\GN;

  elseif nen == 9  # 2次要素(形状関数が2次)
    error('not implimented')
  end

  
  ### 3Dimentional
elseif nsd == 3
  #  (xi,et) : -1~+1 ガウスルジャンドル積分の計算座標
  #  C  : 要素節点の座標行列 [ x1 x2 ... xn ;
  #                           y1 y2 ... yn ;
  #                           z1 z2 ... zn ] 
  # 
  #      nen : 形状関数の数 (1次要素=4 or 2次要素=9)
  # OUTPUT
  #  B  : 形状関数微分行列 [ dN1/dx dN2/dx ... dNn/dx ;
  #                         dN1/dy dN2/dy ... dNn/dy ;
  #                         dN1/dz dN2/dz ... dNn/dz ;
       
  if nen == 4      # 1次要素(形状関数が1次)
    # 勾配行列の計算 GN = [ dN1/dxi dN2/dxi dN3/dxi dN4/dxi ;
    #                      dN1/det dN2/det dN3/det dN4/det ]
    GN = 0.25 * [ et-1, 1-et, 1+et,-et-1 ;
                  xi-1,-1-xi, 1+xi, 1-xi ];
    
    # ヤコビ行列
    #           [dx/dxi  dy/dxi  dz/dxi ;
    #            dx/det  dy/det  dz/det ];
    
    #            dx/dxi = dN1/dxi*x1 + dN2/dxi*x2 ...
    #            dy/dxi = dN1/dxi*y1 + dN2/dxi*y2 ...
    #            dz/dxi = dN1/dxi*z1 + dN2/dxi*z2 ...   
    #            dx/det = dN1/det*x1 + dN2/det*x2 ...
    #            dy/det = dN1/det*y1 + dN2/det*y2 ...
    #            dz/det = dN1/det*z1 + dN2/det*z2 ...
    J  = GN*C';
    
    ## dS = [det|y,z| det|z,x| det|x,y| ]
    detJ = [det(J(:,[2,3])), det(J(:,[3,1])), det(J(:,[1,2])) ];
    
    # 行列値
    detJ = norm(detJ);
    # 形状関数微分行列  [J][B]=[GN]
    # [ dN1/dx dN2/dx dN3/dx dN4/dx;
    #   dN1/dy dN2/dy dN3/dy dN4/dy;
    #   dN1/dz dN2/dz dN3/dz dN4/dz];
    B    = J\GN;
    
  elseif nen == 9  # 2次要素(形状関数が2次)
    error('not implimented')
  end
end
