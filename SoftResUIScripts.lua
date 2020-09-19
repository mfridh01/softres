-- OnUpdate for mainframe
FRAMES.mainFrame.updateInterval = 0.5; -- How often the OnUpdate code will run (in seconds)
FRAMES.mainFrame.timeSinceLastUpdate = 0
FRAMES.mainFrame.scanDots = 1

FRAMES.mainFrame:SetScript("OnUpdate", function(self, elapsed)
  self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed;


    -- CLIENT MODE --
    if BUTTONS.enableClientMode:GetChecked() == true then
        SoftRes.clientMode = true
        SoftResConfig.state.clientMode = true

        -- hide all buttons
        SoftRes.helpers:hideAllServerButtons(true)
    else
        SoftRes.clientMode = false
        SoftResConfig.state.clientMode = false

        -- show all buttons
        SoftRes.helpers.hideAllServerButtons(false)
    end

  
  -- timeupdate
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
        SoftRes.enabled = true
    else
        FRAMES.addonIndicator.texture:SetTexture("Interface\\COMMON\\Indicator-Red")
        SoftRes.enabled = false
    end

    -- Update the MasterLooter checkbox.
    lootmethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod()

    if lootmethod == "master" then
        BUTTONS.masterLooterCheckButton:SetChecked(true) 
    else
        BUTTONS.masterLooterCheckButton:SetChecked(false) 
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

function BUTTONS.deletePlayerDropDown_Initialize(self)
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

function BUTTONS.deletePlayerDropDownInit()
    if #SoftResList.players <= 1 then return end

    UIDropDownMenu_Initialize(BUTTONS.deletePlayerDropDown, BUTTONS.deletePlayerDropDown_Initialize)
    UIDropDownMenu_SetText(BUTTONS.deletePlayerDropDown, SoftResList.players[1].name)
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
            SoftRes.list:reOrderPlayerList()
            SoftRes.list:showFullSoftResList()

            -- Initiate the drop-down list.
            BUTTONS.deletePlayerDropDownInit()
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
    FRAMES.editPlayerAddPlayerPopupWindow:Show()
end)

-- Edit player
BUTTONS.editPlayerButton:SetScript("OnClick", function(self)
    if not SoftRes.helpers:checkAlertPlayer("Edit") then return end

    FRAMES.editPlayerEditItemPopupWindow:Show()
    FRAMES.editPlayerPopupWindow:Hide()

end)

-- Delete player
BUTTONS.deletePlayerButton:SetScript("OnClick", function(self)
    if not SoftRes.helpers:checkAlertPlayer("Del") then return end

    FRAMES.deletePlayerPopupWindow:Show()
end)

-- Scan chat for softreserves.
BUTTONS.scanForSoftResButton:SetScript("OnClick", function(self)
    -- If there are no players, don't start the scanner or if you're not in a group
    if #SoftResList.players < 1 or (not IsInGroup("Player")) then return end
    
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
        --SoftRes.helpers:prepareItem(18423) -- Onyxia Head test.
        --SoftRes.helpers:prepareItem(19003) -- Nef Head test.

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
        
        -- Send to all clients.
        aceComm:SendCommMessage(SoftRes.comm, "SAD::DONE", "RAID");

        -- Cancel all active timers.
        aceTimer:CancelAllTimers()
    elseif button == "LeftButton" and GetCursorInfo() then
        handleDraggedItem()
    end
end)

-- Config
BUTTONS.enableSoftResAddon:SetScript("OnClick", function(self)
    SoftResConfig.state.softResEnabled = self:GetChecked()
end)

-- CLIENT MODE --
BUTTONS.enableClientMode:SetScript("OnClick", function(self)
    SoftResConfig.state.softResClient = self:GetChecked()
    
    if self:GetChecked() then
        FRAMES.mainFrame.title:SetText("Ω SoftRes |cFF00FF00Client|r")
    else
        FRAMES.mainFrame.title:SetText("Ω SoftRes")
    end
        
end)

BUTTONS.broadCastModeButton:SetScript("OnClick", function(self)
    SoftResConfig.state.broadcast = self:GetChecked()
end)
-- // CLIENT MODE \\ --

BUTTONS.autoShowWindowCheckButton:SetScript("OnClick", function(self)
   SoftResConfig.state.autoShowOnLoot = self:GetChecked()
end)

BUTTONS.autoHideWindowCheckButton:SetScript("OnClick", function(self)
    SoftResConfig.state.autoHideOnLootDone = self:GetChecked()
end)

BUTTONS.addPenaltyButton:SetScript("OnClick", function(self)
    SoftResConfig.state.addPenalty = self:GetChecked()
end)

BUTTONS.addPenaltyButton:SetScript("OnShow", function(self)
    -- we only show it if we have any penalties
    if SoftResConfig.dropDecay.ms.value == 0 and SoftResConfig.dropDecay.os.value == 0 then
        SoftResConfig.state.addPenalty = false
        self:SetChecked(false)
        self:Hide()
    else
        SoftResConfig.state.addPenalty = true
        self:SetChecked(true)
    end
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

FRAMES.softResRollTimerEditBox:SetScript("OnEditFocusLost", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.timers.softRes.minValue, SoftResConfig.timers.softRes.maxValue), SoftResConfig.timers.softRes.value)
    SoftResConfig.timers.softRes.value = text
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

FRAMES.msRollTimerEditBox:SetScript("OnEditFocusLost", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.timers.ms.minValue, SoftResConfig.timers.ms.maxValue), SoftResConfig.timers.ms.value)
    SoftResConfig.timers.ms.value = text
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

FRAMES.osRollTimerEditBox:SetScript("OnEditFocusLost", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.timers.os.minValue, SoftResConfig.timers.os.maxValue), SoftResConfig.timers.os.value)
    SoftResConfig.timers.os.value = text
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

FRAMES.itemRarityEditBox:SetScript("OnEditFocusLost", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.itemRarity.minValue, SoftResConfig.itemRarity.maxValue), SoftResConfig.itemRarity.value)
    SoftResConfig.itemRarity.value = text
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

FRAMES.msDropDecayEditBox:SetScript("OnEditFocusLost", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.dropDecay.ms.minValue, SoftResConfig.dropDecay.ms.maxValue), SoftResConfig.dropDecay.ms.value)
    SoftResConfig.dropDecay.ms.value = text
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

