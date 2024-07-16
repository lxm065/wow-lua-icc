-- Addon namespace
local addonName, addon = ...
addon.version = "1.0"

-- Global variable to track if Corrosion is enabled
addon.isCorrosionEnabled = false

-- Function to check if the target has Corrosion debuff
function addon:HasCorrosion(target)
    local _, _, _, _, duration, expirationTime, _, _, _, spellId = UnitDebuff(target, "Corrosion")
    return duration ~= nil
end

-- Function to cast Corrosion on the target
function addon:CastCorrosion(target)
    CastSpellByName("Corrosion")
end

-- Function to toggle Corrosion on/off
function addon:ToggleCorrosion()
    addon.isCorrosionEnabled = not addon.isCorrosionEnabled
    addon.CorrosionUI:SetShown(addon.isCorrosionEnabled)
end

-- Main update loop
function addon:OnUpdate()
    if addon.isCorrosionEnabled then
        local target = UnitExists("target") and "target" or nil
        if target and not self:HasCorrosion(target) then
            self:CastCorrosion(target)
        end
    end
end

-- Create the Corrosion UI
function addon:CreateCorrosionUI()
    local frame = CreateFrame("Frame", "CorrosionUI", UIParent)
    frame:SetSize(200, 50)
    frame:SetPoint("CENTER")
    self.CorrosionUI = frame
end

-- Addon initialization
function addon:OnInitialize()
    self:CreateCorrosionUI()
end

-- Addon enable event
function addon:OnEnable()
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
    self:SetScript("OnUpdate", self.OnUpdate)
end

-- Handle player target change event
function addon:PLAYER_TARGET_CHANGED()
    if addon.isCorrosionEnabled then
        self:OnUpdate()
    end
end