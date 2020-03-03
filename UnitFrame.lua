-- Addon.lua
-- @Author  : DengSir (tdaddon@163.com)
-- @Link    : https://dengsir.github.io

local OPTIONS_FONT_ALPHA = 0.6

---- TargetFrame
do
    local function CreateText(parent, ...)
        local text = parent:CreateFontString(nil, 'OVERLAY', 'TextStatusBarText')
        text:SetPoint(...)
        text:SetAlpha(OPTIONS_FONT_ALPHA)
        return text
    end

    if not TargetFrame.healthbar.TextString then
        TargetFrame.healthbar.TextString = CreateText(TargetFrame.textureFrame, 'CENTER', -50, 3)
        TargetFrame.healthbar.LeftText = CreateText(TargetFrame.textureFrame, 'LEFT', 8, 3)
        TargetFrame.healthbar.RightText = CreateText(TargetFrame.textureFrame, 'RIGHT', -110, 3)
    end

    if not TargetFrame.manabar.TextString then
        TargetFrame.manabar.TextString = CreateText(TargetFrame.textureFrame, 'CENTER', -50, -8)
        TargetFrame.manabar.LeftText = CreateText(TargetFrame.textureFrame, 'LEFT', 8, -8)
        TargetFrame.manabar.RightText = CreateText(TargetFrame.textureFrame, 'RIGHT', -110, -8)
    end

    local function MoveUp(widget, delta)
        local p, r, rp, x, y = widget:GetPoint(1)
        widget:ClearAllPoints()
        widget:SetPoint(p, r, rp, x, y + delta)
    end

    PlayerName:Hide()
    PlayerName.Show = nop

    TargetFrame.name:SetFont(TargetFrame.name:GetFont(), 14, 'OUTLINE')

    PlayerFrame.healthbar:EnableMouse(false)
    PlayerFrame.manabar:EnableMouse(false)

    MoveUp(TargetFrame.name, 16)
    MoveUp(TargetFrame.deadText, 8)
    MoveUp(TargetFrame.healthbar.TextString, 8)
    MoveUp(TargetFrame.healthbar.LeftText, 8)
    MoveUp(TargetFrame.healthbar.RightText, 8)

    MoveUp(PlayerFrame.healthbar.LeftText, 8)
    MoveUp(PlayerFrame.healthbar.RightText, 8)

    hooksecurefunc('LocalizeFrames', function()
        MoveUp(PlayerFrame.healthbar.TextString, 8)
    end)
end

local function InitAlpha(widget)
    if widget then
        widget:SetAlpha(OPTIONS_FONT_ALPHA)
    end
end

local function InitFrameFonts(frame)
    if frame.deadText then
        frame.deadText:SetFont(STANDARD_TEXT_FONT, 13)
        frame.deadText:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
        frame.deadText:SetAlpha(OPTIONS_FONT_ALPHA)
    end

    local hb = frame.healthbar
    local mb = frame.manabar

    InitAlpha(hb.TextString)
    InitAlpha(hb.LeftText)
    InitAlpha(hb.RightText)

    InitAlpha(mb.TextString)
    InitAlpha(mb.LeftText)
    InitAlpha(mb.RightText)
end

for i, frame in ipairs({TargetFrame, FocusFrame}) do
    frame.nameBackground:Hide()
    frame.nameBackground.Show = nop

    frame.healthbar.lockColor = true
    frame.healthbar:ClearAllPoints()
    frame.healthbar:SetPoint('BOTTOMRIGHT', frame, 'TOPRIGHT', -106, -53)

    InitFrameFonts(frame)
end

InitFrameFonts(PlayerFrame)
InitFrameFonts(PetFrame)
InitFrameFonts(PartyMemberFrame1)
InitFrameFonts(PartyMemberFrame2)
InitFrameFonts(PartyMemberFrame3)
InitFrameFonts(PartyMemberFrame4)

local select = select
local hooksecurefunc = hooksecurefunc

local UnitClassBase = UnitClassBase
local UnitClassification = UnitClassification
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapDenied = UnitIsTapDenied
local UnitPlayerControlled = UnitPlayerControlled
local UnitSelectionColor = UnitSelectionColor
local HealthBar_OnValueChanged = HealthBar_OnValueChanged

local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local PlayerFrameHealthBar = PlayerFrameHealthBar
local PlayerLevelText = PlayerLevelText
local PlayerFrameTexture = PlayerFrameTexture

local function UnitClassColor(unit)
    local class = UnitClassBase(unit)
    local color = class and RAID_CLASS_COLORS[class]
    if color then
        return color.r, color.g, color.b
    end
    return 1, 1, 1
end

hooksecurefunc('TargetFrame_CheckClassification', function(self)
    local classification = UnitClassification(self.unit)
    if classification == 'rareelite' then
        self.borderTexture:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Rare-Elite]])
    end

    if classification == 'minus' then
        self.healthbar:SetHeight(12)
    else
        self.healthbar:SetHeight(31)
        self.Background:SetHeight(self.Background:GetHeight() + 19)
    end
end)

hooksecurefunc('TargetFrame_CheckFaction', function(self)
    if UnitIsPlayer(self.unit) then
        if not self.healthbar.disconnected then
            self.healthbar:SetStatusBarColor(UnitClassColor(self.unit))
        else
            self.healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
        end
    else
        if not UnitPlayerControlled(self.unit) and UnitIsTapDenied(self.unit) then
            self.healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
        else
            self.healthbar:SetStatusBarColor(UnitSelectionColor(self.unit))
        end
    end
end)

hooksecurefunc('PlayerFrame_ToPlayerArt', function()
    PlayerFrameHealthBar:SetPoint('TOPLEFT', 106, -22)
    PlayerFrameHealthBar:SetHeight(31)
    PlayerFrameHealthBar.lockColor = true
    PlayerFrameHealthBar:SetStatusBarColor(UnitClassColor('player'))
end)

hooksecurefunc('PlayerFrame_ToVehicleArt', function()
    PlayerFrameHealthBar:SetHeight(12)
    PlayerFrameHealthBar.lockColor = nil
    HealthBar_OnValueChanged(PlayerFrameHealthBar, PlayerFrameHealthBar:GetValue())
end)

hooksecurefunc('PlayerFrame_UpdateLevelTextAnchor', function()
    PlayerLevelText:SetPoint('CENTER', PlayerFrameTexture, 'CENTER', -63, -16)
end)

hooksecurefunc('TargetFrame_UpdateLevelTextAnchor', function(self)
    self.levelText:SetPoint('CENTER', 63, -16)
end)
