# 計算座標系[-1,1]におけるガウス積分点とそれに対応する重み
function [w,gp] = gauss(ngp)
# INPUT
#   ngp : 積分点数
# OUTPUT
#   w   : 重み
#   gp  : ガウス積分点(gauss point)

if ngp == 1
   gp = 0;
   w  = 2;
elseif ngp == 2
   gp = [-0.57735027, 0.57735027];
   w  = [1          , 1         ];
elseif ggp == 3
   gp = [-0.7745966692, 0.7745966692, 0.0];
   w  = [ 0.5555555556, 0.5555555556, 0.8888888889];
end



	 
