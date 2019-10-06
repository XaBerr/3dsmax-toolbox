try  with undo on
(
	move selection -selection.center
	move selection [0,0,-selection.min.z]
)
catch
()
