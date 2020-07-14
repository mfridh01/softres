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