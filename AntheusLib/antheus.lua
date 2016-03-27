--[[

Antheus' Library
This is mostly for personal use, but if you want it, you can use it!

]]

-- Required API's for this API
local fs = require("filesystem")
local term = require("term")
local comp = require("computer")
local component = require("component")
local serial = require("serialization")

local version = 1.0

local gpu = component.gpu

local antheus = {}
    antheus.file = {}
    antheus.error = {}
    antheus.text = {}
        antheus.text.format = {}
    antheus.util = {}

-- Misc Utility Functions

function antheus.util.encode(data)
    return serial.serialize(data)
end

function antheus.util.decode(data)
    local status, result = pcall(serial.unserialize, data)
    return status, result
end

function antheus.version()
    return version
end

-- File Related Functions

function antheus.file.read(loc)
    local file = io.open(loc)
    local data = file:read("*all")
    file:close()
    return data
end

function antheus.file.write(file, data, overwrite) -- Kodos' API
    local tFile = assert(io.open(file, overwrite and "w" or "a"))
    tFile:write(data)
    tFile:close()
    return true
end

-- Error Related Functions

function antheus.error.notice(data)
    io.stderr:write(data.."\n")
    comp.beep()
end

-- Text Related Functions

function antheus.text.format.justify(a ,b , c) -- Taken from Kodos' Lib
    if c == "center" then
        local str = b
        local maxX, maxY = gpu.getResolution()
        local start = ((maxX - #str) / 2) + 1
        gpu.set(start, a, str)
    elseif c == "right" then
        local str = b
        local maxX, maxY = gpu.getResolution()
        local start = (maxX - #str) + 1
        gpu.set(start, a, str)
    elseif c == "left" then
        local str = b
        gpu.set(1, a, str)
    end
end

function antheus.text.hline(y, char)
    local maxX, maxY = gpu.getResolution()
    local char = char or "-"
    local chara = ""
    for i = 1, maxX do
        chara = chara..char
    end
    print(chara)
    chara = nil
end
return antheus