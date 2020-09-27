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
      if not itemId then
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

      local itemString = string.match(itemLink, "item[%-?%d:]+")
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

-- Takes a string, ex: Playername, and formats it to first char to upper, rest lower.
function SoftRes.helpers:formatPlayerName(string)

      -- if string.len(string) < 2 then return false end

      -- Get the character size for the first letter.
      -- local charSize = string:byte(1)


      --local lower = string.lower(string)

      --return (lower:gsub("^%l", string.upper))
      return string
end

-- Gets called when an item gets dropped on the button icon.
function SoftRes.helpers:getItemInfoFromDragged()
      local type, itemId, itemName  = GetCursorInfo()

      -- Check to see that the type is item.
      if type == "item" then

            -- Remove the dragged item from the cursor.
            ClearCursor();

            -- Get the icon.
            local itemIcon = GetItemIcon(itemId)

            -- Change the texture, to the button.
            BUTTONS.announcedItemButton.texture:SetTexture(itemIcon)

            -- set the prepared item.
            SoftRes.preparedItem.itemId = itemId

            return itemId
      end
end

-- Takes a player name and returns the player item.
function SoftRes.helpers:getPlayerFromName(name)
      if not name then return end

      for i = 1, #SoftResList.players do
            if SoftResList.players[i].name == name then
                  return SoftResList.players[i]
            end
      end

      return nil
end

-- Takes a string, turns it into a number and checks so that the value is between the min or max.
-- If the value is under min, it will return min. If it's over max, it will return max.
-- If it's a string, it will return false.
function SoftRes.helpers:returnMinBetweenOrMax(string, min, max)
      local text = tonumber(string)

      if type(text) ~= "number" then
          return false
      else
          if text < min then
              return min
          elseif text > max then
              return max
          else
              return text
          end
      end
end

-- Takes an Index-Value table and searches for the string.
-- If it finds it, returns true.
function SoftRes.helpers:findStringInTable(table, string)
      for i = 1, #table do
            if table[i] == string then
                  return string
            end
      end

      return false
end

-- Takes a player name and returns the class color of said player.
function SoftRes.helpers:getClassColorFromName(name)
      local class, ucaseClass, _ = UnitClass(name)
      local rPerc, gPerc, bPerc, argbHex = GetClassColor(ucaseClass)

      return argbHex
end

-- Onyxia fix (all fixes).
-- Onyxia head have two versions. We make them both the same.
-- Takes a dropped ItemId and a SoftReserved itemId. Returns same number of both.
function SoftRes.helpers:onyxiaFix(dropId, reserveId)
      local itemId = nil
      local reservedItemId = nil

      -- Go through the items with same names, but still different. IE Onyxia head.
      for k, v in pairs(SoftRes.onyxiaFix) do
            if tonumber(dropId) == v[1] or tonumber(dropId) == v[2] then
                  if tonumber(reserveId) == v[1] or tonumber(reserveId) == v[2] then
                        itemId = v[1]
                        reservedItemId = v[1]
                        return itemId, reservedItemId
                  end
            end
      end

      -- If we don't find the onyxa reserve, we simply return the passed values.
      return dropId, reserveId
end

-- Takes a rollType and returns true or false if that rollType has a penalty for it or not.
-- Checks for the value of the corresponding rolltype and if it's checked or not.
function SoftRes.helpers:getPenaltyStatus(rollType)
      -- We only check for MS and OS rolls.
      if rollType == "ms" or rollType == "os" then
            local isOn = SoftResConfig.state.addPenalty
            local rollTypeValue = SoftResConfig.dropDecay[rollType].value

            if isOn and rollTypeValue > 0 then
                  return true
            end

            return false
      end
      
      return nil
end

-- Shows a simple pop-up message window, with an OK button.
-- Takes a text-string as a parameter for displaying text.
function SoftRes.helpers:showPopupWindow(text)
      local alertText = SoftRes.state.alertPlayer.text

      if alertText == "Scan" then alertText = " chat for SoftReserves."
      elseif alertText == "Prep" then alertText = "An item is prepared for distribution."
      elseif alertText == "Anno" then alertText = "Announced an item and still taking rolls.\nDistribution not yet finnished."
      elseif alertText == "Loot" then alertText = "The lootwindow is still opened."
      elseif alertText == "Add" then alertText = "Adding a new player."
      elseif alertText == "Del" then alertText = "Deleteing a player."
      end


      StaticPopupDialogs["SOFTRES_MSG_WINDOW"] = {
            text = alertText .. "\n\nFinish that before continuing.",
            button1 = "OK",
            OnAccept = function()

            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
      }
      
      StaticPopup_Show ("SOFTRES_MSG_WINDOW")
end

-- Returns true or false, depending on wether there is something running already.
function SoftRes.helpers:checkAlertPlayer(mode)
      if SoftRes.state.alertPlayer.state and SoftRes.state.alertPlayer.text ~= mode then
            SoftRes.helpers:showPopupWindow()
            return false
      end

      return true
end

-- Sets the text to a button.
function SoftRes.helpers:setButtonText(button, text)
      if button and text then
            button:SetText(text)
      end
end

-- Takes an itemId, checks which players has soft-reserved it or has already won it.
-- Returns a table of playernames.
function SoftRes.helpers:getSoftReservers(itemId)
      -- check the itemId
      if not itemId or itemId == "" then return false end

      local softReservers = {}
      for i = 1, #SoftResList.players do

            -- Onyxia head fix.
            -- Since there are two versions of the Onyxia Head, we have to check for both of them.
            itemId, SoftResList.players[i].softReserve.itemId = SoftRes.helpers:onyxiaFix(itemId, SoftResList.players[i].softReserve.itemId)

            -- We search for the player(s) who has SoftReserved this item.
            if tonumber(SoftResList.players[i].softReserve.itemId) == tonumber(itemId) then

                  -- Check to see if the player has received it already.
                  if not SoftResList.players[i].softReserve.received then
                        
                        -- Set the item to softReserved.
                        SoftRes.announcedItem.softReserved = true

                        -- Push the player to the table of elegible players.
                        table.insert(softReservers, SoftResList.players[i].name)
                        SoftRes.debug:print("Player: " .. SoftResList.players[i].name .. " is added to the 'elegible' list.")
                  end
            else
                  SoftRes.debug:print("Player: " .. SoftResList.players[i].name .. " has not softreserved this item.")
            end
      end

      SoftRes.debug:print("SoftReserved = " .. tostring(SoftRes.announcedItem.softReserved))
      return softReservers
end

