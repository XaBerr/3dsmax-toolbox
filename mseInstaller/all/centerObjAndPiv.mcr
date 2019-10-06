macroScript P3DScenterObjAndPiv
category:"P3DS" 
tooltip:"centerObjAndPiv" 
buttonText: "COaP"
(
	try
	(
		fileIn ((getDir #scripts)+"\\centerObjAndPiv.mse") quiet:true
	)
	catch()
)