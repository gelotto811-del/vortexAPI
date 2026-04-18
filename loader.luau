-- // Protected by Vortex Panel
-- // Unauthorized access is prohibited

local KEY_URL = "https://raw.githubusercontent.com/gelotto811-del/VortexAPI/main/keys.json"
local REAL_SCRIPT_URL = "https://raw.githubusercontent.com/gelotto811-del/myscript/refs/heads/main/main.luau"
local http = game:GetService("HttpService")

-- Ottieni HWID
local hwid = ""
if syn and syn.request then
    hwid = tostring(pcall(function()
        return syn.request({Url="http://httpbin.org/get",Method="GET"}).Body
    end))
end
if hwid == "" then
    hwid = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
end

-- Scarica keys.json
local ok, res = pcall(function()
    return http:GetAsync(KEY_URL .. "?t=" .. tostring(tick()))
end)
if not ok then
    error("[ Vortex Panel ] Cannot connect to API. Try again later.")
    return
end

local keys = http:JSONDecode(res)

-- Cerca key valida
local found = false
local first_time_key = nil

for key, data in pairs(keys) do
    if data.hwid == hwid then
        found = true
        break
    end
    if data.hwid == "" and first_time_key == nil then
        found = true
        first_time_key = key
        break
    end
end

if not found then
    error("[ Vortex Panel ] You Are Not Whitelisted!")
    return
end

if first_time_key ~= nil then
    warn("[ Vortex Panel ] First time detected!")
    warn("[ Vortex Panel ] Your HWID: " .. hwid)
    error("[ Vortex Panel ] Send your HWID to an admin to activate!")
    return
end

-- HWID ok, carica script reale
print("[ Vortex Panel ] Authenticated successfully!")
loadstring(game:HttpGet(REAL_SCRIPT_URL))()
