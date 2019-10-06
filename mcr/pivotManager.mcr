macroScript XABERRpivotManager
category:"XABERR" 
tooltip:"pivotManager" 
buttonText: "PM"
(
	try
	(
		fileIn ((getDir #scripts)+"\\pivotManager.mse") quiet:true
	)
	catch()
)