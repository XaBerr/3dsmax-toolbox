try(
cui.unregisterdialogbar viewsManager
destroyDialog viewsManager)catch()
global DialogIniFile = ((getDir #scripts) + "\\P3DS\\config.ini")
rollout viewsManager "LayerFreeze" width:64 height:32
(
	button btn1 "D" pos:[0,0] width:16 height:16 toolTip:"view down (bottom)"
	button btn2 "T" pos:[16,0] width:16 height:16 toolTip:"view top"
	button btn3 "B" pos:[32,0] width:16 height:16 toolTip:"view back"
	button btn7 "P" pos:[48,0] width:16 height:16 toolTip:"view prospective"
	
	button btn4 "L" pos:[0,16] width:16 height:16 toolTip:"view left"
	button btn5 "F" pos:[16,16] width:16 height:16 toolTip:"view front"
	button btn6 "R" pos:[32,16] width:16 height:16 toolTip:"view right"
	button btn8 "C" pos:[48,16] width:16 height:16 toolTip:"view camera"
	
	on btn1 pressed do
	(
		undo on (
			try(
				viewport.setType #view_bottom
			)catch( print ("Error hide: "  + getCurrentException()))
		)
	)
	on btn2 pressed do
	(
		undo on (
			try(
				viewport.setType #view_top
			)catch( print ("Error hide: "  + getCurrentException()))
		)
	)
	on btn3 pressed do
	(
		undo on (
			try(
				viewport.setType #view_back
			)catch( print ("Error hide: "  + getCurrentException()))
		)
	)
	on btn4 pressed do
	(
		undo on (
			try(
				viewport.setType #view_left
			)catch( print ("Error hide: "  + getCurrentException()))
		)
	)
	on btn5 pressed do
	(
		undo on (
			try(
				viewport.setType #view_front
			)catch( print ("Error hide: "  + getCurrentException()))
		)
	)
	on btn6 pressed do
	(
		undo on (
			try(
				viewport.setType #view_right
			)catch( print ("Error hide: "  + getCurrentException()))
		)
	)
	
	on btn7 pressed do
	(
		undo on (
			try(
				viewport.setType #view_persp_user
			)catch( print ("Error hide: "  + getCurrentException()))
		)
	)
	on btn8 pressed do
	(
		undo on (
			try(
				viewport.setType #view_camera
			)catch( print ("Error hide: "  + getCurrentException()))
		)
	)
	
	on viewsManager moved pos do
	(
		setIniSetting DialogIniFile "viewsManager" "Position" (pos as string)
	)
)

DialogPos = execute (getIniSetting DialogIniFile "viewsManager" "Position")
if DialogPos == OK then DialogPos = [70,180]
createdialog viewsManager 64 32 DialogPos.x DialogPos.y
cui.RegisterDialogBar viewsManager