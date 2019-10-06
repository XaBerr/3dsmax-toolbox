/*globali*/
epsilon
obj
nVerticiMax

/*prototipi*/
acid
flux
termit
flux_rimuoviVerticiNeiBordi
flux_puntiAdiacenti
flux_distanzaPuntoPiano
flux_rimuoviPunti

/*strutture*/
struct punto
(
	x=0,
	y=0,
	z=0
)

struct piano
(
	a = punto(),
	b = punto(),
	c = punto()
)

/*inizializzazioni*/

/*rollout*/
try(
cui.unregisterdialogbar DownSampling
destroyDialog DownSampling)catch()
global DialogIniFile = ((getDir #scripts) + "\\P3DS\\config.ini")
rollout DownSampling "P3DStudio" width:108 height:87
(
	button btn1 "Flux" pos:[56,3] width:45 height:16
	edittext edt1 "" pos:[5,3] width:44 height:16
	progressBar pb1 "ProgressBar" pos:[1,21] width:106 height:8 color:(color 0 0 255)
	button btn2 "Termit" pos:[56,31] width:45 height:16
	edittext edt2 "" pos:[5,31] width:44 height:16
	progressBar pb2 "ProgressBar" pos:[1,49] width:106 height:8 color:(color 255 0 0)
	button btn3 "Acid" pos:[57,60] width:45 height:16
	edittext edt3 "" pos:[6,60] width:44 height:16
	progressBar pb3 "ProgressBar" pos:[2,78] width:106 height:8 color:(color 0 255 0)
	on DownSampling open do
	(
		edt1.text = "0.1"
		edt2.text = "0.1"
		edt3.text = "0.1"
	)
	on DownSampling moved pos do
	(
		setIniSetting DialogIniFile "DownSampling" "Position" (pos as string)
	)
	on btn1 pressed do with undo on--flux
		(
			try(
			epsilon = edt1.text as float
			epsilon/=1000
			obj = $
			convertTo obj PolyMeshObject
			nVerticiMax = obj.mesh.verts.count
			disablesceneredraw()
			DownSampling.pb1.value = 0
			begin = timestamp()
			flux ()
			end = timestamp()
			enablesceneredraw()
			print ((-begin+end )as string)
			DownSampling.pb1.value = 100
			)catch()
		)
	on btn2 pressed do with undo on--termit
		(
			try(
			epsilon = edt2.text as float
			epsilon/=1000
			obj = $
			convertTo obj PolyMeshObject
			disablesceneredraw()
			DownSampling.pb2.value = 0
			begin = timestamp()
			axa ()
			end = timestamp()
			enablesceneredraw()
			print ((-begin+end )as string)
			DownSampling.pb2.value = 100
			)catch()
		)
	on btn3 pressed do with undo on--acid
		(
			try(
			epsilon = edt3.text as float
			epsilon/=1000
			obj = $
			convertTo obj PolyMeshObject
			nVerticiMax = obj.mesh.verts.count
			disablesceneredraw()
			DownSampling.pb3.value = 0
			begin = timestamp()
			acid 0
			end = timestamp()
			enablesceneredraw()
			print ((-begin+end )as string)
			DownSampling.pb3.value = 100
			)catch()
		)
)

DialogPos = execute (getIniSetting DialogIniFile "DownSampling" "Position")
if DialogPos == OK then DialogPos = [70,180]

createDialog DownSampling 108 87 DialogPos.x DialogPos.y
cui.RegisterDialogBar DownSampling

/*function*/
fn flux =
(
	try(
		verticiGrezzi = #()
		puntiDaRimuovere = #()
		for i = 1 to nVerticiMax do append verticiGrezzi true
		verticiGrezzi =  rimuoviVerticiNeiBordi verticiGrezzi
		for i = 1 to nVerticiMax do
		(
			percentuale =  (100.0 * i) / (1.0 * nVerticiMax)
			DownSampling.pb1.value = percentuale
			if(verticiGrezzi[i])then
			(
				v4 = puntiAdiacenti i
				if v4.count == 1 then ()
				else if v4.count == 2 then
				(
				)
				else if v4.count >= 2 then
				(
					punto1 = punto()
					piano1 = piano()
					punto1 = polyOp.getVert obj i
					piano1.a = polyOp.getVert obj v4[1]
					piano1.b = polyOp.getVert obj v4[2]
					piano1.c = polyOp.getVert obj v4[3]
					
					ha = distanzaPuntoPiano punto1 piano1
					
					if(ha <= epsilon)then
					if v4.count ==3 then
					(
						append puntiDaRimuovere i
						for k in v4 do
							verticiGrezzi[k] = false
					)
					else
					(
						success = true
						for j = 4 to v4.count do
						(
							punto2 = polyOp.getVert $ v4[j]
							ha = distanzaPuntoPiano punto2 piano1
							if ha > epsilon then
								success = false
						)
						if success then
						(
							append puntiDaRimuovere i
							for k in v4 do
								verticiGrezzi[k] = false
						)
					)
				)
				else(print "error")
			)
		)
		rimuoviPunti puntiDaRimuovere
		print ("punti rimossi: "+puntiDaRimuovere.count as string)
	)catch( print ("Error flux: "+getCurrentException()) )
)

fn flux_rimuoviVerticiNeiBordi vertici=
(
	v0=#()
	try(
	v1 = polyOp.getOpenEdges obj
	v2 = polyop.getVertsUsingEdge obj ( v1 as bitArray )
	v3 = vertici
	for i in v2 do
		vertici[i] = false
	v0 = vertici
	)catch( print ("Error rimuoviVerticiNeiBordi: "+getCurrentException()) )
	return v0
)

fn flux_puntiAdiacenti vertice =
(
	v0=#()
	try(
	v1 = polyop.getFacesUsingVert obj (#(vertice) as bitarray)
	for i in v1 do
	(
		v2 = (polyop.getFaceVerts obj i)
		for j in v2 do
			if j != vertice then
				append v0 j
		
	)
	)catch( print ("Error puntiAdiacenti: "+getCurrentException()) )
	return v0
)

fn flux_distanzaPuntoPiano punto0 piano0 =
(
	dist = 0
	try(
	pntx = ((piano0.c.y - piano0.a.y)*(piano0.b.z-piano0.a.z))-((piano0.b.y - piano0.a.y)*(piano0.c.z-piano0.a.z))
	pnty = ((piano0.c.z - piano0.a.z)*(piano0.b.x-piano0.a.x))-((piano0.b.z - piano0.a.z)*(piano0.c.x-piano0.a.x))
	pntz = ((piano0.c.x - piano0.a.x)*(piano0.b.y-piano0.a.y))-((piano0.b.x - piano0.a.x)*(piano0.c.y-piano0.a.y))
	pntw= (((-piano0.a.x)*(piano0.c.y - piano0.a.y)*(piano0.b.z-piano0.a.z))-((-piano0.a.x)*(piano0.b.y - piano0.a.y)*(piano0.c.z-piano0.a.z)) + ((-piano0.a.y)*(piano0.c.z - piano0.a.z)*(piano0.b.x-piano0.a.x))-((-piano0.a.y)*(piano0.b.z - piano0.a.z)*(piano0.c.x-piano0.a.x)) + ((-piano0.a.z)*(piano0.c.x - piano0.a.x)*(piano0.b.y-piano0.a.y))-((-piano0.a.z)*(piano0.b.x - piano0.a.x)*(piano0.c.y-piano0.a.y)))
	
	ga = punto0.x*pntx + punto0.y*pnty + punto0.z*pntz + pntw
	qa = sqrt (pntx*pntx + pnty*pnty + pntz*pntz) 
	ha = ga/qa
	ha = abs ha
	dist = ha
	)catch( print ("Error distanzaPuntoPiano: "+getCurrentException()) )
	return dist
)

fn flux_rimuoviPunti vertici=
(
	try(
	$.EditablePoly.SetSelection #Vertex (vertici as bitArray)
	$.EditablePoly.Remove selLevel:#Vertex
	)catch( print ("Error rimuoviPunto: "+getCurrentException()) )
)

fn termit =
(
	try
	(
		v1 = #()
		v2 = #()
		v3 = #()
		v4 = #()
		v5 = #()
		v6 = #()
		e1 = #()
		e2 = #()
		e3 = 0
		
		convertTo obj PolyMeshObject
		
		check = true
		
		while (check) do
		(
			check = false
			
			v1 = polyOp.getOpenEdges obj
			v2 = polyop.getVertsUsingEdge obj v1
			v3 = obj.mesh.verts as bitarray
			
			for i in v2 do
			(
				j = (findItem v3 i)
				if j != 0
				then (deleteItem v3 j)
			)
			
			
			for i in v3 do
			(
				e1 = polyop.getFacesUsingVert obj i
				v4=#()
				for j in e1 do
				(
					e2 = (polyop.getFaceVerts obj j)
					for k in e2 do
					(
						if (k!=i)
							then ( append v4 k )
					)
				)
				e3 = polyOp.getVert obj i
				if v4.count <=2 then
				(
				)
				else
				(
					
					xa = (polyOp.getVert $ v4[1])
					xb = (polyOp.getVert $ v4[2])
					xc = (polyOp.getVert $ v4[3])
					
					x1 = xa.x
					y1 = xa.y
					z1 = xa.z
					x2 = xb.x
					y2 = xb.y
					z2 = xb.z
					x3 = xc.x
					y3 = xc.y
					z3 = xc.z
					pntx= ((y3 - y1)*(z2-z1))-((y2 - y1)*(z3-z1))
					pnty= ((z3 - z1)*(x2-x1))-((z2 - z1)*(x3-x1))
					pntz= ((x3 - x1)*(y2-y1))-((x2 - x1)*(y3-y1))
					pntw= (((-x1)*(y3 - y1)*(z2-z1))-((-x1)*(y2 - y1)*(z3-z1)) + ((-y1)*(z3 - z1)*(x2-x1))-((-y1)*(z2 - z1)*(x3-x1)) + ((-z1)*(x3 - x1)*(y2-y1))-((-z1)*(x2 - x1)*(y3-y1)))
					
					ga = e3.x*pntx + e3.y*pnty + e3.z*pntz + pntw
					qa = sqrt (pntx*pntx + pnty*pnty + pntz*pntz) 
					ha = ga/qa
					if((abs ha) <= epsilon)then
					if v4.count ==3 then
					(
						append v5 i
					)
					else
					(
						success = true
						for j = 4 to v4.count do
						(
							e4 = polyOp.getVert $ v4[j]
							ga = e4.x*pntx + e4.y*pnty + e4.z*pntz + pntw
							ha = ga / qa
							
							if((abs ha) > epsilon) then
								success = false
						)
						if success then
							append v5 i
					)
					
				)
			)
			
			$.EditablePoly.SetSelection #Vertex (v5 as bitArray)
			$.EditablePoly.Remove selLevel:#Vertex
		)
	)catch( print ("Error: "+getCurrentException()) )
)

fn acid index=
(
	found = true
	try(
	while(found)do
	(
		found = false
		nVerticiAttuali = obj.mesh.verts.count
		percentuale =  (100.0 *((nVerticiMax - nVerticiAttuali)+index)) / (1.0 * nVerticiMax)
		DownSampling.pb1.value = percentuale
		cont = 0
		v3 =  rimuoviVerticiNeiBordi (obj.mesh.verts as bitarray)
		
		for i in v3 do
		(
			cont = cont + 1
			if cont >= index then
			(
				v4 = puntiAdiacenti i
				if v4.count <=2 then
				(
				)
				else
				(
					punto1 = punto()
					piano1 = piano()
					punto1 = polyOp.getVert obj i
					piano1.a = polyOp.getVert $ v4[1]
					piano1.b = polyOp.getVert $ v4[2]
					piano1.c = polyOp.getVert $ v4[3]
					
					ha = distanzaPuntoPiano punto1 piano1
					
					if(ha <= epsilon)then
					if v4.count ==3 then
					(
						rimuoviPunto i #()
						found = true
						exit
					)
					else
					(
						success = true
						for j = 4 to v4.count do
						(
							punto2 = polyOp.getVert $ v4[j]
							ha = distanzaPuntoPiano punto2 piano1
							if ha > epsilon then
								success = false
						)
						if success then
						(
							rimuoviPunto i #()
							found = true
							exit
						)
					)
				)
			)
		)
		
		if found == true then index = (cont-1)
	)
	)catch( print ("Error acid: "+getCurrentException()) )
)

fn acid_rimuoviVerticiNeiBordi vertici=
(
	v0=#()
	try(
	v1 = polyOp.getOpenEdges obj
	v2 = polyop.getVertsUsingEdge obj v1
	v3 = vertici
	for i in v2 do
	(
		j = (findItem v3 i)
		if j != 0
		then (deleteItem v3 j)
	)
	v0 = v3
	)catch( print ("Error rimuoviVerticiNeiBordi: "+getCurrentException()) )
	return v0
)

fn acid_puntiAdiacenti vertice =
(
	v0=#()
	try(
	v1 = polyop.getFacesUsingVert obj vertice
	for i in v1 do
	(
		v2 = (polyop.getFaceVerts obj i)
		for j in v2 do
			if j != vertice then
				append v0 j
		
	)
	)catch( print ("Error puntiAdiacenti: "+getCurrentException()) )
	return v0
)

fn acid_distanzaPuntoPiano punto0 piano0 =
(
	dist = 0
	try(
	pntx = ((piano0.c.y - piano0.a.y)*(piano0.b.z-piano0.a.z))-((piano0.b.y - piano0.a.y)*(piano0.c.z-piano0.a.z))
	pnty = ((piano0.c.z - piano0.a.z)*(piano0.b.x-piano0.a.x))-((piano0.b.z - piano0.a.z)*(piano0.c.x-piano0.a.x))
	pntz = ((piano0.c.x - piano0.a.x)*(piano0.b.y-piano0.a.y))-((piano0.b.x - piano0.a.x)*(piano0.c.y-piano0.a.y))
	pntw= (((-piano0.a.x)*(piano0.c.y - piano0.a.y)*(piano0.b.z-piano0.a.z))-((-piano0.a.x)*(piano0.b.y - piano0.a.y)*(piano0.c.z-piano0.a.z)) + ((-piano0.a.y)*(piano0.c.z - piano0.a.z)*(piano0.b.x-piano0.a.x))-((-piano0.a.y)*(piano0.b.z - piano0.a.z)*(piano0.c.x-piano0.a.x)) + ((-piano0.a.z)*(piano0.c.x - piano0.a.x)*(piano0.b.y-piano0.a.y))-((-piano0.a.z)*(piano0.b.x - piano0.a.x)*(piano0.c.y-piano0.a.y)))
	
	ga = punto0.x*pntx + punto0.y*pnty + punto0.z*pntz + pntw
	qa = sqrt (pntx*pntx + pnty*pnty + pntz*pntz) 
	ha = ga/qa
	ha = abs ha
	dist = ha
	)catch( print ("Error distanzaPuntoPiano: "+getCurrentException()) )
	return dist
)

fn acid_rimuoviPunto vertice verticiVicini=
(
	try(
	$.EditablePoly.SetSelection #Vertex (#(vertice) as bitArray)
	$.EditablePoly.Remove selLevel:#Vertex
	)catch( print ("Error rimuoviPunto: "+getCurrentException()) )
)