-- toggle tabpages.
function SoftRes.helpers:toggleTabPage(page)

      -- Check to see that the tab is not already active.
      if not BUTTONS.tabButtonPage[page].active then

            -- show it.
            FRAMES.tabContainer["page" .. page]:Show()
            BUTTONS.tabButtonPage[page]:SetFrameLevel(BUTTONS.tabButtonPage[page]:GetFrameLevel() + 1)
            BUTTONS.tabButtonPage[page].active = true
      
            for i = 1, #BUTTONS.tabButtonPage do
      
                  if i ~= page then
                        FRAMES.tabContainer["page" .. i]:Hide()
                        BUTTONS.tabButtonPage[i]:SetFrameLevel(BUTTONS.tabButtonPage[page]:GetFrameLevel() - 1)
                        BUTTONS.tabButtonPage[i].active = false
                  end
            end
      end
end

-- Prepare the item for rolls.
function SoftRes.helpers:prepareItem(itemId)

      if itemId then
            -- Set the icon for the item.
            local itemIcon = GetItemIcon(itemId)

            -- Change the texture, to the button.
            BUTTONS.announcedItemButton.texture:SetTexture(itemIcon)

            -- Show the list of players who have soft-reserved the item.
            SoftRes.list:showPrepSoftResList()

            -- Disable all other buttons while rolling.
            SoftRes.helpers:hideAllRollButtons(true)

            -- Set the prepared item to prep item variable.
            SoftRes.preparedItem.itemId = itemId

            -- Hide the prep button.
            BUTTONS.prepareItemButton:Hide()

            -- Set the text in the item frame.
            FRAMES.announcedItemFrame.fs:SetText(SoftRes.helpers:getItemLinkFromId(itemId))

            -- Toggle alert player.            
            SoftRes.state:toggleAlertPlayer(true, "Prep")

            -- Get a list for the elegible players.
            -- Fill them to the list of prepared items.
            SoftRes.preparedItem.elegible = SoftRes.helpers:getSoftReservers(itemId)

            -- Show the first page.
            SoftRes.helpers:toggleTabPage(1)

            -- Handle buttons accordingly.
            SoftRes.list:handleRollButtons()
      end
end

-- Hide and show all roll buttons.
function SoftRes.helpers:hideAllRollButtons(flag)
      if flag == true then
            BUTTONS.raidRollButton:Hide()
            BUTTONS.softResRollButton:Hide()
            BUTTONS.osRollButton:Hide()
            BUTTONS.msRollButton:Hide()
            BUTTONS.addPenaltyButton:Hide()
            BUTTONS.ffaRollButton:Hide()
            BUTTONS.announceRollsButton:Hide()
            BUTTONS.skipItemButton:Hide()
      elseif flag == false then
            BUTTONS.raidRollButton:Show()
            BUTTONS.softResRollButton:Show()
            BUTTONS.osRollButton:Show()
            BUTTONS.msRollButton:Show()
            BUTTONS.addPenaltyButton:Show()
            BUTTONS.ffaRollButton:Show()
            BUTTONS.announceRollsButton:Show()
      end
end

-- When we loot something from the lootwindow, it must be removed from the droppedItemsList.
function SoftRes.helpers:removeHandledItem()
      local temp = {}
      
      for k, v in ipairs(SoftRes.droppedItems) do
            if v ~= SoftRes.preparedItem.itemId then
            tinsert(temp, v)
            end
      end
      
      if table.maxn(temp) > 0 then
            SoftRes.droppedItems = {}
            SoftRes.droppedItems = temp
      end

      for i = 1, #SoftRes.droppedItems do
            if SoftRes.droppedItems[i] == SoftRes.skippedItem then
                  table.remove(SoftRes.droppedItems, i)
                  break
            end
      end
end

-- Unprepare item for rolls.
-- Se SoftRes.helpers:prepareItem() function for info about what happened below.
function SoftRes.helpers:unPrepareItem()
      SoftRes.preparedItem.itemId = nil
      SoftRes.preparedItem.elegible = {}
      SoftRes.preparedItem.softReserved = false

      SoftRes.announcedItem.state = false
      SoftRes.announcedItem.itemId = nil
      SoftRes.announcedItem.elegible = {}
      SoftRes.announcedItem.rolls = {}
      SoftRes.announcedItem.tieRollers = {}
      SoftRes.announcedItem.highestRoll = 0
      SoftRes.announcedItem.softReserved = false
      SoftRes.announcedItem.shitRolls = {}
      SoftRes.announcedItem.manyRolls = {}
      SoftRes.skippedItem = 0
      SoftRes.forced = false

      SoftRes.helpers:hideAllRollButtons(true)
      BUTTONS.announcedItemButton.texture:SetTexture(BUTTONS.announcedItemButton.defaultTexture)

      -- toggleScanForSoftRes takes the first argument as an announcement flag.
      SoftRes.state:toggleScanForSoftRes(false, false)
      SoftRes.state:toggleListenToRolls(false)
      SoftRes.state:toggleListenToRaidRolls(false)

      SoftRes.state.announcedResult = false
      SoftRes.state.rollingForLoot = false
      SoftRes.state.announcedItem = false
      SoftRes.cancel = {}

      FRAMES.announcedItemFrame.fs:SetText("")
      FRAMES.rollFrame.fs:SetText("")

      if SoftRes.state.lootOpened then
            SoftRes.state:toggleAlertPlayer(true, "Loot")
            BUTTONS.prepareItemButton:Show()
      else
            SoftRes.state:toggleAlertPlayer(false)
            BUTTONS.prepareItemButton:Hide()
      end

      SoftRes.list:showFullSoftResList()
      SoftRes.list.showPrepSoftResList()

      aceComm:SendCommMessage(SoftRes.comm, "SAD::DONE", "RAID");
end

-- local function for return an icon per item won.
-- Takes a player, returns 1 loot icon per item won.
function SoftRes.helpers:getRollPenalty(playerName, msPenalty, osPenalty, rolledRollType)
      local wonMS = 0
      local wonOS = 0
      local player = SoftRes.helpers:getPlayerFromName(playerName)
      local rollType = ""

      -- Check to see if the player has recieved items.
      if #player.receivedItems > 0 then
            for i = 1, #player.receivedItems, 1 do

                  -- get the rollType.
                  rollType = player.receivedItems[i][2]
                  local penaltyActive = player.receivedItems[i][5]
                  -- just add to the corresponding type
                  if rollType == "ms" and penaltyActive then
                        wonMS = wonMS + 1
                  elseif rollType == "os" and penaltyActive then
                        wonOS = wonOS + 1
                  end
            end
      end

      wonMS = wonMS * msPenalty
      wonOS = wonOS * osPenalty
  
      if rolledRollType == "ms" then
            return wonMS
      elseif rolledRollType == "os" then
            return wonOS
      end

      return 0
