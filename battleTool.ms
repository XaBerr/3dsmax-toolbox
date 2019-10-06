try(
cui.unregisterdialogbar BattleTool
destroyDialog BattleTool)catch()
global DialogIniFile = ((getDir #scripts) + "\\P3DS\\config.ini")

fn RotatePivotOnly obj rotation= (local rotValInv = inverse (rotation as quat)
	animate on in coordsys local
	obj.rotation*=RotValInv
	obj.objectoffsetpos*=RotValInv
	obj.objectoffsetrot*=RotValInv
	)

rollout BattleTool "P3DStudio" width:140 height:84
(
	button btn1 "C" pos:[0,60] width:35 height:20 tooltip:"Put object in the center the world"
	button btn2 "CPC" pos:[35,60] width:24 height:20 tooltip:"Put object in the center the world\n and pivot in the center of bounding box"
	button btn3 "CPB" pos:[60,60] width:24 height:20 tooltip:"Put object in the center the world\n and pivot in the bottom of bounding box"
	button btn4 "-R" pos:[0,20] width:35 height:20 tooltip:"Rotate object,  around pivot, respect axe (x,y,z) by selected value\n if (v) is selected instance new object"
	button btn5 "+R" pos:[35,20] width:35 height:20 tooltip:"Rotate object,  around pivot, respect axe (x,y,z) by selected value\n if (v) is selected instance new object"
	button btn6 "db" pos:[0,40] width:35 height:20 tooltip:"Mirror respect axe (x,y,z)\n if (v) is selected instance new object "
		
	checkbox chk1 "x" pos:[66,0] width:10 height:20 
	checkbox chk2 "y" pos:[96,0] width:10 height:20
	checkbox chk3 "z" pos:[125,0] width:10 height:20 checked:true
 
 
	
	button btn7 "ExS" pos:[84,60] width:28 height:20 tooltip:"export selected to fbx\n../Documents/3dsMax/export/battleTool.fbx"
	button btn8 "Exp" pos:[112,60] width:28 height:20 tooltip:"export all to fbx\n../Documents/3dsMax/export/battleTool.fbx"
	
	checkbox chk4 "" pos:[39,44] width:13 height:13
	label lbl2 "y" pos:[84,1] width:10 height:20
	label lbl3 "z" pos:[114,1] width:10 height:20
	button btn9 "Y-up" pos:[70,40] width:35 height:20 tooltip:"Move axe y up"
	button btn10 "Z-up" pos:[105,40] width:35 height:20 tooltip:"Move axe z up"
	spinner spn1 "" pos:[-1,1] width:50 height:16 range:[0,1000,10]
	button btn11 "-M" pos:[70,20] width:35 height:20 tooltip:"Move object respect axe (x,y,z) by selected value\n if (v) is selected instance new object\n Work with subobject in editable poly"
	button btn12 "+M" pos:[105,20] width:35 height:20 tooltip:"Move object respect axe (x,y,z) by selected value\n if (v) is selected instance new object\n Work with subobject in editable poly"
	label lbl7 "x" pos:[54,1] width:10 height:20
	label lbl8 "v" pos:[57,43] width:13 height:13
	
	

	
	on btn1 pressed do with undo on
	(
		try
		(
			if chk4.checked do
			(
				maxOps.cloneNodes $ cloneType:#instance newNodes:&nnl
				select nnl
			)
			move selection -selection.center
			move selection [0,0,-selection.min.z]
		)catch()
	)
	on btn2 pressed do with undo on
	(
		try
		(
			if chk4.checked do
			(
				maxOps.cloneNodes $ cloneType:#instance newNodes:&nnl
				select nnl
			)
		
			move selection -selection.center
			move selection [0,0,-selection.min.z]
			CenterPivot selection
		)catch()
	)
	on btn3 pressed do with undo on
	(
		try
		(
			CenterPivot selection
			move selection -selection.center
			$.pivot = selection.center
			$.pivot.z = selection.min.z
			move selection [0,0,-selection.min.z]
		)catch()
	)
	on btn4 pressed do with undo on
	(
		try
		(
			if chk4.checked do
			(
				maxOps.cloneNodes $ cloneType:#instance newNodes:&nnl
				select nnl
			)
			
			if chk1.checked do
				rotate selection (angleaxis (spn1.value as float) [1,0,0])
			if chk2.checked do
				rotate selection (angleaxis (spn1.value as float) [0,1,0])
			if chk3.checked do
				rotate selection (angleaxis (spn1.value as float) [0,0,1])
		)catch()
	)
	on btn5 pressed do with undo on
	(
		try
		(
			if chk4.checked do
			(
				maxOps.cloneNodes $ cloneType:#instance newNodes:&nnl
				select nnl
			)
		
			if chk1.checked do
				rotate selection (angleaxis -(spn1.value as float) [1,0,0])
			if chk2.checked do
				rotate selection (angleaxis -(spn1.value as float) [0,1,0])
			if chk3.checked do
				rotate selection (angleaxis -(spn1.value as float) [0,0,1])
			
		)catch()
	)
	on btn6 pressed do with undo on
	(
		
		if chk4.checked do
		(
			maxOps.cloneNodes $ cloneType:#instance newNodes:&nnl
			select nnl
		)
		
		if chk1.checked do
			for i in $ do
				i.transform=(scaleMatrix [-1,1,1])*i.transform
		if chk2.checked do
			for i in $ do
				i.transform=(scaleMatrix [1,-1,1])*i.transform
		if chk3.checked do
			for i in $ do
				i.transform=(scaleMatrix [1,1,-1])*i.transform
		
	)
	on btn7 pressed do with undo on
	(
		try
		(
			if selection.count != 0 then
			(
				theClasses = exporterPlugin.classes
				_objIdx = findItem theClasses ObjExp
				exportFile (GetDir #export + "/battleTool" ) #noPrompt selectedOnly:on --using:theClasses[_objIdx]
				
			)
		)catch()
	)
	on btn8 pressed do with undo on
	(
		try
		(
			theClasses = exporterPlugin.classes
			_objIdx = findItem theClasses ObjExp
			exportFile (GetDir #export + "/battleTool" ) #noPrompt selectedOnly:off --using:theClasses[_objIdx]
		)catch()
	)
	on btn9 pressed do with undo on
	(
		try
		(
			WorldAlignPivot $
			RotatePivotOnly $ (EulerAngles 90 0 0)
		)catch()
	)
	on btn10 pressed do with undo on
	(
		try
		(
			WorldAlignPivot $
		)catch()
	)
	on btn11 pressed do with undo on
	(
		try
		(
			
			if(getselectionlevel $ == #vertex)then
			(
				if chk1.checked do
					move $.selectedVerts [-1 * (spn1.value as float),0,0]
				if chk2.checked do
					move $.selectedVerts [0,-1 * (spn1.value as float),0]
				if chk3.checked do
					move $.selectedVerts [0,0,-1 * (spn1.value as float)]
			)
			
			if(getselectionlevel $ == #edge)then
			(
				if chk1.checked do
					move $.selectedEdges [-1 * (spn1.value as float),0,0]
				if chk2.checked do
					move $.selectedEdges [0,-1 * (spn1.value as float),0]
				if chk3.checked do
					move $.selectedEdges [0,0,-1 * (spn1.value as float)]
			)
			
			if(getselectionlevel $ == #face)then
			(
				if chk1.checked do
					move $.selectedFaces [-1 * (spn1.value as float),0,0]
				if chk2.checked do
					move $.selectedFaces [0,-1 * (spn1.value as float),0]
				if chk3.checked do
					move $.selectedFaces [0,0,-1 * (spn1.value as float)]
			)
			
			if(getselectionlevel $ == #object)then
			(
				if chk4.checked do
				(
					maxOps.cloneNodes $ cloneType:#instance newNodes:&nnl
					select nnl
				)
				if chk1.checked do
					move selection [-1 * (spn1.value as float),0,0]
				if chk2.checked do
					move selection [0,-1 * (spn1.value as float),0]
				if chk3.checked do
					move selection [0,0,-1 * (spn1.value as float)]
			)
			
		)catch()
	)
	on btn12 pressed do with undo on
	(
		try
		(
				if(getselectionlevel $ == #vertex)then
				(
					if chk1.checked do
						move $.selectedVerts [1 * (spn1.value as float),0,0]
					if chk2.checked do
						move $.selectedVerts [0,1 * (spn1.value as float),0]
					if chk3.checked do
						move $.selectedVerts [0,0,1 * (spn1.value as float)]
				)
				
				if(getselectionlevel $ == #edge)then
				(
					if chk1.checked do
						move $.selectedEdges [1 * (spn1.value as float),0,0]
					if chk2.checked do
						move $.selectedEdges [0,1 * (spn1.value as float),0]
					if chk3.checked do
						move $.selectedEdges [0,0,1 * (spn1.value as float)]
				)
				
				if(getselectionlevel $ == #face)then
				(
					if chk1.checked do
						move $.selectedFaces [1 * (spn1.value as float),0,0]
					if chk2.checked do
						move $.selectedFaces [0,1 * (spn1.value as float),0]
					if chk3.checked do
						move $.selectedFaces [0,0,1 * (spn1.value as float)]
				)
				
				if(getselectionlevel $ == #object)then
				(
					if chk4.checked do
					(
						maxOps.cloneNodes $ cloneType:#instance newNodes:&nnl
						select nnl
					)
					if chk1.checked do
						move selection [1 * (spn1.value as float),0,0]
					if chk2.checked do
						move selection [0,1 * (spn1.value as float),0]
					if chk3.checked do
						move selection [0,0,1 * (spn1.value as float)]
				)
		)catch()
	)
	on BattleTool moved pos do
	(
		setIniSetting DialogIniFile "BattleTool" "Position" (pos as string)
	)
)

DialogPos = execute (getIniSetting DialogIniFile "BattleTool" "Position")
if DialogPos == OK then DialogPos = [70,180]

createdialog BattleTool 140  84 DialogPos.x DialogPos.y
cui.RegisterDialogBar BattleTool

/*
	--ConvertTo $ Editable_Poly
				ver = polyOp.getVertSelection $
				edg = polyOp.getEdgeSelection $
				fac = polyOp.getFaceSelection $
				print ver
				print edg
				print fac
				
				if(vert != #{})then
				(
					if chk1.checked do
						rotate $.selectedVerts (angleaxis -(spn1.value as float) [1,0,0])
					if chk2.checked do
						rotate $.selectedVerts (angleaxis -(spn1.value as float) [0,1,0])
					if chk3.checked do
						rotate $.selectedVerts (angleaxis -(spn1.value as float) [0,0,1])
				)
				
				if(edg != #{})then
				(
					if chk1.checked do
						rotate $.selectedEdges (angleaxis -(spn1.value as float) [1,0,0])
					if chk2.checked do
						rotate $.selectedEdges (angleaxis -(spn1.value as float) [0,1,0])
					if chk3.checked do
						rotate $.selectedEdges (angleaxis -(spn1.value as float) [0,0,1])
				)
				
				if(fac != #{})then
				(
					if chk1.checked do
						rotate $.selectedFaces (angleaxis -(spn1.value as float) [1,0,0])
					if chk2.checked do
						rotate $.selectedFaces (angleaxis -(spn1.value as float) [0,1,0])
					if chk3.checked do
						rotate $.selectedFaces (angleaxis -(spn1.value as float) [0,0,1])
				)
				
				if(vert == #{} and edg == #{} and fac == #{})then
				(
					print 1
					if chk4.checked do
					(
						maxOps.cloneNodes $ cloneType:#instance newNodes:&nnl
						select nnl
					)
					
					if chk1.checked do
						rotate selection (angleaxis -(spn1.value as float) [1,0,0])
					if chk2.checked do
						rotate selection (angleaxis -(spn1.value as float) [0,1,0])
					if chk3.checked do
						rotate selection (angleaxis -(spn1.value as float) [0,0,1])
				)

*/