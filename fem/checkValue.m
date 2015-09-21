function checkValue(para,mesh,boun,dist,mate)
  ## VARIABLE CHECK

  function sizeCheck(array,dim1,dim2,name)
    if size(array) ~= [dim1,dim2]
      ## if isequal( size(array) , [dim1,dim2] )
      printf('\n');
      disp('DIMENSION DOES NOT MATCH!');
      printf('  array size = [#f , #f]\n',size(array));
      printf('correct size = [#f , #f]\n',dim1,dim2);
      printf('please check variable [#s]\n',name);
      printf('\n');
      stop;
    end
  end

  ## check scheme parameter & mesh data
  ## COMMON
  para.nsd;   # 空間の次元数(Number of space dimensions)
  para.ndof;  # 解自由度数 (Number of degree of freedom)
  para.neq;   # 方程式の本数(Number of equations)
  para.ngp;   # ガウスポイント数
  para.mid;   # method ID
  para.ndim;  # 無次元化参照値

  ## solver flag
  boun.flags; # 境界条件フラッグ
  boun.e;     # 基本境界 ( x  = boun.e )
  boun.n;     # 自然境界 ( b += boun.n )
  
  ## mesh (wbm also use when visualizing)
  para.nnp;   # 節点数(Number of nodal points)
  para.nel;   # 要素数(Number of elements)
  para.nen;   # 要素節点数(Number of element nodes)
  para.nben;  # 境界要素節点数(Number of boundary element nodes)
  mesh.nodes;    # 節点
  mesh.elems;    # 要素節点  （変換配列）
  mesh.index;    # 要素自由度（変換配列）
  
  sizeCheck(para.ndim,   1,         para.ndof,'ndim');
  sizeCheck(mesh.nodes,  para.nsd,  para.nnp, 'nodes');
  sizeCheck(mesh.elems,  para.nen,  para.nel, 'elems');
  
  switch para.mid
    case {1,2,3,4} ## FEM
      sizeCheck(boun.flags,  para.ndof, para.nnp, 'flags');
      sizeCheck(boun.e,      para.ndof, para.nnp, 'ebc');
      sizeCheck(boun.n,      para.ndof, para.nnp, 'nbc');
  end

  ## check bounary data
  switch para.mid
    case 3			# acous
      para.nbel_z;	# zbc境界要素数
      if para.nbel_z ~= 0
	boun.z;		# zbcインピーダンス境界
	mesh.belems_z;	# zbc境界要素節点  （変換配列）
	mesh.bindex_z;	# zbc境界要素自由度（変換配列）
	sizeCheck(boun.z,        para.ndof, para.nnp, 'zbc');
	sizeCheck(mesh.belems_z, para.nben, para.nbel_z,'belems_z');
      end
  end

  ## check distribution data
  switch para.mid
    case 1	# truss
      dist.area;
      dist.E;
      dist.leng;
      dist.phi;
    case 2	# bar
      dist.area;
      dist.E;
  end
  
  ## check material parameter
  switch para.mid
    case 1	# for Truss
    case 2	# for Bar
      mate.xp;
      mate.P;
      mate.np;
      mate.nplot;
    case 3	# for acoustic 
      mate.cspeed;
      mate.rho;
      mate.Zc;
      mate.kc;
  end
end
