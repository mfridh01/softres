-- Eventscanning begins here.
--------------------------------------------------------------------

local tradeCommand = ""
local tradeUser = ""
local tradeWith = nil
local tradeItem = nil

FRAMES.mainFrame:RegisterEvent("PLAYER_LOGIN")

FRAMES.mainFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

FRAMES.mainFrame:RegisterEvent("CHAT_MSG_PARTY")
FRAMES.mainFrame:RegisterEvent("CHAT_MSG_PARTY_LEADER")
FRAMES.mainFrame:RegisterEvent("CHAT_MSG_RAID")
FRAMES.mainFrame:RegisterEvent("CHAT_MSG_RAID_LEADER")

FRAMES.mainFrame:RegisterEvent("LOOT_READY")
FRAMES.mainFrame:RegisterEvent("LOOT_SLOT_CLEARED")
FRAMES.mainFrame:RegisterEvent("LOOT_CLOSED")

FRAMES.mainFrame:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED")
FRAMES.mainFrame:RegisterEvent("CHAT_MSG_LOOT")
FRAMES.mainFrame:RegisterEvent("UI_INFO_MESSAGE")

FRAMES.mainFrame:RegisterEvent("CHAT_MSG_SYSTEM")

FRAMES.mainFrame:SetScript("OnEvent", function(self,event,...)

      if event == "PLAYER_LOGIN" then
            if (not SoftResConfig) or type(SoftResConfig) ~= "table" then
                  SoftRes.ui:createDefaultSoftResConfigList()
            else
                  --SoftRes.ui:createDefaultSoftResConfigList() -- FOR DEBUGGING PURPOSES
                  SoftRes.debug:print("SoftResConfig, loaded.. Do stuff.")
            end

            -- Set the saved config values.
            SoftRes.ui:useSavedConfigValues() -- Use the variables.

            if (not SoftResList) or type(SoftResList) ~= "table" then  --  I know it doesn't exist. so set it's default
                  SoftRes.list:createNewSoftResList()
            else
                  -- show the list
                  SoftRes.list:showFullSoftResList()

                  -- set the dropdown menu
                  BUTTONS.editPlayerDropDownInit()
                  SoftRes.debug:print("SoftResList, loaded. Do stuff!!")
            end
      
      -- If a new players joined the group, or the group is re-ordered.
      elseif event == "GROUP_ROSTER_UPDATE" and SoftRes.enabled then
            SoftRes.list:reOrderPlayerList()
            SoftRes.list:showFullSoftResList()
            SoftRes.list:showPrepSoftResList()
      
      -- listen to softReserves in raid or party
      elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" or event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER" and SoftRes.enabled then

            if SoftRes.state.scanForSoftRes.state then
                  arg1, arg2 = ...
                  SoftRes.list:getSoftReserves(arg1, arg2)
                  SoftRes.list:showFullSoftResList()
            end
      
      elseif event == "LOOT_READY" and SoftRes.enabled then

            SoftRes.debug:print("Loot window opened.")

            -- Populate dropped items.
            local handledBySoftRes = SoftRes.list:populateDroppedItems()

            -- Check to see if we get any loot that is configurated to be handled by the addon.

            -- Get the configvalue and autoShow if enabled.
            if SoftResConfig.state.autoShowOnLoot and handledBySoftRes then
                  FRAMES.mainFrame:Show()

                  -- We want the first page to show up.
                  SoftRes.helpers:toggleTabPage(1)
            end

            -- Reset everything.
            SoftRes.helpers:unPrepareItem()

            -- Alert player.
            SoftRes.state:toggleAlertPlayer(true, "Loot")
            SoftRes.state.lootOpened = true

            -- Always show the prepare button.
            BUTTONS.prepareItemButton:Show()
            
            -- Show skip-button.
            if #SoftRes.droppedItems > 1 then
                  BUTTONS.skipItemButton:Show()
            else
                  BUTTONS.skipItemButton:Hide()
            end

      elseif event == "LOOT_SLOT_CLEARED" and SoftRes.enabled then

            SoftRes.debug:print("Looted something")
            
            -- Remove the item from the dropped items list.
            SoftRes.helpers:removeHandledItem()

            -- Reset everything.
            SoftRes.helpers:unPrepareItem()

            -- Always show prepare button.
            BUTTONS.prepareItemButton:Show()

            -- Show skip-button.
            if #SoftRes.droppedItems > 1 then
                  BUTTONS.skipItemButton:Show()
            else
                  BUTTONS.skipItemButton:Hide()
            end

      elseif event == "LOOT_CLOSED" and SoftRes.enabled then

            SoftRes.debug:print("Loot window closed.")

            -- Get the configvalue and autoHide if enabled.
            if SoftResConfig.state.autoHideOnLootDone then FRAMES.mainFrame:Hide() end

            -- Reset everything.
            SoftRes.helpers:unPrepareItem()
            SoftRes.droppedItems = {}
            SoftRes.state.lootOpened = false
            SoftRes.state:toggleAlertPlayer(false)

            -- Always hide prepare button.
            BUTTONS.prepareItemButton:Hide()

      -- Raid Rolls and trades.
      elseif event == "CHAT_MSG_SYSTEM" and SoftRes.enabled then
            arg1, arg2, arg3, arg4 = ...
      
            local trade = SoftRes.helpers:stringSplit(arg1, "%s") or nil
            tradeCommand = trade[5]
            tradeUser = trade[7]
            tradeWith = nil
            local listenToRaidRolls = SoftRes.state.listeningToRaidRolls
            local listenToRolls = SoftRes.state.listeningToRolls

            if tradeCommand == "trade" and tradeUser then
                  tradeWith = tradeUser
            elseif listenToRaidRolls then
                  SoftRes.helpers:raidRollForItem(arg1)
            elseif listenToRolls then
                  SoftRes.helpers:rollForItem(arg1)
            end

            -- show the prepared list.
            SoftRes.list.showPrepSoftResList()
      
      -- got loot.
      elseif event == "CHAT_MSG_LOOT" and SoftRes.enabled then
            arg1, _, _, _, arg5 = ...

            SoftRes.helpers:handleLoot(arg1, arg5)

      -- Trades again.
      elseif event == "UI_INFO_MESSAGE" and SoftRes.enabled then
            arg1, arg2 = ...
      
            -- Om man har trade:at et item.
            if arg2 == "Trade complete." and tradeWith and tradeItem then

                  -- Traded with whom?
                  local tempTradeWith = tradeWith:sub(1, -2)
                  local waitingIndex = 0

                  -- Search through the waiting list.
                  -- we only want to announce the trades with items that are actually won by anyone.
                  for i = 1, #SoftResList.waitingForItems do
                        local listedPlayer = SoftResList.waitingForItems[i]

                        if listedPlayer[1] == tempTradeWith and tonumber(listedPlayer[2]) == tonumber(tradeItem) then
                              SoftRes.announce:sendMessageToChat("Party_Leader", SoftRes.helpers:getItemLinkFromId(tradeItem) .. " has been handed to " .. tempTradeWith .. ".")
                              waitingIndex = i
                        end
                  end

                  -- Delete from the list.
                  table.remove(SoftResList.waitingForItems, waitingIndex)
                  tradeWith = nil
                  tradeItem = nil
            end
      
      elseif event == "TRADE_PLAYER_ITEM_CHANGED" and SoftRes.enabled then
            for i = 1, 7, 1 do
                  local chatItemLink = GetTradePlayerItemLink(i) or nil
                  if chatItemLink and tradeWith then
            
                        for j = 1, #SoftResList.waitingForItems do
                              local listedPlayer = SoftResList.waitingForItems[j]
                              local tempTradeWith = tradeWith:sub(1, -2)
                            
                              if listedPlayer[1] == tempTradeWith and tonumber(listedPlayer[2]) == tonumber(SoftRes.helpers:getItemIdFromLink(chatItemLink)) then
                                    tradeItem = tonumber(SoftRes.helpers:getItemIdFromLink(chatItemLink))
                                    break
                              end
                        end            
                  end
            end
      end
end)

-- Slashcommands
local function slashCommands(msg, editbox)
      -- pattern matching that skips leading whitespace and whitespace between cmd and args
      -- any whitespace at end of args is retained
      local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
            
      if cmd == "show" then
            if FRAMES.mainFrame:IsShown() then
                  FRAMES.mainFrame:Hide()
            else
                  FRAMES.mainFrame:Show()
            end
      elseif cmd == "hide" then
            FRAMES.mainFrame:Hide()
      elseif cmd == "enable" then
            BUTTONS.enableSoftResAddon:SetChecked(true)
            SoftRes.enabled = true
      elseif cmd == "disable" then
            BUTTONS.enableSoftResAddon:SetChecked(false)
            SoftRes.enabled = false
      else
            print("print","Syntax: /softres (show||hide, enable|disable)");
      end
      
      if BUTTONS.enableSoftResAddon:GetChecked() == true then
            printText = "SoftRes is Enabled."
      else
            printText = "SoftRes is Disabled."
      end
end

SLASH_SOFTRES1 = '/softres'
SlashCmdList["SOFTRES"] = slashCommands
