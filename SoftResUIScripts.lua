BUTTONS.testButton:SetScript("OnClick", function()
    print("Clicked!")
    UI:createDefaultSoftResConfigList()
    UI:useSavedConfigValues()
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
--        FRAMES.tabContainer.page3:Show()
        BUTTONS.tabButtonPage[1]:SetFrameLevel(BUTTONS.tabButtonPage[3]:GetFrameLevel() - 1)
        BUTTONS.tabButtonPage[1].active = false
        FRAMES.tabContainer.page1:Hide()
        BUTTONS.tabButtonPage[2]:SetFrameLevel(BUTTONS.tabButtonPage[3]:GetFrameLevel() - 1)
        BUTTONS.tabButtonPage[2].active = false
        FRAMES.tabContainer.page2:Hide()
    end
end)

-- Remove player dropdown
-- DropDownData.. dummy data. USE Player for later.
local removePlayerData = {
    "Player1",
    "Player2",
}

function BUTTONS.removePlayerDropDown_Initialize(self)
    for k, v in ipairs(removePlayerData) do
          local info = UIDropDownMenu_CreateInfo()
          info.hasArrow = false
          info.notCheckable = true
          info.text = v
          info.value = v
          info.func = function() UIDropDownMenu_SetText(self, v) end
          UIDropDownMenu_AddButton(info)
    end
end

UIDropDownMenu_Initialize(BUTTONS.removePlayerDropDown, BUTTONS.removePlayerDropDown_Initialize);
UIDropDownMenu_SetText(BUTTONS.removePlayerDropDown, "Player")
ToggleDropDownMenu(1, nil, BUTTONS.removePlayerDropDown, self, 0, 0);