end

-- Handle the winner.
-- Takes a name, rollValue, rollType, itemId 
-- Adds the winning item to the player-list.
-- Will be used to calculate Roll-penalties.
function SoftRes.helpers:handleWinner(name, roll, rollType, itemId)
      -- Get the winner.
      local player = SoftRes.helpers:getPlayerFromName(name)
      local penalty = SoftResConfig.state.addPenalty
      local winTime = time()

      if rollType == "ffa" or rollType == "raidRoll" then penalty = false end

      if rollType == "softRes" then
            player.softReserve.received = true
            table.insert(SoftResList.waitingForItems, {name, itemId}) 
            
            -- broadcast to clients
            local value = name .. ":true;"
            aceComm:SendCommMessage(SoftRes.comm, "SAS::" .. value, "RAID")
      else
            -- Set the values.
            table.insert(player.receivedItems, {winTime, rollType, itemId, roll, penalty})
            table.insert(SoftResList.waitingForItems, {name, itemId})

            -- broadcast to clients
            local value = name .. ":" .. tostring(winTime) .. "," .. tostring(rollType) .. "," .. tostring(itemId) .. "," .. tostring(roll) .. "," .. tostring(penalty) .. ";"
            aceComm:SendCommMessage(SoftRes.comm, "SAR::" .. value, "RAID")
      end

      -- Add to the cancel-standby.
      SoftRes.cancel = {winTime, name, roll, rollType, itemId}
end

-- UnHandle the winner.
-- Takes the SoftRes.cancel table and takes away the won items.
-- If you press the cancel button, this will take effekt.
function SoftRes.helpers:unHandleWinner()
      -- If there are items to cancel.
      if #SoftRes.cancel > 0 then
            
            -- Get the player info and stuff.
            local winTime = SoftRes.cancel[1]
            local name = SoftRes.cancel[2]
            local roll = SoftRes.cancel[3]
            local rollType = SoftRes.cancel[4]
            local itemId = SoftRes.cancel[5]
            local player = SoftRes.helpers:getPlayerFromName(name)

            -- If the player won a SoftReserved item.
            if rollType == "softRes" then
                  player.softReserve.received = false
            else
                  -- check the received items and if we find THE one, we remove it.
                  for i = 1, #player.receivedItems, 1 do

                        -- we find the time and itemId
                        if player.receivedItems[i][1] == winTime and player.receivedItems[i][3] == itemId then
                              
                              -- we remove it from the table.
                              table.remove(player.receivedItems, i)
                              break
                        end
                  end
            end

            SoftRes.cancel = {}
      end
                  
end

-- Split the rolls and return user/value.
-- Takes a string value .. "player rolls (min-max)"
-- Returns a string with user, value.
local function getRoll(string)
      local splitString = SoftRes.helpers:stringSplit(string)
      local user = splitString[1]
      local value = splitString[3]
      local listenToRolls = SoftRes.state.listeningToRolls
      local listenToRaidRolls = SoftRes.state.listeningToRaidRolls

      -- If we want to get the raid-rolls, but someone else is rolling, just ignore that roll.
      if listenToRaidRolls and user ~= GetUnitName("Player") then return end

      -- if it's not a roll we're listning to.
      if splitString[2] ~= "rolls" then return nil end

      -- Accepted roll values.
      local acceptedRoll = "(1-100)"

      -- Check to see if the player is in the players-list.
      -- If the player is not, add them.
      if (not SoftRes.helpers:getPlayerFromName(user)) then
            -- But is the player in raid?
            for i = 1, GetNumGroupMembers() do
                  name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
                  if user == name then
            
                        local playerIndex = #SoftResList.players + 1
                        -- Create a new player in the list, at the correct index position.
                        SoftResList.players[playerIndex] = SoftRes.player:new()
            
                        -- Populate the newly created palyer
                        SoftResList.players[playerIndex].name = SoftRes.helpers:formatPlayerName(user)
                        SoftResList.players[playerIndex].groupPosition = playerIndex
                  end
            end
      end

      -- Re-order the list.
      SoftRes.list:reOrderPlayerList()
   
      -- Put all the "Shit-Rolls" in the shitlist.
      -- Rolls that aren't accepted.
      if splitString[4] ~= acceptedRoll then
            local isIn = false
            local isInDB = false
            for i = 1, #SoftRes.announcedItem.shitRolls do
                  if #SoftRes.announcedItem.shitRolls[i][1] == user then
                        isIn = true
                        break
                  end
            end

            -- We search for the player in our ShitRollers DB.
            for i = 1, #SoftResDB.shitRollers do
                  if #SoftResDB.shitRollers[i] == user then
                        isInDB = true
                        break
                  end
            end

            if (not isIn) then
                  table.insert(SoftRes.announcedItem.shitRolls, {user, splitString[4]})
                  table.insert(SoftResList.shitRolls, {user, splitString[4]})
            end

            -- Put the player IN the DB for ShitRollers.
            if (not isInDB) then
                  table.insert(SoftResDB.shitRollers, user)
            end

            if SoftRes.rollType ~= "raidRoll" then
                  SoftRes.announce:sendMessageToChat("Party", "Wrong roll-values detected from Player: " .. user .. ".")
                  SoftRes.announce:sendMessageToChat("Party", "Roll was: " .. splitString[4] .. ". Please only roll (1-100)")
            end
      end


      -- Return the roll
      -- if it's a raidRoll, only take the rolls form the player who initiated the roll.
      if listenToRaidRolls and user == GetUnitName("Player") then
            return user, value
      
      --elseif listenToRolls then -- For testing.
      elseif listenToRolls and splitString[4] == acceptedRoll then
            return user, value      
      end
end

