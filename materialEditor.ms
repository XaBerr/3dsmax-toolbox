try(
cui.unregisterdialogbar MaterialEditor
destroyDialog MaterialEditor)catch()
global DialogIniFile = ((getDir #scripts) + "\\P3DS\\config.ini")
cont = 0
fname = ""
vect = #()
vect2 = #()
my_files = #()
rollout MaterialEditor "P3DStudio" width:160 height:336
(
	
	button btn2 "Folder" pos:[6,6] width:51 height:15
	listbox lbx1 "" pos:[10,47] width:139 height:21
	checkbox chk1 "+medit" pos:[91,7] width:56 height:12 enabled:true checked:false
	checkbox chk2 "incr" pos:[92,25] width:56 height:12 enabled:true checked:false
	label lbl4 "Material:" pos:[12,29] width:57 height:16
	
	on MaterialEditor open  do
	(
		try(
			
			DialogFld = getIniSetting DialogIniFile "MaterialEditor" "Folder"
			if DialogFld == undefined then (return 1;)
			
			lbx1.items = #()
			vect = #()
			vect2 = #()
			my_files = #()
			fname = DialogFld+"\\*"
			d = fname
			
			for f in getFiles (d + "*.mat") do
			(
				append my_files (getFilenameFile f)
			)
				
			fname[fname.count] = ""
				
			for filename in my_files do
			(
				loadMaterialLibrary (fname+filename+".mat")
				for i in currentMaterialLibrary do
				(
					append vect (#(i.name, filename))
				)
			)
			
			for o in vect do
				append vect2 o[1]
			sort vect2
			lbx1.items = vect2
			
		)catch()
	)
	
	on MaterialEditor moved pos do
	(
		setIniSetting DialogIniFile "MaterialEditor" "Position" (pos as string)
	)
	on btn2 pressed do
	(
		try
		(
			lbx1.items = #()
			vect = #()
			vect2 = #()
			my_files = #()
			prova = getSavePath caption:"Search a Folder"
			setIniSetting DialogIniFile "MaterialEditor" "Folder" (prova as string)
			fname = prova+"\\*"
			d = fname
			for f in getFiles (d + "*.mat") do
			(
				append my_files (getFilenameFile f)
			)
				
			fname[fname.count] = ""
				
			for filename in my_files do
			(
				loadMaterialLibrary (fname+filename+".mat")
				for i in currentMaterialLibrary do
				(
					append vect (#(i.name, filename))
				)
			)
			
			for o in vect do
				append vect2 o[1]
			sort vect2
			lbx1.items = vect2
		
		)
		catch
		()
	)
	on lbx1 doubleClicked itm do
	with undo on
		(
			print (lbx1.items[itm])
			try
			(
				print "tutto ok begin"
				temp = vect [(findItem (for o in vect collect o[1]) lbx1.items[itm])][2]
				asd = fname+temp+".mat"
				print asd
				print cont
				loadMaterialLibrary (fname+temp+".mat")
				print "tutto ok lib"
				if ( chk2.checked == false) do
				(	
					cont = 0
				)
				print "tutto ok cont"
				print cont
				cont = cont + 1
				
				if chk1.checked do
				(
					meditMaterials[cont]=currentMaterialLibrary[lbx1.items[itm]]
				)
				$.material = currentMaterialLibrary[lbx1.items[itm]]
				print "tutto ok end"
			)
			catch
			()
		)
)
DialogPos = execute (getIniSetting DialogIniFile "MaterialEditor" "Position")
if DialogPos == OK then DialogPos = [70,180]
createdialog MaterialEditor 160 336 DialogPos.x DialogPos.y
cui.RegisterDialogBar MaterialEditor
