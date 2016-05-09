-- Derived from SuPeRMiNoR2's DNS program
-- https://github.com/OpenPrograms/SuPeRMiNoR2-Programs/blob/master/networking/dns.lua

-- Config Options
local port = 16
local version = 1.0

local dnsDir = "/home/dns"
local dnsFile = "dns.lua"
local rdnsFile = "rdns.lua"

local antheus = require("antheus")
local component = require("component")
local event = require("event")
local term = require("term")
local fs = require("filesystem")

local modem = component.modem

-- Create the dns table
dns = {}

-- Create the reverse dns table
rdns = {}

-- Function to send messages
function send(addr, data)
    modem.send(addr, port, data)
end

-- Function to register new things
local function register(name, addr)
    dns[name] = addr
    rdns[addr] = name
    antheus.file.write(dnsDir.."/"..dnsFile, antheus.util.encode(dns), true)
    antheus.file.write(dnsDir.."/"..rdnsFile, antheus.util.encode(rdns), true)
end

-- Stuff to lookup

function _lookup(name)
    return dns[name]
end

local function _rlookup(addr)
    return rdns[addr]
end

local function lookup(name)
    result, addr = pcall(_lookup, name)
    return addr
end

local function rlookup(addr)
    result, name = pcall(_rlookup, addr)
    if result then return name else return false end
end

-- Begin DNS Server
term.clear()
antheus.text.format.justify(1, "OpenDNS Server", "center")
antheus.text.format.justify(2, "Version "..version, "center")
term.setCursor(1, 3)
antheus.text.hline("-")
::FCHK::
print("Checking if DNS Directory Exists")
if fs.exists(dnsDir) ~= true then
    antheus.error.notice("[WARN] DNS Directory Does Not Exist")
    print("Attempting to Make Directory")
    fs.makeDirectory(dnsDir)
    goto FCHK
elseif fs.exists(dnsDir) == true then
    print("Directory Exists")
end

if fs.exists(dnsDir.."/"..dnsFile) == true then
    result, tmp = antheus.util.decode(antheus.file.read(dnsDir.."/"..dnsFile))
    if result and tmp ~= false then
        print("Sucessfully Found DNS File")
        dns = tmp
        print("DNS File Contents:")
        for k, v in pairs(dns) do
            print(k, v)
        end

    end
else
    antheus.error.notice("[WARN] No DNS File Found.")
end

if fs.exists(dnsDir.."/"..rdnsFile) == true then
    result, tmp = antheus.util.decode(antheus.file.read(dnsDir.."/"..rdnsFile))
    if result and tmp ~= false then
        print("Sucessfully Found Reverse DNS File")
        rdns = tmp
        print("Reverse DNS File Contents:")
        for k, v in pairs(rdns) do
            print(k, v)
        end
    end
else
    antheus.error.notice("[WARN] No Reverse DNS File Found.")
end

print("Starting Server Loop")

while true do 
    modem.open(port)
    local e, _, address, port, distance, message = event.pull("modem_message")
    result, message = antheus.util.decode(message)
    if result then
        if message.action == "register" then
            print("Registering "..message.name.." to "..address)
            register(message.name, address)
        end
        if message.action == "lookup" then
            n = lookup(message.name) or nil
            print(address.." Looked Up "..message.name)
            print("Response: "..n)
            send(address, antheus.util.encode({action = "lookup", response = n}))
        end
        if message.action == "rlookup" then
            a = rlookup(message.addr) or nil
            print(address.." Reverse Looked Up "..message.addr)
            print("Response: "..a)
            send(address, antheus.util.encode({action = "rlookup", response = a}))
        end
    end
end