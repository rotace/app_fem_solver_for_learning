function writeVtkMesh(fid,para,mesh)

  ## fmt_name
  ##    unsined_short, short, unsigned_int, int, 
  ##    unsigned_long, long, float, double
  fmt_name = 'float';
  fmt3 = '%e\t%e\t%e\n';

## write header
fprintf(fid, '# vtk DataFile Version 3.0\n');
fprintf(fid, 'hexahedron\n'); 
fprintf(fid, 'ASCII\n'); 
fprintf(fid, 'DATASET UNSTRUCTURED_GRID\n');
fprintf(fid, '\n'); 

## write coordinate
fprintf(fid, ['POINTS %10d   ',fmt_name,'\n'],para.nnp);
fprintf(fid, fmt3, mesh.nodes); 
fprintf(fid, '\n');

## write elements
elemsfmt = '%d   %d %d %d %d %d %d %d %d \n';
fprintf(fid, 'CELLS %10d %10d\n',para.nel ,(para.nen+1)*para.nel );
fprintf(fid, elemsfmt, [8*ones(1,para.nel) ; mesh.elems-1] ); 
fprintf(fid, '\n');

## write cell_type
fprintf(fid, 'CELL_TYPES %d \n',para.nel);
fprintf(fid, '%d \n', 12*ones(para.nel,1) );
fprintf(fid, '\n');	 
	 
end
