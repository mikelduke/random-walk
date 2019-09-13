stepsPerSec = 60
updateDiff = 0
iterations = 0
maxIterations = 500
debug = false
gridX = 36
gridY = 20
scaleX = love.graphics.getWidth() / gridX
scaleY = love.graphics.getHeight() / gridY

lastStep = {x = 0, y = 0}
color = {r = 1, g = 1, b = 1}
walkColor = {r = 0, g = 1, b = 0}
lt = 0

function love.load() reset() end

function love.update(dt)
    if iterations > maxIterations then reset() end
    lt = lt + dt

    local numSteps = stepsPerSec * lt
    if numSteps >= 1 then
        lt = 0

        for i = 0, numSteps do
            step()
        end
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(c)

    if debug then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("DT: " .. tostring(love.timer.getDelta()), 10, 10)
        love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 20)
        love.graphics.print("stepsPerSec: " .. tostring(stepsPerSec), 10, 30)
        love.graphics.print("step: " .. tostring(lastStep.x) .. ", " ..
                                tostring(lastStep.y), 10, 40)
        love.graphics.print("iterations: " .. tostring(iterations) .. " of " .. maxIterations, 10, 50)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'd' and not isrepeat then debug = not debug end

    if key == 'escape' then
        love.event.push('quit')
    elseif key == 'up' then
        stepsPerSec = stepsPerSec + 5
    elseif key == 'down' then
        stepsPerSec = stepsPerSec - 5
        if stepsPerSec < 0 then stepsPerSec = 0 end
    elseif key == 'left' then
        maxIterations = maxIterations - 100
        if maxIterations < 100 then maxIterations = 100 end
    elseif key == 'right' then
        maxIterations = maxIterations + 100
    elseif key == 'r' then
        reset()
    end
end

function reset()
    iterations = 0

    c = love.graphics.newCanvas(love.graphics.getWidth(),
                                love.graphics.getHeight())

    lastStep = {x = love.math.random(1, gridX), y = love.math.random(1, gridY)}

    color = {
        r = love.math.random(),
        g = love.math.random(),
        b = love.math.random()
    }

    walkColor = {
        r = love.math.random(),
        g = love.math.random(),
        b = love.math.random()
    }
end

function step()
    local step = getNextStep()

    while not boundsCheckStep(step) do step = getNextStep() end

    drawStep(lastStep, color)
    drawStep(step, walkColor)
    lastStep = step

    iterations = iterations + 1
end

function getNextStep()
    local direction = love.math.random(4)
    local step = {}

    if direction == 1 then
        step = {x = lastStep.x - 1, y = lastStep.y}
    elseif direction == 2 then
        step = {x = lastStep.x + 1, y = lastStep.y}
    elseif direction == 3 then
        step = {x = lastStep.x, y = lastStep.y - 1}
    elseif direction == 4 then
        step = {x = lastStep.x, y = lastStep.y + 1}
    end

    return step
end

function boundsCheckStep(step)
    if step.x < 0 then
        return false
    elseif step.x >= gridX then
        return false
    elseif step.y < 0 then
        return false
    elseif step.y >= gridY then
        return false
    else
        return true
    end
end

function drawStep(step, color)
    love.graphics.setCanvas(c)
    love.graphics.setColor(color.r, color.g, color.b)
    local x = step.x * scaleX
    local y = step.y * scaleY
    love.graphics.rectangle("fill", x, y, scaleX, scaleY)
    love.graphics.setCanvas()
end
