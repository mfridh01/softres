-- Listhandling.
----------------
-- Creates a new list with default values.
function SoftRes.list:createNewSoftResList()
    SoftResList = {
          date = date("%y-%m-%d %H:%M:%S"),
          zone = GetRealZoneText(),
          players = {},
          drops = {},
    }
end

-- ListGetters
function SoftRes.list:getDate() return SoftResList.date end
function SoftRes.list:getZone() return SoftResList.zone end
--------------------------------------------------------------------

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
        table.insert(SoftResList.players, index, SoftRes.player:new())
        
        -- Populate the newly created palyer
        SoftResList.players[index].name = inputName

        print("Inserted: " .. inputName .. ", at index: " .. index)
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
end

-- Re order the player list, when moving around players in the raid.
-- Almost identical with the populate function.
--------------------------------------------------------------------
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
    local listCopy = SoftResList.players
    SoftResList.players = {}

    -- Insert a plyer to the list.
    local function insertPlayer(inputName, index)
        -- Create a new player in the list at the index-pos.
        table.insert(temp, index, {inputName, index})
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
        for j = 1, #listCopy do
            if listCopy[j].name == temp[i][1] then
                table.insert(SoftResList.players, listCopy[j])
                print("Inserted: " .. listCopy[j].name .. ", at pos: " .. i)
            end
        end
    end
end

-- Show the SoftRessers on the second tabpage.
----------------------------------------------
function SoftRes.list:showFullSoftResList()
    local textFrame = FRAMES.listFrame.fs
    local text = ""

    for i = 1, #SoftResList.players do
        local name = SoftResList.players[i].name
        local itemId = SoftResList.players[i].softReserve.itemId
        local showItem = ""
        local icon = ""

        if not itemId then 
            icon = SoftResConfig.icons.redCross
            itemId = ""
        else
            showItem = SoftRes.helpers:getItemLinkFromId(itemId)
            print(tostring(showItem))
        end

        text = text .. icon .. name .. " " .. showItem .. "\n"
    end

    -- populate the frame with the new text.
    textFrame:SetText(text)
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