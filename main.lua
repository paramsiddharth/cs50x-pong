WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
PADDLE_SPEED = 100

Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Pong')

    smallFont = love.graphics.newFont('font.ttf', 8)

    scoreFont = love.graphics.newFont('font.ttf', 32)

    player1score = 0
    player2score = 0

    paddle1 = Paddle(10, 30, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10 - 5, VIRTUAL_HEIGHT - 30 - 20, 5, 20)

    ball = Ball(
        VIRTUAL_WIDTH / 2 - 2,
        VIRTUAL_HEIGHT / 2 - 2,
        5, 5
    )

    servingPlayer = ball.dx > 0 and 1 or 2

    gameState = 'start'

    push:setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        {
            fullscreen = false,
            vsync = true,
            resizable = false
        }
    )
end

function love.update(dt)
    if gameState == 'play' then

    if ball:collides(paddle1) or ball:collides(paddle2) then
        ball.dx = -ball.dx
    end

    if ball.y <= 0 then
        ball.dy = -ball.dy
        ball.y = 0
    end

    if ball.y >= VIRTUAL_HEIGHT - ball.height then
        ball.dy = -ball.dy
        ball.y = VIRTUAL_HEIGHT - ball.height
    end

    if ball.x <= 0 then
        player2score = player2score + 1
        servingPlayer = 1
        ball:reset()
        ball.dx = PADDLE_SPEED
        gameState = 'serve'
    end

    if ball.x + ball.width >= VIRTUAL_WIDTH then
        player1score = player1score + 1
        servingPlayer = 2
        ball:reset()
        ball.dx = -PADDLE_SPEED
        gameState = 'serve'
    end 

    paddle1:update(dt)
    paddle2:update(dt)

    if love.keyboard.isDown('w') then
        paddle1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0
    end

    if love.keyboard.isDown('up') then
        paddle2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        paddle2.dy = PADDLE_SPEED
    else
        paddle2.dy = 0
    end

        ball:update(dt)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        end
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    paddle1:render()
    paddle2:render()

    ball:render()

    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.printf("Pong", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Space to play...", 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s turn", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Space to serve...", 0, 32, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setColor(0 / 255, 255 / 255, 0 / 255, 255 / 255)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20)
    love.graphics.setColor(1, 1, 1, 1)
end