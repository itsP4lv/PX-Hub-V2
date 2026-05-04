-- ╔══════════════════════════════════════════╗
-- ║         PX-Hub V2 | Script Principal     ║
-- ║     Système de double vérification       ║
-- ╚══════════════════════════════════════════╝

-- ─────────────────────────────────────────────
-- SERVICES
-- ─────────────────────────────────────────────
local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService  = game:GetService("HttpService")
local RunService   = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LOCAL_PLAYER = Players.LocalPlayer
local PLAYER_GUI   = LOCAL_PLAYER:WaitForChild("PlayerGui")

-- ─────────────────────────────────────────────
-- PHASE 1 : AUTHENTIFICATION SILENCIEUSE
-- ─────────────────────────────────────────────
local API_BASE = "https://robloxapi-44le.onrender.com/verify?key="

local function verifyLicense(key)
    if not key or key == "" then
        warn("[PX-Hub] Clé de licence absente.")
        return false
    end

    local success, response = pcall(function()
        return HttpService:GetAsync(API_BASE .. HttpService:UrlEncode(key), true)
    end)

    if not success then
        warn("[PX-Hub] Erreur réseau lors de la vérification : " .. tostring(response))
        return false
    end

    local decodeSuccess, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)

    if not decodeSuccess or type(data) ~= "table" then
        warn("[PX-Hub] Réponse API invalide.")
        return false
    end

    if data.success ~= true then
        warn("[PX-Hub] Accès refusé. Raison : " .. tostring(data.message or "Clé invalide"))
        return false
    end

    return true
end

-- Point d'entrée sécurisé
if not verifyLicense(_G.LicenseKey) then
    return
end

-- ─────────────────────────────────────────────
-- PHASE 2 : CONSTRUCTION DE L'INTERFACE
-- (Exécutée uniquement si la clé est valide)
-- ─────────────────────────────────────────────

local TWEEN_INFO_FAST = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local TWEEN_INFO_MED  = TweenInfo.new(0.5,  Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

-- ─────────────────────────────────────────────
-- MODULE UI : Helpers
-- ─────────────────────────────────────────────
local UI = {}

function UI.new(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props) do
        inst[k] = v
    end
    return inst
end

function UI.corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
end

function UI.padding(parent, px)
    local p = Instance.new("UIPadding")
    local u = UDim.new(0, px or 8)
    p.PaddingTop = u ; p.PaddingBottom = u
    p.PaddingLeft = u ; p.PaddingRight = u
    p.Parent = parent
end

function UI.stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(60, 60, 80)
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
end

-- ─────────────────────────────────────────────
-- MODULE ANIM
-- ─────────────────────────────────────────────
local Anim = {}

function Anim.slideIn(obj, offsetX, duration)
    local target = obj.Position
    obj.Position = UDim2.new(
        target.X.Scale, target.X.Offset + offsetX,
        target.Y.Scale, target.Y.Offset
    )
    TweenService:Create(obj, TweenInfo.new(duration or 0.5, Enum.EasingStyle.Quint), {
        Position = target
    }):Play()
end

function Anim.fadeIn(obj, duration)
    obj.BackgroundTransparency = 1
    TweenService:Create(obj, TweenInfo.new(duration or 0.3), {
        BackgroundTransparency = 0
    }):Play()
end

function Anim.tween(obj, props, info)
    TweenService:Create(obj, info or TWEEN_INFO_FAST, props):Play()
end

-- ─────────────────────────────────────────────
-- CONSTRUCTION DU SCREENGUI
-- ─────────────────────────────────────────────
local ScreenGui = UI.new("ScreenGui", {
    Name           = "PXHub_V2",
    ResetOnSpawn   = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent         = PLAYER_GUI,
})

-- Fenêtre principale
local MainFrame = UI.new("Frame", {
    Name             = "MainFrame",
    Size             = UDim2.new(0, 500, 0, 520),
    Position         = UDim2.new(0.5, -250, 0.5, -260),
    BackgroundColor3 = Color3.fromRGB(14, 14, 20),
    BorderSizePixel  = 0,
    Parent           = ScreenGui,
})
UI.corner(MainFrame, 14)
UI.stroke(MainFrame, Color3.fromRGB(50, 50, 75), 1)
Anim.slideIn(MainFrame, -80, 0.55)

-- Ombre portée
UI.new("ImageLabel", {
    Name                 = "Shadow",
    Size                 = UDim2.new(1, 40, 1, 40),
    Position             = UDim2.new(0, -20, 0, -20),
    BackgroundTransparency = 1,
    Image                = "rbxassetid://5554236805",
    ImageColor3          = Color3.fromRGB(0, 0, 0),
    ImageTransparency    = 0.55,
    ScaleType            = Enum.ScaleType.Slice,
    SliceCenter          = Rect.new(23, 23, 277, 277),
    ZIndex               = 0,
    Parent               = MainFrame,
})

-- ── HEADER ────────────────────────────────────
local Header = UI.new("Frame", {
    Name             = "Header",
    Size             = UDim2.new(1, 0, 0, 56),
    BackgroundColor3 = Color3.fromRGB(20, 20, 30),
    BorderSizePixel  = 0,
    Parent           = MainFrame,
})
UI.corner(Header, 14)

-- Correctif visuel : cache les coins bas du header
UI.new("Frame", {
    Size             = UDim2.new(1, 0, 0, 14),
    Position         = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = Color3.fromRGB(20, 20, 30),
    BorderSizePixel  = 0,
    Parent           = Header,
})

-- Logo / Titre
UI.new("TextLabel", {
    Size                 = UDim2.new(1, -160, 1, 0),
    Position             = UDim2.new(0, 16, 0, 0),
    BackgroundTransparency = 1,
    Text                 = "PX-Hub V2",
    TextColor3           = Color3.fromRGB(220, 220, 255),
    TextSize             = 20,
    Font                 = Enum.Font.GothamBold,
    TextXAlignment       = Enum.TextXAlignment.Left,
    Parent               = Header,
})

-- StatusDot
local StatusDot = UI.new("Frame", {
    Name             = "StatusDot",
    Size             = UDim2.new(0, 10, 0, 10),
    Position         = UDim2.new(1, -118, 0.5, -5),
    BackgroundColor3 = Color3.fromRGB(80, 220, 120), -- Vert : session validée
    BorderSizePixel  = 0,
    Parent           = Header,
})
UI.corner(StatusDot, 999)

-- Pulse animation sur le StatusDot
local function pulseDot()
    local t1 = TweenService:Create(StatusDot, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        BackgroundTransparency = 0.5
    })
    t1:Play()
