try(
cui.unregisterdialogbar PivotPosRollout
destroyDialog PivotPosRollout)catch()
global DialogIniFile = ((getDir #scripts) + "\\P3DS\\config.ini")

fn filterSel o = findItem #(SplineShape, Line, Editable_mesh, Editable_Poly, PolyMeshObject, Editable_Patch) (classof o)
fn PivotOnVertKnot = if selection.count == 1 and (idx = filterSel selection[1]) > 0 do
(
	with undo off with redraw off 
	(
		local sel
		if idx <= 2 then 
		(
			local mods = false
			sel	 = if selection[1].modifiers.count != 0 then (mods = true ; converttosplineshape (copy selection[1])) else selection[1]
			case of
			(
				(subobjectlevel == 0 or subobjectlevel == 3): selection[1].pivot = selection[1].center
				(subobjectlevel == 1):
				(
					if (sk = for s in 1 to (numSplines sel) where (k = getKnotSelection sel s).count == 1 collect datapair s k[1]).count == 1 do
						selection[1].pivot = getKnotPoint sel sk[1].v1 sk[1].v2
				)
				(subobjectlevel == 2):
				(
					if (sk = for s in 1 to (numSplines sel) where (k = getSegSelection sel s).count == 1 collect datapair s k[1]).count == 1 do
						selection[1].pivot = interpBezier3D sel sk[1].v1 sk[1].v2 .50 pathParam:off				
				)
			) ; if mods do delete sel
		)
		else 
		(
			sel = snapshotasmesh selection[1]
			fn averagePos obj vertlist = (local pnt = point3 0 0 0 ; for v in vertlist do pnt += (getVert obj v) ; pnt/vertlist.numberset)
			selection[1].pivot = case getSelectionLevel selection[1] of
			(
				#vertex: if not (verts = getVertSelection sel).isEmpty do averagePos sel verts
				#edge: if not (verts = meshop.getVertsUsingEdge sel (getEdgeSelection sel)).isEmpty do averagePos sel verts
				#face: if not (faces = getFaceSelection sel).isEmpty do (local pnt = point3 0 0 0 ; for f in faces do pnt += (meshop.getFaceCenter sel f) ; pnt/faces.numberset)
				#object: selection[1].center
			) ; free sel
		)
	)
)


rollout PivotPosRollout "P3DStudio" width:80 height:60
(
	button btn1 "L" pos:[0,20] width:20 height:20 tooltip:"Move pivot LEFT\n(bounding box - Object or Group Selection-)"
	button btn2 "F" pos:[20,20] width:20 height:20 tooltip:"Move pivot FRONT\n(bounding box - Object or Group Selection-)"
	button btn3 "R" pos:[40,20] width:20 height:20 tooltip:"Move pivot RIGHT\n(bounding box - Object or Group Selection-)"
	button btn4 "U" pos:[20,0] width:20 height:20 tooltip:"Move pivot UP\n(bounding box - Object or Group Selection-)"
	button btn5 "D" pos:[20,40] width:20 height:20 tooltip:"Move pivot DOWN\n(bounding box - Object or Group Selection-)"
	button btn6 "B" pos:[60,20] width:20 height:20 tooltip:"Move pivot BACK\n(bounding box - Object or Group Selection-)"
	button btn7 "X" pos:[0,0] width:20 height:20 tooltip:"Place pivot at CENTER Object or Group Selection"
	button btn8 "apo" pos:[40,40] width:20 height:20 tooltip:"Affect Pivot Only."
	button btn9 "0" pos:[0,40] width:20 height:20 tooltip:"Place pivot in 0,0,0 position (selected Object or Goup selection)"
	button btn10 "Sub" pos:[40,0] width:20 height:20 tooltip:"Place pivot at Center subObjectSelection"
	button btn11 "z0" pos:[60,40] width:20 height:20 tooltip:"Move Pivot in “0” Z Position - Object or Group Selection -"
	button btn12 "Ali" pos:[60,0] width:20 height:20 tooltip:"Align First Selected Object to the Second Picked One (x,y,z)"
	
	on btn1 pressed do
	with undo on
	(
		try($.pivot.x = $.min.x)catch()
	)
	on btn2 pressed do
	with undo on
	(
		try($.pivot.y = $.min.y)catch()
	)
	on btn3 pressed do
	with undo on
	(
		try($.pivot.x = $.max.x)catch()
	)
	on btn4 pressed do
	with undo on
	(
		try($.pivot.z = $.max.z)catch()
	)
	on btn5 pressed do
	with undo on
	(
		try($.pivot.z = $.min.z)catch()
	)
	on btn6 pressed do
	with undo on
	(
		try($.pivot.y = $.max.y)catch()
	)
	on btn7 pressed do
	with undo on
	(
		try($.pivot = $.center)catch()
	)
	on btn8 pressed do
	with undo on
	(
		try(
		if maxops.pivotmode != #pivotonly
		then maxops.pivotmode = #pivotonly
		else maxops.pivotmode = #none)catch()
	)
	on btn9 pressed do
	with undo on
	(
		try($.pivot = [0,0,0])catch()
	)
	on btn10 pressed do
	with undo on
	(
		try(PivotOnVertKnot())catch()
	)
	on btn11 pressed  do
	with undo on
	(
		try($.pivot.z = 0)catch()
	)
	on btn12 pressed  do
	(
		with undo on
		(
			try
			(
				source = $
				destination = pickobject()
				source.pos = (destination as object) .pivot
			)catch()
		)
	)
	on PivotPosRollout moved pos do
	(
		setIniSetting DialogIniFile "PivotPosRollout" "Position" (pos as string)
	)
)

DialogPos = execute (getIniSetting DialogIniFile "PivotPosRollout" "Position")
if DialogPos == OK then DialogPos = [70,180]

createdialog PivotPosRollout 80 60 DialogPos.x DialogPos.y
cui.RegisterDialogBar PivotPosRollout