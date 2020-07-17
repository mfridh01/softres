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
            SoftRes.ui.frames = {}
            SoftRes.ui.buttons = {}
      
      SoftRes.state = {}
            SoftRes.state.__index = SoftRes.state
            SoftRes.state.announcedItem = false
            SoftRes.state.alertPlayer = {
                  text = "",
                  state = false,
            }
            SoftRes.state.scanForSoftRes = {
                  text = "",
                  state = false,
            }
      
      SoftRes.items = {}
            SoftRes.items.__index = SoftRes.items

      SoftRes.announcedItem = {
            state = false,
            itemId = nil,
            elegible = {},
            rolls = {},
      }
      SoftRes.preparedItem = {
            itemId = nil,
            elegible = {},
      }
--------------------------------------------------------------------

-- SoftRes Debugging.
---------------------
-- For debugging. We use this to print text.
function SoftRes.debug:print(text)
      if SoftRes.debug.enabled then print(text) end
end
--------------------------------------------------------------------

-- Toggle alert on and off + mode
function SoftRes.state:toggleAlertPlayer(flag, modeText)
      -- same as the above, but for announcedItem
      if flag == true then
            SoftRes.state.alertPlayer.state = false
      elseif flag == false then
            SoftRes.state.alertPlayer.state = true
      end

      if SoftRes.state.alertPlayer.state then
            SoftRes.state.alertPlayer.state = false
      else
            SoftRes.state.alertPlayer.state = true
      end

      if SoftRes.state.alertPlayer.state and modeText then
            SoftRes.state.alertPlayer.text = modeText
      else
            SoftRes.state.alertPlayer.text = ""
      end
end

-- Switch for Chat scanning of SoftReserves.
-- Takes a state-flag or not, then toggles the state of SoftRes scanning.
function SoftRes.state:toggleScanForSoftRes(flag)
      -- If we want to force a state.
      -- We toggle it to the opposite of what we want, and then the toggle function will trigger back.
      if flag == true then
            SoftRes.state.scanForSoftRes.state = false
      elseif flag == false then
            SoftRes.state.scanForSoftRes.state = true
      end

      -- a simple toggle function
      if SoftRes.state.scanForSoftRes.state then
            SoftRes.state.scanForSoftRes.state = false
            SoftRes.state.scanForSoftRes.text = ""
            BUTTONS.scanForSoftResButton:SetText(BUTTONS.scanForSoftResButton.normalText)
            FRAMES.mainFrame.titleRight:SetText("")
      else
            SoftRes.state.scanForSoftRes.state = true
            SoftRes.state.scanForSoftRes.text = "Scanning chat for SoftReserves.\n\n"
            BUTTONS.scanForSoftResButton:SetText(BUTTONS.scanForSoftResButton.activeText)
      end
end

function SoftRes.state.toggleAnnouncedItem(flag)
      -- same as the above, but for announcedItem
      if flag == true then
            SoftRes.state.announcedItem.state = false
      elseif flag == false then
            SoftRes.state.announcedItem.state = true
      end

      if SoftRes.state.announcedItem then
            SoftRes.state.announcedItem.state = false
      else
            SoftRes.state.announcedItem.state = true
      end
end