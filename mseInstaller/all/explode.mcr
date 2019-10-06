macroScript P3DSexplode
category:"P3DS" 
tooltip:"explode" 
buttonText: "EX"
(
	try
	(
		fileIn ((getDir #scripts)+"\\explode.mse") quiet:true
	)
	catch()
)