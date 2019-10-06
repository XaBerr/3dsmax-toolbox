macroScript P3DSpivotManager
category:"P3DS" 
tooltip:"pivotManager" 
buttonText: "PM"
(
	try
	(
		fileIn ((getDir #scripts)+"\\pivotManager.mse") quiet:true
	)
	catch()
)