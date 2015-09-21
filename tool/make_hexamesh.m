function out = make_hexamesh(ijk,oxyz,dxyz)

  ## IN DATA
  # max cell in each direction
  imax = ijk(1);
  jmax = ijk(2);
  kmax = ijk(3);
  meshsize.imax = imax;
  meshsize.jmax = jmax;
  meshsize.kmax = kmax;

  ox = oxyz(1);
  oy = oxyz(2);
  oz = oxyz(3);
  dx = dxyz(1); 
  dy = dxyz(2); 
  dz = dxyz(3); 

  ## OUT DATA
  out.nnp = (imax+1)*(jmax+1)*(kmax+1);
  out.nel = imax*jmax*kmax;
  out.nodes = zeros( 3, out.nnp );
  out.elems = zeros( 8, out.nel );
  out.nbel   = zeros(6,1);
  out.belems  = cell(6,1);
  out.bc_poin  = cell(6,1);
  out.hflag = cell(6,1);
  out.plot_poin = 0;

  # local variables
  inijk = zeros( imax+1, jmax+1, kmax+1);
  ieijk = zeros( imax  , jmax  , kmax  );
  

  ############################################ make nodes
  n=0;
  for k = 1:kmax+1
    for j = 1:jmax+1
      for i = 1:imax+1
	n=n+1;
	inijk(i,j,k)=n;
	out.nodes(:,n) = [ ox + (i-1)*dx;
			   oy + (j-1)*dy;
			   oz + (k-1)*dz];
      end
    end
  end
  ############################################ make elems
  l=imax+1;
  m=jmax+1;
  n=0;
  for k= 1:kmax
    for j = 1:jmax
      for i = 1:imax
	n=n+1;
	ieijk(i,j,k)=n;
	iorigin = l*m*(k-1)+l*(j-1)+i;
	out.elems(1,n) = iorigin;
	out.elems(2,n) = iorigin+1;
	out.elems(3,n) = iorigin+1+l;
	out.elems(4,n) = iorigin+l;
	out.elems(5,n) = iorigin+l*m;
	out.elems(6,n) = iorigin+l*m+1;
	out.elems(7,n) = iorigin+l*m+l+1;
	out.elems(8,n) = iorigin+l*m+l;
      end
    end
  end
  ########################################## ## make belems
  for isuf =1:6
    info = getFaceInfo(isuf,meshsize);
    n=0;
    out.nbel(isuf) = info.facesize;
    tmp_belems = zeros(4,out.nbel(isuf));
    for k=info.kmin:info.kmax
      for j=info.jmin:info.jmax
	for i=info.imin:info.imax
	  n=n+1;
	  ie=ieijk(i,j,k);
	  tmp_belems(1,n) = out.elems(info.a,ie); 
	  tmp_belems(2,n) = out.elems(info.b,ie); 
	  tmp_belems(3,n) = out.elems(info.c,ie); 
	  tmp_belems(4,n) = out.elems(info.d,ie);
	end
      end
    end
    out.belems{isuf} = tmp_belems;
  end

  ########################################### make bc_pointer
  for isuf=1:6
    info = getNodeInfo(isuf,meshsize);
    tmp_bc_poin =0;
    tmp_hflag=0;
    n=0;
    for k=info.kmin:info.kmax
      for j=info.jmin:info.jmax
	for i =info.imin:info.imax
	  in=inijk(i,j,k);
	  n = n+1;
	  tmp_bc_poin = [tmp_bc_poin, in];
	  tmp_hflag = [tmp_hflag, n];
	end
      end
    end
    out.bc_poin{isuf}  = tmp_bc_poin(2:end);
    out.hflag{isuf} = tmp_hflag(2:end);
  end

  
  ## plot pointer
  i = round(imax/2+1);
  j = round(jmax/2+1);
  k = round(kmax/2+1);
  out.plot_poin = inijk(:,j,k);

  
end

