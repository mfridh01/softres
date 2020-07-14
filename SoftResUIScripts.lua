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
        BUTTONS.tabButtonPage[3]:SetFrameLevel(BUTTONS.tabButtonPage[1]:GetFrameLevel() - 1)
        BUTTONS.tabButtonPage[3].active = false
    end
end)

BUTTONS.tabButtonPage[2]:SetScript("OnClick", function(self)
    if not self.active then
        BUTTONS.tabButtonPage[2]:SetFrameLevel(BUTTONS.tabButtonPage[2]:GetFrameLevel() + 1)
        BUTTONS.tabButtonPage[2].active = true
        BUTTONS.tabButtonPage[3]:SetFrameLevel(BUTTONS.tabButtonPage[2]:GetFrameLevel() - 1)
        BUTTONS.tabButtonPage[3].active = false
        BUTTONS.tabButtonPage[1]:SetFrameLevel(BUTTONS.tabButtonPage[2]:GetFrameLevel() - 1)
        BUTTONS.tabButtonPage[1].active = false
        FRAMES.tabContainer.page1:Hide()
    end
end)

BUTTONS.tabButtonPage[3]:SetScript("OnClick", function(self)
    if not self.active then
        BUTTONS.tabButtonPage[3]:SetFrameLevel(BUTTONS.tabButtonPage[3]:GetFrameLevel() + 1)
        BUTTONS.tabButtonPage[3].active = true
        BUTTONS.tabButtonPage[1]:SetFrameLevel(BUTTONS.tabButtonPage[3]:GetFrameLevel() - 1)
        BUTTONS.tabButtonPage[1].active = false
        FRAMES.tabContainer.page1:Hide()
        BUTTONS.tabButtonPage[2]:SetFrameLevel(BUTTONS.tabButtonPage[3]:GetFrameLevel() - 1)
        BUTTONS.tabButtonPage[2].active = false
    end
end)