-- OnUpdate for mainframe
FRAMES.mainFrame.updateInterval = 0.5; -- How often the OnUpdate code will run (in seconds)
FRAMES.mainFrame.timeSinceLastUpdate = 0
FRAMES.mainFrame.scanDots = 1

FRAMES.mainFrame:SetScript("OnUpdate", function(self, elapsed)
  self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed;
  
  if (self.timeSinceLastUpdate > FRAMES.mainFrame.updateInterval) then
    -- If we're scanning for softresses.
    -- Show an indicator on the top right, so it's shown.
    if SoftRes.state.alertPlayer.state then
        self.scanDots = self.scanDots + 1
        if self.scanDots > 3 then self.scanDots = 1 end

        local scanDots = ""
        for i = 1, self.scanDots do
            scanDots = scanDots .. "."
        end
        
        FRAMES.mainFrame.titleRight:SetText("|cFF00FF00" .. SoftRes.state.alertPlayer.text .. scanDots .. "|r")
    else
        FRAMES.mainFrame.titleRight:SetText("")
    end

    -- Update the softRes list.
    SoftRes.list:showFullSoftResList()
    SoftRes.list.showPrepSoftResList()

    -- Show AddonEnabled indicator.
    if BUTTONS.enableSoftResAddon:GetChecked() == true then
        FRAMES.addonIndicator.texture:SetTexture("Interface\\COMMON\\Indicator-Green")
    else
        FRAMES.addonIndicator.texture:SetTexture("Interface\\COMMON\\Indicator-Red")
    end

    -----------------------------
    self.timeSinceLastUpdate = 0;
  end
end)

-- TabButtons
for i = 1, #BUTTONS.tabButtonPage do
    BUTTONS.tabButtonPage[i]:SetScript("OnClick", function(self)
        -- If config window.
        -- We can't press it if we have anything else going on.
        -- This means that we can't change any settings while we're doing something else.
        if i == 3 then
            if not SoftRes.helpers:checkAlertPlayer("Rules") then return end
        end

        SoftRes.helpers:toggleTabPage(i)
    end)
end

function BUTTONS.editPlayerDropDown_Initialize(self)
    -- If there are no players, don't initialize the list.
    if #SoftResList.players <= 1 then return end

    for i = 1, #SoftResList.players do
        if not SoftResList.players[i] then break end

        local info = UIDropDownMenu_CreateInfo()
        info.hasArrow = false
        info.notCheckable = true
        info.text = SoftResList.players[i].name
        info.value = SoftResList.players[i].name
        info.func = function()
            UIDropDownMenu_SetText(self, SoftResList.players[i].name)
        end
        UIDropDownMenu_AddButton(info)
    end
end

function BUTTONS.editPlayerDropDownInit()
    if #SoftResList.players <= 1 then return end

    UIDropDownMenu_Initialize(BUTTONS.editPlayerDropDown, BUTTONS.editPlayerDropDown_Initialize)
    UIDropDownMenu_SetText(BUTTONS.editPlayerDropDown, SoftResList.players[1].name)
end

