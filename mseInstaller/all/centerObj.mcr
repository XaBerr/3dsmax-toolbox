macroScript P3DScenterObj
category:"P3DS" 
tooltip:"centerObj" 
buttonText: "XB"
(
	try
	(
		fileIn ((getDir #scripts)+"\\centerObj.mse") quiet:true
	)
	catch()
)