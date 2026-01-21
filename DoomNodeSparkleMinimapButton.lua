-- DoomNodeSparkle Minimap Button

local function InitMinimapButton()

-- Make sure settings table exists
if not DoomNodeSparkle_Settings then
  DoomNodeSparkle_Settings = {
    herb = true,
    mining = true,
    chest = true,
    fishing = true,
    skinning = true
  }
end

-- Initialize saved position
DoomNodeSparkle_Settings.minimapAngle = DoomNodeSparkle_Settings.minimapAngle or 210

local minimapButton = CreateFrame("Button", "DoomNodeSparkleMinimapButton", Minimap)
minimapButton:SetWidth(31)
minimapButton:SetHeight(31)
minimapButton:SetFrameStrata("MEDIUM")
minimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

-- Icon texture
local icon = minimapButton:CreateTexture("OVERLAY")
icon:SetTexture("Interface\\Cooldown\\star4")
icon:SetWidth(20)
icon:SetHeight(20)
icon:SetPoint("CENTER", 0, 1)
icon:SetBlendMode("ADD")

-- Border
local overlay = minimapButton:CreateTexture("OVERLAY")
overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
overlay:SetWidth(53)
overlay:SetHeight(53)
overlay:SetPoint("TOPLEFT", 0, 0)

-- Position
local angle = DoomNodeSparkle_Settings.minimapAngle
local function UpdatePosition()
  local x = 80 * math.cos(math.rad(angle))
  local y = 80 * math.sin(math.rad(angle))
  minimapButton:ClearAllPoints()
  minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end
UpdatePosition()
minimapButton:Show()

-- Dragging
local dragging = false
minimapButton:RegisterForDrag("LeftButton")
minimapButton:SetScript("OnDragStart", function()
  dragging = true
end)

minimapButton:SetScript("OnDragStop", function()
  dragging = false
  DoomNodeSparkle_Settings.minimapAngle = angle
end)

minimapButton:SetScript("OnUpdate", function()
  if dragging then
    local mx, my = Minimap:GetCenter()
    local px, py = GetCursorPosition()
    local scale = Minimap:GetEffectiveScale()
    px, py = px / scale, py / scale
    angle = math.deg(math.atan2(py - my, px - mx))
    UpdatePosition()
  end
end)

-- Tooltip
minimapButton:SetScript("OnEnter", function()
  GameTooltip:SetOwner(this, "ANCHOR_LEFT")
  GameTooltip:SetText("DoomNodeSparkle")
  GameTooltip:AddLine("Left-click: Toggle menu", 1, 1, 1)
  GameTooltip:AddLine("Right-click: Status", 1, 1, 1)
  GameTooltip:AddLine("Drag: Move button", 0.5, 0.5, 0.5)
  GameTooltip:Show()
end)

minimapButton:SetScript("OnLeave", function()
  GameTooltip:Hide()
end)

-- Menu frame
local menu = CreateFrame("Frame", "DoomNodeSparkleMenu", UIParent)
menu:SetWidth(220)
menu:SetHeight(200)
menu:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
menu:SetBackdrop({
  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
  tile = true, tileSize = 32, edgeSize = 32,
  insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
menu:SetFrameStrata("DIALOG")
menu:Hide()
menu:EnableMouse(true)
menu:SetMovable(true)
menu:RegisterForDrag("LeftButton")
menu:SetScript("OnDragStart", function() this:StartMoving() end)
menu:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)

-- Title
local title = menu:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -18)
title:SetText("DoomNodeSparkle")

-- Close button
local close = CreateFrame("Button", nil, menu, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", -2, -2)

-- Create checkboxes
local checkboxes = {}
local types = {
  {key = "herb", label = "Herbalism"},
  {key = "mining", label = "Mining"},
  {key = "chest", label = "Treasure"},
  {key = "fishing", label = "Fishing"},
  {key = "skinning", label = "Skinning"}
}

for i, nodeType in ipairs(types) do
  local cb = CreateFrame("CheckButton", "DoomNodeSparkleCheck"..i, menu, "UICheckButtonTemplate")
  cb:SetPoint("TOPLEFT", 20, -40 - (i-1) * 25)
  cb:SetWidth(24)
  cb:SetHeight(24)
  
  local label = cb:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  label:SetPoint("LEFT", cb, "RIGHT", 5, 0)
  label:SetText(nodeType.label)
  
  -- Store the key and label for the closure
  local settingKey = nodeType.key
  local settingLabel = nodeType.label
  
  cb:SetScript("OnClick", function()
    DoomNodeSparkle_Settings[settingKey] = this:GetChecked() and true or false
    local status = this:GetChecked() and "ON" or "OFF"
    DEFAULT_CHAT_FRAME:AddMessage(settingLabel .. ": " .. status)
  end)
  
  checkboxes[nodeType.key] = cb
end

-- Update checkboxes when menu opens
local function UpdateCheckboxes()
  for key, cb in pairs(checkboxes) do
    cb:SetChecked(DoomNodeSparkle_Settings[key])
  end
end

-- Click handlers
minimapButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
minimapButton:SetScript("OnClick", function()
  if arg1 == "LeftButton" then
    if menu:IsShown() then
      menu:Hide()
    else
      UpdateCheckboxes()
      menu:Show()
    end
  elseif arg1 == "RightButton" then
    DEFAULT_CHAT_FRAME:AddMessage("DoomNodeSparkle Status:")
    DEFAULT_CHAT_FRAME:AddMessage("  Herbalism: " .. (DoomNodeSparkle_Settings.herb and "ON" or "OFF"))
    DEFAULT_CHAT_FRAME:AddMessage("  Mining: " .. (DoomNodeSparkle_Settings.mining and "ON" or "OFF"))
    DEFAULT_CHAT_FRAME:AddMessage("  Treasure: " .. (DoomNodeSparkle_Settings.chest and "ON" or "OFF"))
    DEFAULT_CHAT_FRAME:AddMessage("  Fishing: " .. (DoomNodeSparkle_Settings.fishing and "ON" or "OFF"))
    DEFAULT_CHAT_FRAME:AddMessage("  Skinning: " .. (DoomNodeSparkle_Settings.skinning and "ON" or "OFF"))
  end
end)

end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", InitMinimapButton)