-- New List
BUTTONS.newListButton:SetScript("OnClick", function(self)
    if not SoftRes.helpers:checkAlertPlayer("New") then return end

    -- Popup dialog for creating a new list.
    StaticPopupDialogs["SOFTRES_NEW_LIST"] = {
        text = "Do you really want to generate a new list?\nThis will remove all the entries.\n\nWrite 'yes' in the box to continue.",
        button1 = "Yes",
        button2 = "No",
        hasEditBox = true,
        OnShow = function(self)
            self.button1:Disable()
        end,
        OnAccept = function()
            -- Generate a new list.
            SoftRes.list:createNewSoftResList()
            SoftRes.list:populateListWithPlayers()
            SoftRes.list:showFullSoftResList()

            -- Initiate the drop-down list.
            BUTTONS.editPlayerDropDownInit()
            SoftRes.debug:print("Generating a new list.")
        end,
        OnCancel = function (_,reason)
            -- Cancel.
            SoftRes.debug:print("Generating a new list.")
        end,
        EditBoxOnTextChanged = function (self, data)
            if self:GetText() == "yes" then
                self:GetParent().button1:Enable()
            else
                self:GetParent().button1:Disable()
            end
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    StaticPopup_Show ("SOFTRES_NEW_LIST")
end)

-- Add player
-- Edit player
BUTTONS.addPlayerSoftResButton:SetScript("OnClick", function(self)
    if not SoftRes.helpers:checkAlertPlayer("Add") then return end

    -- Check to see that there is a list.
    if not SoftResList then return end

    -- Popup dialog for adding a player.
    StaticPopupDialogs["SOFTRES_ADD_PLAYER"] = {
        text = "Addinga new player.\n\nEnter the player name.",
        name = "",
        button1 = "Add",
        button2 = "Cancel",
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        hasEditBox = true,
        editBoxWidth = 250,
        OnShow = function(self)
            self.button1:Disable()
        end,
        OnAccept = function(self)
            -- Format the playername. First char upper, rest lower.
            local playerName = SoftRes.helpers:formatPlayerName(self.name)

            -- Add the player
            SoftRes.list:addSoftReservePlayer(playerName)

            -- ReOrder the list.
            SoftRes.list:reOrderPlayerList()

            -- Refresh the list.
            SoftRes.list:showFullSoftResList()
            SoftRes.debug:print("Added player: " .. playerName)
        end,
        OnCancel = function (_,reason)
            -- Cancel.
            SoftRes.debug:print("Canceled adding player player")
        end,
        EditBoxOnTextChanged = function (self, data)
            if string.len(self:GetText()) >= 3 then
                self:GetParent().name = self:GetText()
                self:GetParent().button1:Enable()
            else
                self:GetParent().button1:Disable()
            end
        end,
    }

    StaticPopup_Show ("SOFTRES_ADD_PLAYER")
end)

-- Edit player
BUTTONS.editPlayerButton:SetScript("OnClick", function(self)
    if not SoftRes.helpers:checkAlertPlayer("Edit") then return end

    local editPlayer = SoftRes.player:getPlayerFromPlayerName(UIDropDownMenu_GetText(BUTTONS.editPlayerDropDown))

    -- If there is no player to edit. Then don't.
    if not editPlayer then return end

    local editPlayerItem = SoftRes.helpers:getItemLinkFromId(editPlayer.softReserve.itemId)
    if not editPlayerItem then editPlayerItem = "" end


    -- Popup dialog for editing a player.
    StaticPopupDialogs["SOFTRES_EDIT_PLAYER"] = {
        text = "Deleting " .. editPlayer.name .. ".\n\nType 'delete' and press the 'delete' button, to remove the softres.",
        button1 = "DELETE",
        button2 = "Cancel",
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        hasEditBox = true,
        editBoxWidth = 250,
        OnShow = function(self)
            self.button1:Disable()
        end,
        OnAccept = function()
            -- Delete the player
            SoftRes.list:removeSoftReserve(editPlayer.name)

            -- ReOrder the list
            SoftRes.list:reOrderPlayerList()

            -- ReDraw the list.
            SoftRes.list:showFullSoftResList()

            -- Re-Initiate the dropdown list.
            BUTTONS.editPlayerDropDownInit()
            SoftRes.debug:print("Deleted player: " .. editPlayer.name)
        end,
        OnCancel = function (_,reason)
            -- Cancel.
            SoftRes.debug:print("Canceled deleting player")
        end,
        EditBoxOnTextChanged = function (self, data)
            if self:GetText() == "delete" then
                self:GetParent().button1:Enable()
            else
                self:GetParent().button1:Disable()
            end
        end,
    }

    if editPlayer ~= "" or editPlayer ~= "Edit" then
        StaticPopup_Show ("SOFTRES_EDIT_PLAYER")
    end
end)

-- Scan chat for softreserves.
BUTTONS.scanForSoftResButton:SetScript("OnClick", function(self)
    -- If there are no players, don't start the scanner
    if #SoftResList.players <= 1 then return end
    
    -- Check to see if we already are alerting the player with anything.
    if not SoftRes.helpers:checkAlertPlayer("Scan") then return end

    -- call the toggle function without a flag, to really toggle it.
    -- First argument is wether or not we should announce the scan.
    SoftRes.state:toggleScanForSoftRes(true, nil)

    -- Toggle alert on.
    SoftRes.state:toggleAlertPlayer(nil, "Scan")

    -- redraw the list.
    SoftRes.list:showFullSoftResList()
end)

-- local function for handling itemdrags
local function handleDraggedItem()
    -- only scan if the addon is enabled.
    if BUTTONS.enableSoftResAddon:GetChecked() ~= true then return end

    if GetCursorInfo() then
        -- Check to see if we are clear to handle the item.
        if not SoftRes.helpers:checkAlertPlayer("Prep") then
            ClearCursor()
            return
        end

        -- Prepare the item for announcement.
        local itemId = SoftRes.helpers:getItemInfoFromDragged()
        SoftRes.helpers:prepareItem(itemId)

        -- Show the list.
        SoftRes.list:showPrepSoftResList()
        ClearCursor()

        -- Handle buttons accordingly.
        SoftRes.list:handleRollButtons()
    end
end
-- Announced item, icon position.
BUTTONS.announcedItemButton:SetScript("OnReceiveDrag", function()
    handleDraggedItem()
end)

-- Announced item, icon position.
FRAMES.mainFrame:SetScript("OnReceiveDrag", function()
    handleDraggedItem()
end)

BUTTONS.announcedItemButton:SetScript("OnClick", function(_, button)
    if button == "RightButton" then

        -- If we have started a roll on an item, but not announced a winner, we alert the player.
        if SoftRes.state.rollingForLoot then
            SoftRes.helpers:showPopupWindow()
            return
        end

        SoftRes.helpers:unPrepareItem()
    elseif button == "LeftButton" and GetCursorInfo() then
        handleDraggedItem()
    end
end)

-- Config
BUTTONS.enableSoftResAddon:SetScript("OnClick", function(self)
    SoftResConfig.state.softResEnabled = self:GetChecked()
 end)

BUTTONS.autoShowWindowCheckButton:SetScript("OnClick", function(self)
   SoftResConfig.state.autoShowOnLoot = self:GetChecked()
end)

BUTTONS.autoHideWindowCheckButton:SetScript("OnClick", function(self)
    SoftResConfig.state.autoHideOnLootDone = self:GetChecked()
 end)

-- Config, roll timers.
-- Takes an editbox, text string and a store-variable.
-- If there is no value, it set's the editbox to the value of the text.
-- Returns the text-value or variable value.
local function setEditBoxValue(editBox, text, valueVariable)

    -- If we write a letter and quickly press enter, it will throw an error. This will prevent that.
    -- We just set the text to it's previous value.
    if text == false then
        editBox:SetText(valueVariable)
        return valueVariable
    else
        editBox:SetText(text)
        return text
    end
end

-- SoftRes roll timer.
FRAMES.softResRollTimerEditBox:SetScript("OnTextChanged", function(self)
    -- Convert the text to number.
    local text = tonumber(self:GetText())

    -- if it's not a number, clear the field.
    if not text then
        self:SetText("")
    end
end)

FRAMES.softResRollTimerEditBox:SetScript("OnEnterPressed", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.timers.softRes.minValue, SoftResConfig.timers.softRes.maxValue), SoftResConfig.timers.softRes.value)
    SoftResConfig.timers.softRes.value = text
    FRAMES.msRollTimerEditBox:SetFocus()
    FRAMES.msRollTimerEditBox:HighlightText()
