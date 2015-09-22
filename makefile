
run	:
	\octave main.m
	\touch run

tag	:
	\find . -name "*.m" -exec etags {} +
#	\find . -name "*.m" -print -exec etags {} +

graph	:
	\rm -rf *.txt
	\octave analysis.m

# caution % -> # : you sould fix %d %e %f by yourself.
# utf8-unix	:
# 	\find . -name "*.m" -exec nkf --overwrite -Lu -w {} \;
# 	\find . -name "*.m" -exec sed -i -e "s/%/#/g" {} \;

sjis-win	:
	\find . -name "*.m" -exec nkf --overwrite -Lw -s {} \;
	\find . -name "*.m" -exec sed -i -e "s/#/%/g" {} \;

clean	:
	\rm -rf *.vtk
	\rm -rf *.txt
	\rm -rf *.dat
	\rm -rf run
	\rm -rf paraview_python/*.png

view	:
	\paraview &
