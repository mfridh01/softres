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

            -- Check so that we haven't announced an item before we drag the new one out.
            if not SoftRes.state.announcedItem then
                  SoftRes.state.toggleAnnouncedItem(true, itemId)
            end
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