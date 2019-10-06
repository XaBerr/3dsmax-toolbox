try(
cui.unregisterdialogbar organizer
destroyDialog organizer)catch()
global DialogIniFile = ((getDir #scripts) + "\\P3DS\\config.ini")
rollout organizer "P3DStudio" width:104 height:320
(
	listbox lbx1 "" pos:[7,20] width:90 height:22
	
	GroupBox grp1 "Organizer" pos:[4,5] width:95 height:310
	
	on organizer open do
	(
		lbx1.items = #()
			vect = #()
			vect2 = #()
			my_files = #()
			print ""
			prova = ((getDir #scripts) + "\\P3DS")
			print prova
			fname = prova+"\\*"
			d = fname			
			
			for f in getFiles (d + "*.mse") do
			(
				append my_files (getFilenameFile f)
				print (getFilenameFile f)
			)
			sort my_files
			lbx1.items = my_files
			
	)
	on lbx1 selected itm do
	(
		print (lbx1.items[itm])
		try
		(
			fname = ((getDir #scripts) + "\\P3DS")+"\\"
			fileIn (fname+lbx1.items[itm]+".mse")
		)
		catch
		()
	)
	
	on organizer moved pos do
	(
		setIniSetting DialogIniFile "organizer" "Position" (pos as string)
	)
)

DialogPos = execute (getIniSetting DialogIniFile "organizer" "Position")
if DialogPos == OK then DialogPos = [70,180]

createdialog Organizer 104 320 DialogPos.x DialogPos.y
cui.RegisterDialogBar Organizer