end)

FRAMES.softResRollTimerEditBox:SetScript("OnTabPressed", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.timers.softRes.minValue, SoftResConfig.timers.softRes.maxValue), SoftResConfig.timers.softRes.value)
    SoftResConfig.timers.softRes.value = text
    FRAMES.msRollTimerEditBox:SetFocus()
    FRAMES.msRollTimerEditBox:HighlightText()
end)

-- MS roll timer.
FRAMES.msRollTimerEditBox:SetScript("OnTextChanged", function(self)
    -- Convert the text to number.
    local text = tonumber(self:GetText())

    -- if it's not a number, clear the field.
    if not text then
        self:SetText("")
    end
end)

FRAMES.msRollTimerEditBox:SetScript("OnEnterPressed", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.timers.ms.minValue, SoftResConfig.timers.ms.maxValue), SoftResConfig.timers.ms.value)
    SoftResConfig.timers.ms.value = text
    FRAMES.osRollTimerEditBox:SetFocus()
    FRAMES.osRollTimerEditBox:HighlightText()
end)

FRAMES.msRollTimerEditBox:SetScript("OnTabPressed", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.timers.ms.minValue, SoftResConfig.timers.ms.maxValue), SoftResConfig.timers.ms.value)
    SoftResConfig.timers.ms.value = text
    FRAMES.osRollTimerEditBox:SetFocus()
    FRAMES.osRollTimerEditBox:HighlightText()
