try with undo on
(
	CenterPivot $
	move selection -selection.center
	$.pivot = selection.center
	$.pivot.z = selection.min.z
	move selection [0,0,-selection.min.z]
)
catch
()