end
pulseDot()

-- Label statut
local StatusLabel = UI.new("TextLabel", {
    Name                 = "StatusLabel",
    Size                 = UDim2.new(0, 100, 1, 0),
    Position             = UDim2.new(1, -104, 0, 0),
    BackgroundTransparency = 1,
    Text                 = "API Online",
    TextColor3           = Color3.fromRGB(80, 220, 120),
    TextSize             = 13,
    Font                 = Enum.Font.Gotham,
    TextXAlignment       = Enum.TextXAlignment.Left,
    Parent               = Header,
})

-- Bouton fermeture
local CloseBtn = UI.new("TextButton", {
    Size                 = UDim2.new(0, 28, 0, 28),
    Position             = UDim2.new(1, -40, 0.5, -14),
    BackgroundColor3     = Color3.fromRGB(200, 60, 60),
    Text                 = "✕",
    TextColor3           = Color3.fromRGB(255, 255, 255),
    TextSize             = 14,
    Font                 = Enum.Font.GothamBold,
    BorderSizePixel      = 0,
    Parent               = Header,
})
UI.corner(CloseBtn, 6)
CloseBtn.MouseButton1Click:Connect(function()
    Anim.tween(MainFrame, { Position = UDim2.new(0.5, -250, 1.2, 0) }, TWEEN_INFO_MED)
    task.wait(0.55)
    ScreenGui:Destroy()
end)

-- ── SÉPARATEUR ────────────────────────────────
UI.new("Frame", {
    Size             = UDim2.new(1, -24, 0, 1),
    Position         = UDim2.new(0, 12, 0, 57),
    BackgroundColor3 = Color3.fromRGB(45, 45, 65),
    BorderSizePixel  = 0,
    Parent           = MainFrame,
})

-- ── SECTION LABEL ─────────────────────────────
UI.new("TextLabel", {
    Size                 = UDim2.new(1, -24, 0, 24),
    Position             = UDim2.new(0, 14, 0, 66),
    BackgroundTransparency = 1,
    Text                 = "▸  Joueurs en ligne",
    TextColor3           = Color3.fromRGB(120, 120, 160),
    TextSize             = 12,
    Font                 = Enum.Font.GothamBold,
    TextXAlignment       = Enum.TextXAlignment.Left,
    Parent               = MainFrame,
})

