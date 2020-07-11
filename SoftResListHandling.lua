-- Listhandling.
----------------
-- Creates a new list with default values.
function SoftRes.list:createNewSoftResList()
    SoftResList = {
          date = date("%y-%m-%d %H:%M:%S"),
          zone = GetRealZoneText(),
          players = {},
          drops = {},
    }
end

-- ListGetters
function SoftRes.list:getDate() return self.date end
function SoftRes.list:getZone() return self.zone end
--------------------------------------------------------------------