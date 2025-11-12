-- Forsaken Script !!!

local Exclusive_Emotes = {}
local Gettable_Emotes = {}
local Characters = {}
local Gens = {}
local Minions = {}
local Items = {}
local SPRINTINGTable = {}
local Sprays = {}
local Camera = workspace.CurrentCamera
local DefaultKillerESP = Color3.new(1, 0, 0)
local DefaultSurvivorESP = Color3.new(0, 1, 0)
local DefaultSpectatorESP = Color3.new(1, 1, 1)
local DefaultMininonESP = Color3.new(0, 0.9, 1)
local DefaultGeneratorNONCOMPLETEDESP = Color3.new(1, 0.5, 0)
local DefaultGeneratorCOMPLETEDESP = Color3.new (1, 1, 0)
local DefaultItemESP = Color3.new(0, 0.5, 1)
local DefaultSprayESP = Color3.new(1, 0, 0.7)
local HighlightsFOLDER = workspace:FindFirstChild("HIGHLIGHTS") or Instance.new("Folder", workspace) HighlightsFOLDER.Name = "HIGHLIGHTS"
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = ReplicatedStorage.Assets
local Survivors = Assets.Survivors
local Killers = Assets.Killers
local emotes = Assets.Emotes
local lchr = nil
local lplr = game.Players.LocalPlayer
local IngameFolder = workspace:WaitForChild("Map"):WaitForChild("Ingame")

_G.KeybindStart = Enum.KeyCode.H
_G.KeybindStop = Enum.KeyCode.X

function GetDistance(part, fort)
    return (fort.Position - part.Position).Magnitude
end

for _, Emote in emotes:GetChildren() do
    local requireEmote = require(Emote)
    if requireEmote.Exclusive then
        table.insert(Exclusive_Emotes, "[!] "..requireEmote.DisplayName)
    else
        table.insert(Gettable_Emotes, requireEmote.DisplayName)
    end
end

