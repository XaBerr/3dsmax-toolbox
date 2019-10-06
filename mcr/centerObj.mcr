macroScript XABERRcenterObj
category:"XABERR" 
tooltip:"centerObj" 
buttonText: "XB"
(
	try
	(
		fileIn ((getDir #scripts)+"\\centerObj.mse") quiet:true
	)
	catch()
)