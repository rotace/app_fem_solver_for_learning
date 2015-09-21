function [A,b,x,x_flag] = assembleGlobal( A,b,itr,id)
  loadValue;

  switch id.iMID
    ## Truss
    case 1
      veca   = 1:nen*ndof;
      vecb   = 1:nben*ndof;
      calcLocalAreaMatrix = @calcLocalAreaMatrixTruss;
      calcLocalBounMatrix = @assembleGlobal; # dummy function
      nbc    = 0;  # number of boundary condition
      nsma   = 1;  # number of static matrices (area integration)
      nsmb   = 0;# number of static matrices (boundary integration)
      nsm    = nsma+sum(nsmb);
      ## static matrices coefficient (if reuse_flag = true)
      coef    = zeros(nsm,1);
      coef(1) = 1;		# dynamic matrix (static not implimented)

    ## Bar
    case 2
      veca   = 1:nen*ndof;
      vecb   = 1:nben*ndof;
      calcLocalAreaMatrix = @calcLocalAreaMatrixBar;
      calcLocalBounMatrix = @assembleGlobal; # dummy function
      nbc    = 0;  # number of boundary condition
      nsma   = 1;  # number of static matrices (area integration)
      nsmb   = 0;# number of static matrices (boundary integration)
      nsm    = nsma+sum(nsmb);
      ## static matrices coefficient (if reuse_flag = true)
      coef    = zeros(nsm,1);
      coef(1) = 1;		# dynamic matrix (static not implimented)

    ## Acoustic
    case 3
      veca   = 1:nen*ndof;
      vecb   = 1:nben*ndof;
      calcLocalAreaMatrix = @calcLocalAreaMatrixAcous;
      calcLocalBounMatrix = @calcLocalBounMatrixAcous;
      nbc    = 1;  # number of boundary condition
      nsma   = 2;  # number of static matrices (area integration)
      nsmb   = [1];# number of static matrices (boundary integration)
      nsm    = nsma+sum(nsmb);
      nbel   = {para.nbel_z};
      bindex = {mesh.bindex_z};
      ## static matrices coefficient (if reuse_flag = true)
      coef    = zeros(nsm,1);
      wavenum= itr.omega / mate.cspeed;
      coef(1) = -wavenum^2;	               # static mass matrix
      coef(2) = 1;		               # static stiffness matrix
      coef(3) = complex(0,mate.rho*itr.omega); # impedance bc matrix

  end


  ## lA(row,column,num) : local  matrix
  ## gA(row,column,num) : global matrix
  ## lb(row       ,num) : local  vector
  ## gb(row       ,num) : global vector
  

  gA = zeros(neq,neq,1);
  gb = zeros(neq    ,1);

  
  disp('assemble local matrix ...')
  ########## 要素行列と全体行列の組立て　（領域積分）
  # number array of static matrices
  for le= 1:nel
    ## calc local matrix
    [lA,lb] = calcLocalAreaMatrix(le,itr,id);
    ## assemble global matrix
    lm   = mesh.index(veca,le);
    gb(lm,:)    = gb(lm,:)	+ complex( lb(veca,:) );
    gA(lm,lm,:) = gA(lm,lm,:) + complex( lA(veca,veca,:) );
  end

  ########### 要素行列と全体行列の組立て　（境界積分）
  for i =1:nbc
    for le= 1:nbel{i}
      ## calc local matrix
      [lA,lb] = calcLocalBounMatrix(le,itr,id);
      ## assemble global matrix
      index  = bindex{i};
      lm     = index(vecb,le);
      gb(lm,:)    = gb(lm,:)	  + complex( lb(vecb,:)	);
      gA(lm,lm,:) = gA(lm,lm,:) + complex( lA(vecb,vecb,:) );
    end
  end
  

  ########## 全体静行列の結合
  ## reuse.flag = false :substitute only
  A = sum(gA,3);
  b = b + sum(gb,2);

    
  # flagsを代入
  x_flag  = reshape(boun.flags, [neq,1]);
  # 基本境界条件を解ベクトルに代入
  x      = complex( reshape(boun.e, [neq,1]) );
  # 自然境界条件を外力行列に代入
  b      = b + complex( reshape(boun.n, [neq,1]) );

end

