try(
cui.unregisterdialogbar explode
destroyDialog explode)catch()
global DialogIniFile = ((getDir #scripts) + "\\P3DS\\config.ini")

expl = false
delta = [0,0,0]
percent = 0.3
rollout explode "P3DStudio" width:114 height:24
(
	button btn1 "explode" pos:[57,4] width:50 height:16
	spinner spn1 "%" pos:[10,3] width:42 height:16 range:[-100,100,0.3]
	on explode moved pos do
	(
		setIniSetting DialogIniFile "explode" "Position" (pos as string)
	)
	on btn1 pressed do
	with undo on
		(
			try
			(
				
				if( expl == true) then
				(
					delta = delta * -1
					for i in $ do
					(
						if(i.pos.x > $.center.x) then
							(i.pos.x += delta.x * percent)
						else
							(i.pos.x -= delta.x * percent)
						
						if(i.pos.y > $.center.y) then
							(i.pos.y += delta.y * percent)
						else
							(i.pos.y -= delta.y * percent)
						
						if(i.pos.z > $.center.z) then
							(i.pos.z += delta.z * percent)
						else
							(i.pos.z -= delta.z * percent)
					)
					expl = false
				)
				else
				(
					delta = $.max - $.min
					for i in $ do
					(
						if(i.pos.x > $.center.x) then
							(i.pos.x += delta.x * percent)
						else
							(i.pos.x -= delta.x * percent)
						
						if(i.pos.y > $.center.y) then
							(i.pos.y += delta.y * percent)
						else
							(i.pos.y -= delta.y * percent)
						
						if(i.pos.z > $.center.z) then
							(i.pos.z += delta.z * percent)
						else
							(i.pos.z -= delta.z * percent)
					)
					expl = true
				)
			)catch()
		)
	on spn1 changed value do
	(
		percent = spn1.value
		print spn1.value
	)
)

DialogPos = execute (getIniSetting DialogIniFile "explode" "Position")
if DialogPos == OK then DialogPos = [70,180]

createDialog explode 114 24 DialogPos.x DialogPos.y
cui.RegisterDialogBar explode
