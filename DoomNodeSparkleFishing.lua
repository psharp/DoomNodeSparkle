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
local savedX, savedY = 0, 0
local t = 0
local duration = 0.35
local hideDelay = 0
local hideDelayMax = 0.5

local function TooltipTextLooksLikeFishingPool()  if DoomNodeSparkle_Settings and not DoomNodeSparkle_Settings.fishing then
    return false
  end
    if not GameTooltip or not GameTooltip.NumLines or GameTooltip:NumLines() < 2 then
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
  -- Capture cursor position immediately
  local x, y = GetCursorPosition()
  local s = UIParent:GetEffectiveScale()
  savedX, savedY = x / s, y / s

  Sparkle:ClearAllPoints()
  Sparkle:SetPoint("CENTER", UIParent, "BOTTOMLEFT", savedX, savedY)

  t = 0
  running = true
  tex:SetAlpha(0)
  Sparkle:Show()
end

Sparkle:SetScript("OnUpdate", function()
  local e = arg1 or 0
  
  -- Handle hide delay
  if hideDelay > 0 then
    hideDelay = hideDelay - e
    if hideDelay <= 0 then
      running = false
      sparkleShown = false
      Sparkle:Hide()
      return
    end
  end
  
  if not running then return end

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

  -- Cycle through bright green -> white -> yellow -> pink
  local colorProgress = math.mod(t / duration, 1)
  local r, g, b
  
  if colorProgress < 0.25 then
    -- Green to White
    local p = colorProgress / 0.25
    r = p
    g = 1
    b = p
  elseif colorProgress < 0.5 then
    -- White to Yellow
    local p = (colorProgress - 0.25) / 0.25
    r = 1
    g = 1
    b = 1 - p
  elseif colorProgress < 0.75 then
    -- Yellow to Pink
    local p = (colorProgress - 0.5) / 0.25
    r = 1
    g = 1 - (0.5 * p)
    b = 0.75 * p
  else
    -- Pink to Green
    local p = (colorProgress - 0.75) / 0.25
    r = 1 - p
    g = 0.5 + (0.5 * p)
    b = 0.75 - (0.75 * p)
  end
  
  tex:SetVertexColor(r, g, b)

  if t >= duration then
    -- Loop the animation instead of stopping
    t = 0
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
    if sparkleShown then
      hideDelay = hideDelayMax
      sparkleShown = false
    end
  end)
else
  -- Very old fallback: poll tooltip every frame
  local Poll = CreateFrame("Frame")
  Poll:SetScript("OnUpdate", function()
    if GameTooltip and GameTooltip:IsShown() and TooltipTextLooksLikeFishingPool() then
      if not sparkleShown then
        ShowSparkleAtCursor()
        sparkleShown = true
      end
    else
      if sparkleShown then
        running = false
        sparkleShown = false
        Sparkle:Hide()
      end
    end
  end)
end
