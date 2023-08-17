local composer = require('composer')

local cena = composer.newScene()

function cena:create( event )
	local grupoIniciar = self.view

	local x = display.contentWidth
	local y = display.contentHeight
	local t = (x + y) / 2


	local musica = audio.loadStream( 'recursos/audio/musica.mp3' )

	audio.play( musica, {channel = 32, onClomplete = function()
		audio.play( musica, {channel = 32} )
	end} )
	audio.setVolume( 0.2, {channel = 32} )

	local audioTransicao = audio.loadSound('recursos/audio/transicao.mp3')

	local fonte = native.newFont( 'recursos/fontes/fonte1.ttf' )

	local fundo = display.newImageRect(grupoIniciar, 'recursos/imagens/fazenda.jpg', x*1.5, y )
	fundo.x = x*0.5
	fundo.y = y*0.5

	local sombra = display.newRect(grupoIniciar, x*0.5, y*0.5, x, y )
	sombra:setFillColor( 0,0,0 )
	sombra.alpha = 0.8

	local toque = display.newImageRect(grupoIniciar, 'recursos/imagens/touch.png', t*0.1, t*0.1 )
	toque.x = x*0.5
	toque.y = y*0.5
	toque:setFillColor( 1, 1, 1 )

	local texto = display.newText(grupoIniciar, 'toque para jogar', x*0.5, y*0.4, fonte, t*0.05 )

	local podeTocar = false

	timer.performWithDelay( 500, function()
		podeTocar = true
	end, 1 )

	function toque(event)
		if (podeTocar == true) then
			if (event.phase == 'began') then
				composer.gotoScene( 'cenas.jogo', {time = 300, effect = 'slideLeft'} )
				audio.play( audioTransicao )
			end
		end
	end
	sombra:addEventListener( 'touch', toque )

end
cena:addEventListener( 'create', cena )
return cena











