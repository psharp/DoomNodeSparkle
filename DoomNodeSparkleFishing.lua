-- DoomNodeSparkle - Fishing Pools
-- Shows a pulsing sparkle near the cursor when mousing over a fishing pool tooltip.

local Sparkle = CreateFrame("Frame", "DoomFishingSparkleFrame", UIParent)
Sparkle:SetWidth(48)
Sparkle:SetHeight(48)
Sparkle:SetFrameStrata("TOOLTIP")
Sparkle:Hide()

local tex = Sparkle:CreateTexture(nil, "OVERLAY")
tex:SetAllPoints(Sparkle)
tex:SetTexture("Interface\\Cooldown\\star4")
tex:SetBlendMode("ADD")
tex:SetAlpha(0)

-- State for manual animation
local running = false
local sparkleShown = false
local t = 0
local duration = 0.55

local function TooltipTextLooksLikeFishingPool()
  if not GameTooltip or not GameTooltip.NumLines or GameTooltip:NumLines() < 2 then
    return false
  end

  -- Only trigger for world objects, not bag items or UI elements
  if GameTooltip:GetOwner() then
    return false
  end

  for i = 2, GameTooltip:NumLines() do
    local line = _G["GameTooltipTextLeft" .. i]
    if line then
      local txt = line:GetText()
      if txt then
        -- English matching; if you play another locale, tell me the tooltip text and I'll adjust.
        if string.find(txt, "Fishing") or string.find(txt, "Requires Fishing") then
          return true
        end
      end
    end
  end
  return false
end

local function ShowSparkleAtCursor()
  local x, y = GetCursorPosition()
  local s = UIParent:GetEffectiveScale()
  x, y = x / s, y / s

  Sparkle:ClearAllPoints()
  Sparkle:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x + 18, y + 18)

  t = 0
  running = true
  tex:SetAlpha(0)
  Sparkle:Show()
end

Sparkle:SetScript("OnUpdate", function()
  if not running then return end

  local e = arg1 or 0
  t = t + e

  -- Pulse alpha: quick in, slower out
  local a
  if t < 0.10 then
    a = (t / 0.10) * 0.85
  else
    local outT = (t - 0.10) / (duration - 0.10)
    if outT < 0 then outT = 0 end
    if outT > 1 then outT = 1 end
    a = (1 - outT) * 0.85
  end

  if a < 0 then a = 0 end
  tex:SetAlpha(a)

  -- Cycle colors smoothly
  local cycle = (t / duration) * 3.14159 * 2  -- Full cycle through animation
  local r = (math.sin(cycle) * 0.5 + 0.5) * 0.8 + 0.2
  local g = (math.sin(cycle + 2.09) * 0.5 + 0.5) * 0.8 + 0.2
  local b = (math.sin(cycle + 4.19) * 0.5 + 0.5) * 0.8 + 0.2
  tex:SetVertexColor(r, g, b)

  if t >= duration then
    running = false
    Sparkle:Hide()
  end
end)

-- Hook tooltip
if GameTooltip and GameTooltip.HookScript then
  GameTooltip:HookScript("OnShow", function()
    if TooltipTextLooksLikeFishingPool() and not sparkleShown then
      ShowSparkleAtCursor()
      sparkleShown = true
    end
  end)

  GameTooltip:HookScript("OnTooltipSetItem", function()
    if TooltipTextLooksLikeFishingPool() and not sparkleShown then
      ShowSparkleAtCursor()
      sparkleShown = true
    end
  end)

  GameTooltip:HookScript("OnHide", function()
    running = false
    sparkleShown = false
    Sparkle:Hide()
  end)
else
  -- Very old fallback: poll tooltip every frame
  local Poll = CreateFrame("Frame")
  Poll:SetScript("OnUpdate", function()
    if GameTooltip and GameTooltip:IsShown() and TooltipTextLooksLikeFishingPool() then
      if not Sparkle:IsShown() then
        ShowSparkleAtCursor()
      end
    end
  end)
end
