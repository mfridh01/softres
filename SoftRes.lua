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
            SoftRes.state.lootOpened = false
            SoftRes.state.announcedItem = false
            SoftRes.state.listeningToRolls = false
            SoftRes.state.listeningToRaidRolls = false
            SoftRes.state.announcedResult = false
            SoftRes.state.rollingForLoot = false
            SoftRes.state.alertPlayer = {
                  text = "",
                  state = false,
            }
            SoftRes.state.scanForSoftRes = {
                  text = "",
                  state = false,
            }
      
      SoftRes.droppedItems = {}
            SoftRes.droppedItems.__index = SoftRes.droppedItems

      SoftRes.announcedItem = {
            state = false,
            itemId = nil,
            elegible = {},
            rolls = {},
            tieRollers = {},
            highestRoll = 0,
            softReserved = false,
            shitRolls = {},
            manyRolls = {},
            notElegibleRolls = {},
            
      }
      SoftRes.preparedItem = {
            itemId = nil,
            elegible = {},
            softResrved = false,
      }

      SoftRes.announce = {}
            SoftRes.announce.__index = SoftRes.announce
--------------------------------------------------------------------

-- SoftResDB, a table with saved values that will be kept forever.
------------------------------------------------------------------
SoftResDB = {
      shitRollers = {},
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

function SoftRes.state:toggleAnnouncedItem(flag)
      -- same as the above, but for announcedItem
      if flag == true then
            SoftRes.announcedItem.state = false
      elseif flag == false then
            SoftRes.announcedItem.state = true
      end

      if SoftRes.announcedItem.state then
            SoftRes.announcedItem.state = false
            SoftRes.announcedItem.itemId = nil
            SoftRes.announcedItem.elegible = {}
            SoftRes.announcedItem.softReserved = false
            BUTTONS.announceRollsButton:Hide()
      else
            SoftRes.announcedItem.state = true
            SoftRes.announcedItem.itemId = SoftRes.preparedItem.itemId
            SoftRes.announcedItem.elegible = SoftRes.preparedItem.elegible
            BUTTONS.announceRollsButton:Show()
      end

      SoftRes.debug:print(SoftRes.announcedItem.state)
end

function SoftRes.state:toggleListenToRolls(flag)
      -- same as the above
      if flag == true then
            SoftRes.state.listeningToRolls = false
      elseif flag == false then
            SoftRes.state.listeningToRolls = true
      end

      if SoftRes.state.listeningToRolls then
            SoftRes.state.listeningToRolls = false
      else
            SoftRes.state.listeningToRolls = true
      end

      SoftRes.debug:print(SoftRes.state.listeningToRolls)
end

function SoftRes.state:toggleListenToRaidRolls(flag)
      -- same as the above
      if flag == true then
            SoftRes.state.listeningToRaidRolls = false
      elseif flag == false then
            SoftRes.state.listeningToRaidRolls = true
      end

      if SoftRes.state.listeningToRaidRolls then
            SoftRes.state.listeningToRaidRolls = false
      else
            SoftRes.state.listeningToRaidRolls = true
      end

      SoftRes.debug:print(SoftRes.state.listeningToRaidRolls)
end

-- Toggle roling for loot
function SoftRes.state:toggleRollingForLoot(flag, modeText)
      -- same as the above, but for announcedItem
      if flag == true then
            SoftRes.state.rollingForLoot = false
      elseif flag == false then
            SoftRes.state.rollingForLoot = true
      end

      if SoftRes.state.rollingForLoot then
            SoftRes.state.rollingForLoot = false
      else
            SoftRes.state.rollingForLoot = true
      end

end

-- ANNOUNCE!!
-------------
function SoftRes.announce:softResAnnounce()

end