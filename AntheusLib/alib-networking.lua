--Antheus Networking Library
local version = "0.0.2"

local alib = require("alib-base")
local component = require("component")
local modem = component.modem
local event = require("event")

local m = {}

function m.lookup(host)
    modem.open(22)
    modem.broadcast(22, "LOOKUP", host)
    while true do
        local _, _, from, p, type, msg = event.pull("modem_mesage")
        if type == "LOOKUPR" and msg == host then
            return from
        end
        return from
    end
    modem.close(22)
    return from
end

function m.sendFile(to, loc)
    modem.open(22)
    local t = alib.readFile(loc)
    local t = alib.encode(t)
    modem.send(to, 22, "FILE", t)
    modem.close(22)
    return true
end

function m.recieveFile(loc)
    modem.open(22)
    while true do
        local _, _, from, p, type, msg = event.pull("modem_message")
        if type == "FILE" then
            local t = alib.decode(msg)
            alib.writeFile(t, loc)
        end
    end
    modem.close(22)
    return true
end

return m