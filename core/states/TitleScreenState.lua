--[[
    TitleScreenState Class
    
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The TitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
    -- nothing
end

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        GStateMachine:change('countdown')
    end
    if love.keyboard.wasPressed('c') then
        GStateMachine:change('settings')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(FlappyFont)
    love.graphics.printf('Fifty Bird', 0, 64, Config.defaults.VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(MediumFont)
    love.graphics.printf('Press Enter', 0, 100, Config.defaults.VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Q to quit', 0, 150, Config.defaults.VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press C to open config', 0, 200, Config.defaults.VIRTUAL_WIDTH, 'center')
end