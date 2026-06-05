extends ColorRect
class_name LoadingPage

var _black : Color = Color(0 , 0 , 0 , 1)
var _clear : Color = Color(0 , 0  , 0 , 0)
var _color_tween : Tween

func fade(_new_color , duration : float = 1) -> Signal:
	if _color_tween and _color_tween.is_running():
		_color_tween.kill()
	_color_tween = create_tween()
	_color_tween.tween_property(self, "color" , _new_color , duration)
	return _color_tween.finished
	
func fade_to_clear(duration : float = 1) -> Signal:
	return fade(_clear , duration)
	
func fade_to_black(duration : float = 1) -> Signal:
	return fade(_black , duration)
