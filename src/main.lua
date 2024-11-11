-- =========================================
-- create two run configurations in intellij
-- =========================================
-- - "Emmy Debugger(NEW)" to launch the Emmy debugger
--   - use 'TCP ( Debugger connect IDE )'
--
-- - "Lua Application" to launch the application
--   - Program: "C:\path\to\love.exe"
--   - Working directory: "C:\path\to\this\repo\src"
--   - Entry file: "."  (love.exe expects a path to a dir that contains a main.lua file)
--   - Parameters: [blank]
--   - Environment variables: EMMY_DLL_PATH=C:\path\to\emmy_core.dll
--     ^ this is the same path that is appended to `package.cpath`
--       from the "Emmy Debugger(NEW)" configuration, using env-var avoids hardcoding paths
-- * note that the env-var won't persist in the run configuration without modifying another field
-- * eg. 'working directory', clicking 'apply', then changing it back and clicking 'apply' again
-- -----------------------------------------
-- 1) Set a breakpoint in IntelliJ anywhere in this file
-- 2) Launch the "Emmy Debugger(NEW)" configuration first
-- 3) Launch the "Lua Application" configuration second
--
-- Assuming the `EMMY_DLL_PATH` env var is set correctly, the debugger should connect
-- and it should suspend at the breakpoint and allow inspection and stepping
-- -----------------------------------------
-- Configurations tried when attempting to debug a Love2D project with Intellij-EmmyLua2
-- have been documented in https://github.com/EmmyLua/Intellij-EmmyLua2/issues/6
-- =========================================

package.cpath = package.cpath .. ';' .. os.getenv('EMMY_DLL_PATH')
local dbg = require('emmy_core')
dbg.tcpConnect('localhost', 9966)

local window = {}
local text = {
    font = nil,
    str = "Hello EmmyLua!",
    pos = { x = 0, y = 0 },
    size = { x = 0, y = 0 },
    speed = { x = 200, y = 200 },
}

function love.load(arg)
    window.width, window.height, window.flags = love.window.getMode()
    text.font = love.graphics.newFont(64);
    love.graphics.setFont(text.font)
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    -- update text size in case we want to change it
    text.size.x = text.font:getWidth(text.str)
    text.size.y = text.font:getHeight(text.str)

    -- move the text
    text.pos.x = text.pos.x + text.speed.x * dt
    text.pos.y = text.pos.y + text.speed.y * dt

    -- bounce the text off the window edges
    if text.pos.x < 0 or (text.pos.x + text.size.x) > window.width then
        text.speed.x = -text.speed.x
    end
    if text.pos.y < 0 or (text.pos.y + text.size.y) > window.height then
        text.speed.y = -text.speed.y
    end
end

function love.draw()
    love.graphics.setColor(0.12, 0.12, 0.12, 1)
    love.graphics.rectangle("fill", 0, 0, window.width, window.height)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.print(text.str, text.pos.x, text.pos.y)
end

