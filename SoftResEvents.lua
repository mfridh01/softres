
-- Eventscanning begins here.
--------------------------------------------------------------------

SoftRes.ui.mainFrame:RegisterEvent("PLAYER_LOGIN")

SoftRes.ui.mainFrame:SetScript("OnEvent", function(self,event,...) 

      if event == "PLAYER_LOGIN" then
            if (not SoftResList) or type(SoftResList) ~= "table" then  --  I know it doesn't exist. so set it's default
                  SoftRes.list:createNewSoftResList()
            else
                  SoftRes.debug:print("SoftResList, loaded.")
            end

            if (not SoftResConfig) or type(SoftResConfig) ~= "table" then
                  SoftRes.ui:createDefaultSoftResConfigList()
            else
                  SoftRes.debug:print("SoftResConfig, loaded.")
            end

            SoftRes.ui:useSavedConfigValues() -- Use the variables.
      end


end)