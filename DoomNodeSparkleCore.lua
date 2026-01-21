-- DoomNodeSparkle Core

DoomNodeSparkle_Settings = DoomNodeSparkle_Settings or {
  herb = true,
  mining = true,
  chest = true,
  fishing = true,
  skinning = true
}

local function DoomNodeSparkle_OnLoad()
  
  local function PrintHelp()
    DEFAULT_CHAT_FRAME:AddMessage("DoomNodeSparkle Commands:")
    DEFAULT_CHAT_FRAME:AddMessage("/dns herb on/off")
    DEFAULT_CHAT_FRAME:AddMessage("/dns mining on/off")
    DEFAULT_CHAT_FRAME:AddMessage("/dns chest on/off")
    DEFAULT_CHAT_FRAME:AddMessage("/dns fishing on/off")
    DEFAULT_CHAT_FRAME:AddMessage("/dns skinning on/off")
    DEFAULT_CHAT_FRAME:AddMessage("/dns status")
  end
  
  local function PrintStatus()
    DEFAULT_CHAT_FRAME:AddMessage("DoomNodeSparkle Status:")
    DEFAULT_CHAT_FRAME:AddMessage("  Herbalism: " .. (DoomNodeSparkle_Settings.herb and "ON" or "OFF"))
    DEFAULT_CHAT_FRAME:AddMessage("  Mining: " .. (DoomNodeSparkle_Settings.mining and "ON" or "OFF"))
    DEFAULT_CHAT_FRAME:AddMessage("  Treasure: " .. (DoomNodeSparkle_Settings.chest and "ON" or "OFF"))
    DEFAULT_CHAT_FRAME:AddMessage("  Fishing: " .. (DoomNodeSparkle_Settings.fishing and "ON" or "OFF"))
    DEFAULT_CHAT_FRAME:AddMessage("  Skinning: " .. (DoomNodeSparkle_Settings.skinning and "ON" or "OFF"))
  end
  
  SLASH_DOOMNODESPARKLE1 = "/dns"
  SLASH_DOOMNODESPARKLE2 = "/doomnodesparkle"
  SlashCmdList["DOOMNODESPARKLE"] = function(msg)
    msg = strlower(msg)
    
    if msg == "" or msg == "help" then
      PrintHelp()
      return
    end
    
    if msg == "status" then
      PrintStatus()
      return
    end
    
    local nodeType, toggle
    local space = string.find(msg, " ")
    if space then
      nodeType = string.sub(msg, 1, space - 1)
      toggle = string.sub(msg, space + 1)
    else
      DEFAULT_CHAT_FRAME:AddMessage("Usage: /dns <type> on/off")
      return
    end
    
    local enabled
    if toggle == "on" then
      enabled = true
    elseif toggle == "off" then
      enabled = false
    else
      DEFAULT_CHAT_FRAME:AddMessage("Use 'on' or 'off'")
      return
    end
    
    if nodeType == "herb" or nodeType == "herbalism" then
      DoomNodeSparkle_Settings.herb = enabled
      DEFAULT_CHAT_FRAME:AddMessage("Herbalism: " .. (enabled and "ON" or "OFF"))
    elseif nodeType == "mining" or nodeType == "mine" then
      DoomNodeSparkle_Settings.mining = enabled
      DEFAULT_CHAT_FRAME:AddMessage("Mining: " .. (enabled and "ON" or "OFF"))
    elseif nodeType == "chest" or nodeType == "treasure" then
      DoomNodeSparkle_Settings.chest = enabled
      DEFAULT_CHAT_FRAME:AddMessage("Treasure: " .. (enabled and "ON" or "OFF"))
    elseif nodeType == "fishing" or nodeType == "fish" then
      DoomNodeSparkle_Settings.fishing = enabled
      DEFAULT_CHAT_FRAME:AddMessage("Fishing: " .. (enabled and "ON" or "OFF"))
    elseif nodeType == "skinning" or nodeType == "skin" then
      DoomNodeSparkle_Settings.skinning = enabled
      DEFAULT_CHAT_FRAME:AddMessage("Skinning: " .. (enabled and "ON" or "OFF"))
    else
      DEFAULT_CHAT_FRAME:AddMessage("Unknown type: " .. nodeType)
      PrintHelp()
    end
  end
  
  DEFAULT_CHAT_FRAME:AddMessage("DoomNodeSparkle loaded. Type /dns help")
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", DoomNodeSparkle_OnLoad)
