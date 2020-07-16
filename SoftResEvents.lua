
-- Eventscanning begins here.
--------------------------------------------------------------------

FRAMES.mainFrame:RegisterEvent("PLAYER_LOGIN")
FRAMES.mainFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
FRAMES.mainFrame:RegisterEvent("CHAT_MSG_PARTY")
FRAMES.mainFrame:RegisterEvent("CHAT_MSG_PARTY_LEADER")
FRAMES.mainFrame:RegisterEvent("CHAT_MSG_RAID")
FRAMES.mainFrame:RegisterEvent("CHAT_MSG_RAID_LEADER")

FRAMES.mainFrame:SetScript("OnEvent", function(self,event,...) 

      if event == "PLAYER_LOGIN" then
            if (not SoftResList) or type(SoftResList) ~= "table" then  --  I know it doesn't exist. so set it's default
                  SoftRes.list:createNewSoftResList()
            else
                  SoftRes.debug:print("SoftResList, loaded. Do stuff!!")
            end

            if (not SoftResConfig) or type(SoftResConfig) ~= "table" then
                  SoftRes.ui:createDefaultSoftResConfigList()
            else
                  SoftRes.ui:createDefaultSoftResConfigList() -- FOR DEBUGGING PURPOSES
                  SoftRes.debug:print("SoftResConfig, loaded.. Do stuff.")
            end

            SoftRes.ui:useSavedConfigValues() -- Use the variables.
      
      elseif event == "GROUP_ROSTER_UPDATE" then
            SoftRes.list:reOrderPlayerList()
            SoftRes.list:showFullSoftResList()
            print("Re-Ordering")
      
      -- listen to softReserves in raid or party
      elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" or event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER" then
            arg1, arg2 = ...
            SoftRes.list:getSoftReserves(arg1, arg2)
            SoftRes.list:showFullSoftResList()
            print("Listened to raid")
      end

end)