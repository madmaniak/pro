require './ref.scss'

tag ref

	prop view
	prop target
	prop go

	def render
		<self.active=is_active>

	def is_active
		var url =
			if @go
			then "/{@go}"
			else Router.url @view, @target
		url == Router:path

	def ontap
		return if is_active
		if @go
			Router.go "/{@go}"
		else
			Router.go Router.url @view, @target
