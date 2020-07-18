-- Listhandling.
----------------
-- Creates a new list with default values.
function SoftRes.list:createNewSoftResList()
    SoftResList = {
          date = date("%y-%m-%d %H:%M:%S"),
          time = time(),
          zone = GetRealZoneText(),
          players = {},
          removedPlayers = {},
          drops = {},
          shitRolls = {},
    }

    -- If we're scanning. We toggle it off.
    SoftRes.state:toggleScanForSoftRes(false)
end

-- ListGetters
function SoftRes.list:getDate() return SoftResList.date end
function SoftRes.list:getZone() return SoftResList.zone end

-- Populate the list with players from group/raid.
--------------------------------------------------
function SoftRes.list:populateListWithPlayers()
    -- Get all the groupmembers. At their respective positions in raid (except the leader who is always 1)
    local numGroupMembers = GetNumGroupMembers()
    
    -- Don't do anything if there are no groupmembers.
    if numGroupMembers <= 1 then return end

    -- Leaderposition is always 1.
    local leaderName, _, leaderSubGroup = GetRaidRosterInfo(1)
    local leaderIndex = 1 -- Remember at what spot the leader was at.
    local positionCorrection = -1
    
    -- if we find the leader, we will pus the rest at one spot higher than the leaders.
    local aboveLeader = false

    -- Insert a plyer to the list.
    local function insertPlayer(inputName, index)
        -- Create a new player in the list, at the correct index position.
        SoftResList.players[index] = SoftRes.player:new()
        
        -- Populate the newly created palyer
        SoftResList.players[index].name = inputName
        SoftResList.players[index].groupPosition = index

        print("Inserted: " .. inputName .. ", at index: " .. index)
    end


    -- Clear the list before we create a new one.
    SoftResList.players = {}

    -- Start with the second member of the Group
    -- Populate the list of players.
    for i = 2, numGroupMembers do

        -- Get the information about the groupposition.
        -- GroupNumber + 1 because the leader is at position 1.
        local name, rank, subGroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)

        -- The groupleader is always the first person in the subGroup he is in.
        -- But he is still the first value in the returned table form GetNumGroupMembers()
        -- We have to check if the player we instert in our table is in the same group as the leader.
        -- If he is, we have to put in the leader first, then continue with the rest of the group.
        if subGroup >= leaderSubGroup then
            -- remember the index where the leader should be input.
            if aboveLeader == false then 
                leaderIndex = i - 1
                aboveLeader = true
                positionCorrection = 0
            end
        else
            leaderIndex = i
        end

        insertPlayer(name, i + positionCorrection)
    end

    -- When all the "normal" players are inserted, we push the leader in.
    insertPlayer(leaderName, leaderIndex)
end

