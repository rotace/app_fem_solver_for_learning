#####
### main function

# initialize
import os
import sys
from paraview.simple import *

print "Start-script"

# abs_path
current_path = os.path.abspath(os.path.basename('paraview_python'))
parent_path = os.path.abspath(os.path.dirname('paraview_python'))
import_path = parent_path
export_path = current_path

# proj name
proj = 'acous'

# frequency table
flist = range(300,1301,200)
# if you sellect the sets of freqencies, you have to use below.
# flist = ['2288','2312','2408','2480','2496']

print 'frequency list : '+ str(flist)
print "+++++ Start-Iteration +++++"

for freq in flist:
	infile = import_path + '/' + proj  +str(freq) + '.vtk'
	exfile = export_path + '/' + proj  +str(freq) + '.png'
	
	print 'load file : '+ infile
	
	# import
	result_vtk = LegacyVTKReader( FileNames=[infile] )
	rend = GetRenderView()		# RenderView
	rep = Show()				# DataRepresentation

	# text information
	text = Text()
	text.Text = str(freq) + 'Hz'
	reptext = Show()			# DataRepresentation
	reptext.Color = [0,0,0]

	# camera set (if you want to set the camera potision)

	# input (select data)
	rep.ColorArrayName = ('POINT_DATA', 'pressure_real')

	# color range (auto range)
	datarange = rep.Input.PointData[rep.ColorArrayName].GetRange()
	rep.LookupTable = MakeBlueToRedLT(datarange[0],datarange[1])

	# color range (manual range)
	#datarange = [0,1]
	#rep.LookupTable = MakeBlueToRedLT(datarange[0],datarange[1])

	# write image
	Render()
	WriteImage(exfile)

	# delete
	Delete(text)
	Delete(result_vtk)
	Render()

	print "+++++" + str(freq) + " end  +++++"


print "End-script"
