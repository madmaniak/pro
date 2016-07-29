global:_app = #app
global:render =
	L.throttle do
		global:_app.render
	, 17 # 60 fps
