--[[
Addon.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]


local function initFrameFonts(frame)
    -- frame.name:SetFont(STANDARD_TEXT_FONT, 14)--, 'OUTLINE')
    -- frame.name:SetAlpha(0.6)
    -- frame.name:SetShadowOffset(0, 0)

    if frame.deadText then
        frame.deadText:SetFont(STANDARD_TEXT_FONT, 13)--, 'OUTLINE')
        frame.deadText:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
        frame.deadText:SetAlpha(0.6)
    end

    frame.healthbar.TextString:SetAlpha(0.6)
    frame.healthbar.LeftText:SetAlpha(0.6)
    frame.healthbar.RightText:SetAlpha(0.6)

    frame.manabar.TextString:SetAlpha(0.6)
    frame.manabar.LeftText:SetAlpha(0.6)
    frame.manabar.RightText:SetAlpha(0.6)
end

for i, frame in ipairs({TargetFrame, FocusFrame}) do
    frame.nameBackground:Hide()
    frame.nameBackground.Show = nop

    frame.healthbar.lockColor = true
    frame.healthbar:ClearAllPoints()
    frame.healthbar:SetPoint('BOTTOMRIGHT', frame, 'TOPRIGHT', -106, -53)

    hooksecurefunc(frame.nameBackground, 'SetVertexColor', function(_, ...)
        frame.healthbar:SetStatusBarColor(...)
    end)

    initFrameFonts(frame)
end

initFrameFonts(PlayerFrame)
initFrameFonts(PetFrame)
initFrameFonts(PartyMemberFrame1)
initFrameFonts(PartyMemberFrame2)
initFrameFonts(PartyMemberFrame3)
initFrameFonts(PartyMemberFrame4)

hooksecurefunc('TargetFrame_CheckClassification', function(self)
    if UnitClassification(self.unit) == 'minus' then
        self.healthbar:SetHeight(12)
        -- self.name:SetPoint('CENTER', -50, 19)
    else
        self.healthbar:SetHeight(31)
        -- self.name:SetPoint('CENTER', -50, 33)
        self.Background:SetHeight(self.Background:GetHeight() + 19)
    end
end)

local function UnpackColor(color)
    return color.r, color.g, color.b
end

local function UnitClassColor(unit)
    return UnpackColor(RAID_CLASS_COLORS[select(2, UnitClass(unit))])
end

-- local function UnitSelectionColor(unit)
--     local reaction = UnitReaction(unit, 'player')
--     if reaction then
--         return UnpackColor(FACTION_BAR_COLORS[reaction])
--     end
--     return _G.UnitSelectionColor(unit)
-- end

hooksecurefunc('TargetFrame_CheckFaction', function(self)
    -- if UnitIsPlayer(self.unit) then
    --     local color = RAID_CLASS_COLORS[select(2, UnitClass(self.unit))]
    --     self.name:SetTextColor(color.r, color.g, color.b)
    -- else
    --     self.name:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    -- end

    if UnitIsPlayer(self.unit) and UnitClass(self.unit) then
        self.healthbar:SetStatusBarColor(UnitClassColor(self.unit))
        -- self.name:SetTextColor(UnitSelectionColor(self.unit))
    else
        if not UnitPlayerControlled(self.unit) and UnitIsTapDenied(self.unit) then
            self.healthbar:SetStatusBarColor(0.5, 0.5, 0.5)
        else
            self.healthbar:SetStatusBarColor(UnitSelectionColor(self.unit))
        end
        -- self.name:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
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

local orig_HealthBar_OnValueChanged = HealthBar_OnValueChanged
function HealthBar_OnValueChanged(bar, ...)
    if bar.lockColor then
        return
    end
    return orig_HealthBar_OnValueChanged(bar, ...)
end