function EmoteUseCopy(mobile)
    local EmoteName = nil
    for _, Emote in emotes:GetChildren() do
        local requireEmote = require(Emote)
        if requireEmote.DisplayName == _G.Emotes then
            EmoteName = Emote.Name
        end
    end

    if _G.SepecialDropdownForE == "CopyGame" then
        local args = {
            [1] = "PlayEmote",
            [2] = "Animations",
            [3] = EmoteName
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))

        if mobile then
            task.spawn(function()
                while true do
                    task.wait(0.1)
                    if _G.OFF then
                        local args = {
                            [1] = "StopEmote",
                            [2] = "Animations",
                            [3] = EmoteName
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                        break
                    end
                end
            end)
        else
            game:GetService("UserInputService").InputBegan:Connect(function(input)
                if input.KeyCode == _G.KeybindStop then
                    local args = {
                        [1] = "StopEmote",
                        [2] = "Animations",
                        [3] = EmoteName
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                end
            end)
        end
    end
end

local function SetupUpdateCharacter()
    if lplr.Character then
        lchr = chr
    end

    lplr.CharacterAdded:Connect(function(chrA: Model)
        lchr = chrA
    end)
end

local function RemoveAlreadyExistingCUSTOMANIMATIONS()
    if _G.ANIMATIONCONNECTION then _G.ANIMATIONCONNECTION:Disconnect() end
end

SetupUpdateCharacter()

function EmoteUseNormal(mobile)
    local lplr = game:GetService("Players").LocalPlayer
    local chr = lplr.Character or lplr.CharacterAdded:Wait()
    local tableforstuff = {
        Character = chr
    }
    local Hum = chr:WaitForChild("Humanoid", 5) or nil
    if not Hum then return end

    local EmoteName = nil
    for _, Emote in emotes:GetChildren() do
        local requireEmote = require(Emote)
        if requireEmote.DisplayName == _G.Emotes then
            EmoteName = Emote.Name
         elseif requireEmote.Exclusive and string.split(tostring(_G.Emotes), "[!] ")[2] and requireEmote.DisplayName == string.split(tostring(_G.Emotes), "[!] ")[2]  then
            EmoteName = Emote.Name
        end
    end

    if not EmoteName then return end

    local SpeedMultipliers = chr:FindFirstChild("SpeedMultipliers")
    if not SpeedMultipliers then return end
    local EmoteHACK = SpeedMultipliers:FindFirstChild("EmoteHACK")
    if EmoteHACK then return end

    EmoteHACK = Instance.new("NumberValue")
    EmoteHACK.Value = 0
    EmoteHACK.Name = "EmoteHACK"
    EmoteHACK.Parent = SpeedMultipliers

    local animation = Instance.new("Animation")
    local sound = Instance.new("Sound")
    local animationTrack = nil
    Camera.CameraSubject = chr.Head

    if mobile then
        task.spawn(function()
            while true do
                task.wait(0.1)
                if _G.OFF then
                    if animationTrack then
                        animationTrack:Stop()
                    else
                        EmoteHACK:Destroy()
                        sound:Destroy()
                
                        if emoteScript.Destroyed then
                            pcall(function()
                                emoteScript.Destroyed(lplr)
                            end)
                        elseif emoteScript.DestroyedServer then
                            pcall(function()
                                emoteScript.DestroyedServer(lplr)
                            end)
                        end
                    end
                    animation:Destroy()
                    break
                end
            end
        end)
    else
        local Wow
        Wow = game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.KeyCode == _G.KeybindStop then
                if animationTrack then
                    animationTrack:Stop()
                else
                    EmoteHACK:Destroy()
                    sound:Destroy()
            
                    if emoteScript.Destroyed then
                        pcall(function()
                            emoteScript.Destroyed(lplr)
                        end)
                    elseif emoteScript.DestroyedServer then
                        pcall(function()
                            emoteScript.DestroyedServer(lplr)
                        end)
                    end
                end
                animation:Destroy()

                Wow:Disconnect()
            end
        end)
    end

    local emoteScript = table.clone(require(game:GetService("ReplicatedStorage").Assets.Emotes[EmoteName]))

    if emoteScript.Created then
        local suc, erroer = pcall(function()
            emoteScript.Created(tableforstuff)
        end)
        if not suc then
            warn(erroer)
        end
    elseif emoteScript.CreatedServer then
        local suc, erroer = pcall(function()
            emoteScript.CreatedServer(tableforstuff)
        end)
        if not suc then
            warn(erroer)
        end
    end

    if emoteScript.Speed then
        EmoteHACK.Value = emoteScript.Speed / 15
    end

    if typeof(emoteScript.AssetID) == "string" then
        animation.AnimationId = emoteScript.AssetID
    elseif typeof(emoteScript.AssetID) == "table" then
        local tablse = emoteScript.AssetID
        animation.AnimationId = tostring(unpack(tablse, tonumber(math.random(1, #tablse))))
    end

    animationTrack = Hum.Animator:LoadAnimation(animation)
    animationTrack:Play()

    local var2

    var2 = emoteScript.SFX

    sound.Parent = chr:WaitForChild("HumanoidRootPart")
    sound.Looped = false

    if typeof(var2) == "string" then
        sound.SoundId = var2
    elseif typeof(var2) == "table" then
        local audio = math.random(1, #var2)
        sound.SoundId = tostring(unpack(var2, tonumber(audio)))
    end

    if emoteScript.SFXProperties then
        for i, v in pairs(emoteScript.SFXProperties) do
            if typeof(v) == "number" and v == 0 then continue end
            
            sound[i] = v
        end
    end
    
    sound:Play()

    animationTrack.Stopped:Connect(function()
        EmoteHACK:Destroy()
        sound:Destroy()

        Camera.CameraSubject = chr

        if emoteScript.Destroyed then
            pcall(function()
                emoteScript.Destroyed(tableforstuff)
            end)
        elseif emoteScript.DestroyedServer then
            pcall(function()
                emoteScript.DestroyedServer(tableforstuff)
            end)
        end
    end)
end

function PlayEmote(mobile)
    if _G.SepecialDropdownForE == "Original" then
        EmoteUseNormal(mobile)
    else
        EmoteUseCopy(mobile)
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == _G.KeybindStart then
        PlayEmote()
    end
end)
-- Script
local Lib = 'https://raw.githubusercontent.com/deividcomsono/Obsidian/main/'

local Library = loadstring(game:HttpGet(Lib .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(Lib .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(Lib .. 'addons/SaveManager.lua'))()

local Options = Library.Options

if _G.OceanHubLoaded then
    Library:Warning("Huui")
end


local Window = Library:CreateWindow({
    -- Set Center to true if you want the menu to appear in the center
    -- Set AutoShow to true if you want the menu to appear when it is created
    -- Position and Size are also valid options here
    -- but you do not need to define them unless you are changing them :)

    Title = 'Forsaken',
	Footer = "Version: REWORK",
	Icon = 135839551848990,
	NotifySide = "Left",
	ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab('Main', "list"),
    Visual = Window:AddTab('Visual', "bolt"),
    Player = Window:AddTab('Player', "user"),
    AnimsCustom = Window:AddTab('Custom Animations', "move-3d"),
    Credits = Window:AddTab("Credits", "badge-info"),
    ['UI Settings'] = Window:AddTab('UI Settings', 'settings'),
}

local Creditss = Tabs.Credits:AddLeftGroupbox("Credits")

Creditss:AddLabel({
    Text = '<font color="rgb(255,0,0)">[enzoe15226 (Crimson)]</font> On Discord For Main Developer <font color="rgb(255,0,0)">im</font> writing this btw!',
    DoesWrap = true
})

local MyButton = Creditss:AddButton({
	Text = '<font color="rgb(255,0,0)">[Set Clipboard To Discord Invite]</font>!',
	Func = function()
        local fgd = loadstring(game:HttpGet('https://raw.githubusercontent.com/dizzyhvh/Forest-Fire/refs/heads/main/discordurl.lua'))()
		setclipboard(tostring(fgd))
	end,
	DoubleClick = false,

	Tooltip = "sets the current clipboard to The Discord Invite",
	DisabledTooltip = "I am disabled!",

	Disabled = false, -- Will disable the button (true / false)
	Visible = true, -- Will make the button invisible (true / false)
	Risky = false, -- Makes the text red (the color can be changed using Library.Scheme.Red) (Default value = false)
})

local Sound = Instance.new("Sound")
local MyButton = Creditss:AddButton({
	Text = '<font color="rgb(0,255,0)">[PLAY SIGMA MUSIC]</font>!',
	Func = function()
        local response = request({
            Url = "https://raw.githubusercontent.com/dizzyhvh/Forest-Fire/refs/heads/main/Don't%20You%20Forget%20(Reprise)%20%20%20Hazbin%20Hotel%20Season%202%20%20%20Prime%20Video.mp3",
            Method = "GET"
        })

        writefile("SIGMAMUSIC.mp3", response.Body)

        Sound.Parent = game:GetService("SoundService")
        Sound.Looped = true
        Sound.Volume = 3
        Sound.SoundId = getcustomasset("SIGMAMUSIC.mp3", false)
        Sound:Play()
	end,
	DoubleClick = false,

	Tooltip = "PLAYS SIGMA MUSIC LOOPED",
	DisabledTooltip = "I am disabled!",

	Disabled = false, -- Will disable the button (true / false)
	Visible = true, -- Will make the button invisible (true / false)
	Risky = false, -- Makes the text red (the color can be changed using Library.Scheme.Red) (Default value = false)
})


local MyButton = Creditss:AddButton({
	Text = '<font color="rgb(0,255,0)">[STOP SIGMA MUSIC]</font>!',
	Func = function()
        

        Sound:Stop()
	end,
	DoubleClick = false,

	Tooltip = "STOP SIGMA MUSIC LOOPED",
	DisabledTooltip = "I am disabled!",

	Disabled = false, -- Will disable the button (true / false)
	Visible = true, -- Will make the button invisible (true / false)
	Risky = false, -- Makes the text red (the color can be changed using Library.Scheme.Red) (Default value = false)
})
--- GroupBoxes

local Custom = Tabs.AnimsCustom:AddLeftGroupbox('Custom Animations', "diamond-plus")
local Other = Tabs.Main:AddLeftGroupbox('Other')
local Visual = Tabs.Visual:AddLeftGroupbox('Esp')
local Emotes = Tabs.Main:AddRightGroupbox('Emotes')
local WalkSpeedO = Tabs.Player:AddLeftGroupbox('Sprint Speed')
-- Functions

local function ApplyCustomAnimations(AnimationToReplace: string, CustomAnimationToInforce: string)
    lchr = lplr.Character or lplr.CharacterAdded:Wait()
    local Animator: Animator = (lchr:WaitForChild("Humanoid", 5) or nil) and (lchr.Humanoid:WaitForChild("Animator", 5) or nil)
    if Animator then
        RemoveAlreadyExistingCUSTOMANIMATIONS()

        if lchr.Parent == workspace.Players.Spectating then
            Library:Notify("Error Use This When U Are In The Game", 5)
            return
        end

        _G.ANIMATIONCONNECTION = Animator.AnimationPlayed:Connect(function(animationTrack: AnimationTrack)
            local Animation: Animation = animationTrack.Animation
            if Animation.AnimationId == AnimationToReplace then
                Animation.AnimationId = CustomAnimationToInforce
                local NewAnimationTrack = Animator:LoadAnimation(Animation)
                NewAnimationTrack:Play()
                if animationTrack.Looped then
                    animationTrack.Stopped:Connect(function()
                        NewAnimationTrack:Stop()
                        Animation.AnimationId = AnimationToReplace
                    end)
                end
            end
        end)

        Library:Notify("Successfully Applyed Custom Animations (RESETS AFTER U DIE)", 5)
    end
end

-- Script Stuff

Other:AddToggle('MyToggle', {
    Text = 'Auto Complete Generator',
    Default = false, -- Default value (true / false)
    Visible = true,
    Tooltip = 'Auto Completes Closses Generator', -- Information shown when you hover over the toggle

    Callback = function(Value)
        _G.AutoDoGens = Value
    end
})

Visual:AddToggle('KillerESP', {
    Text = 'Killer Esp',
    Default = false, -- Default value (true / false)
    Visible = true,
    Tooltip = 'Self Explanastory', -- Information shown when you hover over the toggle

    Callback = function(Value)
        _G.KillersEsp = Value
    end
}):AddColorPicker("KillerColorESP", {
	Default = DefaultKillerESP,
	Title = "Color",

	Callback = function(Value)
		DefaultKillerESP = Value
	end,
})

Visual:AddToggle('SurvivorESP', {
    Text = 'Survivor Esp',
    Default = false, -- Default value (true / false)
    Visible = true,
    Tooltip = 'Self Explanastory', -- Information shown when you hover over the toggle

    Callback = function(Value)
        _G.SurvivorsEsp = Value
    end
}):AddColorPicker("SurvivorColorESP", {
	Default = DefaultSurvivorESP,
	Title = "Color",

	Callback = function(Value)
		DefaultSurvivorESP = Value
	end,
})

Visual:AddToggle('SpectatorESP', {
    Text = 'Spectator Esp',
    Default = false, -- Default value (true / false)
    Visible = true,
    Tooltip = 'Self Explanastory', -- Information shown when you hover over the toggle

    Callback = function(Value)
        _G.SpectatingEsp = Value
    end
}):AddColorPicker("SpectatorColorESP", {
	Default = DefaultSpectatorESP,
	Title = "Color",

	Callback = function(Value)
		DefaultSpectatorESP = Value
	end,
})

Visual:AddToggle('SprayESP', {
    Text = 'Spray Esp',
    Default = false, -- Default value (true / false)
    Visible = true,
    Tooltip = 'Self Explanastory', -- Information shown when you hover over the toggle

    Callback = function(Value)
        _G.SprayEsp = Value
    end
}):AddColorPicker("SprayColorESP", {
	Default = DefaultSprayESP,
	Title = "Color",

	Callback = function(Value)
		DefaultSprayESP = Value
	end,
})


Visual:AddToggle('ItemESP', {
    Text = 'Item Esp',
    Default = false, -- Default value (true / false)
    Visible = true,
    Tooltip = 'Self Explanastory', -- Information shown when you hover over the toggle

    Callback = function(Value)
        _G.ItemEsp = Value
    end
}):AddColorPicker("ItemColorESP", {
	Default = DefaultItemESP,
	Title = "Color",

	Callback = function(Value)
		DefaultItemESP = Value
	end,
})

Visual:AddToggle('MinionESP', {
    Text = 'Minion Esp',
    Default = false, -- Default value (true / false)
    Visible = true,
    Tooltip = 'Self Explanastory', -- Information shown when you hover over the toggle

    Callback = function(Value)
        _G.MinionEsp = Value
    end
}):AddColorPicker("MinionColorESP", {
	Default = DefaultMininonESP,
	Title = "Color",

	Callback = function(Value)
		DefaultMininonESP = Value
	end,
})

Visual:AddToggle('GeneratorESP', {
    Text = 'Generator Esp',
    Default = false, -- Default value (true / false)
    Visible = true,
    Tooltip = 'Self Explanastory', -- Information shown when you hover over the toggle

    Callback = function(Value)
        _G.GeneratorEsp = Value
    end
}):AddColorPicker("GeneratorESPColorNONCOMPLETED", {
	Default = DefaultGeneratorNONCOMPLETEDESP,
	Title = "Non Completed Generator Color",

	Callback = function(Value)
		DefaultGeneratorNONCOMPLETEDESP = Value
	end,
})
:AddColorPicker("SpectatorColorESPColorCOMPLETED", {
	Default = DefaultGeneratorCOMPLETEDESP,
	Title = "Completed Generator Color",

	Callback = function(Value)
		DefaultGeneratorCOMPLETEDESP = Value
	end,
})

function AutoDoGens()
    if _G.AutoDoGens and not _G.AutoDoGensWAIT then
        local function ClostNum(part, part2)
            return (part.Position - part2.CFrame.Position).Magnitude
        end

        local BiggestVal = math.huge
        local BiggestObject = nil

        for Generator, _ in Gens do
            if not Generator:IsDescendantOf(workspace) then continue end

            local Val = ClostNum(Generator.Positions.Center, game.Players.LocalPlayer.Character.HumanoidRootPart)
            if Val < BiggestVal then
                BiggestVal = Val
                BiggestObject = Generator
            end
        end

        if BiggestObject then
            local Remotes = BiggestObject:WaitForChild("Remotes", 5) or nil
            if Remotes then
                local RemoteEvent = Remotes:WaitForChild("RE", 5) or nil
               if RemoteEvent then
                    RemoteEvent:FireServer()

                    _G.AutoDoGensWAIT = true
                    task.delay((_G.AutoDoGensWAITTIME or 1.4),function()
                        _G.AutoDoGensWAIT = false
                    end)
                end
            end
        end
    end
end

local function EspThing(Highlight: Highlight, Text: any, Table: table)
    if not Highlight then
        Highlight = Instance.new("Highlight", HighlightsFOLDER)
        Highlight.Adornee = nil

        Table.Highlight = Highlight
    end

    if not Text then
        Text = Drawing.new("Text")
        Text.Center = true
        Text.Outline = true
        Text.Visible = false
        Text.Size = 15
        Text.Font = 2

        Table.Text = Text
    end
end

local function RemoveEsp(Text: any, Highlight: Highlight, Table: table)
    if Highlight then
        Highlight.Adornee = nil
        Highlight:Destroy()

        Table.Highlight = nil
    end
    if Text then
        Text.Visible = false
        Text:Remove()

        Table.Text = nil
    end
end

function esp()
    for chr: Model, v in pairs(Characters) do
        local Highlight = v.Highlight
        local Text = v.Text

        local Root = chr and chr.PrimaryPart

        if not Root or not chr:IsDescendantOf(workspace) or not _G.Esp then
            RemoveEsp(Text, Highlight, v)
            continue
        end

        EspThing(Highlight, Text, v) Highlight = v.Highlight Text = v.Text

        local function IsParentOf(PathName: string)
            local Success = false
            if game:GetService("Workspace").Players:FindFirstChild(PathName) and chr.Parent == game:GetService("Workspace").Players:FindFirstChild(PathName) then
                if not _G[PathName.."Esp"] then
                    Highlight.Adornee = nil
                    Text.Visible = false
                    Text:Remove()

                    v.Text = nil

                    return Success
                end
                Success = true
            end

            return Success
        end

        local function ChangeColor(Color: Color3)
            Highlight.FillColor = Color
            Highlight.OutlineColor = Color

            Text.Color = Color

            Highlight.Adornee = chr
            Text.Visible = true
        end

        local Position, OnScreen = Camera:WorldToScreenPoint(Root.Position)
        if OnScreen then
            Text.Position = Vector2.new(Position.X, Position.Y)
            if IsParentOf("Killers") then
                local SkinName = chr:GetAttribute("SkinNameDisplay")
                Text.Text = "Character: "..chr:GetAttribute("ActorDisplayName")..""..(" | Skin: "..SkinName or "None").." | Player: "..chr:GetAttribute("Username")
                ChangeColor(DefaultKillerESP)
            elseif IsParentOf("Survivors") then
                local SkinName = chr:GetAttribute("SkinNameDisplay")
                Text.Text = "Character: "..chr:GetAttribute("ActorDisplayName")..""..(" | Skin: "..SkinName or "None").." | Player: "..chr:GetAttribute("Username")
                ChangeColor(DefaultSurvivorESP)
            elseif IsParentOf("Spectating") then
                Text.Text = "Player: "..chr.Name
                ChangeColor(DefaultSpectatorESP)
            end
        else
            RemoveEsp(Text, Highlight, v)
        end
    end
    for Minion: Model, v in pairs(Minions) do
        local Highlight = v.Highlight
        local Text = v.Text

        local Root = Minion and Minion.PrimaryPart

        if not Root or not Minion:IsDescendantOf(workspace) or not _G.Esp or not _G.MinionEsp then
            RemoveEsp(Text, Highlight, v)
            continue
        end

        EspThing(Highlight, Text, v) Highlight = v.Highlight Text = v.Text

        local function ChangeColor(Color: Color3)
            Highlight.FillColor = Color
            Highlight.OutlineColor = Color

            Text.Color = Color

            Highlight.Adornee = Minion
            Text.Visible = true
        end

        local Position, OnScreen = Camera:WorldToScreenPoint(Root.Position)
        if OnScreen then
            Text.Position = Vector2.new(Position.X, Position.Y)
            Text.Name = "Minion"
            ChangeColor(DefaultMininonESP)
        else
            RemoveEsp(Text, Highlight, v)
        end
    end
    for Generator, v in pairs(Gens) do
        local Highlight = v.Highlight
        local Text = v.Text

        local Root = Generator and Generator.PrimaryPart
        local Progress = Generator and Generator:FindFirstChild("Progress")

        if not Root or not Progress or not Generator:IsDescendantOf(workspace) or not _G.Esp or not _G.GeneratorEsp then
            RemoveEsp(Text, Highlight, v)
            continue
        end

        EspThing(Highlight, Text, v)

        local function ChangeColor(Color)
            Text.Color = Color
            Highlight.FillColor = Color
            Highlight.OutlineColor = Color
        end

        local Position, OnScreen = Camera:WorldToScreenPoint(Root.Position)
        if OnScreen then
            Text.Visible = true
            Text.Position = Vector2.new(Position.X, Position.Y)
            Highlight.Adornee = Generator

            Text.Text = "Generator Progress: "..Progress.Value

            if Progress.Value ~= 100 then
                ChangeColor(DefaultGeneratorNONCOMPLETEDESP)
            else
                ChangeColor(DefaultGeneratorCOMPLETEDESP)
            end
        else
            RemoveEsp(Text, Highlight, v)
        end
    end
    for Item, v in pairs(Items) do
        local Highlight = v.Highlight
        local Text = v.Text

        local Root = Item and Item:WaitForChild("ItemRoot", 5) or nil

        if not Root or not Item:IsDescendantOf(workspace) or not _G.Esp or not _G.ItemEsp then
            RemoveEsp(Text, Highlight, v)
            continue
        end

        EspThing(Highlight, Text, v) Highlight = v.Highlight Text = v.Text

        local function ChangeColor(Color)
            Text.Color = Color
            Highlight.FillColor = Color
            Highlight.OutlineColor = Color
        end

        local Position, OnScreen = Camera:WorldToScreenPoint(Root.Position)
        if OnScreen then
            Text.Visible = true
            Text.Position = Vector2.new(Position.X, Position.Y)
            Highlight.Adornee = Root

            Text.Text = "Item: "..Item.Name.." | Distance: "..tostring(math.floor((Root.Position - lplr.Character.PrimaryPart.Position).Magnitude))
            ChangeColor(DefaultItemESP)
        else
            RemoveEsp(Text, Highlight, v)
        end
    end
    for Spray, v in pairs(Sprays) do
        local Highlight = v.Highlight
        local Text = v.Text
        local MODELSpray = v.MODELSpray

        local Root = Spray and Spray:FindFirstChild("SprayRangeIndicator") or nil
        local Progress = MODELSpray:GetAttribute("Progression")
        local Completed = MODELSpray:GetAttribute("Completed")

        if not Root or not Spray:IsDescendantOf(workspace) or not _G.Esp or not _G.SprayEsp then
            RemoveEsp(Text, Highlight, v)
            if Root then
                Spray.Transparency = 1
            end
            continue
        end

        EspThing(Highlight, Text, v) Highlight = v.Highlight Text = v.Text

        local function ChangeColor(Color)
            Spray.Color = Color

            Text.Color = Color
            Highlight.FillColor = Color
            Highlight.OutlineColor = Color
        end

        local Position, OnScreen = Camera:WorldToScreenPoint(Spray.Position)
        if OnScreen then
            Text.Visible = true
            Text.Position = Vector2.new(Position.X, Position.Y)
            Highlight.Adornee = Spray

            Text.Text = "Spray | Player: "..v.Player.Name.." | "..(Progress < 100 and "Progress: "..math.floor(Progress) or ("Completed: True" and Completed) or "FATAL ERROR INCODE")
            Spray.Transparency = 0
            ChangeColor(DefaultSprayESP)
        else
            Spray.Transparency = 1
            RemoveEsp(Text, Highlight, v)
        end
    end
end

local CharactersTABLE = {}
local CharacterConfig = nil
local CharacterSELECTED = nil

local AnimationTOREPLACEWITH = nil
local AnimationToReplace = nil

local function GetConfigCharacterSelected(Instance: Folder)
    local Config = (Instance and Instance:FindFirstChild("Config") and table.clone(require(Instance.Config))) or nil
    local SkinSelected = lplr:WaitForChild("PlayerData"):WaitForChild("Equipped"):WaitForChild("Skins"):WaitForChild(Instance.Name).Value
    if SkinSelected then
        local Skins = Assets.Skins[Instance.Parent.Name]
        local SkinConfig = Skins:FindFirstChild(Instance.Name) and Skins[Instance.Name]:FindFirstChild(SkinSelected) and require(Skins[Instance.Name][SkinSelected].Config)
        if SkinConfig then
            if SkinConfig.Animations then
                for AnimationName, AnimationId in SkinConfig.Animations do
                    if typeof(AnimationId) == "string" then
                        Config.Animations[AnimationName] = AnimationId
                    end
                end
            end
        end
    end
    return Config
end
local function AddCharacterToATheTable(CharacterTOADD: Folder)
    table.insert(CharactersTABLE, CharacterTOADD)
end

for _, CharacterTOADD in Killers:GetChildren() do
    AddCharacterToATheTable(CharacterTOADD)
end

for _, CharacterTOADD in Survivors:GetChildren() do
    AddCharacterToATheTable(CharacterTOADD)
end

local Anims = {}
Custom:AddDropdown('CharacterSELECTED', {
    Values = CharactersTABLE,
    Default = 0, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected
    Searchable = true,

    Text = "Select A Character",
    Visible = true,
    Tooltip = 'Select A Character To Replace A Animation', -- Information shown when you hover over the dropdown

    Callback = function(Value)
        CharacterSELECTED = Value
        CharacterConfig = GetConfigCharacterSelected(Value)
        if CharacterConfig and typeof(CharacterConfig) == "table" then
            Anims = {}
            local AnimsDISPLAY = {}
            for AnimationName, AnimationId in CharacterConfig.Animations do
                if typeof(AnimationId) == "string" then
                    Anims[AnimationName] = AnimationId
                    table.insert(AnimsDISPLAY, AnimationName)
                end
            end
            Options.AnimationSELECTED:SetValues(AnimsDISPLAY)
        end
    end
})

Custom:AddDropdown('AnimationSELECTED', {
    Values = {"None Selected"},
    Default = 0, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected
    Searchable = true,

    Text = "Select A Animation",
    Visible = true,
    Tooltip = 'Select A Animation To Replace', -- Information shown when you hover over the dropdown

    Callback = function(Value)
        AnimationToReplace = Value
        local Skins = Assets.Skins
        local SkinsTABLE = {}
        for _, CharacterFolder in Skins:GetChildren() do
            if CharacterFolder:FindFirstChild(CharacterSELECTED.Name) then
                for _, SkinFolder in CharacterFolder:FindFirstChild(CharacterSELECTED.Name):GetChildren() do
                    local Config = (SkinFolder:FindFirstChild("Config") and require(SkinFolder.Config)) or nil
                    if Config then
                        local AnimsE = Config.Animations
                        if not AnimsE then continue end

                        for Animation, _ in AnimsE do
                            if typeof(Animation) == "string" then
                                local AnimationName = Value
                                if AnimationName == Animation then
                                    table.insert(SkinsTABLE, SkinFolder)
                                end
                            end
                        end
                    end
                end
            end
        end

        if #SkinsTABLE == 0 then
            Options.SkinSELECTED:SetValues({"No Skins Found :("})
            task.delay(3, function()
                if Options.SkinSELECTED.Values == {"No Skins Found :("} then
                    Options.SkinSELECTED:SetValues({"None Selected"})
                end
            end)
        else
            Options.SkinSELECTED:SetValues(SkinsTABLE)
        end
    end
})

Custom:AddDropdown('SkinSELECTED', {
    Values = {"None Selected"},
    Default = 0, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = "Select A Skin",
    Visible = true,
    Tooltip = 'Select A Skin To Replace The Animation', -- Information shown when you hover over the dropdown
    Searchable = true,

    Callback = function(Value)
        local Skin = Value
        local Config = (Skin:FindFirstChild("Config") and require(Skin.Config)) or nil
        if Config then
            local AnimsE = Config.Animations
            local AnimationToReplaceName = AnimationToReplace
            for Animation, AnimationId in AnimsE do
                if Animation == AnimationToReplaceName then
                    AnimationTOREPLACEWITH = AnimationId
                end
            end
        end
    end
})

local MyButton = Custom:AddButton({
    Text = 'Apply Custom Animation',
    Func = function()
        local AnimationToReplaceId = Anims[AnimationToReplace]
        ApplyCustomAnimations(AnimationToReplaceId, AnimationTOREPLACEWITH)
    end,
    DoubleClick = false,
    Visible = true,
    Tooltip = "Apply's A Custom Animation"
})

local MyButton = Custom:AddButton({
    Text = 'Reset Custom Animation',
    Func = function()
        RemoveAlreadyExistingCUSTOMANIMATIONS()
    end,
    DoubleClick = false,
    Visible = true,
    Tooltip = "Resets's A Custom Animation"
})

local function AddToCharactersTable(chr: Model)
    Characters[chr] = {}
end

local function AddToGeneratorsTable(Gen: Model)
    Gens[Gen] = {}
end

local function SetupGeneratorStuff(Map: Model)
    local function CheckIfIsAGenerator(Generator)
        if Generator.Name == "Generator" then
            AddToGeneratorsTable(Generator)
        end
    end

    for _, Generator in Map:GetChildren() do
        CheckIfIsAGenerator(Generator)
    end

    Map.ChildAdded:Connect(CheckIfIsAGenerator)
end

local function SetupCharacterStuff(plr: Player)
    local chr = plr.Character
    if chr then
        AddToCharactersTable(chr)
    end

    plr.CharacterAdded:Connect(AddToCharactersTable)
end

local function CheckIfItIsAItem(child: Tool)
    if child:IsA("Tool") then
       Items[child] = {}
    end
end

local function CheckIfIsASprayPaint(child: Model)
    local Player = game:GetService("Players"):FindFirstChild(string.split(child.Name, "Spray")[1])
    if Player then
        local ClosestObject = nil
        local ClosestNumber = math.huge
        
        for _, Object in pairs(child.Parent:GetChildren()) do
            if Object:IsA("Part") and Object.Name == "GraffitiCL" then
                local Number = (Object.Position - child.PrimaryPart.Position).Magnitude
                if Number < ClosestNumber then
                    ClosestNumber = Number
                    ClosestObject = Object
                end
            end
        end

        Sprays[ClosestObject] = {
            Player = Player,
            MODELSpray = child,
        }
    end
end

local function SetupItemStuff(Map: Model)
    for _, object in Map:GetChildren() do
        CheckIfItIsAItem(object)
    end

    Map.ChildAdded:Connect(CheckIfItIsAItem)
end

local function CheckIfIsAMap(child)
    if child.Name == "Map" then
        SetupGeneratorStuff(child)
        SetupItemStuff(child)
    end
end

local function CheckIfItIsAMinion(child)
    local Humanoid = child:WaitForChild("Humanoid", 5) or nil
    if Humanoid and child:GetAttribute("Team") and child:GetAttribute("Team") == "Killers" then
        Minions[child] = {}
    end
end

game:GetService("Players").PlayerAdded:Connect(SetupCharacterStuff)

IngameFolder.ChildAdded:Connect(function(child)
    CheckIfIsAMap(child)
    CheckIfIsASprayPaint(child)
    CheckIfItIsAMinion(child)
end)

for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
    if plr == lplr then continue end

    SetupCharacterStuff(plr)
end

for _, child in IngameFolder:GetChildren() do
    CheckIfIsAMap(child)
    CheckIfIsASprayPaint(child)
    CheckIfItIsAMinion(child)
end



Visual:AddToggle('MyToggle', {
    Text = 'Esp',
    Default = false, -- Default value (true / false)
    Visible = true,
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the toggle

    Callback = function(Value)
        _G.Esp = Value
    end
})

Other:AddSlider('WAITTIME', {
    Text = 'Solving Time (Generator Puzzle)',
    Default = 1.4,
    Min = 1.4,
    Max = 5,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        _G.AutoDoGensWAITTIME = Value
    end
})

Emotes:AddLabel({
    Text = '<font color="rgb(255,0,0)">[Original]</font> This Is For Original Game Only FE Animations \n <font color="rgb(0,255,0)">[Copy Game]</font> This Is For a Copy Everything Is FE ',
    DoesWrap = true
})

Emotes:AddDropdown('MyDropdown', {
    Values = Gettable_Emotes,
    Default = 0, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected
    Searchable = true, -- true / false, makes the dropdown searchable (great for a long list of values)

    Text = "Emotes Free",
    Visible = true,
    Tooltip = 'Select A Emote', -- Information shown when you hover over the dropdown

    Callback = function(Value)
        _G.Emotes = Value
    end
})

Emotes:AddDropdown('MyDropdown', {
    Values = Exclusive_Emotes,
    Default = 0, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected
    Searchable = true, -- true / false, makes the dropdown searchable (great for a long list of values)

    Text = "Emotes Exclusive",
    Visible = true,
    Tooltip = 'Select A Emote', -- Information shown when you hover over the dropdown

    Callback = function(Value)
        _G.Emotes = Value
    end
})

_G.SepecialDropdownForE = "Original"

Emotes:AddDropdown('MyDropdown', {
    Values = {"CopyGame", "Original"},
    Default = 2, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = "Select A Mode",
    Visible = true,
    Tooltip = 'Select A Mode', -- Information shown when you hover over the dropdown

    Callback = function(Value)
        _G.SepecialDropdownForE = Value
    end
})

Emotes:AddLabel('Play Emote Keybind'):AddKeyPicker('KeyPicker', {
    -- SyncToggleState only works with toggles.
    -- It allows you to make a keybind which has its state synced with its parent toggle

    -- Example: Keybind which you use to toggle flyhack, etc.
    -- Changing the toggle disables the keybind state and toggling the keybind switches the toggle state

    Default = 'H', -- String as the name of the keybind (MB1, MB2 for mouse buttons)
    SyncToggleState = false,


    -- You can define custom Modes but I have never had a use for it.
    Mode = 'Hold', -- Modes: Always, Toggle, Hold

    Text = 'Play Emote Keybind', -- Text to display in the keybind menu
    NoUI = false, -- Set to true if you want to hide from the Keybind menu,

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function(Value)
        
    end,

    -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    ChangedCallback = function(New)
        _G.KeybindStart = New
    end
})

Emotes:AddLabel('Stop Emote KeyBind'):AddKeyPicker('KeyPicker', {
    -- SyncToggleState only works with toggles.
    -- It allows you to make a keybind which has its state synced with its parent toggle

    -- Example: Keybind which you use to toggle flyhack, etc.
    -- Changing the toggle disables the keybind state and toggling the keybind switches the toggle state

    Default = 'X', -- String as the name of the keybind (MB1, MB2 for mouse buttons)
    SyncToggleState = false,


    -- You can define custom Modes but I have never had a use for it.
    Mode = 'Hold', -- Modes: Always, Toggle, Hold

    Text = 'Stop Emote KeyBind', -- Text to display in the keybind menu
    NoUI = false, -- Set to true if you want to hide from the Keybind menu,

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function(Value)

    end,

    -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    ChangedCallback = function(New)
        _G.KeybindStop = New
    end
})

local MyButton = Emotes:AddButton({
    Text = 'Play Emote (Mobile)',
    Func = function()
        _G.OFF = false
        PlayEmote(true)
    end,
    DoubleClick = false,
    Visible = true,
    Tooltip = 'Plays The Emote Selected'
})

local MyButton = Emotes:AddButton({
    Text = 'Stop Emote (Mobile)',
    Func = function()
        _G.OFF = true
    end,
    DoubleClick = false,
    Visible = true,
    Tooltip = 'Stops The Emote Already Playing'
})

local requirespeed = require(game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting) or {}

local what = WalkSpeedO:AddButton({
    Text = "Inf Stamina",
    Func = function()
        SPRINTINGTable.MaxStamina = math.huge
    end,
    DoubleClick = false,
    Visible = true,
    Tooltip = 'gives you inf stamina'
})

local what = WalkSpeedO:AddButton({
    Text = "No Stamina Loss",
    Func = function()
        SPRINTINGTable.StaminaLoss = 0
    end,
    DoubleClick = false,
    Visible = true,
    Tooltip = "no stamina lost"
})

local what = WalkSpeedO:AddButton({
    Text = "Revert Stamina Loss",
    Func = function()
        SPRINTINGTable.StaminaLoss = requirespeed.DefaultConfig.StaminaLoss
    end,
    DoubleClick = false,
    Visible = true,
    Tooltip = 'reverts stamina loss'
})

local what = WalkSpeedO:AddButton({
    Text = "Revert Stamina",
    Func = function()
        SPRINTINGTable.MaxStamina = requirespeed.DefaultConfig.MaxStamina
    end,
    DoubleClick = false,
    Visible = true,
    Tooltip = 'reverts stamina'
})

local what = WalkSpeedO:AddButton({
    Text = "Revert Stamina Gain",
    Func = function()
        SPRINTINGTable.StaminaGain = requirespeed.DefaultConfig.StaminaGain
    end,
    DoubleClick = false,
    Visible = true,
    Tooltip = 'reverts stamina gain'
})

local what = WalkSpeedO:AddButton({
    Text = "Revert Sprint Speed",
    Func = function()
        SPRINTINGTable.SprintSpeed = requirespeed.DefaultConfig.SprintSpeed
    end,
    DoubleClick = false,
    Visible = true,
    Tooltip = 'reverts sprint speed'
})

WalkSpeedO:AddSlider('MySlider', {
    Text = 'Stamina',
    Default = requirespeed.DefaultConfig.MaxStamina,
    Min = 0,
    Max = 1000,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        SPRINTINGTable.MaxStamina = Value
    end
})

WalkSpeedO:AddSlider('MySlider', {
    Text = 'Stamina Gain',
    Default = requirespeed.DefaultConfig.StaminaGain,
    Min = 0,
    Max = 1000,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        SPRINTINGTable.StaminaGain = Value
    end
})

WalkSpeedO:AddSlider('MySlider', {
    Text = 'Stamina Loss',
    Default = requirespeed.DefaultConfig.StaminaLoss,
    Min = 0,
    Max = 1000,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        SPRINTINGTable.StaminaLoss = Value
    end
})
WalkSpeedO:AddSlider('MySlider', {
    Text = 'Sprint Speed',
    Default = requirespeed.DefaultConfig.SprintSpeed,
    Min = 0,
    Max = 1000,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        SPRINTINGTable.SprintSpeed = Value
    end
})

local RenderStepped = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
    esp()
    AutoDoGens()
    for i, v in pairs(SPRINTINGTable) do
        requirespeed[i] = v
    end
end)

Library:OnUnload(function()
    RenderStepped:Disconnect()
    print('Unloaded!')
    Library.Unloaded = true
end)
--

-- UI Stuff

Library.KeybindFrame.Visible = true;

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- I set NoUI so it does not show up in the keybinds menu
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder('ForestFire')
SaveManager:SetFolder('ForestFire/Forsaken')

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()



