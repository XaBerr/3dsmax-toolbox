macroScript XABERRloadPrefMat
category:"XABERR" 
tooltip:"loadPrefMat" 
buttonText: "LPM"
(
	try
	(
		fileIn ((getDir #scripts)+"\\loadPrefMat.mse") quiet:true
	)
	catch()
)