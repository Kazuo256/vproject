----------------------------------------------------------------------------------------------------
-- Goroboids v1.4 by Wil																		----
-- Fev/2011																						----
-- conf.lua																						----
----------------------------------------------------------------------------------------------------

-- This files sets the default values for various settings, by using the
-- love.conf callback function.

-- No more love!
game = love

-- The game screen resolution.
screen = { w = 1280, h = 720}

-- This callback function is used before the love engine starts up and gives you the
-- table t which contains the settings to be used. I'll put them all here, even if
-- it just receives its default value, for you to know them all.
function game.conf(t)
    t.title = "Goroboids"		-- The title of the window the game is in (string)
    t.author = "Wil"			-- The author of the game (string)
    t.identity = nil			-- The name of the save directory (string)
    t.version = 1.5				-- The LÖVE version this game was made for (number)
    t.console = false			-- Attach a console (boolean, Windows only)
    t.screen.width = screen.w	-- The window width (number)
    t.screen.height = screen.h	-- The window height (number)
    t.screen.fullscreen = false	-- Enable fullscreen (boolean)
    t.screen.vsync = true		-- Enable vertical sync (boolean)
    t.screen.fsaa = 0			-- The number of FSAA-buffers (number)
    t.modules.joystick = false	-- Enable the joystick module (boolean)
    t.modules.audio = true		-- Enable the audio module (boolean)
    t.modules.keyboard = true	-- Enable the keyboard module (boolean)
    t.modules.event = true		-- Enable the event module (boolean)
    t.modules.image = true		-- Enable the image module (boolean)
    t.modules.graphics = true	-- Enable the graphics module (boolean)
    t.modules.timer = true		-- Enable the timer module (boolean)
    t.modules.mouse = true		-- Enable the mouse module (boolean)
    t.modules.sound = true		-- Enable the sound module (boolean)
    t.modules.physics = false	-- Enable the physics module (boolean)
end

-- From http://love2d.org/wiki/Config_Files