end)

-- OS roll timer.
FRAMES.osRollTimerEditBox:SetScript("OnTextChanged", function(self)
    -- Convert the text to number.
    local text = tonumber(self:GetText())

    -- if it's not a number, clear the field.
    if not text then
        self:SetText("")
    end
end)

FRAMES.osRollTimerEditBox:SetScript("OnEnterPressed", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.timers.os.minValue, SoftResConfig.timers.os.maxValue), SoftResConfig.timers.os.value)
    SoftResConfig.timers.os.value = text
    FRAMES.itemRarityEditBox:SetFocus()
    FRAMES.itemRarityEditBox:HighlightText()
end)

FRAMES.osRollTimerEditBox:SetScript("OnTabPressed", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.timers.os.minValue, SoftResConfig.timers.os.maxValue), SoftResConfig.timers.os.value)
    SoftResConfig.timers.os.value = text
    FRAMES.itemRarityEditBox:SetFocus()
    FRAMES.itemRarityEditBox:HighlightText()
end)

-- Itemrarity editbox
FRAMES.itemRarityEditBox:SetScript("OnTextChanged", function(self)
    -- Convert the text to number.
    local text = tonumber(self:GetText())

    -- if it's not a number, clear the field.
    if not text then
        self:SetText("")
    end
end)

FRAMES.itemRarityEditBox:SetScript("OnEnterPressed", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.itemRarity.minValue, SoftResConfig.itemRarity.maxValue), SoftResConfig.itemRarity.value)
    SoftResConfig.itemRarity.value = text
    FRAMES.msDropDecayEditBox:SetFocus()
    FRAMES.msDropDecayEditBox:HighlightText()
end)

FRAMES.itemRarityEditBox:SetScript("OnTabPressed", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.itemRarity.minValue, SoftResConfig.itemRarity.maxValue), SoftResConfig.itemRarity.value)
    SoftResConfig.itemRarity.value = text
    FRAMES.msDropDecayEditBox:SetFocus()
    FRAMES.msDropDecayEditBox:HighlightText()
end)

-- MS Roll decay.
FRAMES.msDropDecayEditBox:SetScript("OnTextChanged", function(self)
    -- Convert the text to number.
    local text = tonumber(self:GetText())

    -- if it's not a number, clear the field.
    if not text then
        self:SetText("")
    end
end)

FRAMES.msDropDecayEditBox:SetScript("OnEnterPressed", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.dropDecay.ms.minValue, SoftResConfig.dropDecay.ms.maxValue), SoftResConfig.dropDecay.ms.value)
    SoftResConfig.dropDecay.ms.value = text
    FRAMES.osDropDecayEditBox:SetFocus()
    FRAMES.osDropDecayEditBox:HighlightText()
end)

FRAMES.msDropDecayEditBox:SetScript("OnTabPressed", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.dropDecay.ms.minValue, SoftResConfig.dropDecay.ms.maxValue), SoftResConfig.dropDecay.ms.value)
    SoftResConfig.dropDecay.ms.value = text
    FRAMES.osDropDecayEditBox:SetFocus()
    FRAMES.osDropDecayEditBox:HighlightText()
end)

-- OS Roll decay.
FRAMES.osDropDecayEditBox:SetScript("OnTextChanged", function(self)
    -- Convert the text to number.
    local text = tonumber(self:GetText())

    -- if it's not a number, clear the field.
    if not text then
        self:SetText("")
    end
end)

FRAMES.osDropDecayEditBox:SetScript("OnEnterPressed", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.dropDecay.os.minValue, SoftResConfig.dropDecay.os.maxValue), SoftResConfig.dropDecay.os.value)
    SoftResConfig.dropDecay.os.value = text
    FRAMES.softResRollTimerEditBox:SetFocus()
    FRAMES.softResRollTimerEditBox:HighlightText()
end)

