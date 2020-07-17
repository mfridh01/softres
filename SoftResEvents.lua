
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
      elseif event == "GROUP_ROSTER_UPDATE" then
            SoftRes.list:reOrderPlayerList()
            SoftRes.list:showFullSoftResList()
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
            if SoftResConfig.state.autoShowOnLoot then FRAMES.mainFrame:Show() end

      elseif event == "LOOT_SLOT_CLEARED" then
            SoftRes.debug:print("Looted something")

      elseif event == "LOOT_CLOSED" then
            SoftRes.debug:print("Loot window closed.")

      end

end)