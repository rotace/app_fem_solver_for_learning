function writeVtkComplex(fid,para,cmplx,name)

  ## fmt_name
  ##    unsined_short, short, unsigned_int, int, 
  ##    unsigned_long, long, float, double
  fmt_name = 'float';
  fmt1 = '%e\n';
  fmt3 = '%e\t%e\t%e\n';
 
  if     [1,para.nnp] == size(cmplx) # point scalar data
    fprintf(fid, ['SCALARS  ', name ,'_real  ',fmt_name,'\n'] );
    fprintf(fid, 'LOOKUP_TABLE default\n');
    fprintf(fid, fmt1, real(cmplx));
    fprintf(fid, '\n');
    fprintf(fid, ['SCALARS  ', name ,'_imag  ',fmt_name,'\n'] );
    fprintf(fid, 'LOOKUP_TABLE default\n');
    fprintf(fid, fmt1, imag(cmplx));
    fprintf(fid, '\n');
    ## fprintf(fid, ['SCALARS  ', name ,'_abs   ',fmt_name,'\n'] );
    ## fprintf(fid, 'LOOKUP_TABLE default\n');
    ## fprintf(fid, fmt1, abs(cmplx));
    ## fprintf(fid, '\n');
      
  elseif [3,para.nnp] == size(cmplx) # point vector data
    fprintf(fid, ['VECTORS  ', name ,'_real  ',fmt_name,'\n'] );
    fprintf(fid, fmt3, real(cmplx));
    fprintf(fid, '\n');
    fprintf(fid, ['VECTORS  ', name ,'_imag  ',fmt_name,'\n'] );
    fprintf(fid, fmt3, imag(cmplx));
    fprintf(fid, '\n');
    ## fprintf(fid, ['VECTORS  ', name ,'_abs   ',fmt_name,'\n'] );
    ## fprintf(fid, fmt3, abs(cmplx));
    ## fprintf(fid, '\n');
    
  elseif [1,para.nel] == size(cmplx) # cell scalar data
    error('not implemented!');
  elseif [3,para.nel] == size(cmplx) # cell vector data
    error('not implemented!');
  else
    error('size do not match!');
  end

end
