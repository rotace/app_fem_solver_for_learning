# 要素剛性行列と要素体積力行列を作成
function [ke,fe] = calcLocalAreaMatrixBar(e,itr,id);
loadValue;

elemse = mesh.elems(:,e);      # 要素eが接続する全体系の節点番号を準備
coorde = mesh.nodes(elemse);   # 要素節点のx座標を「収集」
[w,gp] = gauss(ngp);	      # ガウス積分点と重みを準備
ke     = zeros(nen,nen);      # 要素剛性行列の初期化 
fe     = zeros(nen,1);	      # 要素体積行列の初期化

for i = 1:ngp
  #要素形状関数ベクトルのガウス積分点での値
  N   = Nvector1D( gp(i), nen);
  #要素形状関数微分ベクトルのガウス積分点での値とヤコビアン
  [B,detJ] = Bmatrix1D( gp(i), coorde, nen);
  ## ガウス積分点における諸量 ([1x1] = [1xnnp]*[nnpx1] )
  Ae  = N*dist.area(elemse)';	# ガウス積分点における断面積 
  Ee  = N*dist.E(elemse)';	# 　　　　　　　　　　ヤング率
  be  = N*dist.body(elemse)';	# 　　　　　　　　　　体積力
  
  ke  = ke + w(i)*(B'*Ae*Ee*B);   # ガウス積分値
  fe  = fe + w(i)*N'*be;	  # ガウス積分値

end
ke  = detJ*ke;
fe  = detJ*fe;

# 要素内に点荷重がある場合の処理
for i=1:mate.np
  Pi = mate.P(i);
  xpi= mate.xp(i);
  if coorde(1)<=xpi && xpi<coorde(nen)
    xi = (xpi - 0.5*(coorde(1)+coorde(nen)))/detJ; #物理座標から計算座標へ
    fe = fe + Pi*[Nvector1D(xi, nen)]'; #点荷重を要素体積行列に加算
  end
end
