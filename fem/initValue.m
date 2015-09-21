function [para,mesh,boun,dist,mate,plflag] = initValue(para)

  mesh = struct;
  boun = struct;
  dist = struct;
  mate = struct;
  plflag = struct;
	 
  ## common initialize
  mesh.nodes = zeros(para.nsd            ,para.nnp); # node coordinates
  mesh.elems = zeros(para.nen            ,para.nel); # element nodes
  mesh.index = zeros(para.nen* para.ndof ,para.nel); # element indexes
  # index means solution vector x's index (Ax=b)
  # if ndof = 1, mesh.index = mesh.elems

  switch para.mid
    case {1,2,3,4} ## FEM
      para.neq = para.ndof * para.nnp;	      # No. of equation
      boun.flags = zeros(para.ndof,para.nnp); # b.c. flag
      boun.e     = zeros(para.ndof,para.nnp); # essential b.c. (x=boun.e)
      boun.n     = zeros(para.ndof,para.nnp); # natural b.c. (b=b+boun.n)
  end
  
  
  ## flags(e.b.c.) = 1
  ## flags(n.b.c.) = 2
  ## flags(h.b.c.) = -1 # hybrid (recieve)
  ## flags(h.b.c.) = -2 # hybrid (send)
  
  switch para.mid
    case 1			# TrussFEM
      plflag.nod = 0;
      plflag.bar = 0;
    case 2			# BarFEM
      plflag.bar = 0;
      dist.E     = zeros(1 , para.nnp ); # ヤング率分布
      dist.body  = zeros(1 , para.nnp ); # 体積力分布
      dist.area  = zeros(1 , para.nnp ); # 断面積分布
    case 3			# AcousFEM
      plflag.poin = 0;
      plflag.name = 'out';
      plflag.zckc = 0;
      boun.z      = zeros(para.ndof,para.nnp ); #インピーダンス境界条件
      mesh.belems_z = zeros(para.nben,para.nbel_z);
      mesh.bindex_z = zeros(para.nben*para.ndof,para.nbel_z);
  end


end
