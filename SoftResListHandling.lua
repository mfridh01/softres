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
          onHold = {},
    }

    -- If we're scanning. We toggle it off.
    SoftRes.state:toggleScanForSoftRes(false, false)
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

-- local function for getting a skull, if the player is on shit-list.
-- Takes a player, return a skull.
local function checkIfShitRoller(player)
    -- For now, we just skip this. might add this feature later.
    -- If the player is in the ShitRollers list. Give them the skull icon.
    if SoftRes.helpers:findStringInTable(SoftResDB.shitRollers, player) then
--        return " " .. SoftResConfig.icons.skull
    end

    return ""
end

-- local function for return an icon per item won.
-- Takes a player, returns 1 loot icon per item won.
local function checkIfReceivedItems(name)
    local lootIcon = ""
    local player = nil
    
    -- get the player.
    for i = 1, #SoftResList.players do
        if SoftResList.players[i].name == name then

            -- Found player.
            player = SoftResList.players[i]
            break
        else
            return ""
        end
    end

    -- Check to see if the player has recieved items.
    if #player.receivedItems > 0 then
        for j = 1, #player.receivedItems do
            local lootItem = "item:" .. player.receivedItems[j][3] .. "::::::::::::"
            local lootIconText = SoftResConfig.icons.loot

            if player.receivedItems[j][2] == "ms" then
                lootIconText = SoftResConfig.icons.loot
            else
                lootIconText = "[OS]"
            end

            lootIcon = lootIcon .. "|H" .. lootItem .. "|h" .. lootIconText .. "|h"
        end
    end

    return lootIcon
end

-- local function for getting a questicon, if the player is on manyRolls list.
-- Takes a player, returns a quest icon.
local function checkIfManyRolls(player)
    -- If the player is in the manyRollers list. Give them the quest icon.
    for i = 1, #SoftRes.announcedItem.manyRolls do
        if SoftRes.announcedItem.manyRolls[i][1] == player then
            return SoftResConfig.icons.quest .. " "
        end
    end

    return ""
end

-- local function for getting a dice, if the player has rolled.
-- Takes a player, returns a dice icon and the value.
local function checkIfRolled(player)
    
    for i = 1, #SoftRes.announcedItem.rolls do
        if SoftRes.announcedItem.rolls[i][1] == player then
            return "" .. SoftResConfig.icons.dice .. " (" .. SoftRes.announcedItem.rolls[i][2] .. ") "
        end
    end

    return ""
end

-- local function for getting a green check icon, if the player has a high roll.
-- Takes a player, returns a green check icon.
local function checkIfHighestRoll(player)
    local iconText = "" .. SoftResConfig.icons.readyCheck .. SoftResConfig.colors.green

    -- If there is only one elegible roller, automaticly send back that player as the winner.
    if #SoftRes.preparedItem.elegible == 1 then
        return iconText
    end

    for i = 1, #SoftRes.announcedItem.rolls do
        if SoftRes.announcedItem.rolls[i][1] == player and tonumber(SoftRes.announcedItem.rolls[i][2]) == tonumber(SoftRes.announcedItem.highestRoll) then
            return iconText
        end
    end

    return ""
end

-- local function for getting a green check icon, if the player has a high roll.
-- Takes a playerName, returns a green check icon.
local function checkIfPlayerIsOffline(player)
    local groupPosition = 0

    for i = 1, #SoftResList.players do
        if SoftResList.players[i].name == player then
            groupPosition = SoftResList.players[i].groupPosition
        end
    end

    if groupPosition > 0 then
        name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(groupPosition)
        if not online then
            return SoftResConfig.icons.redCross .. SoftResConfig.colors.red .. " (OFFLINE) "
        end
    end

    return ""
end

-- local function for getting roll and penalty.
-- Takes a roll and a penalty. Returns formated information about the roll.
local function checkIfRollPenalty(roll, rollPenalty)

    -- If we don't have a penalty, we just return an empty string.
    if rollPenalty == 0 then return "" end

    local iconDice = SoftResConfig.icons.dice
    local iconLoot = SoftResConfig.icons.loot

    return "(" .. iconDice .. roll .. " - " .. iconLoot .. rollPenalty ..")"    
end