-- Get rolls from the system msg channel.
function SoftRes.helpers:rollForItem(arg1)
      -- We only want to go through the process if we're listneing for it.
      if not SoftRes.state.listeningToRolls then return end

      -- Get the user and value from the roll.
      local rollUser, rollValue = getRoll(arg1)

      -- if we have values, we continue
      if (not rollUser) and (not rollValue) then return end
      
      local alreadyRolled = false
      local elegible = false
      local elegibleRollers = SoftRes.preparedItem.elegible
      local announcedItemId = SoftRes.announcedItem.itemId
      local rolls = SoftRes.announcedItem.rolls

      -- We check if there are any softressers first.
      if table.maxn(elegibleRollers) > 0 then
            SoftRes.preparedItem.softReserved = true
            for i = 1, #elegibleRollers do

                  -- If we find an elegible user then we continue.
                  if elegibleRollers[i] == rollUser then
                        elegible = true
                        break
                  end
            end

            if not elegible then
                  SoftRes.debug:print(rollUser .. " is not elegible for rolls...")

                  -- Even if the player is not elegible for rolls, we sill want to catch them.
                  for i = 1, #SoftRes.announcedItem.notElegibleRolls do
                        if SoftRes.announcedItem.notElegibleRolls[i][1] == rollUser then
                              SoftRes.debug:print(rollUser .. " is already in the NotElegibleRolls list.")
                              break
                        end
                  end

                  SoftRes.debug:print(rollUser .. " added to the NotElegibleRolls list.")
                  table.insert(SoftRes.announcedItem.notElegibleRolls, {rollUser, rollValue})

                  -- The player is not elegible, don't continue with reading the roll.
                  SoftRes.announce:sendMessageToChat("Party", "Wrong roll detected. " .. rollUser .. " did not SoftRes this item.")
                  return
            end
      end

      -- check if already rolled.
      for i = 1, #rolls do

            -- IF we find the player in the rolls table, he has already rolled and he will not be elegible for another roll.
            if rolls[i][1] == rollUser then
                  alreadyRolled = true
                  SoftRes.debug:print(rollUser .. " has Already rolled...")

                  -- if we find the player in the many-rolls table. (A table for keeping track of people who tries to roll many times on the same item.)
                  -- We simply adds to the value. it will be shown. Or we add the player to the list.

                  if #SoftRes.announcedItem.manyRolls == 0 then
                        table.insert(SoftRes.announcedItem.manyRolls, {rollUser, 1})
                        SoftRes.debug:print(rollUser .. " was added to the 'ManyRolls' list.")
                  else
                  
                        for j = 1 ,#SoftRes.announcedItem.manyRolls do
                              
                              if SoftRes.announcedItem.manyRolls[j][1] == rollUser then
                                    SoftRes.announcedItem.manyRolls[j][2] = SoftRes.announcedItem.manyRolls[j][2] + 1
                                    SoftRes.debug:print(rollUser .. " is already in the 'ManyRolls' list.")
                                    break
                              else
                                    table.insert(SoftRes.announcedItem.manyRolls, {rollUser, 1})
                                    SoftRes.debug:print(rollUser .. " was added to the 'ManyRolls' list.")
                              end
                        end
                  end

                  return
            end
      end

      -- If the player hasn't already rolled we push him into the rolled table.
      if not alreadyRolled then          
            -- Add the rollPenalty.
            -- But not to rolls for the SoftReserved item.
            local rollPenalty = SoftRes.helpers:getRollPenalty(rollUser, SoftResConfig.dropDecay.ms.value, SoftResConfig.dropDecay.os.value, SoftRes.rollType)
            local rollValueIncPenalty = rollValue - rollPenalty

            -- if not penalty state then.
            -- If we don't add penalty, we shouldn't count penalty either.
            if (not SoftResConfig.state.addPenalty) then
                  rollPenalty = 0
                  rollValueIncPenalty = rollValue
            end

            -- Check if Softres.
            if SoftRes.rollType == "softRes" or SoftRes.rollType == "ffa" then rollValueIncPenalty = rollValue end
         
            tinsert(SoftRes.announcedItem.rolls, {rollUser, rollValueIncPenalty})
          
            -- if we have a roll penalty, we announce it in chat.
            if rollPenalty > 0 and SoftRes.rollType ~= "softRes" then
                  SoftRes.announce:rollPenalty(rollUser, rollValue, rollPenalty)
            end
      end

      -- check for highest roll.
      -- Sort the table accordingly.
      local sortedTable = table.sort(SoftRes.announcedItem.rolls, function(a, b)
            return tonumber(a[2]) > tonumber(b[2])
      end)

      rolls = sortedTable
      -- And we're done.
end

function SoftRes.helpers:handleTieRolls()
      -- Check if we have a tie roll.
      if #SoftRes.announcedItem.tieRollers > 1 then

            SoftRes.debug:print("Handling tie rolls.")
            return true
      end

      return false
end

-- do the raid roll.
-- It does a roll between all the members in the group/raid.
-- Announces the winner.
function SoftRes.helpers:raidRollForItem()
      -- We only want to go through the process if we're listneing for it.
      if not SoftRes.state.listeningToRaidRolls then return end

      -- Get the user and value from the roll.
      local rollUser, rollValue = getRoll(arg1)

      -- Get the rollWinner from the raid list.
      if not rollValue then return end

      -- Inititate.
      local playerName = nil

      -- Get the user who had the correct position
      for i = 1, #SoftResList.players do
            if SoftResList.players[i].groupPosition == tonumber(rollValue) then
                  playerName = SoftResList.players[i].name
                  break
            end
      end

      -- Add the winner to the elegible list and the rolls list.
      table.insert(SoftRes.preparedItem.elegible, playerName)
      table.insert(SoftRes.announcedItem.rolls, {playerName, rollValue})
end

function SoftRes.helpers:countDown(beginningText, rollType, tieRollers)
      if not rollType then return end

      -- if we FFA roll, we get the OS timer, but keep the rolltype.
      local realRollType = rollType

      if rollType == "ffa" then rollType = "os" end

      local rollTime = SoftResConfig.timers[rollType].value
      local itemId = SoftRes.announcedItem.itemId

      -- Get if we have penalty on or off.
      local penalty = SoftRes.helpers:getPenaltyStatus(realRollType)
      local penaltyText = ""
      local penaltyValue = 0

      if (not penalty) or realRollType == "ffa" then  
            penaltyText = "No Penalty"
      elseif  realRollType == "softRes" then
            penaltyText = "SoftRes"
      else
            penaltyValue = SoftResConfig.dropDecay[rollType].value
            penaltyText = "-" .. penaltyValue .. " on Win"
      end

      SoftRes.announce:sendMessageToChat("Party_Leader", SoftRes.helpers:getItemLinkFromId(itemId) .. " " .. beginningText .. " Roll NOW! (" .. penaltyText .. ".)")
      SoftRes.announce:sendMessageToChat("Party", "+-[" .. beginningText .. "-rolls start]----------+")

      aceComm:SendCommMessage(SoftRes.comm, "SAI::" .. beginningText .. ";" .. itemId, "RAID");

      -- Listen to rolls again.
      SoftRes.state:toggleListenToRolls(true)

      aceTimer:ScheduleTimer(function()

            SoftRes.announce:sendMessageToChat("Party_Leader", "3")
            aceTimer:ScheduleTimer(function()

                  SoftRes.announce:sendMessageToChat("Party_Leader", "2")
                  aceTimer:ScheduleTimer(function()

                        SoftRes.announce:sendMessageToChat("Party_Leader", "1")
                        aceTimer:ScheduleTimer(function()

                              SoftRes.announce:sendMessageToChat("Party", "+----------[" .. beginningText .. "-rolls end]-+")

                              if tieRollers then
                                    SoftRes.helpers:announceResult(true, realRollType, tieRollers)
                              else      
                                    SoftRes.helpers:announceResult(false, realRollType)
                              end
                        end ,1)
                  end, 1)
            end, 1)
      end, rollTime - 4)
