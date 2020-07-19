
-- Eventscanning begins here.
--------------------------------------------------------------------

FRAMES.mainFrame:RegisterEvent("PLAYER_LOGIN")

FRAMES.mainFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

FRAMES.mainFrame:RegisterEvent("CHAT_MSG_PARTY")
FRAMES.mainFrame:RegisterEvent("CHAT_MSG_PARTY_LEADER")
FRAMES.mainFrame:RegisterEvent("CHAT_MSG_RAID")
FRAMES.mainFrame:RegisterEvent("CHAT_MSG_RAID_LEADER")

FRAMES.mainFrame:RegisterEvent("LOOT_OPENED")
FRAMES.mainFrame:RegisterEvent("LOOT_SLOT_CLEARED")
FRAMES.mainFrame:RegisterEvent("LOOT_CLOSED")

FRAMES.mainFrame:RegisterEvent("CHAT_MSG_SYSTEM")

FRAMES.mainFrame:SetScript("OnEvent", function(self,event,...) 

      if event == "PLAYER_LOGIN" then
            if (not SoftResConfig) or type(SoftResConfig) ~= "table" then
                  SoftRes.ui:createDefaultSoftResConfigList()
            else
                  SoftRes.ui:createDefaultSoftResConfigList() -- FOR DEBUGGING PURPOSES
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
      elseif event == "GROUP_ROSTER_UPDATE" then
            SoftRes.list:reOrderPlayerList()
            SoftRes.list:showFullSoftResList()
            SoftRes.list:showPrepSoftResList()
            print("Re-Ordering")
      
      -- listen to softReserves in raid or party
      elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" or event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER" then
            if SoftRes.state.scanForSoftRes.state then
                  arg1, arg2 = ...
                  SoftRes.list:getSoftReserves(arg1, arg2)
                  SoftRes.list:showFullSoftResList()
                  print("Listened to raid")
            end
      
      elseif event == "LOOT_OPENED" then
            SoftRes.debug:print("Loot window opened.")

            -- Get the configvalue and autoShow if enabled.
            if SoftResConfig.state.autoShowOnLoot then
                  FRAMES.mainFrame:Show()

                  -- We want the first page to show up.
                  SoftRes.helpers:toggleTabPage(1)
            end

            -- Reset everything.
            SoftRes.helpers:unPrepareItem()

            -- Alert player.
            SoftRes.state:toggleAlertPlayer(true, "Loot")
            SoftRes.state.lootOpened = true

            -- Populate dropped items.
            SoftRes.list:populateDroppedItems()

      elseif event == "LOOT_SLOT_CLEARED" then
            SoftRes.debug:print("Looted something")
            
            -- Remove the item from the dropped items list.
            SoftRes.helpers:removeHandledItem()

            -- Reset everything.
            SoftRes.helpers:unPrepareItem()

      elseif event == "LOOT_CLOSED" then
            SoftRes.debug:print("Loot window closed.")

            -- Get the configvalue and autoHide if enabled.
            if SoftResConfig.state.autoHideOnLootDone then FRAMES.mainFrame:Hide() end

            -- Reset everything.
            SoftRes.helpers:unPrepareItem()
            SoftRes.droppedItems = {}
            SoftRes.state.lootOpened = false
            SoftRes.state:toggleAlertPlayer(false)
      
      -- Raid Rolls and trades.
      elseif event == "CHAT_MSG_SYSTEM" then
            arg1, arg2, arg3, arg4 = ...
      
            local trade = SoftRes.helpers:stringSplit(arg1, "%s") or nil
            local tradeCommand = trade[5]
            local tradeUser = trade[7]
            local tradeWith = nil
            local listenToRaidRolls = SoftRes.state.listeningToRaidRolls
            local listenToRolls = SoftRes.state.listeningToRolls

            if tradeCommand == "trade" and tradeUser then
                  tradeWith = tradeUser
            elseif listenToRaidRolls then
                  SoftRes.helpers:raidRoll(arg1)
            elseif listenToRolls then
                  SoftRes.helpers:rollForItem(arg1)
            end

            -- show the prepared list.
            SoftRes.list.showPrepSoftResList()
      end
end)