-- local function for return an icon if received the softReserved item.
-- Takes a player name, returns the icon for SoftReserved item.
local function checkIfReceveidSoftRes(name)
    local lootIcon = ""
    local player = SoftRes.helpers:getPlayerFromName(name)

    -- Check to see if the player has recieved the items.
    if player.softReserve.received then
        lootIcon = SoftResConfig.icons.readyCheck
    end

    return lootIcon
end

-- Show the SoftRessers on the second tabpage.
----------------------------------------------
function SoftRes.list:showFullSoftResList()
    --local textFrame = FRAMES.listFrame.fs
    local textFrame = FRAMES.listFrame
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
    local offlineColor = colorRed

    local numOffline = numGroupMembers

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

        text = text .. icon .. groupPosition .. "-" .. name .. checkIfShitRoller(name) .. checkIfReceivedItems(name) .. checkIfReceveidSoftRes(name) .. " " .. showItem .. "\n"
    end

    -- Check for offline players
    for i = 1, numGroupMembers do
        name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
        if not online then
            numOffline = numOffline - 1
        end
    end

    -- Set colors.
    if numGroupMembers > listEntries then
        raidTextColor = colorRed
    elseif numGroupMembers == listEntries then
        raidTextColor = colorGreen
        listEntryColor = colorGreen
    end

    if notSoftReserved == 0 then entryText = colorGreen end
    if numOffline == numGroupMembers then offlineColor = colorGreen end

    -- populate the frame with the new text.
    local infoText = "Raid: " .. offlineColor .. numOffline .. "|r/" .. raidTextColor .. numGroupMembers .. "|r || Listentries: " .. listEntryColor .. listEntries .. "|r || SoftRes: " .. entryText .. (listEntries - notSoftReserved) .. "/" .. listEntries .. "|r.\n-----------------------------------------------------------------------\n"
 
    local listHeight = ((12 * #SoftResList.players) + 24) - (#SoftResList.players * (UIParent:GetScale() - 0.711))-- (Textheight * listed players) + title
    textFrame:SetSize(500, listHeight)
    textFrame:EnableMouseWheel(true);
    textFrame:SetScript("OnHyperlinkClick", _G.ChatFrame_OnHyperlinkShow)
    textFrame:Clear()
    textFrame:AddMessage(infoText .. text, 1.0, 1.0, 1.0, nil, nil)

    textFrame:SetScript("OnLoad", function(self)
        self:ScrollToTop()
    end)
end

-- Show prepared item and softreservers on the first page.
----------------------------------------
function SoftRes.list:showPrepSoftResList()
    local textFrame = FRAMES.rollFrame.fs
    local text = ""
    local textTitle = ""
    local rollIcon = SoftResConfig.icons.dice

    -- Set the tile accordingly.
    if SoftRes.announcedItem.softReserved then
        textTitle = "The following players are elegible for rolls:\n-----------------------------------------------------------------------\n"

        -- List all players.
        for i = 1, #SoftRes.preparedItem.elegible do
            local playerName = SoftRes.preparedItem.elegible[i]
            text = text .. checkIfPlayerIsOffline(playerName) .. checkIfHighestRoll(playerName) .. checkIfRolled(playerName) .. playerName .. checkIfManyRolls(playerName) .. checkIfShitRoller(playerName) .. checkIfReceivedItems(playerName) .. checkIfReceveidSoftRes(playerName) .."|r\n"
        end
      
    elseif #SoftRes.announcedItem.rolls > 0 then
        textTitle = "The follwing players has rolled on it:\n-----------------------------------------------------------------------\n"

    elseif SoftRes.preparedItem.itemId then
        textTitle = "The item is NOT SoftReserved:\n-----------------------------------------------------------------------\n"
    else
        textTitle = "Rolls list.\n-----------------------------------------------------------------------\n"
    end

    -- If we have a winner, we override the title.
    -- If there is only 1 person left for the elgible rollers, that means that player is the winner.
    if #SoftRes.preparedItem.elegible == 1 then
        textTitle = "The winner is:\n-----------------------------------------------------------------------\n"
    end

    -- If we have announced the winner, but don't have any rolls.
    if SoftRes.state.announcedResult and #SoftRes.preparedItem.elegible == 0 and #SoftRes.announcedItem.rolls == 0 then
        textTitle = "No one wanted the item.\n-------------------------------------------------------------\n\n  NO ROLLS"
    end


    -- Keep track of all the players with the same rollValue.
    -- We need to know if there is a tie or not.
    -- SoftRes.announcedItem.highestRoll, is the item we're using.
    -- SoftRes.announcedItem.tieRollers is the table we're using.
    local highRollersText = ""

    -- for now, we just show the people who rolled.
    for i = 1, #SoftRes.announcedItem.rolls do
        local rollUser = SoftRes.announcedItem.rolls[i][1]
        local tempRollValue = tonumber(SoftRes.announcedItem.rolls[i][2])
        local rollValue = 0 
        local highRollIcon = ""
        local playerColor = ""
        local shitRollersIcon = ""
        local manyRollersIcon = ""
        local rollPenalty = SoftRes.helpers:getRollPenalty(rollUser, SoftResConfig.dropDecay.ms.value, SoftResConfig.dropDecay.os.value)

        -- add penalty to the rollValue
        rollValue = tempRollValue + rollPenalty

        -- Check if the player who rolled is the highest roller.
        -- If it's higher or same, we set the new value. If not, then we don't give then the nice icon =)
        if rollValue > SoftRes.announcedItem.highestRoll then
            -- Set the new value.
            SoftRes.announcedItem.highestRoll = rollValue

            -- Clear the tie-rolls.
            -- We don't need to know about the ties that are lower than the highest roll.
            SoftRes.announcedItem.tieRollers = {}

            -- Set the winning icon.
            highRollIcon = SoftResConfig.icons.readyCheck
        elseif rollValue == SoftRes.announcedItem.highestRoll then
            
            -- Check if the player is already in the tieRollers list.
            -- Add the player to the HighRollers table.
            if not SoftRes.helpers:findStringInTable(SoftRes.announcedItem.tieRollers, rollUser) then
                table.insert(SoftRes.announcedItem.tieRollers, rollUser)
            end

            -- Set the winning icon.
            highRollIcon = SoftResConfig.icons.readyCheck
            playerColor = SoftResConfig.colors.green
        end

        -- If the player is in the manyrollers list.
        -- This will not override any other color, but will always set an icon.
        for j = 1, #SoftRes.announcedItem.manyRolls do
            if SoftRes.announcedItem.manyRolls[j][1] == rollUser then
                manyRollersIcon = " " .. SoftResConfig.icons.quest

                if highRollIcon == "" then
                    playerColor = SoftResConfig.colors.yellow
                end
            end
        end
        
        -- this is the last row of the rollers.
        -- We don't show it if the item is soft-reserved.
        if not SoftRes.announcedItem.softReserved then
            text = text .. checkIfHighestRoll(rollUser) .. checkIfRolled(rollUser) .. checkIfRollPenalty(rollValue, rollPenalty) .. " " .. rollUser .. checkIfManyRolls(rollUser) .. checkIfShitRoller(rollUser) .. checkIfReceivedItems(rollUser) .. checkIfReceveidSoftRes(rollUser) .. "|r\n"
        end
    end

    -- We have a TIE??!? set the title accordingly.
    if #SoftRes.announcedItem.tieRollers > 1 then

        textTitle = "We have a TIE:\n-----------------------------------------------------------------------\n"

        -- Read through the highRollers and add them to the front.
        for i = 1, #SoftRes.announcedItem.tieRollers do
            highRollersText = highRollersText .. SoftRes.announcedItem.tieRollers[i] .. "\n"
        end

        highRollersText = highRollersText .. "----------------------------------------------------------------------\n"
    end

    textFrame:SetText(textTitle .. highRollersText .. text)
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
    local numberOfItems = GetNumLootItems()
 
    -- If there are no items dropped.
    if numberOfItems == 0 then return nil end
    SoftRes.debug:print("Number of items to loot: " .. tostring(numberOfItems))

    if (not numberOfItems) then return nil end

    for i = 1, numberOfItems do
       local itemLink = GetLootSlotLink(i)
       local itemId = SoftRes.helpers:getItemIdFromLink(itemLink)
       local itemRarity = SoftRes.helpers:getItemRarityFromId(itemId)
       
       -- If the dropped item is lower than the type of items handled by SoftRes then just don't add it.
       if itemRarity and itemRarity >= SoftResConfig.itemRarity.value then
          table.insert(SoftRes.droppedItems, itemId)
       end
    end

    BUTTONS.prepareItemButton:Show()
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