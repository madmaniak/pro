require './ref.scss'

tag ref

	prop view
	prop target
	prop go

	def render
		<self.active=is_active>

	def is_active
		var view, params
		[ view, params ] = Router.split_path(link)
		view == Router:view && L.isEqual params, Router:params

	def ontap
		return if is_active
		Router.go link

	def link
		@go || Router.url @view, @target
