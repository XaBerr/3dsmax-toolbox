macroScript P3DSdownSampling
category:"P3DS" 
tooltip:"downSampling" 
buttonText: "DS"
(
	try
	(
		fileIn ((getDir #scripts)+"\\downSampling.mse") quiet:true
	)
	catch()
)