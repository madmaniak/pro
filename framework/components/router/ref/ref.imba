require './ref.scss'

tag ref

	prop view
	prop target
	prop go

	def setup
		@r = R

	def render
		<self.active=is_active>

	def is_active
		var view, params
		[ view, params ] = @r.split_path(link)
		view == @r:view && L.isEqual params, @r:params

	def ontap
		return if is_active
		@r.go link
		window.scrollTo 0, 0

	def link
		@go || url

	def url
		if @target
			var attributes = L.reduce L.concat({}, @target), do |map, el|
				map[el:type] = el:id
				map
		@r.to_path @view, L.defaults attributes || {}, @r:safe_params
