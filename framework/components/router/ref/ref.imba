tag ref < a

	prop view
	prop target
	prop go

	attr onclick

	def setup
		@r = R

	def render
		<self.active=is_active href=link onclick='return false'>

	def is_active
		var view, params
		[ view, params ] = @r.split_path(link)
		view == @r:view && L.isEqual params, @r:params

	def ontap e
		return if is_active
		@r.go dom:href
		window.scrollTo 0, 0

	def link
		@go || url

	def url
		if @target
			var attributes = L.reduce L.concat({}, @target), do |map, el|
				map[el:type] = el:id
				map
		@r.to_path @view, L.defaults attributes || {}, @r:safe_params
