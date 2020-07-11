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

--------------------------------------------------------------------

-- SoftRes functions and tables.
--------------------------------
SoftRes = {}
      SoftRes.debug = {}
            SoftRes.debug.__index = SoftRes.debug
            SoftRes.debug.enabled = true -------------------- DEBUG

      SoftRes.helpers = {}
            SoftRes.helpers.__index = SoftRes.helpers

      SoftRes.list = {}
            SoftRes.list.__index = SoftRes.list

      SoftRes.player = {}
            SoftRes.player.__index = SoftRes.player

      SoftRes.ui = {}
            SoftRes.ui.__index = SoftRes.ui
--------------------------------------------------------------------

-- SoftRes Debugging.
---------------------
-- For debugging. We use this to print text.
function SoftRes.debug:print(text)
      if SoftRes.debug.enabled then print(text) end
end
--------------------------------------------------------------------

-- SoftRes Helpers.
-------------------
-- Takes a string and turns it into a table of words split by defined separator.
-- If there is no separator passed, then it defaults to "<SPACE>"
function SoftRes.helpers:stringSplit(string, separator)
      if separator == nil then
            separator = "%s"
      end
      
      local temp = {}
      
      for str in string.gmatch(string, "([^"..separator.."]+)") do
            table.insert(temp, str)
      end
      
      return temp
end

-- Takes an itemId and returns an itemLink.
function SoftRes.helpers:getItemLinkFromId(itemId)
      if not itemId or string.len(itemId) < 1 then
            return nil
      end
      
      _, itemLink = GetItemInfo(itemId)
      
      return itemLink
end

-- Takes an itemLink and returns an itenId.
function SoftRes.helpers:getItemIdFromLink(itemLink)
      if not itemLink or string.len(itemLink) < 1 then
            return nil
      end

      local itemString = string.match(link, "item[%-?%d:]+")
      if not itemString then return nil end

      local itemId = string.sub(itemString, 6, string.len(itemString));

      if itemId == "" or (not itemId) then return nil end

      return string.sub(itemId, 1, string.find(itemId, ":")-1)
end

-- Takes an itemId and returns the itemRarity
-- 0 = gray, 1 = green, 2 = rare, 3 = epic, 4 = legendary
function SoftRes.helpers:getItemRarityFromId(itemId)
      if not itemId or string.len(itemId) < 1 then
            return nil
      end

      _, _, itemRarity = GetItemInfo(itemId)

      return itemRarity
end
--------------------------------------------------------------------

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

-- Playerhandling.
------------------
-- (create new player), When we first create a player, fill in the layout with blanks/defaults.
function SoftRes.player:new()
      local self = {
            groupPosition = nil, -- The position in group/raid
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

-- PlayerGetters
function SoftRes.player:getSoftReserveTime() return self.softReserve.time end
function SoftRes.player:getSoftReserveItemId() return self.softReserve.itemId end
function SoftRes.player:getSoftReserveReceived() return self.softReserve.received end

-- PlayerSetters
function SoftRes.player:setSoftReserveItemId()

end
--------------------------------------------------------------------



-- UI-Handling.
---------------
-- Create a new config list, with default values.
function SoftRes.ui:createDefaultSoftResConfigList()
      SoftResConfig = {
            ui = {
                  mainFrame = {
                        size = {
                              full = {
                                    width = 555,
                                    height = 700,
                              }
                        }
                  }
            }
      }
end

-- Apply values from saved list, to the frames.
function SoftRes.ui:useSavedConfigValues()
      SoftRes.ui.mainFrame:SetSize(SoftResConfig.ui.mainFrame.size.full.height, SoftResConfig.ui.mainFrame.size.full.width)
end
--------------------------------------------------------------------







-- UI BEGINS HERE.
------------------
SoftRes.ui.mainFrame = CreateFrame("Frame", "SoftResMainFrame", UIParent, "BasicFrameTemplateWithInset")
      SoftRes.ui.mainFrame:SetFrameStrata("HIGH")
      SoftRes.ui.mainFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -10)
      SoftRes.ui.mainFrame:SetMovable(true)
      SoftRes.ui.mainFrame:EnableMouse(true)
      SoftRes.ui.mainFrame:RegisterForDrag("LeftButton")
      SoftRes.ui.mainFrame:SetScript("OnDragStart", SoftRes.ui.mainFrame.StartMoving)
      SoftRes.ui.mainFrame:SetScript("OnDragStop", SoftRes.ui.mainFrame.StopMovingOrSizing)
      SoftRes.ui.mainFrame:Show()

      SoftRes.ui.mainFrame.title = SoftRes.ui.mainFrame:CreateFontString(nil, "Overlay")
            SoftRes.ui.mainFrame.title:SetFontObject("GameFontHighlight")
            SoftRes.ui.mainFrame.title:SetPoint("TOP", SoftRes.ui.mainFrame.TitleBg, "TOP", 0, -3)
            SoftRes.ui.mainFrame.title:SetText("SoftRes - A Soft-Reservation- and Loot distribution helper.")

      SoftRes.ui.mainFrame.fs = SoftRes.ui.mainFrame:CreateFontString(nil, "Overlay")
      SoftRes.ui.mainFrame.fs:SetFontObject("GameFontHighlight")
      SoftRes.ui.mainFrame.fs:SetPoint("TOPLEFT", SoftRes.ui.mainFrame, "TOPLEFT", 15, -32)
      SoftRes.ui.mainFrame.fs:SetJustifyH("LEFT")
      SoftRes.ui.mainFrame.fs:SetText("Soft reserve - List")


SoftRes.ui.buttons.testButton = CreateFrame("Button", "testButton", SoftRes.ui.mainFrame, "UIPanelButtonGrayTemplate")
      SoftRes.ui.buttons.testButton:SetPoint("TOP", SoftRes.ui.mainFrame, "TOP", 0, 0)
      SoftRes.ui.buttons.testButton:SetWidth(100)
      SoftRes.ui.buttons.testButton:SetHeight(20)
      SoftRes.ui.buttons.testButton:SetText("|TInterface\\FriendsFrame\\InformationIcon:10:10:0:0|t")

























-- Eventscanning begins here.
--------------------------------------------------------------------
SoftRes.ui.mainFrame:RegisterEvent("PLAYER_LOGIN")

SoftRes.ui.mainFrame:SetScript("OnEvent", function(self,event,...) 

      if event == "PLAYER_LOGIN" then
            if type(SoftResList) ~= "table" then  --  I know it doesn't exist. so set it's default
                  SoftRes.ui:createNewSoftResList()
            else
                  SoftRes.debug:print("SoftResList, loaded.")
            end

            if type(SoftResConfig) ~= "table" then
                  SoftRes.ui:createDefaultSoftResConfigList()
            else
                  SoftRes.debug:print("SoftResConfig, loaded.")
                  SoftRes.ui:useSavedConfigValues()
            end
      end
      end)