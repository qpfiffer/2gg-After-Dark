scale = 2 -- love.window.getDPIScale()
window_width = 640 * scale
window_height = 480 * scale

toasters = {}
all_sprites = {}

TICKER_RATE = 1/60
BLINK_RATE = 8
dtotal = 0

math.randomseed(os.time())

function init_new_toaster()
    local speeds = {1, 1.5, 2, 2.5, 3}
    local scales = {1, 1.5, 2, 2.75, 3}
    local sprite = all_sprites[math.random(#all_sprites)]
    local scale = scales[math.random(#scales)]
    local quads = {}
    local FRAMES = 4
    local imgWidth, imgHeight = sprite:getWidth(), sprite:getHeight()
    local spriteHeight = imgHeight / FRAMES
    for i=0, FRAMES-1 do
        table.insert(quads, love.graphics.newQuad(0, i * spriteHeight, imgWidth, spriteHeight, imgWidth, imgHeight))
    end

    local new_toaster = {
        x = math.random(window_width * 2),
        y = 0,
        speed = speeds[math.random(#speeds)],
        frame = 0,
        blinks = BLINK_RATE,
        quads = quads,
        scale = scale,
        sprite = sprite
    }

    return new_toaster
end

function love.draw()
    for i=1, #toasters do
        local toaster = toasters[i]
        --love.graphics.print("Hello World", toaster.x, toaster.y)
        love.graphics.draw(toaster.sprite, toaster.quads[toaster.frame + 1], toaster.x, toaster.y, 0, toaster.scale, toaster.scale)
    end
end

function love.load(arg)
    love.mouse.setVisible(false)
    love.window.setTitle("After Dark")
    love.window.setMode(window_width, window_height, {resizable=false, vsync=false})
    love.window.setFullscreen(true)
    two_gg = love.graphics.newImage("sprites/2gg.png")
    gg_two = love.graphics.newImage("sprites/gg2.png")
    two_gg_two = love.graphics.newImage("sprites/2gg2.png")
    all_sprites = {
        two_gg, gg_two,
        two_gg, gg_two,
        two_gg_two}
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.update(dt)
    dtotal = dtotal + dt
    if dtotal >= TICKER_RATE then
        dtotal = dtotal - TICKER_RATE

        if math.random(100) > 95 then
            table.insert(toasters, init_new_toaster())
        end

        for i=1, #toasters do
            local toaster = toasters[i]
            toaster.blinks = toaster.blinks - 1
            if toaster.blinks <= 0 then
                toaster.frame = (toaster.frame + 1) % 4
                toaster.blinks = BLINK_RATE
            end
            toaster.x = toaster.x - toaster.speed
            toaster.y = toaster.y + toaster.speed
        end
    end
end
