function getEdgeLength theEditablePoly iEdge =
(
	local aiEdgeVerts = polyOp.getEdgeVerts theEditablePoly iEdge

	local ap3VertPosition = for iVert in aiEdgeVerts collect
	polyOp.getVert theEditablePoly iVert

	return (distance ap3VertPosition[1] ap3VertPosition[2])
)

fn quad =
(
	try with undo on
	(
	v1 = #()
	v2 = 0
	v3 = #()
	v4 = #()
	v5 = #()
	
	print "start quad"
	obj = $
	convertTo obj PolyMeshObject
	
	--elenco di tutti gli edge
	for i = 1 to (polyop.getNumEdges obj) do
	(
		append v1 i
	)
	
	for i in v1 do
	(
		--tutte le faccie che toccano un edge
		v2 = polyop.getEdgeFaces obj i
		if v2.count == 2 then
		(
			--tutte gli edge di quella faccia
			v3 = polyop.getFaceEdges obj v2[1]
			v4 = polyop.getFaceEdges obj v2[2]
			if (v3.count == 3) and (v4.count == 3) then
			(
				success = true
				for k in v3 do
				(
					if ( getEdgeLength obj k )>(getEdgeLength obj i) then
						success=false
				)
				
				for k in v4 do
				(
					if ( getEdgeLength obj k )>(getEdgeLength obj i) then
						success=false
				)
				
				if(success) then
					appendIfUnique v5 i
			)
		)
	)
	
	obj.EditablePoly.SetSelection #Edge (v5 as bitArray)
	obj.EditablePoly.Remove selLevel:#Edge
	)catch()
	print "done"
)

quad()