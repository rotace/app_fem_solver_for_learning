function disp_and_stress(e,d,id)
loadValue;

de     = d(mesh.index(:,e));
elemse = mesh.elems(:,e);            # 要素eが接続する全体系の節点番号を準備
xe     = mesh.nodes(elemse);	      # 要素節点のx座標を「収集」
[w,gp] = gauss(ngp);	      # ガウス積分点と重みを準備

# ガウス積分点で応力を評価
for i=1:ngp

  #要素形状関数ベクトルのガウス積分点での値
  N   = Nvector1D( gp(i), nen);
  #要素形状関数微分ベクトルのガウス積分点での値とヤコビアン
  [B,detJ] = Bmatrix1D( gp(i), xe, nen);

  Ee  = N*dist.E(elemse)';
  stress_gauss(i) = Ee*B*de;
  
  xt = 0.5*(xe(1)+xe(nen))+detJ*gp(i);
  gauss_pt(i) = xt;
end

# 要素内のガウス積分点における応力をコマンドウィンドウに出力
fprintf(1,'%d\t%f\t%f\t%f\t%f\n', ...
	e, gauss_pt(1),gauss_pt(2),stress_gauss(1),stress_gauss(2));

# 要素内の標本点で変位と応力を評価
# （linspace命令により要素内で等間隔な点列を作成）
xplot  = linspace(xe(1), xe(nen), mate.nplot);

for i= 1:mate.nplot
    xpi      = xplot(i);
    xi       = (xpi - 0.5*(xe(1)+xe(nen)))/detJ; #物理座標から計算座標へ
    N        = Nvector1D(xi,nen);
    [B,detJ] = Bmatrix1D(xi,xe,nen);

    Ee = N*dist.E(elemse)';
    displacement(i) = N*de;
    stress(i) = Ee*B*de;
end

# 変位と応力の分布を描画
figure(2)
subplot(2,1,1);
plot(xplot,displacement,'b'); legend('sdf'); hold on;
ylabel('displacement'); title('FE analysis of 1D bar');

subplot(2,1,2);
plot(xplot,stress,'b'); hold on;
ylabel('stress'); xlabel('x');
legend('FE');

    
  
