function [ke,fe] = calcLocalBounMatrixAcous(e,itr,id);
  loadValue;

  nsm  =  3;
  ## common
  elemse = mesh.belems_z(:,e);
  coorde = mesh.nodes(:,elemse);

  ke     = zeros(nben,nben,1);
  fe     = zeros(nben     ,1);

  ke     = complex(ke);
  fe     = complex(fe);
  

  ## 2D:TRIA
  if nsd == 2 && nen == 3

  ## 2D:QUAD
  elseif nsd == 2 && nen == 4
	 
  ## 3D:HEXA
  elseif nsd == 3 && nen == 8	# nben = 4
	 
    [w,gp] = gauss(ngp);
    for i = 1:ngp
      for j = 1:ngp
	xi = gp(i);
	et = gp(j);
	## 要素形状関数ベクトルのガウス積分点での値
	N   = Nvector2D(xi,et,nben);
	## 要素形状関数微分ベクトルのガウス積分点での値とヤコビアン
	[B,detJ] = Bmatrix2D(xi,et,coorde,nben,nsd);

	## prevent deviding by 0
	if prod(boun.z(elemse)) == 0
	  error('occur dividing by 0 when calc inverse of impedance')
	end
	## ガウス積分点における特性インピーダンスの逆数
	## ([1x1] = [1xnnp]*[nnpx1] )
	ze = N * boun.z(elemse)'.^-1;

	######## 要素行列演算 ########
	ke  = ke + complex(0,mate.rho*itr.omega) ...
		   *ze*N'*N * w(i) * w(j) * detJ;
	
      end
    end
  end

end