FRAMES.osDropDecayEditBox:SetScript("OnTabPressed", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.dropDecay.os.minValue, SoftResConfig.dropDecay.os.maxValue), SoftResConfig.dropDecay.os.value)
    SoftResConfig.dropDecay.os.value = text
    FRAMES.softResRollTimerEditBox:SetFocus()
    FRAMES.softResRollTimerEditBox:HighlightText()
end)

-- Extra information
FRAMES.extraInfoEditBox:SetScript("OnEnterPressed", function(self)
    self:ClearFocus()
    SoftResConfig.extraInformation.value = self:GetText()
end)

FRAMES.extraInfoEditBox:SetScript("OnTabPressed", function(self)
    self:ClearFocus()
    SoftResConfig.extraInformation.value = self:GetText()
end)

-- Prepare items
BUTTONS.prepareItemButton:SetScript("OnClick", function(self)
    -- only scan if the addon is enabled.
    if BUTTONS.enableSoftResAddon:GetChecked() ~= true then return end

    -- check for availability
    if not SoftRes.helpers:checkAlertPlayer("Loot") then return end

    -- Check for items to prepare.
    if #SoftRes.droppedItems == 0 then return end

    -- We check the first item, then prepare it for loot.
    local preparedItemId = SoftRes.droppedItems[1]
    SoftRes.helpers:prepareItem(preparedItemId)
end)

-- SoftRes Roll.
BUTTONS.softResRollButton:SetScript("OnClick", function(self)
    -- Cancel all active timers.
    aceTimer:CancelAllTimers()

    -- Switch the listening state on.
    SoftRes.state:toggleListenToRolls(true)

    -- Rolling for loot
    SoftRes.state:toggleRollingForLoot(true)

    -- Alert the player.
    SoftRes.state:toggleAlertPlayer(true, "Anno")

    -- Disable all other buttons while rolling.
    SoftRes.helpers:hideAllRollButtons(true)

    -- announce the item.
    SoftRes.state:toggleAnnouncedItem(true)

    -- force State
    SoftRes.state.announcedItem = false

    -- Active the timer.
    SoftRes.announce:softResRollAnnounce()
end)

-- SoftRes Roll.
BUTTONS.msRollButton:SetScript("OnClick", function(self)
    -- Cancel all active timers.
    aceTimer:CancelAllTimers()

    -- Announce the item.
    SoftRes.state:toggleAnnouncedItem(true)

    -- Rolling for loot
    SoftRes.state:toggleRollingForLoot(true)

    -- Alert the player.
    SoftRes.state:toggleAlertPlayer(true, "Anno")

    -- Disable all other buttons while rolling.
    SoftRes.helpers:hideAllRollButtons(true)

    -- Active the timer.
    SoftRes.helpers:countDown("MS", "ms", nil)

    -- When done. deactive the rolls.
end)

BUTTONS.osRollButton:SetScript("OnClick", function(self)
    -- Cancel all active timers.
    aceTimer:CancelAllTimers()

    -- Announce the item.
    SoftRes.state:toggleAnnouncedItem(true)

    -- Rolling for loot
    SoftRes.state:toggleRollingForLoot(true)

    -- Alert the player.
    SoftRes.state:toggleAlertPlayer(true, "Anno")

    -- Disable all other buttons while rolling.
    SoftRes.helpers:hideAllRollButtons(true)

    -- Active the timer.
    SoftRes.helpers:countDown("OS", "os", nil)
end)

BUTTONS.ffaRollButton:SetScript("OnClick", function(self)
    -- Cancel all active timers.
    aceTimer:CancelAllTimers()

    -- Announce the item.
    SoftRes.state:toggleAnnouncedItem(true)

    -- Rolling for loot
    SoftRes.state:toggleRollingForLoot(true)

    -- Alert the player.
    SoftRes.state:toggleAlertPlayer(true, "Anno")

    -- Disable all other buttons while rolling.
    SoftRes.helpers:hideAllRollButtons(true)

    -- Active the timer.
    SoftRes.helpers:countDown("FFA", "os", nil)
end)

