macroScript XABERRbattleTool
category:"XABERR" 
tooltip:"battleTool" 
buttonText: "BT"
(
	try
	(
		fileIn ((getDir #scripts)+"\\battleTool.mse") quiet:true
	)
	catch()
)