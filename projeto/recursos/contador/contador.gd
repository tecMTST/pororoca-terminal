extends CenterContainer

func isPlaying() -> bool:
	if self.visible:
		return true
	return false
