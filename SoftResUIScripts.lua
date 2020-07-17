-- OnUpdate for mainframe
FRAMES.mainFrame.updateInterval = 1.0; -- How often the OnUpdate code will run (in seconds)
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

    self.timeSinceLastUpdate = 0;
  end
end)

-- TabButtons
for i = 1, #BUTTONS.tabButtonPage do
    BUTTONS.tabButtonPage[i]:SetScript("OnClick", function(self)
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
    SoftRes.state:toggleScanForSoftRes()

    -- Toggle alert on.
    SoftRes.state:toggleAlertPlayer(nil, "Scan")

    -- redraw the list.
    SoftRes.list:showFullSoftResList()
end)

-- local function for handling itemdrags
local function handleDraggedItem()
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
        SoftRes.helpers:unPrepareItem()
    elseif button == "LeftButton" and GetCursorInfo() then
        handleDraggedItem()
    end
end)

-- Prepare item
BUTTONS.prepareItemButton:SetScript("OnClick", function(self)
    if SoftRes.preparedItem.itemId and SoftRes.preparedItem.itemId ~= "" then
        print(SoftRes.preparedItem.itemId)
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
    print(SoftResConfig.timer.softRes.value)
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
end)

FRAMES.osRollTimerEditBox:SetScript("OnTabPressed", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.timers.os.minValue, SoftResConfig.timers.os.maxValue), SoftResConfig.timers.os.value)
    SoftResConfig.timers.os.value = text
    FRAMES.ffaRollTimerEditBox:SetFocus()
    FRAMES.ffaRollTimerEditBox:HighlightText()
end)

-- FFA roll timer.
FRAMES.ffaRollTimerEditBox:SetScript("OnTextChanged", function(self)
    -- Convert the text to number.
    local text = tonumber(self:GetText())

    -- if it's not a number, clear the field.
    if not text then
        self:SetText("")
    end
end)

FRAMES.ffaRollTimerEditBox:SetScript("OnEnterPressed", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.timers.ffa.minValue, SoftResConfig.timers.ffa.maxValue), SoftResConfig.timers.ffa.value)
    SoftResConfig.timers.ffa.value = text
end)

FRAMES.ffaRollTimerEditBox:SetScript("OnTabPressed", function(self)
    self:ClearFocus()
    local text = setEditBoxValue(self, SoftRes.helpers:returnMinBetweenOrMax(self:GetText(), SoftResConfig.timers.ffa.minValue, SoftResConfig.timers.ffa.maxValue), SoftResConfig.timers.ffa.value)
    SoftResConfig.timers.ffa.value = text
    FRAMES.softResRollTimerEditBox:SetFocus()
    FRAMES.softResRollTimerEditBox:HighlightText()
end)