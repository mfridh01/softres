-- TODO
-- Ny lista -> Med datum, ML, Zone osv osv osv.

--[[ 
nyLista  = {
      date,
      zone,
      players = {
            (name1) - {
                  softReserve = {
                        time,
                        itemId,
                        received, -- bool
                  },
                  receivedItems = {
                        time,
                        rollType, -- MS, OS osv.
                        itemId,
                        roll,
                  },
            },
            (name2) = { -- osv osv.
            },
      },
      drops = { -- Announced drops
            (1) = {
                  time,
                  itemId,
                  itemLink,
                  rolls = {
                        time,
                        rollType, -- MS, OS osv.
                        player,
                        roll,
                  },
                  handled = {
                        time,
                        player,
                  },
            },
            (2) = { -- osv osv.
            },
      },
}--]]

SoftRes = {}

SoftRes.list = {}
SoftRes.list.__index = SoftRes.list

SoftRes.player = {}
SoftRes.player.__index = SoftRes.player


-- Functions

function SoftRes.list:getDate() return self.date end
function SoftRes.list:getZone() return self.zone end


-- When we first create a player, fill in the layout with blanks/defaults.
function SoftRes.player:new()
      local self = {
            softReserve = { -- Softreserved item.
                  time = nil, -- When it was softreserved.
                  itemId = nil, -- Ingame itemId.
                  received = false, -- If it has been received or not. Always defaults to false.
            },
            receivedItems = { -- Log every received item.
                  time = nil, -- Time, when you received the item.
                  rollType = nil, -- MS, OS, FFA, SoftRes, RaidRoll.
                  itemId = nil, -- ingame itemId.
                  roll = nil, -- Winning roll.
            },
      }
      setmetatable(self, SoftRes.player)

      return self
end

function SoftRes.player:getSoftReserveTime() return self.softReserve.time end
function SoftRes.player:getSoftReserveItemId() return self.softReserve.itemId end
function SoftRes.player:getSoftReserveReceived() return self.softReserve.received end
















-- EventReaderFrame
SoftRes.eventFrame = CreateFrame("Frame")

-- All registered Events.
SoftRes.eventFrame:RegisterEvent("PLAYER_LOGIN")







local function testFill()
      for i = 1, 10, 1 do
            SoftResList.players["TestPlayer-" .. i] = SoftRes.player:new(random(1,100))
      end
end

local function testPrint()
      for k, v in pairs(SoftResList.players) do
            print(v:getSoftReserveItemId())
      end
end





-- EventFunctions
SoftRes.eventFrame:SetScript("OnEvent", function(self,event,...) 

      if event == "PLAYER_LOGIN" then
		if type(SoftResList) ~= "table" then  --  I know it doesn't exist. so set it's default
			SoftResList = {} -- The current list.
				SoftResList.date = date("%y-%m-%d %H:%M:%S")
				SoftResList.zone = nil
				SoftResList.players = {}
				SoftResList.drops = {}
		end

		if type(SoftResConfig) ~= "table" then
			SoftResConfig = {}
		end










            testFill()
            testPrint()


      end
      
end)