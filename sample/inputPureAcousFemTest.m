function inputPureAcousFemTest(itr)
  include_fem;
  ########## SET MESH DATA ################
  ## make mash
  ## ijk = [5,7,7];
  ## oxyz = [0.0, 0.0, 0.0];
  ## dx = 0.02;
  ## dxyz = [dx, dx*2, dx*2];
  ijk = [50,2,2];
  oxyz = [0.0, 0.0, 0.0];
  dxyz = [0.01, 0.1, 0.1];

  out = make_hexamesh(ijk,oxyz,dxyz);

  para.nsd =3;			# 空間の次元数
  para.ndof=1;			# 節点あたりの自由度数(ux,uy,uz,p)
  para.nnp =out.nnp;		# 節点数
  para.nel =out.nel;		# 要素数
  para.nen =8;			# 要素節点数
  para.nben=4;			# 境界要素節点数
  para.ngp =2;			# １方向あたりのガウス積分点数
  para.mid =3;			# method ID (biot)
  # 無次元数[ux^,uy^,uz^,p] = [ 1mm 1mm 1mm 1Pa]
  para.ndim=1;

  para.nbel_z=out.nbel(4);		# zbc境界要素数
  
  ####### init value #######
  [para,mesh,boun,dist,mate,plflag] = initValue(para);
  
  ## 節点、要素
  mesh.nodes  = out.nodes;
  mesh.elems  = out.elems;
  mesh.index  = makeIndex( mesh.elems , para.ndof, para.nel , para.nen  );
  
  ## 基本境界条件
  boun.flags(out.bc_poin{3}) = 1;
  boun.e    (out.bc_poin{3}) = 1;

  ## 境界要素 (zbc) インピーダンス境界
  mesh.belems_z = out.belems{4};
  mesh.bindex_z = makeIndex(mesh.belems_z, para.ndof, para.nbel_z, para.nben );
  boun.z    (out.bc_poin{4}) = 10000000000; # 剛壁境界

  
  ## plot flag
  plflag.poin   = out.plot_poin;
  plflag.name   = 'acous';
  plflag.zckc   =1;


  ########## SET MATERIAL DATA ################
  ## acoustic3D情報
  mate.cspeed = 340;
  mate.rho    = 1.225;
  kc     = itr.omega/mate.cspeed
  Zc     = mate.rho*mate.cspeed
  mate.kc = kc;
  mate.Zc = Zc;
  
  checkValue(para,mesh,boun,dist,mate);
  saveValue(para,mesh,boun,dist,mate,plflag);
  ##################################################
  ## input global infomation
  setGlobalID(para);
  
end