end

-- Local function for softResCountDown.
-- Takes a table of players and checks if they have all rolled.
-- returns true if everyone has rolled.
local function checkForAllRolls(players)
      local allRolls = 0
      local notRolled = ""

      -- if forced
      if SoftRes.state.forced then
            return ""
      end

      -- for every player, check for the rolls.
      for i = 1, #players do
            local isIn = false

            -- find the player in rolls.
            for j = 1, #SoftRes.announcedItem.rolls do
                  if players[i] == SoftRes.announcedItem.rolls[j][1] then
                        isIn = true
                        break
                  end
            end
            
            if isIn then
                  allRolls = allRolls + 1
            else
                  notRolled = notRolled .. players[i] .. ". "
            end            
      end

      -- Everyone has rolled. (Can be forced by pressing announce while SoftRes rolling.)
      if allRolls == #players then
            return ""
      end


      return notRolled
end

function SoftRes.helpers:softResCountDown(players, rolls, tieInfo)
      local rollTime = SoftResConfig.timers.softRes.value
      local itemId = SoftRes.announcedItem.itemId
      local playerNames = ""
      
      -- If we don't have any info, set it to ""
      if not tieInfo then tieInfo = "" end

      -- Convert players to string.
      for i = 1, #players do
            playerNames = playerNames .. players[i] .. ". "
      end

      -- Listen to rolls again.
      SoftRes.state:toggleListenToRolls(true)

      -- Set the rollType to softRes
      SoftRes.rollType = "softRes"

      if SoftRes.state.announcedItem == false then
            SoftRes.announce:sendMessageToChat("Party_Leader", SoftRes.helpers:getItemLinkFromId(itemId) .. " SoftRes " .. tieInfo .. "Roll NOW!")
            SoftRes.announce:sendMessageToChat("Party_Leader", playerNames)
            SoftRes.announce:sendMessageToChat("Party", "+-[SoftRes-rolls start]----------+")

            -- force State
            SoftRes.state.announcedItem = true

            -- Every time the timer triggers it will announce which players who hasn't rolled for their softreserved item.
            local numLoop = 0
            aceTimer:ScheduleRepeatingTimer(function()
                  numLoop = numLoop + 1

                  if numLoop == rollTime then
                        numLoop = 0
                        local notRolled = checkForAllRolls(players)
                        if notRolled ~= "" then
                              SoftRes.announce:sendMessageToChat("Party_Leader", notRolled .. " still needs to roll.")
                        end
                  else
                        -- Calls a check function every second.
                        if checkForAllRolls(players) == "" then
                              -- cancel all timers if we have all rolls.
                              aceTimer:CancelAllTimers()

                              -- If we forced an announcement, but still have tie-rollers.
                              if SoftRes.state.forced and #SoftRes.announcedItem.tieRollers > 1 then
                                    -- clear forced state.
                                    SoftRes.state.forced = false
                              end

                              -- If we have a TIE in soft-res?
                              if #SoftRes.announcedItem.tieRollers > 1 then
                                    
                                    -- Set the announcement state to false, or it won't announce again.
                                    SoftRes.state.announcedItem = false
                                    
                                    -- Reset the loop or it will trigger none-stop.
                                    numLoop = 0
                                    
                                    -- Clear the rolls, or it won't trigger again.
                                    SoftRes.announcedItem.rolls = {}

                                    -- We have to clear all the other players and only have the tie-rollers left for the SoftRes roll.
                                    -- So we set the eligble players to all players who rolled a tie.
                                    SoftRes.preparedItem.elegible = SoftRes.announcedItem.tieRollers
                                    SoftRes.announcedItem.tieRollers = {}

                                    -- Call the SoftRes roll again.
                                    SoftRes.helpers:softResCountDown(SoftRes.preparedItem.elegible, nil, "tie ")
                              else
                                    -- announce the winner.
                                    SoftRes.helpers:announceResult(false, "softRes")
                              end
                        end
                  end
            end, 1)
      end
end

