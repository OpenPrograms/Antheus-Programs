-- DNS Library for clients
-- Derived from SuPeRMiNoR2's DNS program
-- https://github.com/OpenPrograms/SuPeRMiNoR2-Programs/blob/master/networking/dns.lua
--[[

TODO List:
    add support for TLD's
    add support for domains and whatnot

]]

local version = 1.0
local port = 16

local dns = {}
local component = require("component")
local event = require("event")

local antheus = require("antheus")

local modem = component.modem

function dns.version()
    return version
end

function dns.register(_name)
    modem.open(port)
    modem.broadcast(port, antheus.util.encode({action = "register", name = _name}))
    modem.close(port)
end

function dns.lookup(_name)
    found = false
    found_addr = nil
    modem.open(port)
    modem.broadcast(port, antheus.util.encode({action = "lookup", name = _name}))
    local e, _, address, _port, distance, message = event.pull("modem_message")
    modem.close(port)
    result, message = antheus.util.decode(message)
    if result == true then
        if message.action == "lookup" then
            found = true
            found_addr = message.response
        end
    end
    return found, found_addr
end

function dns.rlookup(_addr)
    found = false
    found_name = nil
    modem.open(port)
    modem.broadcast(port, antheus.util.encode({action = "rlookup", addr = _addr}))
    local e, _, address, _port, distance, message = event.pull("modem_message")
    modem.close(port)
    result, message = antheus.util.decode(message)
    if result == true then
        if message.action == "rlookup" then
            found = true
            found_name = message.response
        end
    end
    return found, found_name
end

return dns