require './switch.scss'

tag switch

	prop key
	prop disable

	def render
		<self.is_on=is_on .disabled=@disable>

	def is_on
		Router:params[@key]

	def ontap
		Router.toggle key unless @disable