-- Announce the results of the rolls.
function SoftRes.helpers:announceResult(tieRollers, rollType, players)
      -- We don't stop the rolls-listen state for this.
      -- We check so that we have all the rolls done by the SoftRessers.
      -- or if we force it to announced.
      if #SoftRes.preparedItem.elegible >= 2 and #SoftRes.announcedItem.rolls < #SoftRes.preparedItem.elegible and (not SoftRes.state.forced) and rollType == "softRes" then
            SoftRes.helpers:softResCountDown(SoftRes.preparedItem.elegible, SoftRes.preparedItem.rolls)
            return
      end

      -- Stop listening to rolls.
      SoftRes.state:toggleListenToRolls(false)

      -- Not forced any more.
      SoftRes.state.forced = false

      -- if it's a tie-roll and no one rolled. re-announce it.
      if #SoftRes.preparedItem.elegible >= 2 and #SoftRes.announcedItem.rolls == 0 then
            local newRollType = rollType
            local newText = "Tie"

            -- Call the announcement function again.
            SoftRes.helpers:countDown(newText, newRollType, tieRollers)
            return
      end

      -- if no one wants the item and it's an MS roll. Start an OS-roll
      if #SoftRes.announcedItem.rolls == 0 and rollType == "ms" then
            -- Call the announcement function again.
            SoftRes.rollType = "os"
            SoftRes.helpers:countDown("OS", "os")
            return
      end

      -- Check if there are any rolls.
      if #SoftRes.announcedItem.rolls > 0 then

            -- Handle tie-rolls.
            if SoftRes.helpers:handleTieRolls() then

                  -- Populate the elegible list with only the tie-rollers.
                  SoftRes.preparedItem.elegible = {}
                  SoftRes.preparedItem.elegible = SoftRes.announcedItem.tieRollers

                  -- Clear the rolls lists
                  -- Clear the tie-rollers list. It could be populated again.
                  SoftRes.announcedItem.rolls = {}
                  SoftRes.announcedItem.tieRollers = {}
                  SoftRes.announcedItem.highestRoll = 0

                  -- Announce Re-Roll for only the tie-rollers.
                  local tieRollers = ""
                  local announceText = "We have a TIE. Roll again:"

                  -- Get the tie-rollers.
                  for i = 1, #SoftRes.preparedItem.elegible do
                        tieRollers = tieRollers .. SoftRes.preparedItem.elegible[i] .. ". "
                  end

                  -- Send the announcement after 1 second.
                  aceTimer:ScheduleTimer(function()
                        -- send the text.
                        SoftRes.announce:sendMessageToChat("Party_Leader", announceText)

                        -- Wait another second before posting the players.
                        aceTimer:ScheduleTimer(function()

                              SoftRes.announce:sendMessageToChat("Party_Leader", tieRollers)
                              
                              -- Call the announcement function again.
                              SoftRes.helpers:countDown("Tie", rollType, tieRollers)
                        end, 1)
                  end, 0.5)

                  -- Re-draw the list.
                  SoftRes.list:showPrepSoftResList()

                  return

            -- We don't have tie-rolls.
            -- But we do actually have rolls.
            else

                  -- Get the highest roller.
                  -- that's the Index #1 in rollers lite, since it's already sorted.
                  local highestRoller = SoftRes.announcedItem.rolls[1]

                  -- Clear all rollers except the winner.
                  -- Copy the rollers to another list.
                  SoftRes.announcedItem.restRollers = SoftRes.announcedItem.rolls
                  SoftRes.announcedItem.rolls = {}
                  table.insert(SoftRes.announcedItem.rolls, highestRoller)

                  -- Show only the winner.
                  -- We push the winner to be the sole elegible player for the roll.
                  -- That way we will announce the winner however that player won.
                  SoftRes.preparedItem.elegible = {}
                  table.insert(SoftRes.preparedItem.elegible, highestRoller[1])

                  -- We have announced the results.
                  SoftRes.state.announcedResult = true

                  -- stop listening to rolls.
                  SoftRes.state:toggleListenToRolls(false)

                  -- Rolling has stopped.
                  SoftRes.state:toggleRollingForLoot(false)

                  -- ANNOUNCE IT
                  local winnerName = SoftRes.announcedItem.rolls[1][1]
                  local winnerRoll = SoftRes.announcedItem.rolls[1][2]
                  local announceText = "The winner is: " .. winnerName .. ", with a (" .. winnerRoll .. ") roll."

                  SoftRes.announce:sendMessageToChat("Party_Leader", announceText)

                  -- Re-draw the list.
                  SoftRes.list:showPrepSoftResList()

                  -- Add the winning item to the player-list.
                  -- For decay.
                  SoftRes.helpers:handleWinner(winnerName, winnerRoll, rollType, SoftRes.announcedItem.itemId)

                  return
            end
      end

      -- Winner by softres.

      -- We have announced the results.
      SoftRes.state.announcedResult = true

      -- stop listening to rolls.
      SoftRes.state:toggleListenToRolls(false)

      -- Rolling has stopped.
      SoftRes.state:toggleRollingForLoot(false)

      -- No rollers?`
      if SoftRes.state.announcedResult and #SoftRes.preparedItem.elegible == 0 and #SoftRes.announcedItem.rolls == 0 then
            SoftRes.announce:sendMessageToChat("Party_Leader", "No one wanted the item.")

            SoftRes.list:handleRollButtons()
      else

            -- We only have one SoftRes.
            local winnerName = SoftRes.preparedItem.elegible[1]
            local announceText = "One SoftRes. Grats: " .. winnerName .. "."
            local linkedItem = SoftRes.helpers:getItemLinkFromId(SoftRes.preparedItem.itemId)

            -- Announce winner
            SoftRes.helpers:handleWinner(winnerName, _, "softRes", _)
            SoftRes.announce:sendMessageToChat("Party_Leader", linkedItem)
            SoftRes.announce:sendMessageToChat("Party_Leader", announceText)
      end

      -- Re-draw the list.
      SoftRes.list:showPrepSoftResList()
      
end

-- Takes a string and a receiver.
-- Used to announce that the item that the player has won, is handed to the player.
function SoftRes.helpers:handleLoot(string, receiver)
      -- we can only handle loot from an actual loot / receiver.
      if not string then return end

      local splitString = SoftRes.helpers:stringSplit(string)
      local user = splitString[1]
      local type = splitString[2]
      local itemId = SoftRes.helpers:getItemIdFromLink(string)
      local waitingIndex = 0
   
      if user == "You" then user = GetUnitName("Player", false) end
   
      -- Check to see if the user has received the item or not.
      -- But we only check for items in the 'waiting' list.
      if type == "receive" or type == "receives" and itemId then
            if user == receiver then

                  -- Search in waiting list.
                  for i = 1, #SoftResList.waitingForItems do
                        local listedPlayer = SoftResList.waitingForItems[i]
      
                        -- found? nice, announce that the item is received.
                        if listedPlayer[1] == user and listedPlayer[2] == itemId then
                              SoftRes.announce:sendMessageToChat("Party_Leader", SoftRes.helpers:getItemLinkFromId(itemId) .. " has been handed to " .. user .. ".")
                              waitingIndex = i
                              break
                        end
                  end

                  -- Delete from the list.
                  table.remove(SoftResList.waitingForItems, waitingIndex)
            end
      end
end

-- Send a whisper to everyone, what item they have reserved.
function SoftRes.helpers.whisperSoftRes()
    
      for i = 1, #SoftResList.players, 1 do
          local player = SoftResList.players[i]
          local itemId = player.softReserve.itemId
          local name = player.name
          local whisperText = "You have not reserved any item."
          local itemLink = SoftRes.helpers:getItemLinkFromId(itemId)
          
          if itemLink then
              whisperText = "Your SoftReservation of " .. itemLink .. " is confirmed. GL HF"
          end

          ChatThrottleLib:SendChatMessage("NORMAL", "SoftResRollAnnounce", whisperText, "WHISPER", nil, name, nil, nil, nil)
      end
end

-- Checks the raid so that everyone is on the list.
-- If not, it adds them with an empty SoftRes.
function SoftRes.helpers:addPlayersNotOnList()
      
      -- Iterate through all the players.
      for i = 1, GetNumGroupMembers(), 1 do

            -- Get the player.
            local name, rank, subGroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
            local isIn = false
            local formatedName = SoftRes.helpers:formatPlayerName(name)

            -- Iterate through the SoftRes List and check if the player is in or not.
            for j = 1, #SoftResList.players, 1 do

                  -- Get the player.
                  local player = SoftResList.players[j]

                  -- Matche the playernames.
                  if player.name == formatedName then
                        isIn = true
                        break
                  end
            end

            -- If the player isn't in the list. Add it.
            if (not isIn) then
                  SoftRes.list:addSoftReservePlayer(formatedName)
            end
      end
end

-- Hides all the server buttons.
function SoftRes.helpers:hideAllServerButtons(state)

      if state then
            BUTTONS.masterLooterCheckButton:Hide()
            BUTTONS.broadCastModeButton:Hide()
            BUTTONS.newListButton:Hide()
            BUTTONS.importListButton:Hide()
            BUTTONS.announceAllSoftresButton:Hide()
            BUTTONS.announceRulesButton:Hide()
            BUTTONS.scanForSoftResButton:Hide()
            BUTTONS.addPlayerSoftResButton:Hide()
            BUTTONS.editPlayerButton:Hide()
            BUTTONS.deletePlayerButton:Hide()

            FRAMES.announcedItemFrame:Hide()
            FRAMES.announcedItemFrame.fs:Hide()
            BUTTONS.announcedItemButton:Hide()
            BUTTONS.cancelEverythingButton:Hide()

            FRAMES.softResRollTimerEditBox:Disable()
            FRAMES.msRollTimerEditBox:Disable()
            FRAMES.osRollTimerEditBox:Disable()
            FRAMES.msDropDecayEditBox:Disable()
            FRAMES.osDropDecayEditBox:Disable()
            FRAMES.extraInfoEditBox:Disable()

            FRAMES.clientModeAnnouncedItemFrame:Show()
            FRAMES.clientModeAnnouncedItemFrame.fs:Show()
            FRAMES.clientModeAnnouncedItemFrameRollType:Show()
            FRAMES.clientModeAnnouncedItemFrameRollType.fs:Show()
            BUTTONS.clientModeAnnouncedItemRollButton:Show()
            BUTTONS.clientModeRequestListButton:Show()

            FRAMES.clientModeMasterLooterFrame:Show()
            BUTTONS.clientModeMasterLooterSetButton:Show()
            BUTTONS.clientModeMasterLooterClearButton:Show()
      else
            BUTTONS.masterLooterCheckButton:Show()
            BUTTONS.broadCastModeButton:Show()
            BUTTONS.newListButton:Show()
            BUTTONS.importListButton:Show()
            BUTTONS.announceAllSoftresButton:Show()
            BUTTONS.announceRulesButton:Show()
            BUTTONS.scanForSoftResButton:Show()
            BUTTONS.addPlayerSoftResButton:Show()
            BUTTONS.editPlayerButton:Show()
            BUTTONS.deletePlayerButton:Show()

            FRAMES.announcedItemFrame:Show()
            FRAMES.announcedItemFrame.fs:Show()
            BUTTONS.announcedItemButton:Show()
            BUTTONS.cancelEverythingButton:Show()

            FRAMES.softResRollTimerEditBox:Enable()
            FRAMES.msRollTimerEditBox:Enable()
            FRAMES.osRollTimerEditBox:Enable()
            FRAMES.msDropDecayEditBox:Enable()
            FRAMES.osDropDecayEditBox:Enable()
            FRAMES.extraInfoEditBox:Enable()

            FRAMES.clientModeAnnouncedItemFrame:Hide()
            FRAMES.clientModeAnnouncedItemFrame.fs:Hide()
            FRAMES.clientModeAnnouncedItemFrameRollType:Hide()
            FRAMES.clientModeAnnouncedItemFrameRollType.fs:Hide()
            BUTTONS.clientModeAnnouncedItemRollButton:Hide()
            BUTTONS.clientModeRequestListButton:Hide()

            FRAMES.clientModeMasterLooterFrame:Hide()
            BUTTONS.clientModeMasterLooterSetButton:Hide()
            BUTTONS.clientModeMasterLooterClearButton:Hide()
      end

end

-- Send the list to all clients.
function SoftRes.helpers:sendListToClients()
      
      -- (S)server (A)nnounce (L)ist
      local command = "SAL"
      local value = ""

      for i = 1, #SoftResList.players, 1 do

            local player = SoftResList.players[i]
            local name = player.name
            local softResItemId = player.softReserve.itemId
            local received = player.softReserve.received

            if (not softResItemId) then softResItemId = "" end

            value = value .. name .. "," .. softResItemId .. "," .. tostring(received) .. ";"
      end

      if value and value ~= "" then
            aceComm:SendCommMessage(SoftRes.comm, command .. "::" .. value, "RAID");
      end
end

-- Send the list to all clients.
function SoftRes.helpers:sendItemsToClients()
      
      -- (S)server (A)nnounce (R)eceivedItems
      local command = "SAR"
      local value = ""

      for i = 1, #SoftResList.players, 1 do

            local player = SoftResList.players[i]
            local name = player.name
            local receivedItems = player.receivedItems

            -- if the player has received an item or more.
            if #receivedItems > 0 then
                  
                  -- loop through them.
                  for j = 1, #receivedItems, 1 do

                        -- Add to the value.
                        value = value .. name .. ":" .. tostring(receivedItems[j][1]) .. "," .. tostring(receivedItems[j][2]) .. "," .. tostring(receivedItems[j][3]) .. "," .. tostring(receivedItems[j][4]) .. "," .. tostring(receivedItems[j][5]) .. ";"
                  end
            end

      end

      if value and value ~= "" then
            aceComm:SendCommMessage(SoftRes.comm, command .. "::" .. value, "RAID");
      end
end

-- Send the list to all clients.
function SoftRes.helpers:sendReceivedSoftResItems()
      
      -- (S)server (A)nnounce (S)oftReserved.received
      local command = "SAS"
      local value = ""

      for i = 1, #SoftResList.players, 1 do

            local player = SoftResList.players[i]
            local name = player.name
            local received = player.softReserve.received

            -- if the player has received an item or more.
            if received then
            
                  -- Add to the value.
                  value = value .. name .. ":" .. tostring(received) .. ";"
            end

      end

      if value and value ~= "" then
            aceComm:SendCommMessage(SoftRes.comm, command .. "::" .. value, "RAID");
      end
end

-- Send the rules and config to all clients.
function SoftRes.helpers:sendSoftResRules()

      -- (S)erver (A)nnounce (C)onfig
      local command = "SAC"
      local value = ""

      local CONFIG_DECAY = SoftResConfig.dropDecay

      value = value .. SoftResConfig.timers.softRes.value .. ";"
      value = value .. SoftResConfig.timers.ms.value .. ";"
      value = value .. SoftResConfig.timers.os.value .. ";"

      value = value .. SoftResConfig.dropDecay.ms.value .. ";"
      value = value .. SoftResConfig.dropDecay.os.value .. ";"

      value = value .. SoftResConfig.extraInformation.value .. ";"

      if value and value ~= "" then
            aceComm:SendCommMessage(SoftRes.comm, command .. "::" .. value, "RAID");
      end
end

-- Format the list from the server.
function SoftRes.helpers:formatListFromServer(list)

      -- Get the current MasterLooter.
      local currentMasterLooter = SoftResList.masterLooter

      -- clear the current list.
      SoftRes.list:createNewSoftResList()

      local playerReservations = SoftRes.helpers:stringSplit(list, ";")

      -- terate through all the reservations
      for i = 1, #playerReservations, 1 do
            local playerRes = SoftRes.helpers:stringSplit(playerReservations[i], ",")

            local playerName = playerRes[1]
            local itemId = playerRes[2]
            local received = false

            if playerRes[3] == "true" then received = true end

            SoftRes.list:addSoftReservePlayer(playerName, itemId, received)
      end

      -- Set the masterlooter again.
      SoftResList.masterLooter = currentMasterLooter

      -- re-order the list
      SoftRes.list:reOrderPlayerList()

      -- show the addon-window.
      FRAMES.mainFrame:Show()
end

-- Get the received items per player.
function SoftRes.helpers:setReceivedItems(list)

      if (not list) then return end

      -- The list is sent like this:
      -- PLAYERNAME:winTime,rollType,itemId,roll,penalty;PLAYERNAME:winTime,rollType,itemId,roll,penalty;

      -- Split the values-list to handle players.
      -- Handles each received item.
      -- reveivedITems[1] = PLAYERNAME:winTime,rollType,itemId,roll,penalty
      -- reveivedITems[2] = PLAYERNAME:winTime,rollType,itemId,roll,penalty
      local receivedItems = SoftRes.helpers:stringSplit(list, ";")

      for i = 1, #receivedItems, 1 do

            -- Split the received item into playername and items.
            -- playerItem[1] = PLAYERNAME
            -- playerItem[2] = winTime,rollType,itemId,roll,penalty
            local playerItem = SoftRes.helpers:stringSplit(receivedItems[i], ":")

            local player = ""

            for j = 1, #SoftResList.players do
                  if SoftResList.players[j].name == playerItem[1] then
                        player = SoftResList.players[j]
                        break
                  end
            end

            -- Split the itemValue into an array for adding to the list.
            -- itemInfo[1] = winTime
            -- itemInfo[2] = rollType
            -- itemInfo[3] = itemId
            -- itemInfo[4] = roll
            -- itemInfo[5] = penalty
            local itemInfo = SoftRes.helpers:stringSplit(playerItem[2], ",")

            local winTime = tonumber(itemInfo[1])
            local rollType = itemInfo[2]
            local itemId = tonumber(itemInfo[3])
            local roll = tonumber(itemInfo[4])
            local penalty = false

            -- set the bool
            if itemInfo[5] == "true" then penalty = true end

            -- Push it to the player.
            if player == "" then
                  print("Please request the latest list from server.")
            else
                  table.insert(player.receivedItems, {winTime,rollType,itemId,roll,penalty})
            end
      end
end

-- Get the received items per player.
function SoftRes.helpers:setReceivedSoftResItems(list)

      if (not list) then return end

      -- The list is sent like this:
      -- PLAYERNAME:BOOL;PLAYERNAME:BOOL

      -- Split the values-list to handle players.
      -- Handles each received item.
      -- reveivedITems[1] = Playername
      -- reveivedITems[2] = boolean
      local receivedItems = SoftRes.helpers:stringSplit(list, ";")

      for i = 1, #receivedItems, 1 do

            -- Split the received item into playername and items.
            -- playerItem[1] = PLAYERNAME
            -- playerItem[2] = Bool
            local playerItem = SoftRes.helpers:stringSplit(receivedItems[i], ":")
            local receivedSoftRes = false

            local player = ""

            for j = 1, #SoftResList.players do
                  if SoftResList.players[j].name == playerItem[1] then
                        player = SoftResList.players[j]
                  end
            end

            if playerItem[2] == "true" then receivedSoftRes = true end

            -- Push it to the player.
            if player == "" then
                  print("Please request the latest list from server.")
            else
                  player.softReserve.received = receivedSoftRes
            end
      end
end

-- Get the config from the server.
function SoftRes.helpers:setSoftResRules(value)

      -- Get the configs.
      local configs = SoftRes.helpers:stringSplit(value, ";")

      SoftResConfig.timers.softRes.value = tonumber(configs[1])
      SoftResConfig.timers.ms.value = tonumber(configs[2])
      SoftResConfig.timers.os.value = tonumber(configs[3])

      SoftResConfig.dropDecay.ms.value = tonumber(configs[4])
      SoftResConfig.dropDecay.os.value = tonumber(configs[5])

      SoftResConfig.extraInformation.value = configs[6]

      -- use the configs.
      SoftRes.ui:useSavedConfigValues()
end

-- Get the announced item.
function SoftRes.helpers:setAnnouncedItem(value)

      -- Get the item.
      local item = SoftRes.helpers:stringSplit(value, ";")

      local rollType = item[1]
      local itemId = item[2]

      local itemLink = SoftRes.helpers:getItemLinkFromId(itemId)
      SoftRes.announcedItem.itemId = itemId

      local player = SoftRes.helpers:getPlayerFromName(GetUnitName("Player"))

      aceTimer:ScheduleTimer(function()
            FRAMES.clientModeAnnouncedItemFrame.fs:SetText(SoftRes.helpers:getItemLinkFromId(itemId))
            FRAMES.clientModeAnnouncedItemFrameRollType.fs:SetText(rollType)
      end , 1)

      BUTTONS.clientModeAnnouncedItemRollButton:Enable()

      if rollType == "SR" and tonumber(player.softReserve.itemId) ~= tonumber(itemId) then
            BUTTONS.clientModeAnnouncedItemRollButton:Disable()
      end
end

function SoftRes.helpers:clearAnnouncedItem()
      FRAMES.clientModeAnnouncedItemFrame.fs:SetText("")
      FRAMES.clientModeAnnouncedItemFrameRollType.fs:SetText("")
      SoftRes.announcedItem.itemId = nil
      
      FRAMES.rollFrame.fs:SetText(SoftRes.rollString)
end

-- send all item-info
function SoftRes.helpers:sendAllInfo(rules)

      -- Send the list to clients.
      SoftRes.helpers:sendListToClients()

      -- Send the received items list.
      SoftRes.helpers:sendItemsToClients()

      -- Send the received softreserved items list.
      SoftRes.helpers:sendReceivedSoftResItems()

      if rules then
            -- Send the rules as well.
            SoftRes.helpers:sendSoftResRules()
      end
end

-- Get the rolls
function SoftRes.helpers:setRollsList(list)
      
      local textFrame = FRAMES.rollFrame.fs
      textFrame:SetText(list)

end