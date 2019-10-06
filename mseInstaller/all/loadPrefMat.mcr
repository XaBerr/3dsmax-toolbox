macroScript P3DSloadPrefMat
category:"P3DS" 
tooltip:"loadPrefMat" 
buttonText: "LPM"
(
	try
	(
		fileIn ((getDir #scripts)+"\\loadPrefMat.mse") quiet:true
	)
	catch()
)