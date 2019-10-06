macroScript XABERRdownSampling
category:"XABERR" 
tooltip:"downSampling" 
buttonText: "DS"
(
	try
	(
		fileIn ((getDir #scripts)+"\\downSampling.mse") quiet:true
	)
	catch()
)