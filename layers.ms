try(
cui.unregisterdialogbar LayerFreeze
destroyDialog LayerFreeze)catch()
global DialogIniFile = ((getDir #scripts) + "\\P3DS\\config.ini")

currentLayerH
currentLayerF
try(destroydialog LayerFreeze)catch()
rollout LayerFreeze "LayerFreeze" width:32 height:32
(
	button btn1 "H" pos:[0,0] width:16 height:16 toolTip:"Hide layer"
	button btn2 "S" pos:[16,0] width:16 height:16 toolTip:"Show layer"
	button btn5 "F" pos:[0,16] width:16 height:16 toolTip:"Freeze layer"
	button btn6 "U" pos:[16,16] width:16 height:16 toolTip:"Unfreeze layer"
	on btn1 pressed do
	(
		undo on (
			try(
				currentLayerH = $.layer
				$.layer.on = false
			)catch( print ("Error hide: "  + getCurrentException()))
		)
	)
	on btn2 pressed do
	(
		undo on (
			try(
				currentLayerH.on = true
			)catch( print ("Error unhide: "  + getCurrentException()))
		)
	)
	on btn5 pressed do
	(
		undo on (XA
			try(
				currentLayerF = $.layer
				$.layer.isFrozen  = true
			)catch( print ("Error hide: "  + getCurrentException()))
		)
	)
	on btn6 pressed do
	(
		undo on (
			try(
				currentLayerF.isFrozen  = false
			)catch( print ("Error unhide: "  + getCurrentException()))
		)
	)
	on LayerFreeze moved pos do
	(
		setIniSetting DialogIniFile "LayerFreeze" "Position" (pos as string)
	)
)

DialogPos = execute (getIniSetting DialogIniFile "LayerFreeze" "Position")
if DialogPos == OK then DialogPos = [70,180]

createdialog LayerFreeze 32 32 DialogPos.x DialogPos.y
cui.RegisterDialogBar LayerFreeze