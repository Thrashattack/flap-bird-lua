--[[
    SettingsState Class
    
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The TitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

SettingsState = Class{__includes = BaseState}

local levels = {
    easy = {
        bird = {
            gravity = 8,
            jump_ratio = -1,
            width = 18,
            height = 10,
        },
        pipe = {
            speed = 60,
            width = 55,
            height = 200,
            gap = 120,
        },
        level = {            
            scroll_speed = 60,
            lt_tolerance = 6,
            rb_tolerance = 10,
        }
    },
    medium = {
        bird = {
            gravity = 15,
            jump_ratio = -3,
            width = 38,
            height = 24,
        },
        pipe = {
            speed = 75,
            width = 70,
            height = 288,
            gap = 90,
        },
        level = {            
            scroll_speed = 45,
            lt_tolerance = 2,
            rb_tolerance = 4,
        }
    },
    hard = {
        bird = {
            gravity = 20,
            jump_ratio = -4,
            width = 60,
            height = 55,
        },
        pipe = {
            speed = 85,
            width = 30,
            height = 350,
            gap = 70,
        },
        level = {            
            scroll_speed = 30,
            lt_tolerance = 1,
            rb_tolerance = 2,
        }
    }
}

local function setLevel(difficulty, Config, SettingsState)
    Config.level.difficulty = difficulty
    SettingsState.current_level = levels[Config.level.difficulty]
    Config.level.BACKGROUND_SCROLL_SPEED = SettingsState.current_level.level.scroll_speed
    Config.level.LEFT_TOP_OFFSET_TOLLERANCE = SettingsState.current_level.level.lt_tolerance
    Config.level.RIGHT_BOTTOM_OFFSET_TOLLERANCE = SettingsState.current_level.level.rb_tolerance
    Config.level.GRAVITY = SettingsState.current_level.bird.gravity
    Config.bird.BIRD_JUMP_RATIO = SettingsState.current_level.bird.jump_ratio
    Config.bird.BIRD_WIDTH = SettingsState.current_level.bird.width
    Config.bird.BIRD_HEIGHT = SettingsState.current_level.bird.height
    Config.pipe.PIPE_WIDTH = SettingsState.current_level.pipe.width
    Config.pipe.PIPE_HEIGHT = SettingsState.current_level.pipe.height
    Config.pipe.PIPE_SPEED = SettingsState.current_level.pipe.speed
    Config.pipe.GAP_HEIGHT = SettingsState.current_level.pipe.gap

    Inifile.save('config.ini', Config)
end

function SettingsState:init()
    SettingsState.current_level = levels[Config.level.difficulty]
end


function SettingsState:update(dt)
    SettingsState.current_level = levels[Config.level.difficulty]
    if love.keyboard.wasPressed('Esc') or love.keyboard.wasPressed('escape') then
        GStateMachine:change('title')
    end
    if love.keyboard.wasPressed('e') then
        setLevel('easy', Config, SettingsState)
    end
    if love.keyboard.wasPressed('m') then
        setLevel('medium', Config, SettingsState)
    end
    if love.keyboard.wasPressed('h') then
        setLevel('hard', Config, SettingsState)
    end
end

function SettingsState:render()
    love.graphics.setFont(FlappyFont)
    love.graphics.printf('Fifty Bird - Settings ', 0, 25, Config.defaults.VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Level ' .. Config.level.difficulty, 0, 64, Config.defaults.VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(MediumFont)
    love.graphics.printf('Press E to set level Easy', 0, 100, Config.defaults.VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press M to set level Medium', 0, 130, Config.defaults.VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press H to set level Hard(Beware!)', 0, 160, Config.defaults.VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Esc or escape to main menu', 0, 225, Config.defaults.VIRTUAL_WIDTH, 'center')
end