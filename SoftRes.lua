aceTimer = LibStub("AceAddon-3.0"):NewAddon("SoftRes", "AceTimer-3.0")
aceComm = LibStub("AceComm-3.0")

-- SoftRes functions and tables.
--------------------------------
SoftRes = {}
      SoftRes.comm = "SoftRes" -- Communicatio prefix.
      SoftRes.enabled = false -- Is the addon enabled or not?
      SoftRes.rollType = ""
      SoftRes.debug = {}
            SoftRes.debug.__index = SoftRes.debug
            SoftRes.debug.enabled = false -------------------- DEBUG

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
            SoftRes.state.forced = false
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
            --SoftRes.droppedItems.__index = SoftRes.droppedItems
      
      SoftRes.skippedItem = 0

      SoftRes.trade = {
            tradeWith = "",
      }

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
            restRollers = {},
      }
      SoftRes.preparedItem = {
            itemId = nil,
            elegible = {},
            softResrved = false,
      }

      SoftRes.announce = {}
            SoftRes.announce.__index = SoftRes.announce

      SoftRes.timers = {
            timers = {},
      }
            SoftRes.timers.__index = SoftRes.timers
            SoftRes.timers.timers.countDownTimer = nil
            SoftRes.timers.timers.raidRollTimer = nil
      
      SoftRes.editPlayer = false
      SoftRes.addPlayer = false
      SoftRes.cancel = {}

      SoftRes.onyxiaFix = {
            onyxia = {18422, 18423},
            nefarian = {19002, 19003},
      }
            --SoftRes.onyxiaFix.__index = SoftRes.onyxiaFix
--------------------------------------------------------------------

-- SoftRes Debugging.
---------------------
-- For debugging. We use this to print text.
function SoftRes.debug:print(text, chat)
      if chat then
            DEFAULT_CHAT_FRAME:AddMessage(text)
      elseif SoftRes.debug.enabled then
            print(text)
      end
end
--------------------------------------------------------------------
-- Send message, using ChatThrottleLib.
function SoftRes.announce:sendMessageToChat(chat, text)

      local raid = UnitInRaid("Player")
      local party = UnitInParty("Player")
      
      if raid and chat == "Party_Leader" then
         chat2 = "RAID_WARNING"
      else
         chat2 = "RAID"
      end
   
      if raid then
            ChatThrottleLib:SendChatMessage("ALERT", "SoftResRollAnnounce", text, chat2, nil, nil, nil, nil, nil)
      elseif party then
            ChatThrottleLib:SendChatMessage("ALERT", "SoftResRollAnnounce", text, "PARTY", nil, nil, nil, nil, nil);
      end
   end


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
function SoftRes.state:toggleScanForSoftRes(announce, flag)
      -- If we want to force a state.
      -- We toggle it to the opposite of what we want, and then the toggle function will trigger back.
      if flag and flag == true then
            SoftRes.state.scanForSoftRes.state = false
      elseif flag == false then
            SoftRes.state.scanForSoftRes.state = true
      end

      local groupType = "/Party"
      local raid = UnitInRaid("Player")
  
      if raid then groupType = "/Raid" end

      -- a simple toggle function
      if SoftRes.state.scanForSoftRes.state then
            SoftRes.state.scanForSoftRes.state = false
            SoftRes.state.scanForSoftRes.text = ""
            BUTTONS.scanForSoftResButton:SetText(BUTTONS.scanForSoftResButton.normalText)
            FRAMES.mainFrame.titleRight:SetText("")

            if announce == true then
                  SoftRes.announce:sendMessageToChat("Party","+----------------------------+")
                  SoftRes.announce:sendMessageToChat("Party_Leader","|| No more reservations taken. GL HF.")

                  -- Hide the announce missing softres button.
                  BUTTONS.announceMissingSoftresButton:Hide()

                  -- Whisper the softresses
                  
                  StaticPopupDialogs["SOFTRES_WHISPER_ALL"] = {
                        text = "Do you want to send out a confirmation to everyone about their reservations?",
                        button1 = "Yes",
                        button2 = "No",
                        OnAccept = function()
                              SoftRes.helpers.whisperSoftRes()
                        end,
                        OnCancel = function (_,reason)
                        end,
                        timeout = 0,
                        whileDead = true,
                        hideOnEscape = true,
                    }
                
                    StaticPopup_Show ("SOFTRES_WHISPER_ALL")
            end

            local function myChatEventHandler(self,event,arg1,...)
                  local filterFuncList = ChatFrame_GetMessageEventFilters(event)
                        if newarg1 then
                              arg1 = newarg
                              -- you should actually probably do this for all of arg2..arg11 since that's what framexml does
                        end
                  -- whoop de do, not filtered, go about our business and display etc
            end
      else
            if announce == true then
                  SoftRes.announce: sendMessageToChat("Party_Leader","|| Everyone! Link your SoftRes items in " .. groupType .. ".")
                  SoftRes.announce: sendMessageToChat("Party","+----------------------------+")
            end

            SoftRes.state.scanForSoftRes.state = true
            --SoftRes.state.scanForSoftRes.text = "Scanning chat for SoftReserves.\n\n"
            BUTTONS.scanForSoftResButton:SetText(BUTTONS.scanForSoftResButton.activeText)

            -- show the announce missing softres button.
            BUTTONS.announceMissingSoftresButton:Show()
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

function SoftRes.announce:raidRollAnnounce()
      SoftRes.debug:print("Announcing raidRoll.")

      -- Get the item, and announce it to the group.
      local announcedItemId = SoftRes.announcedItem.itemId

      -- if the announced Item is bogus.
      if (not announcedItemId) or announcedItemId == "" then return end

      -- Send the announcement to chat, we're using ChatThrottle for this.
      SoftRes.announce:sendMessageToChat("Party_Leader", SoftRes.helpers:getItemLinkFromId(announcedItemId) .. " -> Raid-Rolling.")

      -- Wait 2.5 seconds before rolling.
      aceTimer:ScheduleTimer(function()

            -- Roll the dice.
            RandomRoll(1, GetNumGroupMembers())

            -- Announce to the group, who the winner is.
            aceTimer:ScheduleTimer(function()

                  SoftRes.helpers:announceResult()
            end, 2.5)
      end, 2.5)
end

function SoftRes.announce:softResRollAnnounce()
      SoftRes.debug:print("Announcing softResRoll")

      -- Get the item, and announce it to the group.
      local announcedItemId = SoftRes.announcedItem.itemId

      -- if the announced Item is bogus.
      if (not announcedItemId) or announcedItemId == "" then return end

      -- Get the elegible players.
      local players = {}

      for i = 1, #SoftRes.preparedItem.elegible do
            table.insert(players, SoftRes.preparedItem.elegible[i])
      end


      -- Activate the timer.
      SoftRes.helpers:softResCountDown(players, nil)
end

-- If we detect a roll-penalty.
-- Annoucne it to the raid.
-- Takes a playername, his roll and his penalty.
function SoftRes.announce:rollPenalty(rollUser, rollValue, rollPenalty)
      SoftRes.debug:print("Announcing rollPenalty.")

      -- Send the announcement to chat, we're using ChatThrottle for this.
      SoftRes.announce:sendMessageToChat("Party", "Roll-Penalty detected on " .. rollUser .. ".")
      SoftRes.announce:sendMessageToChat("Party", "Roll = " .. rollValue .. ", Penalty = " .. rollPenalty .. ". New roll value = " .. rollValue - rollPenalty .. ".")
end