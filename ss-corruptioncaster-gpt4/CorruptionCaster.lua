local isRunning = false;

function CorruptionCaster_OnLoad()
  print("Corruption Caster Loaded.");
  CorruptionCasterFrame = CreateFrame("Frame", "CorruptionCasterFrame");
  CorruptionCasterFrame:Show();
  CorruptionCasterFrame:Show();

end

function InitializeButton()
    local button = CreateFrame("Button", "CorruptionCasterButton", UIParent)
    -- 这里进行其他必要的按钮配置
    return button
end
function CorruptionCaster_Toggle()
  isRunning = not isRunning;
  CorruptionCasterButton = InitializeButton()
  if isRunning then
    CorruptionCasterButton:SetText("Stop");
    CorruptionCasterFrame:RegisterEvent("PLAYER_TARGET_CHANGED");
    CorruptionCasterFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
  else
    CorruptionCasterButton:SetText("Start");
    CorruptionCasterFrame:UnregisterEvent("PLAYER_TARGET_CHANGED");
    CorruptionCasterFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
  end
end

function CorruptionCaster_OnEvent(self, event, ...)
  if event == "PLAYER_TARGET_CHANGED" or event == "COMBAT_LOG_EVENT_UNFILTERED" then
    if isRunning then
      CorruptionCaster_CheckAndCastCorruption();
    end
  end
end

function CorruptionCaster_CheckAndCastCorruption()
  local target = "target";
  if UnitExists(target) and not UnitDebuff(target, "Corruption") then
    CastSpellByName("Corruption", target);
  end
end

CorruptionCasterFrame:SetScript("OnEvent", CorruptionCaster_OnEvent);

