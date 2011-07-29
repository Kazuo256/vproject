----------------------------------------------------------------------------------------------------
-- Goroboids v1.4 by Wil																		----
-- Fev/2011																						----
-- main.lua																						----
--																								----
-- Because without love, it cannot be seen.														----
----------------------------------------------------------------------------------------------------

-- We require goroboids!
-- This loads the goroboids class, along with all its class dependencies.
require("goroboid")
-- Also, starting version 1.1+, I'll make some experiments with particles.
require("particles")

-- The game sprite list.
sprite_list = {}

-- A boolean to say wheter the game window is focused or not.
focus = true

-- This is needed because lua's rng's default seed is weird.
math.randomseed(9999999*math.sin(os.time()))

-- Some cool fire particles will be stored here.
fire = nil
-- If you are firing it or not.
active = false

-- Updates the fire particles to be always at the mouse position.
-- Adds somes noise to make it more flame-like.
function update_fire(dt)
    if active then
        local x, y  = game.mouse.getPosition()
        x, y = x - 10 + 20*math.random(), y - 10 + 20*math.random()
        fire:setPosition(x, y)
    end
    fire:update(dt)
end

-- Draws the the fire particles.
function draw_fire()
    game.graphics.setBlendMode("additive")
    game.graphics.draw(fire)
    game.graphics.setBlendMode("alpha")
end

-- This function is called when any love-engine game begins.
-- All initializing stuff should be done here.
function game.load()
    -- Begin the particles system.
    particles:load_base()
    -- Create 10 goroboids at random positions of the screen.
    for i = 1, 10 do
        local x, y = math.random(0, screen.w), math.random(0, screen.h)
        local sprite = class.goroboid(class.vector(x, y), 0.25)
        table.insert(sprite_list, sprite)
    end
    -- Prepare and start the fire particles u.u
    fire = particles.make_fire_particles()
    -- This are the two most important lines of the program. LOL
    bgm = game.audio.newSource("happy_maria_uta_m.ogg", "stream")
    game.audio.play(bgm)
end

-- Callback function of the love engine.
-- This is called whenever the focus state of the game changes, which means
-- whenever you change windows or minimize it and stuff like that.
function game.focus(f)
    -- I just store the current focus state of the game. It's a boolean.
    focus = f
end

-- Callback function of the love engine.
-- This is called whenever some mouse button is pressed.
-- We use this to start the fire particles.
function game.mousepressed(x, y, button)
    if button == "l" and not active then
        active = true
        fire:setLifetime(-1)
        if not fire:isActive() then
            fire:start()
        end
    end
end

-- Callback function of the love engine.
-- This is called whenever some mouse button is released
-- We use this to stop the fire particles.
function game.mousereleased(x, y, button)
    if button == "l" and active then
        active = false
        fire:setLifetime(0.75)
    end
end


-- This function is called every frame of the game. The parameter dt is
-- the difference in time since the last frame.
function game.update(dt)
    -- Update only while focused.
    if focus then
        -- The sprites know how to handle themselves!
        -- Just tell them to update!
        local i,v,j,u
        for i, v in ipairs(sprite_list) do
            v:update(dt) -- they need the dt info.
        end
        -- Now check and proccess collisions.
        for i, v in ipairs(sprite_list) do
            for j, u in ipairs(sprite_list) do
                if j > i then
                    v:collide(u, dt)
                end
            end
        end
        -- And finally check if any goroboid is being ignited.
        if game.mouse.isDown("l") then
            for i, v in ipairs(sprite_list) do
                local x, y = game.mouse.getPosition()
                local dist = class.vector(x, y) - v.pos
                if dist:length() < v.radius then
                    v.speed = v.speed*1.05
                    v.rot_spd = v.rot_spd*1.05
                end
            end
        end
        -- Update the fire particles when the left mouse button is pressed.
        update_fire(dt)
    end
end


-- This function is called whenever possible to draw the game screen.
-- So your drawing stuff should be here AND ONLY HERE.
function game.draw()
    -- Prepare the screen and the engine graphics.
    game.graphics.clear()
    -- The sprites also know how to draw themselves!!!
    -- Ain't they smart?
    -- Just tell them to draw!
    for i, v in ipairs(sprite_list) do
        v:draw()
    end
    -- Now draw the fire particles if they are active.
    draw_fire()
    -- This writes the current fps on the top-left of the screen.
    game.graphics.print(game.timer.getFPS(), 0, 0)
end


-- Feliz aniversário Goroba. \o/

