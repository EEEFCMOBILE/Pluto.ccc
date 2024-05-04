local ScriptSettings = {
    AimLock = {
        Enabled = true,
        Aimlockkey = "q",
        Prediction = 0.1229,
        Aimpart = 'HumanoidRootPart',
        Notifications = true,
        AutoPrediction = true,
    },
    Settings = {
        Thickness = 2,
        Transparency = 1,
        Color = Color3.fromRGB(106, 13, 173),
        FOV = true
    }
}

-- Notification
local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))();
local Notify = AkaliNotif.Notify;

Notify({
    Description = "made by Rex niggas",
    Title = "Pluto.cc",
    Duration = 3,
})

plr = game:GetService('Players').LocalPlayer

local Notify = AkaliNotif.Notify;

Notify({
    Description = "Loading..",
    Title = "tapped.lua",
    Duration = 0.9
})
wait(1)

Notify({
    Description = "Loaded! Prediction: "..ScriptSettings.AimLock.Prediction.."; Ping: "..game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString(),
    Title = "tapped.lua",
    Duration = 2.5
})

Notify({
    Description = "Ping: "..game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString(),
    Title = "tapped.lua",
    Duration = 2.5
})

local CurrentCamera = game:GetService("Workspace").CurrentCamera
local Inset = game:GetService("GuiService"):GetGuiInset().Y
local RunService = game:GetService("RunService")

local Mouse = game.Players.LocalPlayer:GetMouse()
local LocalPlayer = game.Players.LocalPlayer

local Line = Drawing.new("Line")
local Circle = Drawing.new("Circle")

local Plr

Mouse.KeyDown:Connect(function(KeyPressed)
    if KeyPressed == (ScriptSettings.AimLock.Aimlockkey) then
        if ScriptSettings.AimLock.Enabled == true then
            ScriptSettings.AimLock.Enabled = false
            if ScriptSettings.AimLock.Notifications == true then
                Plr = FindClosestPlayer()
                Notify({
                    Description = "Unlocked",
                    Title = "tapped.lua",
                    Duration = 0.5
                })
            end
        else
            Plr = FindClosestPlayer()
            ScriptSettings.AimLock.Enabled = true
            if ScriptSettings.AimLock.Notifications == true then
                Notify({
                    Description = "Locked on: "..tostring(Plr.Character.Humanoid.DisplayName),
                    Title = "tapped.lua",
                    Duration = 0.5
                })
            end
        end
    end
end)

function FindClosestPlayer()
    local ClosestDistance, ClosestPlayer = math.huge, nil;
    for _, Player in next, game:GetService("Players"):GetPlayers() do
        local ISNTKNOCKED = Player.Character:WaitForChild("BodyEffects")["K.O"].Value ~= true
        local ISNTGRABBED = Player.Character:FindFirstChild("GRABBING_COINSTRAINT") == nil

        if Player ~= LocalPlayer then
            local Character = Player.Character
            if Character and Character.Humanoid.Health > 1 and ISNTKNOCKED and ISNTGRABBED then
                local Position, IsVisibleOnViewPort = CurrentCamera:WorldToViewportPoint(Character.HumanoidRootPart.Position)
                if IsVisibleOnViewPort then
                    local Distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Position.X, Position.Y)).Magnitude
                    if Distance < ClosestDistance then
                        ClosestPlayer = Player
                        ClosestDistance = Distance
                    end
                end
            end
        end
    end
    return ClosestPlayer, ClosestDistance
end

RunService.Heartbeat:connect(function()
    if ScriptSettings.AimLock.Enabled == true then
        local Vector = CurrentCamera:WorldToViewportPoint(Plr.Character[ScriptSettings.AimLock.Aimpart].Position + (Plr.Character[ScriptSettings.AimLock.Aimpart].Velocity * ScriptSettings.AimLock.Prediction))
        Line.Color = ScriptSettings.Settings.Color
        Line.Transparency = ScriptSettings.Settings.Transparency
        Line.Thickness = ScriptSettings.Settings.Thickness
        Line.From = Vector2.new(Mouse.X, Mouse.Y + Inset)
        Line.To = Vector2.new(Vector.X, Vector.Y)
        Line.Visible = true
        Circle.Position = Vector2.new(Mouse.X, Mouse.Y + Inset)
        Circle.Visible = ScriptSettings.Settings.FOV
        Circle.Thickness = 2
        Circle.Radius = 60
        Circle.Color = ScriptSettings.Settings.Color
    elseif ScriptSettings.AimLock.FOV == true then
        Circle.Visible = true
    else
        Circle.Visible = false
        Line.Visible = false
    end
end)

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(...)
    local args = {...}
    if ScriptSettings.AimLock.Enabled and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" then
        args[3] = Plr.Character[ScriptSettings.AimLock.Aimpart].Position + (Plr.Character[ScriptSettings.AimLock.Aimpart].Velocity * ScriptSettings.AimLock.Prediction)
        return old(unpack(args))
    end
    return old(...)
end)

if ScriptSettings.AimLock.AutoPrediction == true then
    local pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    local split = string.split(pingvalue,'(')
    local ping = tonumber(split[1])
    if ping < 130 then
        ScriptSettings.AimLock.Prediction = 0.151
    elseif ping < 120 then
        ScriptSettings.AimLock.Prediction = 0.149
    elseif ping < 110 then
        ScriptSettings.AimLock.Prediction = 0.146
    elseif ping < 105 then
        ScriptSettings.AimLock.Prediction = 0.138
    elseif ping < 90 then
        ScriptSettings.AimLock.Prediction = 0.136
    elseif ping < 80 then
        ScriptSettings.AimLock.Prediction = 0.134
    elseif ping < 70 then
        ScriptSettings.AimLock.Prediction = 0.131
    elseif ping < 60 then
        ScriptSettings.AimLock.Prediction = 0.1229
    elseif ping < 50 then
        ScriptSettings.AimLock.Prediction = 0.1225
    elseif ping < 40 then
        ScriptSettings.AimLock.Prediction = 0.1256
    end
end
