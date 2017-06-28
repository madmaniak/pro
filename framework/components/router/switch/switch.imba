require './switch.scss'

tag switch

	prop key
	prop disable

	def setup
		@r = R

	def render
		<self.is_on=is_on .disabled=@disable>

	def is_on
		@r:params[@key]

	def ontap
		@r.toggle key unless @disable