BUTTONS.raidRollButton:SetScript("OnClick", function(self)

    -- If we have started a roll on an item, but not announced a winner, we alert the player.
    if SoftRes.state.rollingForLoot then
        SoftRes.helpers:showPopupWindow()
        return
    end

    -- Cancel all active timers.
    aceTimer:CancelAllTimers()

    -- Switch the listening state on.
    SoftRes.state:toggleListenToRaidRolls(true)

    -- Announce the item.
    SoftRes.state:toggleAnnouncedItem(true)

    -- Rolling for loot
    SoftRes.state:toggleRollingForLoot(true)

    -- Alert the player.
    SoftRes.state:toggleAlertPlayer(true, "Anno")

    -- Disable all other buttons while rolling.
    SoftRes.helpers:hideAllRollButtons(true)

    -- Active the timer.
    SoftRes.announce:raidRollAnnounce()
end)

BUTTONS.announceRollsButton:SetScript("OnClick", function(self)
    -- handle the announcement.
    SoftRes.helpers:announceResult()
end)

-- If we want to cancel stuff, we do it here.
BUTTONS.cancelEverythingButton:SetScript("OnClick", function(self)
    -- Popup dialog for creating a new list.
    StaticPopupDialogs["SOFTRES_CANCEL_ALL"] = {
        text = "Do you really want to cancel all announcements, rolls and such?",
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            -- Canceling stuff.
            SoftRes.helpers:unPrepareItem()

            -- Cancel all active timers.
            aceTimer:CancelAllTimers()
            
            SoftRes.debug:print("Cancelled all announcements, rolls and such.")
        end,
        OnCancel = function (_,reason)
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    StaticPopup_Show ("SOFTRES_CANCEL_ALL")
end)

-- Announce the rules and stuff to the group
BUTTONS.announceRulesButton:SetScript("OnClick", function(self)
    if not SoftRes.helpers:checkAlertPlayer("Rules") then return end
    if not SoftRes.helpers:checkAlertPlayer("Scan") then return end

    local groupType = "/Party"
    local raid = UnitInRaid("Player")

    if raid then groupType = "/Raid" end

    local colorBlue = "|cFF6EA5DC"
    local colorGreen = "|cFF00FF00"
    local colorYellow = "|cFFFFFF00"
    local colorWhite = "|cFFFFFFFF"

    -- Just a welcome message.
    SoftRes.announce:sendMessageToChat("Party_Leader", "Welcome to " .. GetUnitName("Player") .. "'s SoftRes run.")
    SoftRes.announce:sendMessageToChat("Party", "||SoftRes-Addon]--------------+")
    SoftRes.announce:sendMessageToChat("Party", "|| Everyone will SoftReserve one item.")
    SoftRes.announce:sendMessageToChat("Party", "|| When prompted, link that item in " .. groupType .. ".")
    SoftRes.announce:sendMessageToChat("Party", "|| Drops except SoftReserved = MS>OS")
    SoftRes.announce:sendMessageToChat("Party", "|| Timers- SoftRes: " .. SoftResConfig.timers.softRes.value .. "s. MS: "  .. SoftResConfig.timers.ms.value .. "s. OS: " .. SoftResConfig.timers.os.value .. "s.")
    SoftRes.announce:sendMessageToChat("Party", "|| Roll-penalties- MS: " .. "-" .. SoftResConfig.dropDecay.ms.value .. ", OS: " .. "-" .. SoftResConfig.dropDecay.os.value)
    SoftRes.announce:sendMessageToChat("Party", "|| " .. SoftResConfig.extraInformation.value)
    SoftRes.announce:sendMessageToChat("Party", "\\-------------------[By Snits]")

    -- call the toggle function without a flag, to really toggle it.
    -- First argument is wether or not we should announce the scan.
    SoftRes.state:toggleScanForSoftRes(true, nil)

    -- Toggle alert on.
    SoftRes.state:toggleAlertPlayer(nil, "Scan")

    -- redraw the list.
    SoftRes.list:showFullSoftResList()
end)

-- Skip item.
BUTTONS.skipItemButton:SetScript("OnClick", function(self)
    -- Set the index of skipped item
    SoftRes.skippedItem = SoftRes.skippedItem + 1

    -- Check to see so that the index is not higher than the actual drop list.
    -- If it is, just set it to the first item.
    if SoftRes.skippedItem == #SoftRes.droppedItems then
        SoftRes.skippedItem = 0
    end

    -- Prepare the next item on the list.
    SoftRes.helpers:prepareItem(SoftRes.droppedItems[SoftRes.skippedItem + 1])
end)