-- Re order the player list, when moving around players in the raid.
-- Almost identical with the populate function.
-- While the populate function fills the list with player from the group, 
--   the reOder function simply re-orders the group according to the raidPosition in the raid menu.
--   All players who are on the list but are not in the raid, will be re-ordered to position 0 but still be on the list.
--   For various resons, like switching char for some encounter or whatever.
------------------------------------------------------------------------------------------------------------------------
function SoftRes.list:reOrderPlayerList()
    -- Almost the same as the add-player.
    local numGroupMembers = GetNumGroupMembers()
    
    -- Don't do anything if there are no groupmembers.
    if numGroupMembers <= 1 then return end

    -- Leaderposition is always 1.
    local leaderName, _, leaderSubGroup = GetRaidRosterInfo(1)
    local leaderIndex = 1 -- Remember at what spot the leader was at.
    local positionCorrection = -1
    
    -- if we find the leader, we will pus the rest at one spot higher than the leaders.
    local aboveLeader = false
    
    local temp = {}

    -- Insert a plyer to the list.
    local function insertPlayer(inputName, index)
        -- Create a new player in the list at the index-pos.
        --table.insert(temp, index, {inputName, index})
        temp[index] = {inputName, index}
    end

    -- Start with the second member of the Group
    -- Populate the list of players.
    for i = 2, numGroupMembers do

        -- Get the information about the groupposition.
        -- GroupNumber + 1 because the leader is at position 1.
        local name, rank, subGroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)

        -- The groupleader is always the first person in the subGroup he is in.
        -- But he is still the first value in the returned table form GetNumGroupMembers()
        -- We have to check if the player we instert in our table is in the same group as the leader.
        -- If he is, we have to put in the leader first, then continue with the rest of the group.
        if subGroup >= leaderSubGroup then
            -- remember the index where the leader should be input.
            if aboveLeader == false then 
                leaderIndex = i - 1
                aboveLeader = true
                positionCorrection = 0
            end
        else
            leaderIndex = i
        end

        insertPlayer(name, i + positionCorrection)
    end

    -- When all the "normal" players are inserted, we push the leader in.
    insertPlayer(leaderName, leaderIndex)

    -- Re-arrange the real list, accordingly.
    for i = 1, #temp do
        for j = 1, #SoftResList.players do
            if SoftResList.players[j].name == temp[i][1] then
                SoftResList.players[j].groupPosition = i
                SoftRes.debug:print("ReOrdered: " .. SoftResList.players[j].name .. ", to pos: " .. i)
            end
        end
    end

    -- For all the players who are not in the raid, but still on the list (second char or whatever.)
    -- We have to re-order them to 0 so that they are not elegible for raid roll.
    for i = 1, #SoftResList.players do
        local isIn = false
        for j = 1, #temp do
            -- if We find the player in the group (still the temp table) then we simply break.
            if temp[j][1] == SoftResList.players[i].name then
                isIn = true
                break
            end
        end

        -- If we don't find the player in the raid, we re-order him/her to position 0.
        if not isIn then
            SoftResList.players[i].groupPosition = 0
        end
    end
end

-- Show the SoftRessers on the second tabpage.
----------------------------------------------
function SoftRes.list:showFullSoftResList()
    local textFrame = FRAMES.listFrame.fs
    local text = SoftRes.state.scanForSoftRes.text
    local numGroupMembers = GetNumGroupMembers()
    local listEntries = #SoftResList.players
    local notSoftReserved = listEntries

    local colorGreen = SoftResConfig.colors.green
    local colorRed = SoftResConfig.colors.red
    local colorYellow = SoftResConfig.colors.yellow

    local entryText = colorRed
    local raidTextColor = colorYellow
    local listEntryColor = colorYellow

    -- Set the list-date to the center of the title.
    FRAMES.mainFrame.titleCenter:SetText(SoftResList.date)

    for i = 1, #SoftResList.players do
        local name = SoftResList.players[i].name
        local itemId = SoftResList.players[i].softReserve.itemId
        local groupPosition = SoftResList.players[i].groupPosition
        local showItem = ""
        local icon = ""

        -- Check to se if the player has linked an item.
        if not itemId then 
            icon = SoftResConfig.icons.questionMark
        else
            notSoftReserved = notSoftReserved - 1
            showItem = SoftRes.helpers:getItemLinkFromId(itemId)
        end

        -- We change the icon for the players who are not in the raid. to a cross.
        if groupPosition < 1 then 
            icon = SoftResConfig.icons.redCross
        elseif groupPosition > 0 and itemId and SoftRes.state.scanForSoftRes.state then
            -- Change the icon to OK if there is a softReserve AND we're scanning.
            icon = SoftResConfig.icons.readyCheck
        end

        
        
        -- if there still is no item, we set it to ""
        if not showItem then showItem = "" end

        text = text .. icon .. groupPosition .. "-" .. name .. " " .. showItem .. "\n"
    end

    -- Set colors.
    if numGroupMembers > listEntries then
        raidTextColor = colorRed
    elseif numGroupMembers == listEntries then
        raidTextColor = colorGreen
        listEntryColor = colorGreen
    end

    if notSoftReserved == 0 then entryText = colorGreen end

    -- populate the frame with the new text.
    local infoText = "In raid: " .. raidTextColor .. numGroupMembers .. "|r || On the list: " .. listEntryColor .. listEntries .. "|r || SoftReserves: " .. entryText .. (listEntries - notSoftReserved) .. "/" .. listEntries .. "|r.\n-------------------------------------------------------------\n"
    textFrame:SetText(infoText .. text)
