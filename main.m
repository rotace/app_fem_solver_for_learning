###############################################
#      vibro-acoustic solver
#               written by shibata (2015/6/18)
###############################################

disp('##################################')
disp('###     START     SOLVER       ###')
disp('##################################')
clear all;
close all;

addpath('system');
addpath('fem');
addpath('truss');
addpath('bar');
addpath('acoustic');
addpath('tool');
addpath('sample');


## 全体時間計測
tstart = tic;

## iteration
itr.graph = 0;
itr.step  = 0;
itr.first = true;
itr.start = 300;
itr.stop  = 300;
itr.stop  = 1300;
itr.df    = 200;
for freq = itr.start:itr.df:itr.stop

  itr.freq  = freq;    
  itr.step  = itr.step +1;
  itr.omega = 2*pi*itr.freq;
  if itr.step ~= 1
    itr.first  = false;
  end
  ## display
  freq  = itr.freq
  step  = itr.step
  save('itr.dat','itr')

  ## 時間計測
  tic;

  # global変数のインクルード
  include_global;

  ## input
  disp('###      Input      ###')
  ## ３種類の入力ファイルを実行できます。
  ## 実行したい入力ファイル以外をコメントアウトしてください。
  ## sample_truss2D(itr);
  ## sample_bar1D(itr);
  inputPureAcousFemTest(itr);

  # メモリ割り当て (Ax = b)
  disp('### Allocate Memory ###')
  A      = zeros( g_neq     );
  b      = zeros( g_neq , 1 );
  x      = zeros( g_neq , 1 );
  x_flag = zeros( g_neq , 1 ); # 境界条件flag

  # complex
  A = complex(A);
  b = complex(b);
  x = complex(x);

  # マトリクスアセンブリ
  disp('### Matrix assembly ###')
  ta = tic;

  id.iSID = 1;
  id.iMID = g_mid;
  [A,b,x,x_flag] = assembleGlobal( A,b,itr,id);

  toc(ta);

  # 連立1次方程式の求解
  disp('###      SOLVE      ###')
  ts=tic;
  [x,b_E] = solvedr(A,b,x,x_flag);
  toc(ts);

  # ポストプロセス
  disp('###      Output     ###')
  id.iSID = 1;
  id.iMID = g_mid;

  switch id.iMID
    case 1
      post = @Truss2Dpostprocessor;
    case 2
      post = @Bar1Dpostprocessor;
    case 3
      post = @vtk_output;
  end
  post(x,itr,id);

  ## 時間計測
  toc

  disp('##################################')
  disp('###        ITERATION END       ###')
  disp('##################################')
## iteration end
end

## 全体時間計測
toc(tstart);
