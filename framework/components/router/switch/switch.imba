require './switch.scss'

tag switch

	prop key

	def render
		<self.is_on=is_on>

	def is_on
		Router:params[@key]

	def ontap
		Router.toggle key
