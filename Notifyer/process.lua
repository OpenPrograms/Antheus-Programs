local event = require("event")
local component = require("component")
local modem = component.modem
local port = 15
local computer = require("computer")
modem.open(15)

local function notify(_, msg)
    modem.broadcast(15, "NOTIFY", msg)
    computer.beep()
end

function start()
    event.listen("NOTIFY", notify)
end