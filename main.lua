-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'third-party/push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'third-party/class'

-- Inifile to load config dynamically
Inifile = require 'third-party/inifile'

Config = Inifile.parse('config.ini')


-- a basic StateMachine class which will allow us to transition to and from
-- game states smoothly and avoid monolithic code in one file
require 'core/StateMachine'

require 'core/states/BaseState'
require 'core/states/CountdownState'
require 'core/states/PlayState'
require 'core/states/ScoreState'
require 'core/states/SettingsState'
require 'core/states/TitleScreenState'

require 'core/entities/bird/Bird'
require 'core/entities/pipe/Pipe'
require 'core/entities/pipe/PipePair'


local background = love.graphics.newImage('assets/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('assets/ground.png')
local groundScroll = 0

-- global variable we can use to scroll the map
Scrolling = true

function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- seed the RNG
    math.randomseed(os.time())

    -- app window title
    love.window.setTitle('Fifty Bird')

    -- initialize our nice-looking retro text fonts
    SmallFont = love.graphics.newFont('assets/font.ttf', 8)
    MediumFont = love.graphics.newFont('assets/flappy.ttf', 14)
    FlappyFont = love.graphics.newFont('assets/flappy.ttf', 28)
    HugeFont = love.graphics.newFont('assets/flappy.ttf', 56)
    love.graphics.setFont(FlappyFont)

    -- initialize our table of sounds
    Sounds = {
        ['jump'] = love.audio.newSource('assets/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('assets/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('assets/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('assets/score.wav', 'static'),

        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('assets/marios_way.mp3', 'static')
    }

    -- kick off music
    Sounds['music']:setLooping(true)
    Sounds['music']:play()

    -- initialize our virtual resolution
    push:setupScreen(Config.defaults.VIRTUAL_WIDTH, Config.defaults.VIRTUAL_HEIGHT, Config.defaults.WINDOW_WIDTH, Config.defaults.WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize state machine with all state-returning functions
    GStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['settings'] = function() return SettingsState() end,
    }
    GStateMachine:change('title')

    -- initialize input table
    love.keyboard.keysPressed = {}

    -- initialize mouse input table
    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'q' then
        love.event.quit()
    end
end

--[[
    LÖVE2D callback fired each time a mouse button is pressed; gives us the
    X and Y of the mouse, as well as the button in question.
]]
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--[[
    Equivalent to our keyboard function from before, but for the mouse buttons.
]]
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + Config.level.BACKGROUND_SCROLL_SPEED * dt) % Config.defaults.BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + Config.defaults.GROUND_SCROLL_SPEED * dt) % Config.defaults.VIRTUAL_WIDTH
    end

    GStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()
    
    love.graphics.draw(background, -backgroundScroll, 0)
    GStateMachine:render()
    love.graphics.draw(ground, -groundScroll, Config.defaults.VIRTUAL_HEIGHT - 16)
    
    push:finish()
end