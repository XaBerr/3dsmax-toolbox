macroScript XABERRorganizer
category:"XABERR" 
tooltip:"organizer" 
buttonText: "XB"
(
	try
	(
		fileIn ((getDir #scripts)+"\\organizer.mse") quiet:true
	)
	catch()
)