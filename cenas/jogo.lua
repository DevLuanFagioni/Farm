
local composer = require('composer')

local cena = composer.newScene()

function cena:create( event )
	local grupoJogo = self.view


	-- DECLARAÇÃOS DAS VARIAVEIS PARA TRABALHAR COM POSICIONAMENTO
	local x = display.contentWidth
	local y = display.contentHeight
	local t = (x + y) / 2

	-- DECLARAÇÃO DOS AUDIOS
	local audioColeta = audio.loadSound('recursos/audio/coleta.mp3')
	local audioTransicao = audio.loadSound('recursos/audio/transicao.mp3')
	local audioMorte = audio.loadSound('recursos/audio/morte.mp3')

	

	-- DECLARAÇÃO DA FONTE
	local fonte = native.newFont( 'recursos/fontes/fonte1.ttf' )

	-- DECLARAÇÃO DOS GRUPOS
	local jogo = display.newGroup()
	local GUI = display.newGroup()

	grupoJogo:insert( jogo )
	grupoJogo:insert( GUI )



	-- DECLARAÇÃO DA FISICA
	local physics = require('physics')
	physics.setDrawMode( 'normal' )
	physics.start()
	physics.setGravity( 0, 0 )


	-- DECLARACAO DAS VARIAVEIS
	local vidas = 3

	local pontos = 0

	local listaFrutas = {}

	local listaObstaculos = {}

	local vivo = true


	-- DECLARAÇÃO DE OBJETOS
	local fundo = display.newImageRect(jogo, 'recursos/imagens/fazenda.jpg', x*2, y )
	fundo.x = x*0.5
	fundo.y = y*0.5

	local jogador = display.newImageRect(jogo, 'recursos/imagens/jogador.png', t*0.5, t*0.5)
	jogador.x = x*0.5
	jogador.y = y*0.82
	physics.addBody(jogador, 'static', {radius = t*0.1})
	jogador.id = 'jogadorID'

	local fundoVidas = display.newImageRect(GUI, 'recursos/imagens/barra.png', x*0.45, y*0.05 )
	fundoVidas.x = x*0.1
	fundoVidas.y = y*0.08

	local logo = display.newImageRect(GUI, 'recursos/imagens/CPDI.png', t*0.25, t*0.25 )
	logo.x = x*0.75
	logo.y = y*0.12

	local iconeVida1 = display.newImageRect(GUI, 'recursos/imagens/vida-cheia.png', t*0.05, t*0.05 ) 
	iconeVida1.x = x*0.06
	iconeVida1.y = fundoVidas.y

	local iconeVida2 = display.newImageRect(GUI, 'recursos/imagens/vida-cheia.png', t*0.05, t*0.05 ) 
	iconeVida2.x = x*0.15
	iconeVida2.y = fundoVidas.y

	local iconeVida3 = display.newImageRect(GUI, 'recursos/imagens/vida-cheia.png', t*0.05, t*0.05 ) 
	iconeVida3.x = x*0.24
	iconeVida3.y = fundoVidas.y

	local fundoPontos = display.newImageRect(GUI, 'recursos/imagens/barra.png', x*0.45, y*0.05 )
	fundoPontos.x = x*0.1
	fundoPontos.y = y*0.14

	local textoPontos = display.newText(GUI, pontos, fundoPontos.x*1.45, fundoPontos.y, fonte, t*0.05 )

	local sombra = display.newRect(GUI, x*0.5, y*0.5, x, y )
	sombra:setFillColor( 0,0,0 )
	sombra.alpha = 0

	-- DECLARAÇÃO DE FUNCOES


	function atualizaPontos()
		pontos = pontos + 1
		textoPontos.text = pontos
	end
	

	function verificaVida()
		if (vidas == 0) then
			iconeVida1.alpha = 0
			iconeVida2.alpha = 0
			iconeVida3.alpha = 0

			vivo = false
			sombra.alpha = 0.7
			local perdeu = display.newText(GUI, 'VOCE PERDEU', x*0.5, y*0.5, fonte, t*0.08)
			perdeu:setFillColor( 1,0,0 )

			
			function recomecar()
				os.exit()
			end
	
			timer.performWithDelay( 2000, reiniciarJogo, 1 )


		elseif (vidas == 1) then
			iconeVida1.alpha = 1
			iconeVida2.alpha = 0
			iconeVida3.alpha = 0

		elseif (vidas == 2) then
			iconeVida1.alpha = 1
			iconeVida2.alpha = 1
			iconeVida3.alpha = 0

		elseif (vidas == 3) then
			iconeVida1.alpha = 1
			iconeVida2.alpha = 1
			iconeVida3.alpha = 1

		end

	end
	Runtime:addEventListener( 'enterFrame', verificaVida )




	local isDragging = false -- Variável para rastrear se o personagem está sendo arrastado

	function dragPersonagem(event)
	    local phase = event.phase

	    if (phase == "began") then
	        -- Verifica se o toque começou dentro do personagem
	        if (event.target == jogador) then
	            display.getCurrentStage():setFocus(jogador) -- Captura o foco do toque
	            jogador.isFocus = true
	            isDragging = true
	        end
	    elseif (jogador.isFocus) then
	        if (phase == "moved") then
	        
	        		jogador.x = event.x

	        elseif (phase == "ended" or phase == "cancelled") then
	            display.getCurrentStage():setFocus(nil) -- Libera o foco do toque
	            jogador.isFocus = false
	            isDragging = false
	        end
	    end

	    -- Impede o evento de propagação para outros objetos
	    return true
	end
	jogador:addEventListener("touch", dragPersonagem)



	function criaFrutas()
		if (vivo == true) then
			local frutas = {
			'recursos/imagens/frutas/lime.png',
			'recursos/imagens/frutas/banana.png',
			'recursos/imagens/frutas/coconut.png',
			'recursos/imagens/frutas/lemon.png',
			'recursos/imagens/frutas/orange.png',
			'recursos/imagens/frutas/peach.png',
			'recursos/imagens/frutas/pear.png',
			'recursos/imagens/frutas/plum.png',
			}

			local frutaAleatorio = math.random(1,8)

			local fruta = display.newImageRect(jogo, frutas[frutaAleatorio], t*0.12, t*0.12)
			fruta.y = -y*0.2
			fruta.x = math.random( x*0.2, x*0.9 )
			table.insert( listaFrutas, fruta )
			physics.addBody( fruta, 'dynamic' )
			fruta.id = 'frutaID'

			transition.to(fruta, {
				time = 2000,
				y = y*1.2,
				onComplete = function()
					display.remove( fruta )
				end
			})

			
		end
	end
	timer.performWithDelay( 1500, criaFrutas, 0 )



	function criaObstaculo()
		if (vivo == true) then
			local obstaculos = {
			'recursos/imagens/obstaculo.png',
			}

			local obstaculoAleatorio = 1

			local obstaculo = display.newImageRect(jogo, obstaculos[obstaculoAleatorio], t*0.12, t*0.12)
			obstaculo.y = -y*0.2
			obstaculo.x = math.random( x*0.2, x*0.9 )
			table.insert( listaObstaculos, obstaculo )
			physics.addBody( obstaculo, 'dynamic' )
			obstaculo.id = 'obstaculoID'

			transition.to(obstaculo, {
				time = 2000,
				y = y*1.2,
				onComplete = function()
					display.remove( obstaculo )
				end
			})

			
		end
	end
	timer.performWithDelay( 3000, criaObstaculo, 0 )




	function verificaColisao(event)
		if (vivo == true) then
			if (event.phase == 'began') then
				if (event.object1.id == 'jogadorID' and event.object2.id == 'frutaID' or event.object2.id == 'jogadorID' and event.object1.id == 'frutaID') then

					atualizaPontos()

					local fruta
					if (event.object1.id ==  'frutaID') then
						fruta = event.object1
					else
						fruta = event.object2
					end
					audio.play( audioColeta )
					display.remove( fruta )

				end


				if (event.object1.id == 'jogadorID' and event.object2.id == 'obstaculoID' or event.object2.id == 'jogadorID' and event.object1.id == 'obstaculoID') then

					atualizaPontos()

					local obstaculo
					if (event.object1.id ==  'obstaculoID') then
						obstaculo = event.object1
					else
						obstaculo = event.object2
					end
					display.remove( obstaculo )

					vidas = vidas - 1
					audio.play( audioMorte )

					local jogador
					if (event.object1.id ==  'jogadorID') then
						jogador = event.object1
					else
						jogador = event.object2
					end
					local pisca = transition.blink( jogador, {time = 300} )
					timer.performWithDelay( 500, function()
						transition.cancel( pisca )
						jogador.alpha = 1
					end, 1)

				end
			end
		end
	end
	Runtime:addEventListener('collision', verificaColisao)

end
cena:addEventListener( 'create', cena )
return cena