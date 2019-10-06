macroScript XABERRmaterialEditor
category:"XABERR" 
tooltip:"materialEditor" 
buttonText: "ME"
(
	try
	(
		fileIn ((getDir #scripts)+"\\materialEditor.mse") quiet:true
	)
	catch()
)