-- OnUpdate for mainframe
FRAMES.mainFrame.updateInterval = 1.0; -- How often the OnUpdate code will run (in seconds)
FRAMES.mainFrame.timeSinceLastUpdate = 0
FRAMES.mainFrame.scanDots = 1

FRAMES.mainFrame:SetScript("OnUpdate", function(self, elapsed)
  self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed;
  
  if (self.timeSinceLastUpdate > FRAMES.mainFrame.updateInterval) then

    -- If we're scanning for softresses.
    -- Show an indicator on the top right, so it's shown.
    if SoftRes.state.scanForSoftRes.state then
        self.scanDots = self.scanDots + 1
        if self.scanDots > 3 then self.scanDots = 1 end

        local scanText = ""
        for i = 1, self.scanDots do
            scanText = scanText .. "."
        end
        
        FRAMES.mainFrame.titleRight:SetText("|cFF00FF00Scan" .. scanText .. "|r")
    else
        FRAMES.mainFrame.titleRight:SetText("")
    end

    self.timeSinceLastUpdate = 0;
  end
end)

-- TabButtons
BUTTONS.tabButtonPage[1]:SetScript("OnClick", function(self)
    if not self.active then
        BUTTONS.tabButtonPage[1]:SetFrameLevel(BUTTONS.tabButtonPage[1]:GetFrameLevel() + 1)
        BUTTONS.tabButtonPage[1].active = true
        FRAMES.tabContainer.page1:Show()
        BUTTONS.tabButtonPage[2]:SetFrameLevel(BUTTONS.tabButtonPage[1]:GetFrameLevel() - 1)
        BUTTONS.tabButtonPage[2].active = false
        FRAMES.tabContainer.page2:Hide()
        BUTTONS.tabButtonPage[3]:SetFrameLevel(BUTTONS.tabButtonPage[1]:GetFrameLevel() - 1)
        BUTTONS.tabButtonPage[3].active = false
        --FRAMES.tabContainer.page3:Hide()
    end
end)

BUTTONS.tabButtonPage[2]:SetScript("OnClick", function(self)
    if not self.active then
        BUTTONS.tabButtonPage[2]:SetFrameLevel(BUTTONS.tabButtonPage[2]:GetFrameLevel() + 1)
        BUTTONS.tabButtonPage[2].active = true
        FRAMES.tabContainer.page2:Show()
        BUTTONS.tabButtonPage[3]:SetFrameLevel(BUTTONS.tabButtonPage[2]:GetFrameLevel() - 1)
        BUTTONS.tabButtonPage[3].active = false
        --FRAMES.tabContainer.page3:Hide()
        BUTTONS.tabButtonPage[1]:SetFrameLevel(BUTTONS.tabButtonPage[2]:GetFrameLevel() - 1)
        BUTTONS.tabButtonPage[1].active = false
        FRAMES.tabContainer.page1:Hide()
    end
end)

BUTTONS.tabButtonPage[3]:SetScript("OnClick", function(self)
    if not self.active then
        BUTTONS.tabButtonPage[3]:SetFrameLevel(BUTTONS.tabButtonPage[3]:GetFrameLevel() + 1)
        BUTTONS.tabButtonPage[3].active = true
        --FRAMES.tabContainer.page3:Show()
        BUTTONS.tabButtonPage[1]:SetFrameLevel(BUTTONS.tabButtonPage[3]:GetFrameLevel() - 1)
        BUTTONS.tabButtonPage[1].active = false
        FRAMES.tabContainer.page1:Hide()
        BUTTONS.tabButtonPage[2]:SetFrameLevel(BUTTONS.tabButtonPage[3]:GetFrameLevel() - 1)
        BUTTONS.tabButtonPage[2].active = false
        FRAMES.tabContainer.page2:Hide()
    end
end)

function BUTTONS.editPlayerDropDown_Initialize(self)
    -- If there are no players, don't initialize the list.
    if #SoftResList.players <= 1 then return end

    for i = 1, #SoftResList.players do
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
        text = "Do you really want to generate a new list?\nThis will remove all the entries.",
        button1 = "Yes",
        button2 = "No",
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
        text = "Editing " .. editPlayer.name .. ".\n\nType 'delete' and press the 'delete' button, to remove the softres.",
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
    
    -- call the toggle function without a flag, to really toggle it.
    SoftRes.state:toggleScanForSoftRes()

    -- redraw the list.
    SoftRes.list:showFullSoftResList()
end)