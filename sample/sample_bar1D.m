function sample_bar1D(itr)
include_fem;
########## SET MESH DATA ################
para.nsd =1;# 空間の次元数
para.ndof=1;# 節点あたりの自由度数
para.nnp =5;# 節点数
para.nel =2;# 要素数
para.nen =3;# 要素節点数
para.nben=1;# 境界要素節点数
para.neq  = para.ndof * para.nnp;
para.ngp =2;# １方向あたりのガウス積分点数
para.mid =2;# method ID
para.ndim=1;


# init value
[para,mesh,boun,dist,mate,plflag] = initValue(para);

### Bar固有情報 ###############
# 要素特性
dist.E    = 8*ones(1,para.nnp); # ヤング率の節点値
dist.body = 8*ones(1,para.nnp); # 体積力 (body force)の節点値
dist.area = [4 7 10 11 12 ]; # 断面積 の節点値


# 計算結果の可視化フラグ
plflag.bar = 'yes';
plflag.nod = 'yes';

nplot = para.nnp*10; # 変位と応力を描画するための標本点数

# 要素内の点荷重
P   = 24; # 点荷重 (point forces)
xp  = 5;  # 点荷重を作用させるx座標値
np  = 1;  # 点荷重の数

### 一般情報 ##################
# 基本境界条件
boun.flags(1)=1; # 全体系の節点1が基本境界上にあることのフラグ
boun.e    (1)=0; # 基本境界条件の値(既知の変位)

# 自然境界条件
boun.flags(5)=2; # 全体系の節点5が自然境界上にあることのフラグ
boun.n    (5)=0; # 自然境界条件の値(既知の外力)

## 節点
nodes = [ 2.0 3.5 5.0 5.5 6.0];

# 要素に関する局所的な節点番号を，
# 付け替え前の全体系の節点番号に変換するための2次元配列
elems   = [ 1 3;
	  2 4;
	  3 5];

mesh.nodes  = nodes;
mesh.elems  = elems;
mesh.index  = makeIndex( elems , para.ndof, para.nel , para.nen  );

mate.xp       = xp;
mate.P        = P;
mate.np       = np;
mate.nplot    = nplot;


checkValue(para,mesh,boun,dist,mate);
saveValue(para,mesh,boun,dist,mate,plflag);
################################
## input global infomation
setGlobalID(para);

