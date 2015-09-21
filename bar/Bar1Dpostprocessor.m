function Bar1Dpostprocessor(d,itr,id)
loadValue;

fprintf(1,'\n     Print stresses at the Gauss points \n')
fprintf(1,'Element\t x1(gauss1) \t x2(gauss2) \t stress(x1) \t stress (x2) \n')
fprintf(1,'---------------------------------------------------------------------------------------\n');


# 要素ごとの変位と応力を算出して出力
for e = 1:nel
    disp_and_stress(e,d,id);
end

	 
ExactSolution;
