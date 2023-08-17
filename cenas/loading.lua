local composer = require('composer')

local cena = composer.newScene()

function cena:create( event )
	local grupoLoading = self.view

	local fonte = native.newFont( 'recursos/fontes/fonte1.ttf' )

	local x, y = display.contentWidth, display.contentHeight
	local t = x + y / 2


	local fundo = display.newImageRect(grupoLoading, 'recursos/imagens/fazenda.jpg', x*1.5, y )
	fundo.x = x*0.5
	fundo.y = y*0.5

	local sombra = display.newRect(grupoLoading, x*0.5, y*0.5, x, y )
	sombra:setFillColor( 0,0,0 )
	sombra.alpha = 0.8

	local logo = display.newImageRect(grupoLoading, 'recursos/imagens/CPDI.png', t*0.45, t*0.45 )
	logo.x = x*0.5
	logo.y = y*0.4

	local barraFundo = display.newRoundedRect( grupoLoading, x*0.5, y*0.8, x*0.9, y*0.05, t*0.1)

	local barra = display.newRoundedRect( grupoLoading, x*0.5, y*0.8, 0, y*0.035, t*0.1)
	barra:setFillColor( 0,0.7,0  )

	function carregamento()
		local aleatorio = math.random( 4000, 8000 )
		transition.to( barra, {time = aleatorio, width = x*0.85, onComplete = function()
			composer.gotoScene( 'cenas.iniciar', {time = 300, effect = 'fade'} )
		end} )
	end
	carregamento()

end
cena:addEventListener( 'create', cena )
return cena