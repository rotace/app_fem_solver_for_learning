# トラス要素の要素剛性行列を作成
function [ke,fe] = calcLocalAreaMatrixTruss(e,itr,id)
loadValue;

const = dist.area(e)*dist.E(e)/dist.leng(e); # 要素剛性行列の成分

if ndof == 1;
    ke = const * [1 -1; # 棒要素(1次元)の要素剛性行列
                 -1  1];
elseif ndof == 2;
    p = dist.phi(e)*pi/180; # 角度(degree)を弧度(radian)に変換
    
    s = sin(p);  c = cos(p);
    s2 = s^2;    c2 = c^2;
    cs = c*s;
    
    ke = const*[ c2  cs -c2 -cs;
                 cs  s2 -cs -s2;
                -c2 -cs c2   cs;
                -cs -s2 cs   s2];
end

fe      = zeros(ndof*2,1);

