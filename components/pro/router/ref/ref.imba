tag ref

	prop view
	prop target
	prop go

	def build
		@url =
			if @go
			then "/{@go}"
			else Router.url @view, @target
		render

	def render
		<self.active=is_active>

	def is_active
		@url == document:location:pathname

	def ontap
		return if is_active
		if @go
			Router.go "/{@go}"
		else
			Router.go Router.url @view, @target