-- ── BODY (ScrollingFrame) ─────────────────────
local Body = UI.new("ScrollingFrame", {
    Name                   = "Body",
    Size                   = UDim2.new(1, -24, 1, -100),
    Position               = UDim2.new(0, 12, 0, 94),
    BackgroundTransparency = 1,
    ScrollBarThickness     = 3,
    ScrollBarImageColor3   = Color3.fromRGB(90, 90, 150),
    CanvasSize             = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize    = Enum.AutomaticSize.Y,
    BorderSizePixel        = 0,
    Parent                 = MainFrame,
})

local BodyLayout = Instance.new("UIListLayout")
BodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
BodyLayout.Padding   = UDim.new(0, 8)
BodyLayout.Parent    = Body

-- ─────────────────────────────────────────────
-- MODULE : Liste des joueurs
-- ─────────────────────────────────────────────
local PlayerList = {}

local function formatAge(days)
    if days < 1   then return "Nouveau"
    elseif days < 30  then return days .. " j"
    elseif days < 365 then return math.floor(days / 30) .. " mois"
    else return math.floor(days / 365) .. " an(s)" end
end

local function getTeam(player)
    return player.Team and player.Team.Name or "Aucune"
end

function PlayerList.createCard(player)
    local card = UI.new("Frame", {
        Name             = "Card_" .. player.Name,
        Size             = UDim2.new(1, 0, 0, 76),
        BackgroundColor3 = Color3.fromRGB(22, 22, 34),
        BorderSizePixel  = 0,
        LayoutOrder      = player.UserId,
        Parent           = Body,
    })
    UI.corner(card, 10)
    UI.stroke(card, Color3.fromRGB(40, 40, 65), 1)
    Anim.fadeIn(card, 0.3)

    -- Avatar
    local avatarOk, avatarImg = pcall(function()
        return Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size48x48
        )
    end)
    local imgLabel = UI.new("ImageLabel", {
        Size             = UDim2.new(0, 50, 0, 50),
        Position         = UDim2.new(0, 12, 0.5, -25),
        BackgroundColor3 = Color3.fromRGB(35, 35, 50),
        BorderSizePixel  = 0,
        Image            = avatarOk and avatarImg or "",
        Parent           = card,
    })
    UI.corner(imgLabel, 999)

    -- Nom
    UI.new("TextLabel", {
        Size                 = UDim2.new(1, -80, 0, 24),
        Position             = UDim2.new(0, 72, 0, 12),
        BackgroundTransparency = 1,
        Text                 = player.DisplayName .. "  (@" .. player.Name .. ")",
        TextColor3           = Color3.fromRGB(215, 215, 255),
        TextSize             = 14,
        Font                 = Enum.Font.GothamBold,
        TextXAlignment       = Enum.TextXAlignment.Left,
        TextTruncate         = Enum.TextTruncate.AtEnd,
        Parent               = card,
    })

    -- Métadonnées
    UI.new("TextLabel", {
        Size                 = UDim2.new(1, -80, 0, 18),
        Position             = UDim2.new(0, 72, 0, 38),
        BackgroundTransparency = 1,
        Text                 = "ID: " .. player.UserId
                               .. "   Compte: " .. formatAge(player.AccountAge)
                               .. "   Équipe: " .. getTeam(player),
        TextColor3           = Color3.fromRGB(110, 110, 150),
        TextSize             = 12,
        Font                 = Enum.Font.Gotham,
        TextXAlignment       = Enum.TextXAlignment.Left,
        TextTruncate         = Enum.TextTruncate.AtEnd,
        Parent               = card,
    })

    return card
end

function PlayerList.rebuild()
    for _, child in ipairs(Body:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        PlayerList.createCard(p)
    end
end

-- ─────────────────────────────────────────────
-- MODULE : Toggle F4
-- ─────────────────────────────────────────────
local menuVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F4 then
        menuVisible = not menuVisible
        if menuVisible then
            MainFrame.Visible = true
            Anim.tween(MainFrame, {
                Position = UDim2.new(0.5, -250, 0.5, -260),
                BackgroundTransparency = 0
            }, TWEEN_INFO_MED)
        else
            Anim.tween(MainFrame, {
                Position = UDim2.new(0.5, -250, 0.5, -330),
                BackgroundTransparency = 1
            }, TWEEN_INFO_MED)
            task.delay(0.5, function()
                if not menuVisible then
                    MainFrame.Visible = false
                end
            end)
        end
    end
end)

-- ─────────────────────────────────────────────
-- ÉVÉNEMENTS JOUEURS
-- ─────────────────────────────────────────────
Players.PlayerAdded:Connect(function()
    PlayerList.rebuild()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.1)
    PlayerList.rebuild()
end)

-- ─────────────────────────────────────────────
-- INITIALISATION
-- ─────────────────────────────────────────────
PlayerList.rebuild()