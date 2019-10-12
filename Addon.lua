--[[
Addon.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]
 local function alpha(ui, alpha)
    if not ui then
        return
    end
    ui:SetAlpha(alpha)
end

local function initFrameFonts(frame)
    if frame.deadText then
        frame.deadText:SetFont(STANDARD_TEXT_FONT, 13) -- , 'OUTLINE')
        frame.deadText:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
        frame.deadText:SetAlpha(0.6)
    end

    if not frame.healthbar.TextString then
        TextStatusBar_UpdateTextString(frame.healthbar)
        TextStatusBar_UpdateTextString(frame.manabar)

        local function point(text, point, ...)
            if not text then
                return
            end
            text:ClearAllPoints()
            text:SetPoint(point, frame.textureFrame, point, ...)
        end

        point(frame.healthbar.TextString, 'CENTER', -50, 3)
        point(frame.healthbar.LeftText, 'LEFT', 8, 3)
        point(frame.healthbar.RightText, 'RIGHT', -110, 3)

        point(frame.manabar.TextString, 'CENTER', -50, -8)
        point(frame.manabar.LeftText, 'LEFT', 8, -8)
        point(frame.manabar.RightText, 'RIGHT', -110, -8)
    end

    alpha(frame.healthbar.TextString, 0.6)
    alpha(frame.healthbar.LeftText, 0.6)
    alpha(frame.healthbar.RightText, 0.6)

    alpha(frame.manabar.TextString, 0.6)
    alpha(frame.manabar.LeftText, 0.6)
    alpha(frame.manabar.RightText, 0.6)
end

for i, frame in ipairs({TargetFrame, FocusFrame}) do
    frame.nameBackground:Hide()
    frame.nameBackground.Show = nop

    -- frame.name:SetPoint('CENTER', -50, 36)

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
    local classification = UnitClassification(self.unit)
    if classification == 'rareelite' then
        self.borderTexture:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Rare-Elite]])
    end

    if classification == 'minus' then
        self.healthbar:SetHeight(12)
        -- self.name:SetPoint('CENTER', -50, 19)
    else
        self.healthbar:SetHeight(31)
        -- self.name:SetPoint('CENTER', -50, 33)
        self.Background:SetHeight(self.Background:GetHeight() + 19)
    end
end)

local function UnitClassColor(unit)
    return RAID_CLASS_COLORS[select(2, UnitClass(unit))]:GetRGB()
end

hooksecurefunc('TargetFrame_CheckFaction', function(self)
    -- if UnitIsPlayer(self.unit) then
    --     local color = RAID_CLASS_COLORS[select(2, UnitClass(self.unit))]
    --     self.name:SetTextColor(color.r, color.g, color.b)
    -- else
    --     self.name:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    -- end

    if UnitIsPlayer(self.unit) then
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

    -- if self.showPVP and not self.pvpIcon:IsShown() then
    --     local factionGroup = UnitFactionGroup(self.unit)

    --     self.pvpIcon:SetTexture('Interface\\TargetingFrame\\UI-PVP-' .. factionGroup)
    --     self.pvpIcon:Show()
    --     self.pvpIcon:SetDesaturated(true)
    --     self.pvpIcon:SetAlpha(0.7)
    -- else
    --     self.pvpIcon:SetDesaturated(false)
    --     self.pvpIcon:SetAlpha(1)
    -- end
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

hooksecurefunc('PlayerFrame_UpdateLevelTextAnchor', function()
    PlayerLevelText:SetPoint('CENTER', PlayerFrameTexture, 'CENTER', -63, -16)
end)

-- function PlayerFrame_UpdateLevelTextAnchor(level)
--     PlayerLevelText:SetPoint('CENTER', PlayerFrameTexture, 'CENTER', -63, -17)
-- end

-- PlayerLevelText:SetPoint('CENTER', PlayerFrameTexture, 'CENTER', -63, -16)
-- PlayerLevelText.SetPoint = nop

-- TargetFrame.levelText:SetPoint('CENTER', 63, -16)
-- TargetFrame.levelText.SetPoint = nop

hooksecurefunc('TargetFrame_UpdateLevelTextAnchor', function(self)
    self.levelText:SetPoint('CENTER', 63, -16)
end)
