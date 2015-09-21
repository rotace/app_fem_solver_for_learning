function spygray(A)

[mx,my]=size(A);
## colormap(gray);

## binarization
for i=1:mx
  for j=1:my
    ## A = real(A)
    ## A = abs(A)
      if     abs( A(i,j) ) < 1.e-7
	A(i,j) =  0;
      elseif A(i,j) > 0.0
	A(i,j) = +1;
      elseif A(i,j) < 0.0
	A(i,j) = -1;
      end
      
  end
end

pcolor([A,zeros(mx,1);
	zeros(1,my+1)]);
colorbar;
axis ij;
axis square;