end

-- Show prepared item and softreservers on the first page.
----------------------------------------
function SoftRes.list:showPrepSoftResList()
    -- FIX SHOW LIST
end

-- Listen to the raid or party chat and get the softreserves.
-------------------------------------------------------------
function SoftRes.list:getSoftReserves(arg1, arg2)
    -- arg1 = text, arg2 = user.
    -- Separate the username from the servername.
    local user = string.sub(arg2, 1, string.find(arg2, "-")-1)
    local itemId = nil

    -- We get an itemlink from arg1 and returns the id.
    itemId = SoftRes.helpers:getItemIdFromLink(arg1)

    -- add the item to the list.
    for i = 1, #SoftResList.players do
        local name = SoftResList.players[i].name

        if itemId and user == name then
            SoftResList.players[i].softReserve.time = time()
            SoftResList.players[i].softReserve.itemId = itemId
        end
    end
end

-- Remove the selected player.
-- We move the player to the "removedPlayers" table in the list.
----------------------------------------------------------------
function SoftRes.list:removeSoftReserve(playerName)
    if not playerName then return end

    -- Search the list for the correct player, and remove from the list.
    for i = 1, #SoftResList.players do
        if SoftResList.players[i].name == playerName then

            -- Log the time of removal.
            SoftResList.players[i].removedTime = time()

            -- We insert the removed player to the list.
            table.insert(SoftResList.removedPlayers, SoftResList.players[i])

            -- Remove the player from players list.
            table.remove(SoftResList.players, i)

            -- we're done.
            break
        end
    end
end

-- Add a player to the list.
----------------------------
function SoftRes.list:addSoftReservePlayer(playerName)
    -- If we don't get a name, don't add it.
    if not playerName then return end

    -- If the player is not in the list already.
    for i = 1, #SoftResList.players do
        if SoftResList.players[i].name == playerName then
            SoftRes.debug:print(playerName .. " is already on the list.")
            return
        end
    end

    -- We add the new player to the last spot on the list.
    local lastIndex = #SoftResList.players + 1
    table.insert(SoftResList.players, lastIndex, SoftRes.player:new(playerName, 0))
end

-- Populate the list with dropped items.
-- We only add the items of the accepted rarity (config.)
-- Coins count as ZERO items.
---------------------------------------------------------
function SoftRes.list:populateDroppedItems()
    local numberOfItems = 0

    if SR_ElvUI or SR_TukUI then
       numberOfItems = GetNumLootItems()
    else
       numberOfItems = LootFrame.numLootItems
    end
 
    -- If there are no items dropped.
    if numberOfItems == 0 then return nil end
    SoftRes.debug:print("Number of items to loot: " .. numberOfItems)

    for i = 1, numberOfItems do
       local itemLink = GetLootSlotLink(i)
       local itemId = SoftRes.helpers:getItemIdFromLink(itemLink)
       local itemRarity = SoftRes.helpers:getItemRarityFromId(itemId)
       
       -- If the dropped item is lower than the type of items handled by SoftRes then just don't add it.
       if itemRarity and itemRarity >= SoftResConfig.itemRarity.value then
          table.insert(SoftRes.droppedItems, itemId)
       end
    end
end

-- We will change the states of the roll-buttons according to the drops and reserves.
-------------------------------------------------------------------------------------
function SoftRes.list:handleRollButtons()
    -- First we hide all the buttons.
    SoftRes.helpers:hideAllRollButtons(true)

    -- We check if there are softreservers for the current item.
    if #SoftRes.preparedItem.elegible == 1 then
        BUTTONS.announceRollsButton:Show()
    elseif #SoftRes.preparedItem.elegible > 1 and SoftRes.announcedItem.softReserved then
        BUTTONS.softResRollButton:Show()
    else
        BUTTONS.raidRollButton:Show()
        BUTTONS.osRollButton:Show()
        BUTTONS.msRollButton:Show()
        BUTTONS.ffaRollButton:Show()
    end
end