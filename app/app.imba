require '../framework/components/router/router_tag'
Router.init :demo

tag #app

	def render
		<self>
			<ref go='demo'> 'Sketchpad demo'
			<ref go='questions'> 'Questions'
			<ref go='404'> 'Wrong way'
			<router>
