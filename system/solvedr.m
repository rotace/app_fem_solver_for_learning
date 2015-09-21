function [x,x_E] = solvedr(A,b,x,x_flag)
  # 分割法による連立一次方程式の解
  include_global;


  ## flag = reshape([ones(3,8);zeros(1,8)] ,[1,32]);
  ## [tmpA,tmpb,tmpx,ID,nd] = replace(A,b,x,flag,g_neq);
  ## spygray(A);
  ## spygray(tmpA);
  debug = false;

  ## spygray(A)
  ## pause


  ## 行列入換#############
  ## 基本境界Eを行列上位に入れ替え & hybrid境界をアセンブリ
  disp('replace matrix');
  [tmpA,tmpb,tmpx,ID,nd] = replace(A,b,x,x_flag,g_neq);
  

  ## 行列分割#################
  # 行列Kと列ベクトルf,dの分割
  A_E   = tmpA(1:nd,1:nd);		     # 部分行列A_Eの抽出
  A_F   = tmpA(nd+1:g_neq,nd+1:g_neq);	     # 部分行列A_Fの抽出
  A_FE  = tmpA(nd+1:g_neq,1:nd);	     # 部分行列A_FEの抽出
  A_EF  = tmpA(1:nd,nd+1:g_neq);	     # 部分行列A_EFの抽出
  b_F   = tmpb(nd+1:g_neq);		     # 部分列行列b_Fの抽出
  x_E   = tmpx(1:nd);			     # 部分行列x_Eの抽出

  ## tmpA
  ## [A_E,A_EF;
  ##  A_FE,A_F]


  ## SOLVE####################
  # x_Fについて解く
  disp('solve');
  x_F   = A_F\( b_F - A_FE*x_E);

  ## CHECK
  Row_Matrix = size(A_F,2)
  Rank_Matrix = rank(A_F)
  comment = 'Check Step.1 ... A_F*x_F = b_F - A_FE*x_E';
  check(A_F,b_F - A_FE*x_E,x_F,debug,comment);


  ##再構成####################
  # 全体変位行列dの再構成
  tmpx = [x_E 
          x_F];
  
  ## 行列再入換 #########
  for i =1:g_neq
    x(i) = tmpx(ID(i));
  end

  ## CHECK
  comment = 'Check Step.2 ... A*x-b (dimension)';
  check(A,b,x,debug,comment);
  
end






################################
## 行列入れ替え関数の定義
function [A,b,x,ID,nd] = replace(A,b,x,flag,g_neq)

  # 基本境界条件をカウント
  # hybrid境界条件をカウント	 
  nd = 0;
  for i= 1:g_neq
    if flag(i) == 1
      nd = nd + 1;
    end
  end

  ## 変数の入れ替え  ... A(:,i) <=> A(:,j) , x(i) <=> x(j)
  count0 = 0; count1= 0; count2=g_neq+1;
  ID2   = zeros(1,g_neq);
  tmpA  = zeros(g_neq);
  tmpx  = zeros(g_neq,1);
  tmpb  = zeros(g_neq,1);
  for i= 1:g_neq
    if     flag(i) == 1 #基本境界のとき
      count1 = count1 + 1;
      ID2(i) = count1;  #基本境界上のE節点から優先的に番号をつける
      tmpA(:,ID2(i))  = A(:,i);
      tmpx(  ID2(i))  = x(i);
    else
      count0 = count0 + 1;
      ID2(i) = nd + count0;
      tmpA(:,ID2(i))  = A(:,i);
      tmpx(  ID2(i))  = x(i);
    end
  end
  
  ## 方程式の入れ替え... A(i,:) <=> A(j,:) , b(i) <=> b(j) 
  A = tmpA;
  for i= 1:g_neq
    tmpA(ID2(i),:) = A(i,:);
    tmpb(ID2(i))   = b(i);
  end

  ## hybrid:sendを除外 (hybrid:recieveにアセンブリ済. x_reci = x_send)
  A = tmpA;
  b = tmpb;
  x = tmpx;
  ID = ID2;

end



## check関数
function check(A,b,x,debug,comment)
  if debug
    disp('')
    disp(comment)
    Row_Matrix = size(A,2)
    Rank_Matrix = rank(A)
    Condition = cond(A)
    Residual = norm(b - A*x)
    Relative_Residual  = Residual/norm(b)
  end
end
