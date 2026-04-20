-- [[ STEAL A BRAINROT: AUTO-JOINER & VPS BOT ]] --
-- Based on ServerDestroyerV5 Logic

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- CONFIGURATION
local AJ_Settings = {
    WebhookURL = "YOUR_WEBHOOK_HERE", -- Paste your Discord Webhook URL here
    ItemToWatch = "Brainrot",          -- Name of the item the bot looks for
    ScannerDelay = 15,                 -- Seconds between scans
    VpsMode = true                     -- Set to true to disable graphics/lag
}

-- 1. VPS OPTIMIZATION (Inspired by your AntilagSection)
if AJ_Settings.VpsMode then
    task.spawn(function()
        -- Disable Rendering to save VPS CPU
        RunService:Set3dRenderingEnabled(false)
        
        -- Delete heavy visual assets
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("PostEffect") then
                v:Destroy()
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
        print("VPS Optimization Active: Graphics Disabled.")
    end)
end

-- 2. DISCORD NOTIFIER
local function notifyDiscord(msg)
    local payload = {
        ["content"] = "@everyone",
        ["embeds"] = {{
            ["title"] = "🧠 BRAINROT DETECTED",
            ["description"] = msg .. "\n\n**Server JobId:**\n`" .. game.JobId .. "`",
            ["color"] = 0x00ff00,
            ["fields"] = {
                {
                    ["name"] = "Join Command (Copy/Paste to Executor)",
                    ["value"] = "
