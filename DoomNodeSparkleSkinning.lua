-- DoomNodeSparkle - Skinning
-- Shows a pulsing sparkle near the cursor when mousing over a skinnable corpse tooltip.

local Sparkle = CreateFrame("Frame", "DoomSkinningSparkleFrame", UIParent)
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
local hideDelayMax = 0.3

local function TooltipTextLooksLikeSkinningNode()
  if DoomNodeSparkle_Settings and not DoomNodeSparkle_Settings.skinning then
    return false
  end
  
  if not GameTooltip or not GameTooltip.NumLines or GameTooltip:NumLines() < 1 then
    return false
  end

  for i = 1, GameTooltip:NumLines() do
    local line = _G["GameTooltipTextLeft" .. i]
    if line then
      local txt = line:GetText()
      if txt then
        -- English matching; if you play another locale, tell me the tooltip text and I'll adjust.
        if string.find(txt, "Skinnable") or string.find(txt, "Skinning") or string.find(txt, "Requires Skinning") then
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
  hideDelay = 0
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
      hideDelay = 0
      running = false
      sparkleShown = false
      tex:SetAlpha(0)
      Sparkle:Hide()
      return
    end
    -- Don't animate during hide delay, just keep sparkle frozen
    return
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

-- Check tooltip when mousing over dead units
local Poll = CreateFrame("Frame")
local checkDelay = 0
Poll:SetScript("OnUpdate", function()
  checkDelay = checkDelay + arg1
  if checkDelay < 0.05 then
    return
  end
  checkDelay = 0
  
  local canSkin = false
  
  -- Check if tooltip is shown AND we're over a dead unit
  if GameTooltip:IsShown() and UnitExists("mouseover") and UnitIsDead("mouseover") then
    if TooltipTextLooksLikeSkinningNode() then
      canSkin = true
    end
  end
  
  if canSkin then
    if not sparkleShown then
      ShowSparkleAtCursor()
      sparkleShown = true
    end
  else
    if sparkleShown then
      hideDelay = hideDelayMax
      sparkleShown = false
      running = false
    end
  end
end)
