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
    -- If there is no list.
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

-- Edit player
BUTTONS.editPlayerButton:SetScript("OnClick", function(self)
    local editPlayer = SoftRes.player:getPlayerFromPlayerName(UIDropDownMenu_GetText(BUTTONS.editPlayerDropDown))
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


--[[ function ChatEdit_LinkItem(itemID, itemLink)
	if ( not itemLink ) then
		itemLink = select(2, GetItemInfo(itemID));
	end
	if ( itemLink ) then
		if ( ChatEdit_GetActiveWindow() ) then
			ChatEdit_InsertLink(itemLink);
		else
			ChatFrame_OpenChat(itemLink);
		end
	end
end

function ChatEdit_InsertLink(text)
	if ( not text ) then
		return false;
	end

	local activeWindow = ChatEdit_GetActiveWindow();
	if ( activeWindow ) then
		activeWindow:Insert(text);
		return true;
	end ]]