FRAMES.osDropDecayEditBox:SetScript("OnEditFocusLost", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.dropDecay.os.minValue, SoftResConfig.dropDecay.os.maxValue), SoftResConfig.dropDecay.os.value)
    SoftResConfig.dropDecay.os.value = text
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

    -- Show skip-button.
    if #SoftRes.droppedItems > 1 then
        BUTTONS.skipItemButton:Show()
    else
        BUTTONS.skipItemButton:Hide()
    end
end)

-- SoftRes Roll.
BUTTONS.softResRollButton:SetScript("OnClick", function(self)
    -- Cancel all active timers.
    aceTimer:CancelAllTimers()

    -- Switch the listening state on.
    SoftRes.state:toggleListenToRolls(true)

    -- Set the rollType to nothing
    SoftRes.rollType = "softRes"

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

    -- Send to all clients.
    aceComm:SendCommMessage(SoftRes.comm, "SAI::SR;" .. SoftRes.announcedItem.itemId, "RAID");
end)

-- SoftRes Roll.
BUTTONS.msRollButton:SetScript("OnClick", function(self)
    -- Cancel all active timers.
    aceTimer:CancelAllTimers()

    -- Announce the item.
    SoftRes.state:toggleAnnouncedItem(true)

    -- Set the rollType to ms
    SoftRes.rollType = "ms"

    -- Rolling for loot
    SoftRes.state:toggleRollingForLoot(true)

    -- Alert the player.
    SoftRes.state:toggleAlertPlayer(true, "Anno")

    -- Disable all other buttons while rolling.
    SoftRes.helpers:hideAllRollButtons(true)

    -- Active the timer.
    SoftRes.helpers:countDown("MS", "ms", nil)

    -- Send to all clients.
    --aceComm:SendCommMessage(SoftRes.comm, "SAI::MS;" .. SoftRes.announcedItem.itemId, "RAID");
end)

BUTTONS.osRollButton:SetScript("OnClick", function(self)
    -- Cancel all active timers.
    aceTimer:CancelAllTimers()

    -- Announce the item.
    SoftRes.state:toggleAnnouncedItem(true)

    -- Set the rollType to nothing
    SoftRes.rollType = "os"

    -- Rolling for loot
    SoftRes.state:toggleRollingForLoot(true)

    -- Alert the player.
    SoftRes.state:toggleAlertPlayer(true, "Anno")

    -- Disable all other buttons while rolling.
    SoftRes.helpers:hideAllRollButtons(true)

    -- Active the timer.
    SoftRes.helpers:countDown("OS", "os", nil)

    -- Send to all clients.
    --aceComm:SendCommMessage(SoftRes.comm, "SAI::OS;" .. SoftRes.announcedItem.itemId, "RAID");
end)

BUTTONS.ffaRollButton:SetScript("OnClick", function(self)
    -- Cancel all active timers.
    aceTimer:CancelAllTimers()

    -- Announce the item.
    SoftRes.state:toggleAnnouncedItem(true)

    -- Set the rollType to nothing
    SoftRes.rollType = "ffa"

    -- Rolling for loot
    SoftRes.state:toggleRollingForLoot(true)

    -- Alert the player.
    SoftRes.state:toggleAlertPlayer(true, "Anno")

    -- Disable all other buttons while rolling.
    SoftRes.helpers:hideAllRollButtons(true)

    -- Active the timer.
    SoftRes.helpers:countDown("FFA", "ffa", nil)

    -- Send to all clients.
    --aceComm:SendCommMessage(SoftRes.comm, "SAI::FFA;" .. SoftRes.announcedItem.itemId, "RAID");
end)

BUTTONS.raidRollButton:SetScript("OnClick", function(self)

    -- If we have started a roll on an item, but not announced a winner, we alert the player.
    if SoftRes.state.rollingForLoot then
        SoftRes.helpers:showPopupWindow()
        return
    end

    -- Reorder the list.
    SoftRes.list:reOrderPlayerList()

    -- Cancel all active timers.
    aceTimer:CancelAllTimers()

    -- Set the rollType to raidRoll
    SoftRes.rollType = "raidRoll"

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

    -- Send to all clients.
    aceComm:SendCommMessage(SoftRes.comm, "SAD::DONE", "RAID");
end)

