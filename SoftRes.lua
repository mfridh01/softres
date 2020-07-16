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
            SoftRes.state.scanForSoftRes = {
                  text = "",
                  state = false,
            }
--------------------------------------------------------------------

-- SoftRes Debugging.
---------------------
-- For debugging. We use this to print text.
function SoftRes.debug:print(text)
      if SoftRes.debug.enabled then print(text) end
end
--------------------------------------------------------------------

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