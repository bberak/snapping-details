# Set background
bg = new BackgroundLayer backgroundColor: "#877DD7"

# Create ScrollComponent
scroll = new ScrollComponent
	width: bg.width
	height: bg.height
	scrollHorizontal: false
	
class Details extends Layer
	constructor: ({x, y, width, height, scroll, h1, h3, image, borderRadius}) ->
		super
			x: x
			y: y
			parent: scroll.content
			width: width
			height: height
			backgroundColor: "white"
			borderRadius: borderRadius
			clip: true
			
		@open = false
		@originalX = x
		@originalY = y
		@originalWidth = width
		@originalHeight = height
		@parentScroll = scroll
		@h1 = h1
		@h3 = h3		
				
		@picLayer = new Layer
			parent: this
			width: @parentScroll.width
			height: @parentScroll.height
			image: image
		
		titleHtml = """
			<h3 style='font: bold 30px/42px Helvetica Neue'>Five Oaks</h3><h1 style='font: 300 52px/62px Helvetica Neue'>2007 Cabernet Sauvignon</h1>
		"""
		
		@titleLayer = new Layer
			parent: @picLayer
			y: height - 120
			x: 0
			width: @picLayer.width
			html: titleHtml
			backgroundColor: "transparent"
			style:
				paddingLeft: "20px"
							
		@picLayer.onClick this.toggle.bind(this)
		
	createInfoLayer: () ->
		infoLayerHtml = """
			<h3 style='padding: 0px 0px 0px 10px;font: bold 30px/42px Helvetica Neue; color: #555'>Description</h3>
			<p style='text-align: justify; padding: 30px 10px 0px 10px; font: normal 30px/42px Helvetica Neue; color: #777'>The wine has a complex fragrant dark fruit nose of ripe blackcurrants, blackberries and black plums, with hints of spice, which is replicated on the concentrated palate.</p>
			<p style='text-align: justify; padding: 30px 10px 0px 10px; font: normal 30px/42px Helvetica Neue; color: #777'>Fine-grained grape tannins balance the rich flavours and seamlessly integrated elegant French oak tannins, giving the wine a smooth long finish.</p>
			"""	
		infoLayer = new Layer
			parent: @parentScroll.content
			width: @parentScroll.width
			height: @parentScroll.height
			y: @parentScroll.scrollY + @parentScroll.height
			backgroundColor: "#FFF"
			html: infoLayerHtml
			style:
				paddingTop: "20px"
				paddingLeft: "20px"
				paddingRight: "20px"
					
		return infoLayer
				
	toggle: () ->
		@open = not @open
		if @open
			@parentScroll.scrollVertical = false
			this.bringToFront()
			this.animate
				properties:
					height: @parentScroll.height * 0.7
					width: @parentScroll.width
					x: @parentScroll.scrollX
					y: @parentScroll.scrollY
				curve: "spring-rk4"
				curveOptions:
					tension:  200, friction: 25, velocity: 10
			
			@titleLayer.animate
				properties:
					y: (@parentScroll.height * 0.7) - 120
					opacity: 1
				curve: "spring-rk4"
				curveOptions:
					tension:  200, friction: 25, velocity: 10
			
			@infoLayer = this.createInfoLayer()
			@infoLayer.onClick () -> 42
		
			@infoLayer.animate
				properties:
					y: @parentScroll.scrollY + (@parentScroll.height * 0.7)
					opacity: 1
				curve: "spring-rk4"
				curveOptions:
					tension:  200, friction: 25, velocity: 10
		else
			@parentScroll.scrollVertical = true
			this.animate
				properties:
					height: @originalHeight
					width: @originalWidth
					x: @originalX
					y: @originalY
				curve: "spring-rk4"
				curveOptions:
					tension:  200, friction: 25, velocity: 10
			
			@titleLayer.animate
				properties:
					y: @originalHeight - 120
					opacity: 1
				curve: "spring-rk4"
				curveOptions:
					tension:  200, friction: 25, velocity: 10
			
			@infoLayer.animate
				properties:
					y: @parentScroll.scrollY + @parentScroll.height
				curve: "spring-rk4"
				curveOptions:
					tension:  200, friction: 25, velocity: 10
					
			@infoLayer.onAnimationEnd (event, layer) ->
				layer.destroy()
			
# Create 10 detail items
for i in [0..10]
	details = new Details
		width: scroll.width - 40
		height: 280
		x: 20
		y: 300 * i 
		scroll: scroll
		h3: "Five Oaks"
		h1: "2007 Cabernet Sauvignon"
		image: "http://placekitten.com/g/#{scroll.width}/#{scroll.height}"
		borderRadius: 0