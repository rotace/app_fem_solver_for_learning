# ポストプロセスー計算結果の後処理
function Truss2Dpostprocessor(d,itr,id)
loadValue;

# 要素ごとの応力をコマンドウィンドウに出力
fprintf(1,'element\t\tstress\n');
# 応力の算出
for e = 1:nel
    de     = d(mesh.index(:,e)); # 要素番号eの節点変位を「収集」して要素変位行列に
    const  = dist.E(e)/dist.leng(e); # 応力の成分
    
    if ndof == 1 # 棒要素(1次元)のとき
        stess(e) = const*([-1 1]*de);
    end
    if ndof == 2 # トラス要素(2次元)のとき
        p = dist.phi(e)*pi/180;
        c = cos(p); s=sin(p);
        stress(e) = const*[-c -s c s]*de; # 応力の算出
    end
    
    fprintf(1,'%d\t\t%f\n',e,stress(e));
end
