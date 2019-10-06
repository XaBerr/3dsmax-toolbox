macroScript P3DSmaterialEditor
category:"P3DS" 
tooltip:"materialEditor" 
buttonText: "ME"
(
	try
	(
		fileIn ((getDir #scripts)+"\\materialEditor.mse") quiet:true
	)
	catch()
)