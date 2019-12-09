-- Range.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 12/5/2019, 1:26:24 PM

local RangeCheck = LibStub('LibRangeCheck-2.0')

local Range = CreateFrame('Frame', nil, TargetFrame)

function Range:Load()
    self.elapsed = 0
    self.text = self:CreateFontString(nil, 'OVERLAY', 'NumberFontNormalLarge')
    self.text:SetPoint('BOTTOM', TargetFrame.portrait, 'TOP', 0, 5)
    self:SetScript('OnUpdate', self.OnUpdate)
end

function Range:Update()
    local min, max = RangeCheck:GetRange(TargetFrame.unit)
    if not max then
        self.text:SetText('')
    else
        self.text:SetText(format('%d-%d', min, max))

        if max == 5 then
            self.text:SetTextColor(0, 1, 0)
        elseif max <= 15 then
            self.text:SetTextColor(0, 1, 1)
        elseif max <= 20 then
            self.text:SetTextColor(0.5, 0.5, 1)
        elseif max <= 30 then
            self.text:SetTextColor(1, 0.5, 0)
        elseif max <= 35 then
            self.text:SetTextColor(1, 0, 0)
        end
    end
end

function Range:OnUpdate(elapsed)
    self.elapsed = self.elapsed - elapsed
    if self.elapsed < 0 then
        self.elapsed = 0.1
        self:Update()
    end
end

Range:Load()
