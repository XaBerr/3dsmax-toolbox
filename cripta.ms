
rollout cr "P3DS" width:143 height:52
(
	button btn25 "Cripta" pos:[38,13] width:64 height:22
	on btn25 pressed  do
	(
		d = "D:\\ALTRO\\max\\version1.0\\"
		for f in getFiles (d + "*.ms") do
		(
			print (f)
			encryptScript f
		)
	)
)

createdialog cr