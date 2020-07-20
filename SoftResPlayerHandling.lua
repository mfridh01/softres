-- Playerhandling.
------------------
-- (create new player), When we first create a player, fill in the layout with blanks/defaults.
function SoftRes.player:new(playerName, groupPosition)
      -- If we get a name, use it.
      local self = {
            name = playerName,
            groupPosition = groupPosition,
            removedTime = nil, -- If removed, we log the time.
            softReserve = { -- Softreserved item.
                  time = nil, -- When it was softreserved.
                  itemId = nil, -- Ingame itemId.
                  received = false, -- If it has been received or not. Always defaults to false.
            },
            receivedItems = {} -- Log every received item.
--[[              time = nil, -- Time, when you received the item.
                  rollType = nil, -- MS, OS, FFA, SoftRes, RaidRoll.
                  itemId = nil, -- ingame itemId.
                  roll = nil, -- Winning roll. ]]
      }
      setmetatable(self, SoftRes.player)

      return self
end

-- PlayerGetters
function SoftRes.player:getName() return self.name end
function SoftRes.player:getSoftReserveTime() return self.softReserve.time end
function SoftRes.player:getSoftReserveItemId() return self.softReserve.itemId end
function SoftRes.player:getSoftReserveReceived() return self.softReserve.received end
function SoftRes.player:getPlayerFromPlayerName(name) 
      if not name then return end

      for i = 1, #SoftResList.players do
            if SoftResList.players[i].name == name then
                  return SoftResList.players[i]
            end
      end
end