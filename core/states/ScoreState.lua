--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        GStateMachine:change('countdown')
    end
    if love.keyboard.wasPressed('escape') or love.keyboard.wasPressed('esc') then
        GStateMachine:change('title')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(FlappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, Config.defaults.VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(MediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, Config.defaults.VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, Config.defaults.VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Esc to Main Menu', 0, 220, Config.defaults.VIRTUAL_WIDTH, 'center')
end