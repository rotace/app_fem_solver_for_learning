function [ke,fe] = calcLocalAreaMatrixAcous(e,itr,id);
  loadValue;

  nsm    = 3;
  ## common
  elemse = mesh.elems(:,e);
  coorde = mesh.nodes(:,elemse);

  ke     = zeros(nen,nen,1);
  fe     = zeros(nen    ,1);

  wavenum= itr.omega / mate.cspeed;


  ## 2D:TRIA
  if nsd == 2 && nen == 3
    a = coorde(:,2) - coorde(:,1); 
    b = coorde(:,3) - coorde(:,2); 
    c = coorde(:,1) - coorde(:,3); 

    t1 = acos( dot(-c,a) / (norm(c) * norm(a)));
    t2 = acos( dot(-a,b) / (norm(a) * norm(b)));
    t3 = acos( dot(-b,c) / (norm(b) * norm(c)));

    s  = (norm(a) + norm(b) + norm(c)) /2;
    S  = sqrt(s * (s - norm(a)) * (s - norm(b)) * (s - norm(c)));

    K  = 0.5  * [ cot(t2)+cot(t3),        -cot(t3),        -cot(t2) ;
	          -cot(t3), cot(t1)+cot(t3),        -cot(t1) ;
	          -cot(t2),        -cot(t1), cot(t1)+cot(t2) ];

    M  = S/12 * [ 2, 1, 1 ;
		  1, 2, 1 ;
		  1, 1, 2 ];

    ke = K - wavenum^2 * M;
    

  ## 2D:QUAD
  elseif nsd == 2 && nen == 4
    [w,gp] = gauss(ngp);
    for j = 1:ngp
      for i = 1:ngp
	xi = gp(i);
	et = gp(j);
	## 要素形状関数ベクトルのガウス積分点での値 (1x4)
	N   = Nvector2D(xi,et,nen);
	## 要素形状関数微分ベクトルのガウス積分点での値とヤコビアン (3x4)
	[B,detJ] = Bmatrix2D(xi,et,coorde,nen,nsd);

	ke  = ke + (B'*B- wavenum^2 * N'*N) * w(i) * w(j) * detJ;
	
      end
    end
    
    

  ## 3D:HEXA
  elseif nsd == 3 && nen == 8
	 
    [w,gp] = gauss(ngp);
    for k = 1:ngp
      for j = 1:ngp
	for i = 1:ngp
	  xi = gp(i); 
	  et = gp(j); 
	  zt = gp(k); 
	  ## 要素形状関数ベクトルのガウス積分点での値 (1x8)
	  N   = Nvector3D(xi,et,zt,nen);
	  ## 要素形状関数微分ベクトルのガウス積分点での値とヤコビアン (3x8)
	  [B,detJ] = Bmatrix3D(xi,et,zt,coorde,nen);

	  ######## 要素行列演算 ########
	  weight = w(i) * w(j) *w(k) * detJ;

	  ke  = ke + (B'*B- wavenum^2 * N'*N) * weight;
	  
	end
      end
    end
  end

## error('stop');
end


