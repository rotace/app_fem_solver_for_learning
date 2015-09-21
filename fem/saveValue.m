function saveValue(para,mesh,boun,dist,mate,plflag)
  include_fem;
  ## save value
  dataset{1,1} = para;
  dataset{1,2} = mesh;
  dataset{1,3} = boun;
  dataset{1,4} = dist;
  dataset{1,5} = mate;
  dataset{1,6} = plflag;
end
