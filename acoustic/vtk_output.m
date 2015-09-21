function vtk_output( x,itr,id)
loadValue;

## define gloval vector
count = zeros(1,nnp);
sol.p     = zeros(1,nnp);		# fluid pressure
sol.v     = zeros(3,nnp);		# fluid velocity

## calculation
for e= 1:nel

  elemse = mesh.elems(:,e);
  indexe = mesh.index(:,e);
  
  ce     = mesh.nodes(:,elemse);  # coordinate local array
  xe     = x(indexe);		  # solution   local vector

  ## define local vector (element vector)
  pe     = 0;			# pressure local vector
  ve    = zeros(3,1);		# velocity local vector
  
  wavenum= itr.omega / mate.cspeed;

  ## 3D:HEXA
  if nsd == 3 && nen == 8
    n=0;
    for k = -1:2:1
      for theta = -45:90:225
	n=n+1;  
	rad = theta*pi/180;
	## node(n)(xt,et,zt)
	xi = round(sqrt(2)*cos(rad));
	et = round(sqrt(2)*sin(rad));
	zt = k;
	## node1(+1,-1,-1)
	## node2(+1,+1,-1)
	## node3(-1,+1,-1)
	## node4(-1,-1,-1)
	## node5(+1,-1,+1)
	## node6(+1,+1,+1)
	## node7(-1,+1,+1)
	## node8(-1,-1,+1)

	## 要素形状関数ベクトルのガウス積分点での値 (1x8)
	N   = Nvector3D(xi,et,zt,nen);
	## 要素形状関数微分ベクトルのガウス積分点での値とヤコビアン (3x8)
	[B,detJ] = Bmatrix3D(xi,et,zt,ce,nen);

	## calc
	pe = N*xe;
	ve = 1i/mate.rho/itr.omega * B*xe;
	## 空間勾配はメッシュの精度に依存することに注意
	## とりわけサインカーブの頂点は誤差が大きい
	## よって速度，インピーダンスはメッシュ誤差に依存
	
	## assembly
	node = elemse(n);
	count(node) = count(node)+1;
	sol.p(:,node) = sol.p(:,node)  + pe;
	sol.v(:,node) = sol.v(:,node)  + ve;

      end
    end
  end
end
## average
sol.p = sol.p./count;
sol.v = sol.v./[count;count;count];
## calc
sol.Zx = sol.p./sol.v(1,:);



## WRITE DAT FILE #######################
filename = [plflag.name,num2str(round(itr.freq)),'.dat'];
save(filename, 'para','mesh','boun','mate','sol','plflag')



## WRITE VTK FILE #######################
filename = [plflag.name,num2str(round(itr.freq)),'.vtk'];
fid = fopen(filename, 'w');

writeVtkMesh(fid,para,mesh)

## write POINT DATA
fprintf(fid, 'POINT_DATA %d \n', nnp);
writeVtkComplex(fid,para,sol.p, 'pressure')
writeVtkComplex(fid,para,sol.v, 'velocity')
writeVtkComplex(fid,para,sol.Zx,'impX')

fclose(fid);