BUTTONS.announceRollsButton:SetScript("OnClick", function(self)
    -- handle the announcement.
    -- if we have forced it (while we're doing a soft-res roll)
    if SoftRes.state.announcedItem and SoftRes.rollType == "softRes" then
        SoftRes.state.forced = true
    else
        SoftRes.helpers:announceResult(nil, nil, false)
    end
end)

-- If we want to cancel stuff, we do it here.
BUTTONS.cancelEverythingButton:SetScript("OnClick", function(self)
    -- Popup dialog for creating a new list.
    StaticPopupDialogs["SOFTRES_CANCEL_ALL"] = {
        text = "Do you really want to cancel all announcements, rolls and winner?",
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            -- If rolling, then announce before canceling.
            if #SoftRes.announcedItem.rolls > 0 then
                SoftRes.announce:sendMessageToChat("Party_Leader", "The rolls for this item are canceled.")
            end

            -- We unHandle the winner. remove the wins.
            SoftRes.helpers:unHandleWinner()

            -- Canceling stuff.
            SoftRes.helpers:unPrepareItem()

            -- Cancel all active timers.
            aceTimer:CancelAllTimers()
            
            SoftRes.debug:print("Cancelled all announcements, rolls and such.")

            -- Send to all clients.
            aceComm:SendCommMessage(SoftRes.comm, "SAD::DONE", "RAID");
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

    local function messageToRaid(scan)

        local groupType = "/Party"
        local raid = UnitInRaid("Player")
    
        if raid then groupType = "/Raid" end
    
        local colorBlue = "|cFF6EA5DC"
        local colorGreen = "|cFF00FF00"
        local colorYellow = "|cFFFFFF00"
        local colorWhite = "|cFFFFFFFF"
    
        -- Just a welcome message.
        SoftRes.announce:sendMessageToChat("Party", "Welcome to " .. GetUnitName("Player") .. "'s SoftRes run.")
        SoftRes.announce:sendMessageToChat("Party", "||SoftRes-Addon]--------------+")
        SoftRes.announce:sendMessageToChat("Party", "|| Everyone will SoftReserve one item.")
        SoftRes.announce:sendMessageToChat("Party", "|| Drops except SoftReserved = MS>OS")
        SoftRes.announce:sendMessageToChat("Party", "|| Timers- SoftRes: " .. SoftResConfig.timers.softRes.value .. "s. MS: "  .. SoftResConfig.timers.ms.value .. "s. OS: " .. SoftResConfig.timers.os.value .. "s.")
        SoftRes.announce:sendMessageToChat("Party", "|| Roll-penalties- MS: " .. "-" .. SoftResConfig.dropDecay.ms.value .. ", OS: " .. "-" .. SoftResConfig.dropDecay.os.value)
        SoftRes.announce:sendMessageToChat("Party", "|| " .. SoftResConfig.extraInformation.value)
        SoftRes.announce:sendMessageToChat("Party", "+-------------------[By Snits]")
          
        if scan then
            -- call the toggle function without a flag, to really toggle it.
            -- First argument is wether or not we should announce the scan.
            SoftRes.state:toggleScanForSoftRes(true, nil)
        
            -- Toggle alert on.
            SoftRes.state:toggleAlertPlayer(nil, "Scan")
        end

        -- redraw the list.
        SoftRes.list:showFullSoftResList()

    end

    -- Popup dialog for Posting the rules.
    StaticPopupDialogs["SOFTRES_ANNOUNCE_RULES"] = {
        text = "Do you want to post the rules to chat?",
        button1 = "Yes",
        button2 = "Yes & Scan",
        button3 = "No",
        OnAccept = function(self, button, data2)

            -- send the message to raid, without scanning.
            messageToRaid(false)
        end,
        OnCancel = function (_,reason)
            
            -- send the message to raid, with scanning.
            messageToRaid(true)
        end,
        OnAlt = function ()
            
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    StaticPopup_Show ("SOFTRES_ANNOUNCE_RULES")
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

-- Adds a button for getting the target name. For easier add.
BUTTONS.addPlayerTargetNameButton:SetScript("OnClick", function(self)
    local targetName = GetUnitName("Target")

    if UnitIsPlayer("Target") and targetName then
        FRAMES.addPlayerNameEditBox:SetText(targetName)
    end
end)

-- Cancel
BUTTONS.addPlayerPopUpCancelButton:SetScript("OnClick", function(self)
    -- Clear the editboxes.
    FRAMES.addPlayerNameEditBox:SetText("")
    FRAMES.addPlayerItemEditBox:SetText("")

    -- close the window.
    FRAMES.addPlayerPopupWindow:Hide()
end)

-- Add player
BUTTONS.addPlayerPopUpAddButton:SetScript("OnClick", function(self)

    local playerNameRaw = FRAMES.addPlayerNameEditBox:GetText()
    local itemLinkRaw = FRAMES.addPlayerItemEditBox:GetText()
    local infoText = FRAMES.addPlayerNameEditBox.fs:GetText()

    -- Format the playername. First char upper, rest lower.
    local playerName = SoftRes.helpers:formatPlayerName(playerNameRaw)

    -- Format the itemId.
    local itemId = SoftRes.helpers:getItemIdFromLink(itemLinkRaw)

    -- Check the itemId
    if not itemId or itemId == "" then
        -- Add the player without the item.
        SoftRes.list:addSoftReservePlayer(playerName)
    else
        -- Add the player
        SoftRes.list:addSoftReservePlayer(playerName, itemId)
    end

    -- ReOrder the list.
    SoftRes.list:reOrderPlayerList()

    -- Refresh the list.
    SoftRes.list:showFullSoftResList()
    SoftRes.debug:print("Added player: " .. playerName)

    -- close the window.
    FRAMES.addPlayerPopupWindow:Hide()

    -- Send all info to clients. (Not rules)
    SoftRes.helpers:sendAllInfo(false)
end)

-- EditBox name
FRAMES.addPlayerNameEditBox:SetScript("OnTabPressed", function(self)
    FRAMES.addPlayerItemEditBox:SetFocus()
    FRAMES.addPlayerItemEditBox:HighlightText()
end)

FRAMES.addPlayerNameEditBox:SetScript("OnTextChanged", function(self)
    if #self:GetText() > 0 then
        BUTTONS.addPlayerPopUpAddButton:Show()
    else
        BUTTONS.addPlayerPopUpAddButton:Hide()
    end
end)

FRAMES.addPlayerItemEditBox:SetScript("OnTabPressed", function(self)
    FRAMES.addPlayerNameEditBox:SetFocus()
    FRAMES.addPlayerNameEditBox:HighlightText()
end)

-- HOOK ... Clear focus if you click.
-- Can only link items into the editbox.
FRAMES.addPlayerItemEditBox:SetScript("OnCursorChanged", function(self)
    FRAMES.addPlayerItemEditBox:ClearFocus()
end)

FRAMES.addPlayerItemEditBox:SetScript("OnEditFocusGained", function(self)
end)

FRAMES.addPlayerPopupWindow:SetScript("OnShow", function(self)
    -- Alert the player.
    SoftRes.addPlayer = true
    BUTTONS.addPlayerPopUpAddButton:Hide()

    -- Clear the editboxes.
    FRAMES.addPlayerNameEditBox:SetText("")

    -- Set the text.
    FRAMES.addPlayerNameEditBox.fs:SetText("To add a new player\nsimply enter the Player name \n and (or not) the linked item.\n\nPlayer Name:")

    local origChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow
    ChatFrame_OnHyperlinkShow = function(...)
        local chatFrame, link, text, button = ...
        if FRAMES.addPlayerItemEditBox:GetText() == "" and IsShiftKeyDown() then
            local itemId = SoftRes.helpers:getItemIdFromLink(link)
            local itemLink = SoftRes.helpers:getItemLinkFromId(itemId)

            FRAMES.addPlayerItemEditBox:SetText(itemLink)
            FRAMES.editPlayerEditItemEditBox:SetText("")
            return
        end
        return origChatFrame_OnHyperlinkShow(...)
    end

    hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", function(self, button)
        if IsShiftKeyDown() and button == "LeftButton" and self:GetParent():GetID() <= 5 then 
            local _, itemLink = GetItemInfo(GetContainerItemID(self:GetParent():GetID(), self:GetID()))
            ClearCursor()
            FRAMES.addPlayerItemEditBox:SetText(itemLink)
            FRAMES.editPlayerEditItemEditBox:SetText("")
            return
        end 
    end)
end)

FRAMES.addPlayerPopupWindow:SetScript("OnHide", function(self)
    -- Alert the player.
    SoftRes.addPlayer = false
    
    -- Clear the editboxes.
    FRAMES.addPlayerNameEditBox:SetText("")
    FRAMES.addPlayerItemEditBox:SetText("")
end)

BUTTONS.addPlayerItemClearButton:SetScript("OnClick", function(self)
    FRAMES.addPlayerItemEditBox:SetText("")
end)

FRAMES.deletePlayerEditBox:SetScript("OnTextChanged", function(self)
    if self:GetText() == "delete" then
        BUTTONS.deletePlayerPopUpDeleteButton:Show()
    else
        BUTTONS.deletePlayerPopUpDeleteButton:Hide()
    end
end)

BUTTONS.deletePlayerPopUpDeleteButton:SetScript("OnClick", function(self)
    local editPlayer = SoftRes.player:getPlayerFromPlayerName(UIDropDownMenu_GetText(BUTTONS.deletePlayerDropDown))

    -- If there is no player to edit. Then don't.
    if not editPlayer then return end

    local editPlayerItem = SoftRes.helpers:getItemLinkFromId(editPlayer.softReserve.itemId)
    if not editPlayerItem then editPlayerItem = "" end

    -- Delete the player
    SoftRes.list:removeSoftReserve(editPlayer.name)

    -- ReOrder the list
    SoftRes.list:reOrderPlayerList()

    -- ReDraw the list.
    SoftRes.list:showFullSoftResList()

    -- Re-Initiate the dropdown list.
    BUTTONS.deletePlayerDropDownInit()
    SoftRes.debug:print("Deleted player: " .. editPlayer.name)

    BUTTONS.deletePlayerPopUpDeleteButton:Hide()
    FRAMES.deletePlayerPopupWindow:Hide()

    -- Send all info to clients. (Not rules)
    SoftRes.helpers:sendAllInfo(false)
end)

BUTTONS.deletePlayerPopUpCancelButton:SetScript("OnClick", function(self)
    FRAMES.deletePlayerEditBox:SetText("")
    BUTTONS.deletePlayerPopUpDeleteButton:Hide()
    FRAMES.deletePlayerPopupWindow:Hide()
end)

FRAMES.deletePlayerPopupWindow:SetScript("OnShow", function(self)
    -- Alert the player.
    SoftRes.state:toggleAlertPlayer(true, "Del")
end)

FRAMES.deletePlayerPopupWindow:SetScript("OnHide", function(self)
    -- Alert the player.
    FRAMES.deletePlayerEditBox:SetText("")
    SoftRes.state:toggleAlertPlayer(false)
end)

-- Edit
function BUTTONS.editPlayerDropDown_Initialize(self)
    -- If there are no players, don't initialize the list.
    if #SoftResList.players <= 1 then return end

    -- Clear the text.
    UIDropDownMenu_SetText(self, "")

    for i = 1, #SoftResList.players do
        if not SoftResList.players[i] then break end
        if #SoftResList.players[i].receivedItems > 0 then

            local info = UIDropDownMenu_CreateInfo()
            info.hasArrow = false
            info.notCheckable = true
            info.text = SoftResList.players[i].name
            info.value = SoftResList.players[i].name
            info.func = function()
                UIDropDownMenu_SetText(self, SoftResList.players[i].name)
                UIDropDownMenu_Initialize(BUTTONS.editPlayerItemDropDown, BUTTONS.editPlayerItemDropDown_Initialize)
            end
            UIDropDownMenu_AddButton(info)
        end
    end
end

function BUTTONS.editPlayerDropDownInit()
    if #SoftResList.players <= 1 then return end

    UIDropDownMenu_Initialize(BUTTONS.editPlayerDropDown, BUTTONS.editPlayerDropDown_Initialize)
end

function BUTTONS.editPlayerItemDropDown_Initialize(self)
    -- If there are no players, don't initialize the list.
    if #SoftResList.players <= 1 then return end

    -- Get the player from the name.
    local player = SoftRes.player:getPlayerFromPlayerName(UIDropDownMenu_GetText(BUTTONS.editPlayerDropDown))
    if not player then return end

    -- Clear the text.
    UIDropDownMenu_SetText(self, "")
    self:Show()

    -- Then we check for the items.
    for i = 1, #player.receivedItems do
        if not player.receivedItems[i] then break end

        local itemLink = SoftRes.helpers:getItemLinkFromId(player.receivedItems[i][3])
        local itemIndex = i

        local info = UIDropDownMenu_CreateInfo()
        info.hasArrow = false
        info.notCheckable = true
        info.text = itemLink
        info.value = i
        info.func = function()
            UIDropDownMenu_SetSelectedValue(self, i)
            UIDropDownMenu_SetText(self, itemLink)
            UIDropDownMenu_Initialize(BUTTONS.rollTypeDropDown, BUTTONS.rollTypeDropDown_Initialize)
            UIDropDownMenu_SetText(BUTTONS.rollTypeDropDown, player.receivedItems[i][2])
        end
        UIDropDownMenu_AddButton(info)
    end
end

function BUTTONS.rollTypeDropDown_Initialize(self)
    -- If there are no players, don't initialize the list.
    if #SoftResList.players <= 1 then return end

    -- Get the player from the name.
    local player = SoftRes.player:getPlayerFromPlayerName(UIDropDownMenu_GetText(BUTTONS.editPlayerDropDown))
    local itemIndex = UIDropDownMenu_GetSelectedValue(BUTTONS.editPlayerItemDropDown)

    if (not player) or (not itemIndex) then return end

    -- Set the default value.
    local rollType = player.receivedItems[itemIndex][2]
    local penalty = player.receivedItems[itemIndex][5]
    self:Show()
    BUTTONS.editPenaltyButton:Show()
    BUTTONS.editPenaltyButton:SetChecked(penalty)
    FRAMES.deletePlayerItemEditBox:Show()
    BUTTONS.editPlayerPopUpDeleteButton:Show()

    -- Set the rollTypes.
    local rollTypes = {
        "ms",
        "os",
        "ffa"
    }

    -- Then we check for the type
    for i = 1, #rollTypes do
        local info = UIDropDownMenu_CreateInfo()
        info.hasArrow = false
        info.notCheckable = true
        info.text = rollTypes[i]
        info.value = rollTypes[i]
        info.func = function()
            UIDropDownMenu_SetText(self, rollTypes[i])
        end
        UIDropDownMenu_AddButton(info)
    end
end

BUTTONS.editPlayerPopUpDeleteButton:SetScript("OnClick", function(self)
    local player = SoftRes.player:getPlayerFromPlayerName(UIDropDownMenu_GetText(BUTTONS.editPlayerDropDown))
    local playerName = UIDropDownMenu_GetText(BUTTONS.editPlayerDropDown)
    local playerItem = SoftRes.helpers:getItemIdFromLink(UIDropDownMenu_GetText(BUTTONS.editPlayerItemDropDown))
    local playerItemIndex = UIDropDownMenu_GetSelectedValue(BUTTONS.editPlayerItemDropDown)
    local playerRollType = UIDropDownMenu_GetText(BUTTONS.rollTypeDropDown)
    local playerPenalty = BUTTONS.editPenaltyButton:GetChecked()
    local deleteItemText = FRAMES.deletePlayerItemEditBox:GetText()

    -- If there is no player to edit. Then don't.
    if (not playerName) or (not playerItem) then
        return
    end

    -- removal code
    -- Set the new values.
    if deleteItemText == "delete" then
        table.remove(player.receivedItems, playerItemIndex)
    else
        if tonumber(playerItem) == tonumber(player.receivedItems[playerItemIndex][3]) then
            player.receivedItems[playerItemIndex][2] = playerRollType
            player.receivedItems[playerItemIndex][5] = playerPenalty
        end
    end

    -- ReOrder the list
    SoftRes.list:reOrderPlayerList()

    -- ReDraw the list.
    SoftRes.list:showFullSoftResList()

    -- Re-Initiate the dropdown list.
    UIDropDownMenu_SetText(BUTTONS.editPlayerItemDropDown, "")
    UIDropDownMenu_SetText(BUTTONS.rollTypeDropDown, "")
    UIDropDownMenu_Initialize(BUTTONS.editPlayerDropDown, BUTTONS.editPlayerDropDown_Initialize)
    FRAMES.deletePlayerItemEditBox:SetText("")

    -- Hide the buttons again.
    BUTTONS.editPlayerItemDropDown:Hide()
    BUTTONS.rollTypeDropDown:Hide()
    BUTTONS.editPenaltyButton:Hide()
    FRAMES.deletePlayerItemEditBox:Hide()
    
    SoftRes.debug:print("Edited player: " .. player.name)

    BUTTONS.editPlayerPopUpDeleteButton:Hide()
    FRAMES.editPlayerPopupWindow:Hide()

    -- Send all info to clients. (Not rules)
    SoftRes.helpers:sendAllInfo(false)
end)

BUTTONS.editPlayerPopUpCancelButton:SetScript("OnClick", function(self)
    BUTTONS.editPlayerPopUpDeleteButton:Hide()
    FRAMES.editPlayerPopupWindow:Hide()
    BUTTONS.editPlayerPopUpResetLootButton:Show()
end)

FRAMES.editPlayerPopupWindow:SetScript("OnShow", function(self)
    BUTTONS.editPlayerItemDropDown:Hide()
    BUTTONS.rollTypeDropDown:Hide()
    BUTTONS.editPenaltyButton:Hide()
    FRAMES.deletePlayerItemEditBox:Hide()
    BUTTONS.editPlayerDropDownInit()
end)

FRAMES.editPlayerPopupWindow:SetScript("OnHide", function(self)

end)

-- Add / Edit players, softres.
FRAMES.editPlayerAddPlayerPopupWindow:SetScript("OnShow", function(self)
    -- Alert the player.
    SoftRes.state:toggleAlertPlayer(true, "Add")

    -- Set framevisibility.
    FRAMES.addPlayerPopupWindow:Hide()
    FRAMES.editPlayerEditPopupWindow:Hide()
end)

FRAMES.editPlayerAddPlayerPopupWindow:SetScript("OnHide", function(self)
    -- Alert the player.
    SoftRes.state:toggleAlertPlayer(false)
end)

FRAMES.editPlayerEditPopupWindow:SetScript("OnShow", function(self)
    SoftRes.editPlayer = true
    BUTTONS.editPlayerPopUpEditButton:Hide()
    FRAMES.editPlayerEditItemEditBox:Hide()
    BUTTONS.editPlayerEditItemClearButton:Hide()
    BUTTONS.editPlayerEditSoftResButton:Hide()

    local origChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow
    ChatFrame_OnHyperlinkShow = function(...)
        local chatFrame, link, text, button = ...
        if FRAMES.editPlayerEditItemEditBox:GetText() == "" and IsShiftKeyDown() then
            local itemId = SoftRes.helpers:getItemIdFromLink(link)
            local itemLink = SoftRes.helpers:getItemLinkFromId(itemId)
            FRAMES.addPlayerItemEditBox:SetText("")
            FRAMES.editPlayerEditItemEditBox:SetText(itemLink)
            return
        end
        return origChatFrame_OnHyperlinkShow(...)
    end

    hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", function(self, button)
        if IsShiftKeyDown() and button == "LeftButton" and self:GetParent():GetID() <= 5 then 
            local _, itemLink = GetItemInfo(GetContainerItemID(self:GetParent():GetID(), self:GetID()))
            ClearCursor()
            FRAMES.addPlayerItemEditBox:SetText("")
            FRAMES.editPlayerEditItemEditBox:SetText(itemLink)
            return
        end 
    end)
end)

FRAMES.editPlayerEditPopupWindow:SetScript("OnHide", function(self)
    SoftRes.editPlayer = false
end)

BUTTONS.editPlayerPopUpAddPlayerButton:SetScript("OnClick", function(self)
    FRAMES.addPlayerPopupWindow:Show()
    FRAMES.editPlayerEditPopupWindow:Hide()
end)

BUTTONS.editPlayerPopUpEditPlayerButton:SetScript("OnClick", function(self)
    FRAMES.addPlayerPopupWindow:Hide()
    FRAMES.editPlayerEditPopupWindow:Show()
    FRAMES.editPlayerEditItemEditBox:SetText("")
    UIDropDownMenu_Initialize(BUTTONS.editPlayerEditDropDown, BUTTONS.editPlayerEditDropDown_Initialize)
end)

BUTTONS.editPlayerEditPopUpCancelButton:SetScript("OnClick", function(self) 
    FRAMES.editPlayerEditPopupWindow:Hide()
    FRAMES.editPlayerEditItemEditBox:SetText("")
end)

BUTTONS.editPlayerEditItemClearButton:SetScript("OnClick", function(self)
    FRAMES.editPlayerEditItemEditBox:SetText("")
end)

FRAMES.editPlayerEditItemEditBox:SetScript("OnCursorChanged", function(self)
    FRAMES.editPlayerEditItemEditBox:ClearFocus()
end)

function BUTTONS.editPlayerEditDropDown_Initialize(self)
    -- If there are no players, don't initialize the list.
    if #SoftResList.players <= 1 then return end

    -- Clear the text.
    UIDropDownMenu_SetText(self, "")

    for i = 1, #SoftResList.players do
        if not SoftResList.players[i] then break end

        local itemId = SoftResList.players[i].softReserve.itemId
        local itemLink = SoftRes.helpers:getItemLinkFromId(itemId)
        local receivedSoftReserve = SoftResList.players[i].softReserve.received

        if not itemLink then itemLink = "" end

        local info = UIDropDownMenu_CreateInfo()
        info.hasArrow = false
        info.notCheckable = true
        info.text = SoftResList.players[i].name
        info.value = SoftResList.players[i].name
        info.func = function()
            UIDropDownMenu_SetText(self, SoftResList.players[i].name)
            FRAMES.editPlayerEditItemEditBox:SetText(itemLink)
            BUTTONS.editPlayerPopUpEditButton:Show()
            BUTTONS.editPlayerEditSoftResButton:Show()
            BUTTONS.editPlayerEditSoftResButton:SetChecked(receivedSoftReserve)
            FRAMES.editPlayerEditItemEditBox:Show()
            BUTTONS.editPlayerEditItemClearButton:Show()
        end
        UIDropDownMenu_AddButton(info)
    end
end

function BUTTONS.editPlayerEditDropDownInit()
    if #SoftResList.players <= 1 then return end

    UIDropDownMenu_Initialize(BUTTONS.editPlayerEditDropDown, BUTTONS.editPlayerEditDropDown_Initialize)
end

BUTTONS.editPlayerPopUpEditButton:SetScript("OnClick", function(self)

    -- If there are no players, don't initialize the list.
    if #SoftResList.players <= 1 then return end

    -- Get the player from the name.
    local player = SoftRes.player:getPlayerFromPlayerName(UIDropDownMenu_GetText(BUTTONS.editPlayerEditDropDown))
    if not player then return end

    local itemId = SoftRes.helpers:getItemIdFromLink(FRAMES.editPlayerEditItemEditBox:GetText())
    local itemLink = SoftRes.helpers:getItemLinkFromId(itemId)
    local receivedSoftReserve = BUTTONS.editPlayerEditSoftResButton:GetChecked()

    -- set the value.
    player.softReserve.itemId = itemId
    player.softReserve.received = receivedSoftReserve

    -- close the window.
    editPlayerEditPopupWindow:Hide()

    -- Send all info to clients. (Not rules)
    SoftRes.helpers:sendAllInfo(false)
end)

BUTTONS.editPlayerPopUpEditItemButton:SetScript("OnClick", function(self)
    FRAMES.editPlayerPopupWindow:Show()
    FRAMES.editPlayerAddItemPopupWindow:Hide()
    BUTTONS.editPlayerPopUpResetLootButton:Hide()
end)

FRAMES.editPlayerEditItemPopupWindow:SetScript("OnShow", function(self)
    -- Alert the player.
    SoftRes.state:toggleAlertPlayer(true, "Edit")

    FRAMES.editPlayerPopupWindow:Hide()
    FRAMES.editPlayerAddItemPopupWindow:Hide()
    BUTTONS.editPlayerPopUpResetLootButton:Show()
end)

FRAMES.editPlayerEditItemPopupWindow:SetScript("OnHide", function(self)
    -- Alert the player.
    SoftRes.state:toggleAlertPlayer(false)
end)

FRAMES.editPlayerAddItemPopupWindow:SetScript("OnShow", function(self)
    -- Set and hide stuffs.
    FRAMES.editPlayerAddItemEditBox:SetText("")
    FRAMES.editPlayerAddItemEditBox:Hide()
    BUTTONS.editPlayerAddItemClearButton:Hide()
    BUTTONS.editPlayerAddItemRollTypeDropDown:Hide()
    UIDropDownMenu_Initialize(BUTTONS.editPlayerAddItemRollTypeDropDown, BUTTONS.editPlayerAddItemRollTypeDropDown_Initialize)
    BUTTONS.editPlayerAddItemPenaltyButton:Hide()
    BUTTONS.editPlayerAddItemAddButton:Hide()

    -- Hook for getting hyperlinks on shift+click
    local origChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow
    ChatFrame_OnHyperlinkShow = function(...)
        local chatFrame, link, text, button = ...
        if FRAMES.editPlayerAddItemEditBox:GetText() == "" and IsShiftKeyDown() then
            local itemId = SoftRes.helpers:getItemIdFromLink(link)
            local itemLink = SoftRes.helpers:getItemLinkFromId(itemId)
            FRAMES.editPlayerAddItemEditBox:SetText(itemLink)
            return
        end
        return origChatFrame_OnHyperlinkShow(...)
    end

    hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", function(self, button)
        if IsShiftKeyDown() and button == "LeftButton" and self:GetParent():GetID() <= 5 then 
            local _, itemLink = GetItemInfo(GetContainerItemID(self:GetParent():GetID(), self:GetID()))
            ClearCursor()
            FRAMES.editPlayerAddItemEditBox:SetText(itemLink)
            return
        end 
    end)
end)

BUTTONS.editPlayerPopUpAddItemButton:SetScript("OnClick", function(self)
    FRAMES.editPlayerAddItemPopupWindow:Show()
    FRAMES.editPlayerPopupWindow:Hide()
    BUTTONS.editPlayerAddItemDropDownInit()
    BUTTONS.editPlayerPopUpResetLootButton:Hide()
end)

function BUTTONS.editPlayerAddItemDropDown_Initialize(self)
    -- If there are no players, don't initialize the list.
    if #SoftResList.players <= 1 then return end

    -- Clear the text.
    UIDropDownMenu_SetText(self, "")

    for i = 1, #SoftResList.players do
        if not SoftResList.players[i] then break end

        local info = UIDropDownMenu_CreateInfo()
        info.hasArrow = false
        info.notCheckable = true
        info.text = SoftResList.players[i].name
        info.value = SoftResList.players[i].name
        info.func = function()
            UIDropDownMenu_SetText(self, SoftResList.players[i].name)
            FRAMES.editPlayerAddItemEditBox:Show()
            BUTTONS.editPlayerAddItemClearButton:Show()
            BUTTONS.editPlayerAddItemRollTypeDropDown:Show()
            BUTTONS.editPlayerAddItemPenaltyButton:Show()
            BUTTONS.editPlayerAddItemPenaltyButton:SetChecked(true)
        end
        UIDropDownMenu_AddButton(info)
    end
end

function BUTTONS.editPlayerAddItemDropDownInit()
    if #SoftResList.players <= 1 then return end

    UIDropDownMenu_Initialize(BUTTONS.editPlayerAddItemDropDown, BUTTONS.editPlayerAddItemDropDown_Initialize)
end

BUTTONS.editPlayerAddItemClearButton:SetScript("OnClick", function(self)
    FRAMES.editPlayerAddItemEditBox:SetText("")
    BUTTONS.editPlayerAddItemAddButton:Hide()
end)

FRAMES.editPlayerAddItemEditBox:SetScript("OnCursorChanged", function(self)
    FRAMES.editPlayerAddItemEditBox:ClearFocus()
end)

function BUTTONS.editPlayerAddItemRollTypeDropDown_Initialize(self)
    -- If there are no players, don't initialize the list.
    if #SoftResList.players <= 1 then return end

    -- Set the rollTypes.
    local rollTypes = {
        "ms",
        "os",
        "ffa"
    }

    -- Set default to MS.
    UIDropDownMenu_SetText(self, rollTypes[1])

    -- Then we check for the type
    for i = 1, #rollTypes do
        local info = UIDropDownMenu_CreateInfo()
        info.hasArrow = false
        info.notCheckable = true
        info.text = rollTypes[i]
        info.value = rollTypes[i]
        info.func = function()
            UIDropDownMenu_SetText(self, rollTypes[i])
        end
        UIDropDownMenu_AddButton(info)
    end
end

FRAMES.editPlayerAddItemEditBox:SetScript("OnTextChanged", function(self)
    if #self:GetText() > 0 then
        BUTTONS.editPlayerAddItemAddButton:Show()
    end
end)

BUTTONS.editPlayerAddItemCancelButton:SetScript("OnClick", function(self) 
    FRAMES.editPlayerAddItemPopupWindow:Hide()
    BUTTONS.editPlayerPopUpResetLootButton:Show()
end)

BUTTONS.editPlayerAddItemAddButton:SetScript("OnClick", function(self)
    -- If there are no players, don't initialize the list.
    if #SoftResList.players <= 1 then return end

    -- Get the player from the name.
    local player = SoftRes.player:getPlayerFromPlayerName(UIDropDownMenu_GetText(BUTTONS.editPlayerAddItemDropDown))
    if not player then return end

    local itemId = SoftRes.helpers:getItemIdFromLink(FRAMES.editPlayerAddItemEditBox:GetText())
    local itemLink = SoftRes.helpers:getItemLinkFromId(itemId)

    local rollType = UIDropDownMenu_GetText(BUTTONS.editPlayerAddItemRollTypeDropDown)
    local penalty = BUTTONS.editPlayerAddItemPenaltyButton:GetChecked()

    -- Add it to the received items list.
    table.insert(player.receivedItems, {time(), rollType, itemId, 0, penalty})

    -- close the window.
    editPlayerAddItemPopupWindow:Hide()

    -- Send all info to clients. (Not rules)
    SoftRes.helpers:sendAllInfo(false)
end)

-- Switch lootType between GroupLoot and Masterloot.
local function setMasterLooter(flag)
    
    -- Get the current lootmethod.
    lootmethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod()
 
    -- If we want it to be master-looter and it isn't already.
    -- Make it masterlooter.
    if flag and lootmethod ~= "master" then
        SetLootMethod("master", GetUnitName("Player"))
    elseif not flag or lootmethod == "master" then
        SetLootMethod("group")
    end
end

-- Master Looter
BUTTONS.masterLooterCheckButton:SetScript("OnClick", function(self)
    local isIn = false
    local rank = 0
    
    -- Get loot method.
    lootmethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod()

    -- Get the player raidNumber
    for i = 1, GetNumGroupMembers(), 1 do
        local name = ""
        
        name, rank = GetRaidRosterInfo(i)

        -- IF we find the user
        if name == GetUnitName("Player") then
            isIn = true
            break
        end
    end

    -- If we are of the correct rank (leader) to be able to change the Loot type.
    if isIn and rank == 2 then
        if self:GetChecked(true) then
            setMasterLooter(true)
        else
            setMasterLooter(false)
        end
    end
end)

-- If we want to reset all the received loot penalties.
BUTTONS.editPlayerPopUpResetLootButton:SetScript("OnClick", function(self)
    -- Popup dialog for creating a new list.
    StaticPopupDialogs["SOFTRES_RESET_ALL_PENALTIES"] = {
        text = "Do you really want to reset all received lootpenalties?\nThis is final and can't be reverted.",
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            
            -- Switch the won item loot-type to FFA from anything.
            for i = 1, #SoftResList.players, 1 do
                local player = SoftResList.players[i]

                -- If the player has received any items. Do your thing.
                if #player.receivedItems > 0 then
                    
                    -- We go through all the loot.
                    for j = 1, #player.receivedItems, 1 do

                        -- set the penalty to false.
                        player.receivedItems[j][5] = false
                    end
                end
            end

            -- Send all info to clients. (Not rules)
            SoftRes.helpers:sendAllInfo(false)

        end,
        OnCancel = function (_,reason)
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    StaticPopup_Show ("SOFTRES_RESET_ALL_PENALTIES")
end)

-- Announce the SoftReservations to the raid.
BUTTONS.announceAllSoftresButton:SetScript("OnClick", function(self)
        -- Popup dialog for for accepting the announcement or not.
        StaticPopupDialogs["SOFTRES_ANNOUNCE_SOFTRESERVERATIONS"] = {
            text = "Do you want to announce the SoftReservations?\nThis will post all reservations in chat.",
            button1 = "Yes",
            button2 = "No",
            OnAccept = function()
                
                local softReservedItems = {}

                -- get all softreserved items.
                for i = 1, #SoftResList.players, 1 do
                    local itemId = SoftResList.players[i].softReserve.itemId
                    local playerName = SoftResList.players[i].name
                    local isIn = false

                    -- check the itemList.
                    -- If item not in list, put it in there.
                    for j = 1, #softReservedItems, 1 do

                        if itemId == softReservedItems[j][1] then
                            isIn = true
                            table.insert(softReservedItems[j][2], playerName)
                        end
                    end

                    -- if the item was not in the list.
                    if not isIn then
                        table.insert(softReservedItems, {itemId, {playerName}})
                    end
                end

                -- send the list to the party.
                SoftRes.announce:sendMessageToChat("Party", "[SoftRes-List]-------------+")

                for i = 1, #softReservedItems, 1 do
                    local itemId = softReservedItems[i][1]
                    local itemLink = SoftRes.helpers:getItemLinkFromId(itemId)
                    local players = ""

                    for j = 1, #softReservedItems[i][2], 1 do
                        players = players .. softReservedItems[i][2][j] .. ". "
                    end

                    if itemLink then
                        SoftRes.announce:sendMessageToChat("Party", itemLink .. " " .. players)
                    end
                end

                SoftRes.announce:sendMessageToChat("Party", "+----------------------------+")
                SoftRes.announce:sendMessageToChat("Party", ">> LIST PUSHED TO CLIENTS <<")

                -- send the list to the clients.
                if SoftResConfig.state.softResClientBroadCast then
                    SoftRes.helpers:sendListToClients()
                end
                
    
            end,
            OnCancel = function (_,reason)
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
        }
    
        StaticPopup_Show ("SOFTRES_ANNOUNCE_SOFTRESERVERATIONS")
end)

-- Import list
BUTTONS.importListButton:SetScript("OnClick", function(self)
    if not SoftRes.helpers:checkAlertPlayer("Imp") then return end
    FRAMES.importListPopupWindow:Show()
end)


function BUTTONS.importListDropDownInit()
    UIDropDownMenu_Initialize(BUTTONS.importListDropDown, BUTTONS.importListDropDown_Initialize)
end

function BUTTONS.importListDropDown_Initialize(self)
    local importTypes = {
        "softres.it",
    }
    
    -- Set default to MS.
    UIDropDownMenu_SetText(self, importTypes[1])

    -- Then we check for the type
    for i = 1, #importTypes do
        local info = UIDropDownMenu_CreateInfo()
        info.hasArrow = false
        info.notCheckable = true
        info.text = importTypes[i]
        info.value = importTypes[i]
        info.func = function()
            UIDropDownMenu_SetText(self, importTypes[i])
        end
        UIDropDownMenu_AddButton(info)
    end
end

-- Import popup show
FRAMES.importListPopupWindow:SetScript("OnShow", function(self)

    -- Alert the player.
    SoftRes.state:toggleAlertPlayer(true, "Imp")

    -- Set the drop-down list.
    BUTTONS.importListDropDownInit()
end)

-- import Popup hide
FRAMES.importListPopupWindow:SetScript("OnHide", function(self)
    SoftRes.state:toggleAlertPlayer(false)
end)

-- Cancel import
BUTTONS.importListPopUpCancelButton:SetScript("OnClick", function(self)
    FRAMES.importListPopupWindow:Hide()
end)

-- Clear button
BUTTONS.importListClearButton:SetScript("OnClick", function(self)

    -- Clear the text.
    FRAMES.importListEditBox:SetText("")
end)

-- Editbox on escape pressed.
FRAMES.importListEditBox:SetScript("OnEscapePressed", function(self)

    -- Clear focus
    self:ClearFocus()
end)


-- Parselists
-- SoftRes.it
local function parseSoftResIt(importString)
    if (not importString) then return false end

    local rows = SoftRes.helpers:stringSplit(importString, "\n")
    if (not rows) then return false end

    -- clear the current list.
    SoftRes.list:createNewSoftResList()

    -- let's add the players!!
    -- Start on the second row.
    for i = 2, #rows, 1 do
        local _, rowItemId, _, rowName = strsplit(",", rows[i])

        if (not rowName) or (not rowItemId) then return false end

        -- Format the playername. First char upper, rest lower.
        local playerName = SoftRes.helpers:formatPlayerName(rowName)

        -- Format the itemId.
        local itemId = GetItemInfo(rowItemId)

        -- Check the itemId
        if itemId or itemId ~= "" then

            -- Add the player
            SoftRes.list:addSoftReservePlayer(playerName, rowItemId)
        end
    end

    return true
end

-- import button pressed.
BUTTONS.importListPopupImportButton:SetScript("OnClick", function(self)

    -- Popup window, clear list and import yes/no
    StaticPopupDialogs["SOFTRES_IMPORT_LIST"] = {
        text = "Do you really want to import the new list?\nThis will clear the current list.",
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            
            -- variables
            local importSuccess = false

            -- get the text.
            local importString = FRAMES.importListEditBox:GetText()

            if importString == "" then return end

            -- Check what type to parse.
            local importType = UIDropDownMenu_GetText(BUTTONS.importListDropDown)
           
            if importType == "softres.it" then
                importSuccess = parseSoftResIt(importString)
            end

            -- clear the text
            if importSuccess then

                FRAMES.importListEditBox:SetText("")
                FRAMES.importListPopupWindow:Hide()

                -- Add players who are not on the SoftRes list.
                SoftRes.helpers:addPlayersNotOnList()
            else
                FRAMES.importListEditBox:SetText("FAILED TO IMPORT!!")
            end

            SoftRes.list:reOrderPlayerList()
            SoftRes.list:showFullSoftResList()

        end,
        OnCancel = function (_,reason)
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    StaticPopup_Show ("SOFTRES_IMPORT_LIST")
end)

BUTTONS.announceMissingSoftresButton:SetScript("OnClick", function(self)

    local players = ""
    local numPlayers = 0

    -- Search through the softres list.
    for i = 1, #SoftResList.players, 1 do

        local player = SoftResList.players[i]

        if (not player.softReserve.itemId) then
            players = players .. player.name .. ". "
            numPlayers = numPlayers + 1
        end
    end

    if players ~= "" then
        local numPlayersString = "player has"

        if numPlayers > 1 then
            numPlayersString = "players have"
        end

        SoftRes.announce:sendMessageToChat("Party_Leader", "The following " .. numPlayersString .. " not made a reservation.")
        SoftRes.announce:sendMessageToChat("Party_Leader", players)
    end

end)

-- CLIENT MODE --
-----------------

-- Request a new list from the master looter.
BUTTONS.clientModeRequestListButton:SetScript("OnClick", function(self)

    -- Popup window, clear list and import yes/no
    StaticPopupDialogs["SOFTRES_CLIENT_REQUEST_LIST"] = {
        text = "Are you sure you want to request a new list from the ML?",
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            
            -- Client request, list.
            aceComm:SendCommMessage(SoftRes.comm, "CR::List", "RAID");
    
        end,
        OnCancel = function (_,reason)
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    StaticPopup_Show ("SOFTRES_CLIENT_REQUEST_LIST")
end)

FRAMES.clientModeAnnouncedItemFrame:SetScript("OnEnter",
   function(self)
      -- TOOLTIP
      if SoftRes.announcedItem.itemId then
         GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
         GameTooltip:SetHyperlink(SoftRes.helpers:getItemLinkFromId(SoftRes.announcedItem.itemId))
         GameTooltip:Show()
      end
end)

FRAMES.clientModeAnnouncedItemFrame:SetScript("OnLeave",
   function(self)
      GameTooltip:Hide()
end)

-- Send /roll
BUTTONS.clientModeAnnouncedItemRollButton:SetScript("OnClick", function(self)
    RandomRoll(1, 100)
end)