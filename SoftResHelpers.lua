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
      local lower = string.lower(string)
      return (lower:gsub("^%l", string.upper))
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

-- Shows a simple pop-up message window, with an OK button.
-- Takes a text-string as a parameter for displaying text.
function SoftRes.helpers:showPopupWindow(text)
      local alertText = SoftRes.state.alertPlayer.text

      if alertText == "Scan" then alertText = "Scanning chat for SoftReserves."
      elseif alertText == "Prep" then alertText = "An item is prepared for distribution."
      elseif alertText == "Anno" then alertText = "Announced an item but not done with the distribution."
      end


      StaticPopupDialogs["SOFTRES_MSG_WINDOW"] = {
            text = "ERROR!\n\n" .. alertText .. "\n\nFinish that before continuing.",
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

            -- We search for the player(s) who has SoftReserved this item.
            if tonumber(SoftResList.players[i].softReserve.itemId) == tonumber(itemId) then
                  print("in here?")

                  -- Check to see if the player has received it already.
                  if not SoftResList.players[i].softReserve.received then
                        
                        -- Push the player to the table of elegible players.
                        table.insert(softReservers, SoftResList.players[i].name)
                        SoftRes.debug:print("Player: " .. SoftResList.players[i].name .. " is added to the 'elegible' list.")
                  end
            else
                  SoftRes.debug:print("Player: " .. SoftResList.players[i].name .. " has not softreserved this item.")
            end
      end

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
      end
end

-- Unprepare item for rolls.
-- Se SoftRes.helpers:prepareItem() function for info about what happened below.
function SoftRes.helpers:unPrepareItem()
      SoftRes.preparedItem.itemId = nil
      BUTTONS.prepareItemButton:Show()
      BUTTONS.announcedItemButton.texture:SetTexture(BUTTONS.announcedItemButton.defaultTexture)
      FRAMES.announcedItemFrame.fs:SetText("")
      SoftRes.state.toggleAlertPlayer(false)
      SoftRes.preparedItem.elegible = {}
      FRAMES.rollFrame.fs:SetText("")
end