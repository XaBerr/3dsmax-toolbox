macroScript XABERRexplode
category:"XABERR" 
tooltip:"explode" 
buttonText: "EX"
(
	try
	(
		fileIn ((getDir #scripts)+"\\explode.mse") quiet:true
	)
	catch()
)