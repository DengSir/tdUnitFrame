-- Range.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 12/5/2019, 1:26:24 PM

local RangeCheck = LibStub('LibRangeCheck-2.0')

local Range = CreateFrame('Frame', nil, TargetFrame)

function Range:Load()
    self.elapsed = 0
    self.text = self:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    self.text:SetPoint('BOTTOM', TargetFrame.portrait, 'TOP')
    self:SetScript('OnUpdate', self.OnUpdate)
end

function Range:Update()
    local min, max = RangeCheck:GetRange(TargetFrame.unit)

    self.text:SetText(max and format('%d-%d', min, max) or min .. '+')
end

function Range:OnUpdate(elapsed)
    self.elapsed = self.elapsed - elapsed
    if self.elapsed < 0 then
        self.elapsed = 0.1
        self:Update()
    end
end

Range:Load()
