try(
cui.unregisterdialogbar LoadPrefMat
destroyDialog LoadPrefMat)catch()
global DialogIniFile = ((getDir #scripts) + "\\P3DS\\config.ini")
filename = ""
rollout LoadPrefMat "P3DStudio" width:162 height:25
(
	button btn1 "Load" pos:[123,5] width:33 height:16
	button btn2 "File" pos:[5,5] width:35 height:16
	edittext edt2 "numb" pos:[46,5] width:70 height:16
	on LoadPrefMat open  do
	(
		edt2.text = "1"
		DialogFile = getIniSetting DialogIniFile "LoadPrefMat" "File"
		if DialogFile == undefined then (return 1;)
		filename = DialogFile
	)
	on LoadPrefMat moved pos do
	(
		setIniSetting DialogIniFile "LoadPrefMat" "Position" (pos as string)
	)
	on btn1 pressed do
	with undo on
		(
			try(
				max mtledit
				print "filename:"
				print filename
				loadMaterialLibrary filename
				for i = 1 to edt2.text as integer do
					meditMaterials[i] = currentMaterialLibrary[i]
					print i as integer
			)catch()
		)
	on btn2 pressed do
	(
		try(
			filename = getOpenFileName caption:"Material Library" filename:(getDir #renderPresets + @"\")
			setIniSetting DialogIniFile "LoadPrefMat" "File" (filename as string)
		)catch()
	)
	
)
DialogPos = execute (getIniSetting DialogIniFile "LoadPrefMat" "Position")
if DialogPos == OK then DialogPos = [70,180]
createDialog LoadPrefMat 162 25 DialogPos.x DialogPos.y
cui.RegisterDialogBar LoadPrefMat