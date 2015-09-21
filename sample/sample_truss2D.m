function sample_truss2D(itr)
  include_fem;
  ########## SET MESH DATA ################
  para.nsd =2;# 空間の次元数
  para.ndof=2;# 節点あたりの自由度数
  para.nnp =3;# 節点数
  para.nel =2;# 要素数
  para.nen =2;# 要素節点数
  para.nben=2;# 境界要素節点数
  para.neq =para.ndof * para.nnp;	# 方程式の本数
  para.ngp =0;# １方向あたりのガウス積分点数
  para.mid =1;# method ID
  para.ndim = [1,1];


  ####### init value #######
  [para,mesh,boun,dist,mate,plflag] = initValue(para);

  ### 一般情報 ##################
  ## 節点
  nodes = [1 0;
	   0 0;
	   1 1]';

  ## 要素構成節点
  elems = [1 2 ;
	   3 3];

  # 基本境界条件
  boun.flags(:,1:2)=ones(2,2); # 節点1,2が基本境界上にあることのフラグ
  boun.e    (:,1:2) =zeros(2,2);  # 基本境界条件の値(既知の変位)

  # 自然境界条件
  boun.flags(:,3)= [2;2]; # 節点3(x,y)が自然境界上にあることのフラグ
  boun.n    (:,3)= [10;0]; # 節点3のx方向力とy方向力

  mesh.nodes  = nodes;
  mesh.elems  = elems;
  mesh.index  = makeIndex( elems , para.ndof, para.nel , para.nen  );


  ### Truss固有情報 ############
  # 要素特性
  dist.leng  = [1  sqrt(2)]; # 要素長さ　(Elements length)
  dist.phi   = [90   45   ]; # x'軸(局所座標系)とx軸(全体座標系)がなす角度
  dist.E     = [1    1    ]; # ヤング率
  dist.area  = [1    1    ]; # 断面積　(Elements cross-sectional area)

  # 計算結果の可視化フラグ
  plflag.truss = 'yes';
  plflag.nod   = 'yes';

  checkValue(para,mesh,boun,dist,mate);
  saveValue(para,mesh,boun,dist,mate,plflag);
  
  # トラスの描画
  plottruss(plflag);
  ################################
  ## input global infomation
  setGlobalID(para);
  
end
