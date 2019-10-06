macroScript P3DSorganizer
category:"P3DS" 
tooltip:"organizer" 
buttonText: "P3DS"
(
	try
	(
		fileIn ((getDir #scripts)+"\\organizer.mse") quiet:true
	)
	catch()
)