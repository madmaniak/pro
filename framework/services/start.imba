var render = do this.render
global:render =	L.throttle render.bind(#app), 17 # 60 fps