function info = getFaceInfo(isuf, meshsize)
  switch isuf
    case 1 ## (surface No.1... kmin( -z direction )
      info.facesize = meshsize.imax * meshsize.jmax;
      info.imin = 1;
      info.imax = meshsize.imax;
      info.jmin = 1;
      info.jmax = meshsize.jmax;
      info.kmin = 1;
      info.kmax = 1;
      info.a = 3;
      info.b = 2;
      info.c = 1;
      info.d = 4;
    case 2 ## (surface No.2... kmax( +z direction )
      info.facesize = meshsize.imax * meshsize.jmax;
      info.imin = 1;
      info.imax = meshsize.imax;
      info.jmin = 1;
      info.jmax = meshsize.jmax;
      info.kmin = meshsize.kmax;
      info.kmax = meshsize.kmax;
      info.a = 5;
      info.b = 6;
      info.c = 7;
      info.d = 8;
    case 3 ## (surface No.3... imin( -x direction )
      info.facesize = meshsize.jmax * meshsize.kmax;
      info.imin = 1;
      info.imax = 1;
      info.jmin = 1;
      info.jmax = meshsize.jmax;
      info.kmin = 1; 
      info.kmax = meshsize.kmax;
      info.a = 5; 
      info.b = 8;
      info.c = 4;
      info.d = 1;
    case 4 ## (surface No.4... imax( +x direction )
      info.facesize = meshsize.jmax * meshsize.kmax;
      info.imin = meshsize.imax;
      info.imax = meshsize.imax;
      info.jmin = 1;
      info.jmax = meshsize.jmax;
      info.kmin = 1; 
      info.kmax = meshsize.kmax;
      info.a = 2;
      info.b = 3;
      info.c = 7;
      info.d = 6;
    case 5 ## (surface No.5... jmin( -y direction )
      info.facesize = meshsize.imax * meshsize.kmax;
      info.imin = 1;
      info.imax = meshsize.imax;
      info.jmin = 1;
      info.jmax = 1;
      info.kmin = 1; 
      info.kmax = meshsize.kmax;
      info.a = 1; 
      info.b = 2;
      info.c = 6;
      info.d = 5;
    case 6 ## (surface No.6... jmax( +y direction )
      info.facesize = meshsize.imax * meshsize.kmax;
      info.imin = 1;
      info.imax = meshsize.imax;
      info.jmin = meshsize.jmax;
      info.jmax = meshsize.jmax;
      info.kmin = 1; 
      info.kmax = meshsize.kmax;
      info.a = 3; 
      info.b = 4;
      info.c = 8;
      info.d = 7;
  end
end

function info = getNodeInfo(isuf, meshsize)
  switch isuf
    case 1 ## (surface No.1... kmin( -z direction )
      info.nodesize = (meshsize.imax+1) * (meshsize.jmax+1);
      info.imin = 1;
      info.imax = meshsize.imax+1;
      info.jmin = 1;
      info.jmax = meshsize.jmax+1;
      info.kmin = 1;
      info.kmax = 1;
    case 2 ## (surface No.2... kmax( +z direction )
      info.nodesize = (meshsize.imax+1) * (meshsize.jmax+1);
      info.imin = 1;
      info.imax = meshsize.imax+1;
      info.jmin = 1;
      info.jmax = meshsize.jmax+1;
      info.kmin = meshsize.kmax+1;
      info.kmax = meshsize.kmax+1;
    case 3 ## (surface No.3... imin( -x direction )
      info.nodesize = (meshsize.kmax+1) * (meshsize.jmax+1);
      info.imin = 1;
      info.imax = 1;
      info.jmin = 1;
      info.jmax = meshsize.jmax+1;
      info.kmin = 1; 
      info.kmax = meshsize.kmax+1;
    case 4 ## (surface No.4... imax( +x direction )
      info.nodesize = (meshsize.kmax+1) * (meshsize.jmax+1);
      info.imin = meshsize.imax+1;
      info.imax = meshsize.imax+1;
      info.jmin = 1;
      info.jmax = meshsize.jmax+1;
      info.kmin = 1; 
      info.kmax = meshsize.kmax+1;
    case 5 ## (surface No.5... jmin( -y direction )
      info.nodesize = (meshsize.imax+1) * (meshsize.kmax+1);
      info.imin = 1;
      info.imax = meshsize.imax+1;
      info.jmin = 1;
      info.jmax = 1;
      info.kmin = 1; 
      info.kmax = meshsize.kmax+1;
    case 6 ## (surface No.6... jmax( +y direction )
      info.nodesize = (meshsize.imax+1) * (meshsize.kmax+1);
      info.imin = 1;
      info.imax = meshsize.imax+1;
      info.jmin = meshsize.jmax+1;
      info.jmax = meshsize.jmax+1;
      info.kmin = 1; 
      info.kmax = meshsize.kmax+1;
  end
end

