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
function SoftRes.list:getDate() return SoftResList.date end
function SoftRes.list:getZone() return SoftResList.zone end
--------------------------------------------------------------------



function SoftRes.list:doSoftResStuff()
    print(SoftRes.list:getDate())
end