-- UI-Handling.
---------------

-- globals
UI = SoftRes.ui
FRAMES = UI.frames
BUTTONS = UI.buttons

-- Create a new config list, with default values.
function SoftRes.ui:createDefaultSoftResConfigList()
      SoftResConfig = {
            ui = {
                  frames = {
                        mainFrame = {
                              size = {
                                    full = {
                                          width = 338,
                                          height = 284,
                                    }
                              },
                              hidden = false,
                        },
                        tabContainer = {
                              pages = {},
                              size = {
                                    full = {
                                          width = 327,
                                          height = 227,
                                    },
                              },
                              hidden = false,
                        },
                        rollFrameContainer = {
                              size = {
                                    full = {
                                          width = 314-30,
                                          height = 118,
                                    },
                              },
                              hidden = false,
                              child = {
                                    size = {
                                          width = 300,
                                          height = 227,
                                    },
                              },
                        },
                        listFrameContainer = {
                              size = {
                                    full = {
                                          width = 314,
                                          height = 118+30,
                                    },
                              },
                              hidden = false,
                              child = {
                                    size = {
                                          width = 300,
                                          height = 227,
                                    },
                              },
                        },
                  }
            }
      }
end

-- Apply values from saved list, to the frames.
function SoftRes.ui:useSavedConfigValues()
      local CONFIG_UI_FRAMES = SoftResConfig.ui.frames
      FRAMES.mainFrame:SetSize(CONFIG_UI_FRAMES.mainFrame.size.full.width, CONFIG_UI_FRAMES.mainFrame.size.full.height)
      FRAMES.tabContainer:SetSize(CONFIG_UI_FRAMES.tabContainer.size.full.width, CONFIG_UI_FRAMES.tabContainer.size.full.height)
      FRAMES.rollFrameContainer:SetSize(CONFIG_UI_FRAMES.rollFrameContainer.size.full.width, CONFIG_UI_FRAMES.rollFrameContainer.size.full.height)
      FRAMES.rollFrameContainer.child:SetSize(CONFIG_UI_FRAMES.rollFrameContainer.child.size.width, CONFIG_UI_FRAMES.rollFrameContainer.child.size.height)
      FRAMES.listFrameContainer:SetSize(CONFIG_UI_FRAMES.listFrameContainer.size.full.width, CONFIG_UI_FRAMES.listFrameContainer.size.full.height)
      FRAMES.listFrameContainer.child:SetSize(CONFIG_UI_FRAMES.listFrameContainer.child.size.width, CONFIG_UI_FRAMES.listFrameContainer.child.size.height)
end
--------------------------------------------------------------------

-- UI BEGINS HERE.
------------------

--Frames
FRAMES.mainFrame = CreateFrame("Frame", "SoftResMainFrame", UIParent, "BasicFrameTemplate")
      FRAMES.mainFrame:SetFrameStrata("DIALOG")
      FRAMES.mainFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -10)
      FRAMES.mainFrame:SetMovable(true)
      FRAMES.mainFrame:EnableMouse(true)
      FRAMES.mainFrame:RegisterForDrag("LeftButton")
      FRAMES.mainFrame:SetScript("OnDragStart", FRAMES.mainFrame.StartMoving)
      FRAMES.mainFrame:SetScript("OnDragStop", FRAMES.mainFrame.StopMovingOrSizing)

      FRAMES.mainFrame.title = FRAMES.mainFrame:CreateFontString(nil, "Overlay")
            FRAMES.mainFrame.title:SetFontObject("GameFontHighlight")
            FRAMES.mainFrame.title:SetPoint("TOPLEFT", FRAMES.mainFrame.TitleBg, "TOPLEFT", 3, -3)
            FRAMES.mainFrame.title:SetText("Ω SoftRes")

      FRAMES.mainFrame.fs = FRAMES.mainFrame:CreateFontString(nil, "Overlay")
            FRAMES.mainFrame.fs:SetFontObject("GameFontHighlight")
            FRAMES.mainFrame.fs:SetPoint("TOPLEFT", FRAMES.mainFrame, "TOPLEFT", 15, -32)
            FRAMES.mainFrame.fs:SetJustifyH("LEFT")

FRAMES.tabContainer = CreateFrame("Frame", "TabContainer", FRAMES.mainFrame, "InsetFrameTemplate2")
      FRAMES.tabContainer:SetPoint("TOPLEFT", FRAMES.mainFrame, "TOPLEFT", 4, -51)
      FRAMES.tabContainer:SetBackdrop({
            bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
            tile     = true,
            tileSize = 32,
            insets   = { left = 4, right = 4, top = 4, bottom = 4 }
      })


-- PAGE 1
FRAMES.tabContainer.page1 = CreateFrame("Frame", "TabPagesPage1", FRAMES.mainFrame)
            FRAMES.tabContainer.page1:SetPoint("TOPLEFT", FRAMES.tabContainer, "TOPLEFT", 7, -10)
            FRAMES.tabContainer.page1:SetSize(313, 127)
            FRAMES.tabContainer.page1:SetBackdrop({
                  bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
                  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                  tile     = true,
                  tileSize = 32,
                  edgeSize = 10,
                  insets   = { left = 2, right = 2, top = 2, bottom = 2 }
            })
            FRAMES.tabContainer.page1:Show()

FRAMES.rollFrameContainer = CreateFrame("ScrollFrame", "RollFrameContainer", FRAMES.tabContainer.page1, "UIPanelScrollFrameTemplate")
      FRAMES.rollFrameContainer:SetPoint("TOPLEFT", FRAMES.tabContainer.page1, "TOPLEFT", 5, -5)

      
      local  scrollbarName = FRAMES.rollFrameContainer:GetName()
      FRAMES.rollFrameContainer.scrollBar = _G[scrollbarName .. "ScrollBar"]
      FRAMES.rollFrameContainer.scrollUpButton = _G[scrollbarName .. "ScrollBarScrollUpButton"]
      FRAMES.rollFrameContainer.scrollDownButton = _G[scrollbarName .. "ScrollBarScrollDownButton"]

            FRAMES.rollFrameContainer.scrollUpButton:ClearAllPoints()
            FRAMES.rollFrameContainer.scrollUpButton:SetPoint("TOPRIGHT", FRAMES.rollFrameContainer, "TOPRIGHT", -10+30, 0)
      
            FRAMES.rollFrameContainer.scrollDownButton:ClearAllPoints()
            FRAMES.rollFrameContainer.scrollDownButton:SetPoint("BOTTOMRIGHT", FRAMES.rollFrameContainer, "BOTTOMRIGHT", -10+30, 0)      

            FRAMES.rollFrameContainer.scrollBar:ClearAllPoints()
            FRAMES.rollFrameContainer.scrollBar:SetPoint("TOP", FRAMES.rollFrameContainer.scrollUpButton, "BOTTOM", 0, 0)
            FRAMES.rollFrameContainer.scrollBar:SetPoint("BOTTOM", FRAMES.rollFrameContainer.scrollDownButton, "TOP", 0, 0)

      FRAMES.rollFrameContainer.child = CreateFrame("Frame")
      FRAMES.rollFrameContainer:SetScrollChild(FRAMES.rollFrameContainer.child)

FRAMES.rollFrame = CreateFrame("Frame", nil, FRAMES.rollFrameContainer.child)
      FRAMES.rollFrame:SetAllPoints(FRAMES.rollFrameContainer.child)
      FRAMES.rollFrame:EnableMouse()

      FRAMES.rollFrame.fs = FRAMES.rollFrame:CreateFontString(nil, "OVERLAY") -- This is the main list FontString. Populate this one.
            FRAMES.rollFrame.fs:SetFontObject("GameFontHighlightSmall")
            FRAMES.rollFrame.fs:SetFont(FRAMES.rollFrame.fs:GetFont(), 10)
            FRAMES.rollFrame.fs:SetPoint("TOPLEFT", FRAMES.rollFrame, "TOPLEFT", 0, 0)
            FRAMES.rollFrame.fs:SetText("|TInterface\\FriendsFrame\\InformationIcon:10:10:0:0|tTestrad-01\n|TInterface\\RaidFrame\\ReadyCheck-Ready:10:10:0:0|tTestrad-02\n|TInterface\\RaidFrame\\ReadyCheck-NotReady:10:10:0:0|tWWWWWWWWWWWW " .. SoftRes.helpers:getItemLinkFromId(19364) .. "\n|TInterface\\Buttons\\UI-GroupLoot-Dice-Up:10:10:0:0|tTestrad-04\nTestrad-05\nTestrad-06\nTestrad-07\nTestrad-08\nTestrad-09\nTestrad-10\nTestrad-11\nTestrad-12")
            FRAMES.rollFrame.fs:SetJustifyH("Left")
            FRAMES.rollFrame.fs:SetNonSpaceWrap(true)

FRAMES.announcedItemFrame = CreateFrame("Frame", "AnnouncedItemFrame", FRAMES.tabContainer.page1)            
      FRAMES.announcedItemFrame:SetPoint("TOPLEFT", FRAMES.rollFrameContainer, "BOTTOMLEFT", 31, -7)
      FRAMES.announcedItemFrame:SetSize(276, 34)
      FRAMES.announcedItemFrame:SetBackdropColor(0, 0, 0, 1);
      FRAMES.announcedItemFrame:SetBackdrop({
            bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile     = true,
            tileSize = 32,
            edgeSize = 10,
            insets   = { left = 2, right = 2, top = 2, bottom = 2 }
      })

-- PAGE 2
FRAMES.tabContainer.page2 = CreateFrame("Frame", "TabPagesPage2", FRAMES.mainFrame)
      FRAMES.tabContainer.page2:SetPoint("TOPLEFT", FRAMES.tabContainer, "TOPLEFT", 7, -10)
      FRAMES.tabContainer.page2:SetSize(313, 157)
      FRAMES.tabContainer.page2:SetBackdrop({
            bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile     = true,
            tileSize = 32,
            edgeSize = 10,
            insets   = { left = 2, right = 2, top = 2, bottom = 2 }
      })
      FRAMES.tabContainer.page2:Hide()

FRAMES.listFrameContainer = CreateFrame("ScrollFrame", "ListFrameContainer", FRAMES.tabContainer.page2, "UIPanelScrollFrameTemplate")
      FRAMES.listFrameContainer:SetPoint("TOPLEFT", FRAMES.tabContainer.page2, "TOPLEFT", 5, -5)

      
      local  listScrollbarName = FRAMES.listFrameContainer:GetName()
      FRAMES.listFrameContainer.scrollBar = _G[listScrollbarName .. "ScrollBar"]
      FRAMES.listFrameContainer.scrollUpButton = _G[listScrollbarName .. "ScrollBarScrollUpButton"]
      FRAMES.listFrameContainer.scrollDownButton = _G[listScrollbarName .. "ScrollBarScrollDownButton"]

            FRAMES.listFrameContainer.scrollUpButton:ClearAllPoints()
            FRAMES.listFrameContainer.scrollUpButton:SetPoint("TOPRIGHT", FRAMES.listFrameContainer, "TOPRIGHT", -10, 0)
      
            FRAMES.listFrameContainer.scrollDownButton:ClearAllPoints()
            FRAMES.listFrameContainer.scrollDownButton:SetPoint("BOTTOMRIGHT", FRAMES.listFrameContainer, "BOTTOMRIGHT", -10, 0)      

            FRAMES.listFrameContainer.scrollBar:ClearAllPoints()
            FRAMES.listFrameContainer.scrollBar:SetPoint("TOP", FRAMES.listFrameContainer.scrollUpButton, "BOTTOM", 0, 0)
            FRAMES.listFrameContainer.scrollBar:SetPoint("BOTTOM", FRAMES.listFrameContainer.scrollDownButton, "TOP", 0, 0)

      FRAMES.listFrameContainer.child = CreateFrame("Frame")
      FRAMES.listFrameContainer:SetScrollChild(FRAMES.listFrameContainer.child)

FRAMES.listFrame = CreateFrame("Frame", nil, FRAMES.listFrameContainer.child)
      FRAMES.listFrame:SetAllPoints(FRAMES.listFrameContainer.child)
      FRAMES.listFrame:EnableMouse()

      FRAMES.listFrame.fs = FRAMES.listFrame:CreateFontString(nil, "OVERLAY") -- This is the main list FontString. Populate this one.
            FRAMES.listFrame.fs:SetFontObject("GameFontHighlightSmall")
            FRAMES.listFrame.fs:SetFont(FRAMES.listFrame.fs:GetFont(), 10)
            FRAMES.listFrame.fs:SetPoint("TOPLEFT", FRAMES.listFrame, "TOPLEFT", 0, 0)
            FRAMES.listFrame.fs:SetText("Testrad-01\nTestrad-02\nTestrad-03\nTestrad-04\nTestrad-05\nTestrad-06\nTestrad-07\nTestrad-08\nTestrad-09\nTestrad-10\nTestrad-11\nTestrad-12")
            FRAMES.listFrame.fs:SetJustifyH("Left")

-- Buttons
BUTTONS.tabButtonPage = {}

BUTTONS.testButton = CreateFrame("Button", "testButton", FRAMES.mainFrame, "UIPanelButtonGrayTemplate")
      BUTTONS.testButton:SetPoint("TOP", FRAMES.mainFrame, "TOP", 0, 0)
      BUTTONS.testButton:SetWidth(100)
      BUTTONS.testButton:SetHeight(20)
      BUTTONS.testButton:SetText("|TInterface\\FriendsFrame\\InformationIcon:10:10:0:0|t")

BUTTONS.tabButtonPage[1] = CreateFrame("Button", "TabButtonPage1", FRAMES.mainFrame, "TabButtonTemplate")
      BUTTONS.tabButtonPage[1].active = true
      BUTTONS.tabButtonPage[1]:SetFrameLevel(3)
      BUTTONS.tabButtonPage[1]:SetPoint("BOTTOMLEFT", FRAMES.tabContainer, "TOPLEFT", 15, -3)
      BUTTONS.tabButtonPage[1]:SetSize(100, 20)
      BUTTONS.tabButtonPage[1]:SetText("Items / rolls")

BUTTONS.tabButtonPage[2] = CreateFrame("Button", "TabButtonPage2", FRAMES.mainFrame, "TabButtonTemplate")
      BUTTONS.tabButtonPage[2].active = false
      BUTTONS.tabButtonPage[2]:SetFrameLevel(2)
      BUTTONS.tabButtonPage[2]:SetPoint("LEFT", BUTTONS.tabButtonPage[1], "RIGHT", 2, 0)
      BUTTONS.tabButtonPage[2]:SetSize(100, 20)
      BUTTONS.tabButtonPage[2]:SetText("SoftRes List")

BUTTONS.tabButtonPage[3] = CreateFrame("Button", "TabButtonPage3", FRAMES.mainFrame, "TabButtonTemplate")
      BUTTONS.tabButtonPage[3].active = false
      BUTTONS.tabButtonPage[3]:SetFrameLevel(2)
      BUTTONS.tabButtonPage[3]:SetPoint("LEFT", BUTTONS.tabButtonPage[2], "RIGHT", 2, 0)
      BUTTONS.tabButtonPage[3]:SetSize(100, 20)
      BUTTONS.tabButtonPage[3]:SetText("Config")

      -- Resizing tabs.
      for i = 1, #BUTTONS.tabButtonPage do
            PanelTemplates_TabResize(BUTTONS.tabButtonPage[i], 0)
      end

BUTTONS.announcedItemButton = CreateFrame("Button", "lootItemIcon", FRAMES.tabContainer.page1)
      BUTTONS.announcedItemButton:SetSize(32, 32)
      BUTTONS.announcedItemButton:SetPoint("TOPLEFT", FRAMES.rollFrameContainer, "BOTTOMLEFT", -3, -8)

      BUTTONS.announcedItemButton:EnableMouse(true)
      BUTTONS.announcedItemButton:RegisterForClicks("RightButtonUp", "LeftButtonUp")
      BUTTONS.announcedItemButton:SetScript("OnDragStart", lootItemIcon.StartMoving)
      BUTTONS.announcedItemButton:SetScript("OnDragStop", lootItemIcon.StopMovingOrSizing)
      BUTTONS.announcedItemButton:SetBackdrop({
            bgFile   = "interface\\buttons\\ui-emptyslot-white",
            edgeFile = nil,
            tile     = true,
            tileSize = 0,
            edgeSize = 0,
            insets   = { left = -8, right = -8, top = -8, bottom = -8 }
      })

BUTTONS.prepareItemButton = CreateFrame("Button", "PrepareItemButton", FRAMES.tabContainer.page1, "UIPanelButtonGrayTemplate")
      BUTTONS.prepareItemButton:SetPoint("TOPLEFT", BUTTONS.announcedItemButton, "BOTTOMLEFT", -1, -2)
      BUTTONS.prepareItemButton:SetWidth(102)
      BUTTONS.prepareItemButton:SetHeight(20)
      BUTTONS.prepareItemButton:SetText("Prepare Item")
      
BUTTONS.raidRollButton = CreateFrame("Button", "RaidRollButton", FRAMES.tabContainer.page1, "UIPanelButtonGrayTemplate")
      BUTTONS.raidRollButton:SetPoint("TOPLEFT", BUTTONS.announcedItemButton, "BOTTOMLEFT", -1, -24)
      BUTTONS.raidRollButton:SetWidth(102)
      BUTTONS.raidRollButton:SetHeight(20)
      BUTTONS.raidRollButton:SetText("Raid Roll")

BUTTONS.softResRollButton = CreateFrame("Button", "SoftResRollButton", FRAMES.tabContainer.page1, "UIPanelButtonGrayTemplate")
      BUTTONS.softResRollButton:SetPoint("LEFT", BUTTONS.prepareItemButton, "RIGHT", 3, 0)
      BUTTONS.softResRollButton:SetWidth(102)
      BUTTONS.softResRollButton:SetHeight(20)
      BUTTONS.softResRollButton:SetText("SoftRes Roll")

BUTTONS.osRollButton = CreateFrame("Button", "OSRollButton", FRAMES.tabContainer.page1, "UIPanelButtonGrayTemplate")
      BUTTONS.osRollButton:SetPoint("TOP", BUTTONS.softResRollButton, "BOTTOM", 0, -2)
      BUTTONS.osRollButton:SetWidth(30)
      BUTTONS.osRollButton:SetHeight(20)
      BUTTONS.osRollButton:SetText("OS")

BUTTONS.msRollButton = CreateFrame("Button", "MSRollButton", FRAMES.tabContainer.page1, "UIPanelButtonGrayTemplate")
      BUTTONS.msRollButton:SetPoint("RIGHT", BUTTONS.osRollButton, "LEFT", -4, -0)
      BUTTONS.msRollButton:SetWidth(30)
      BUTTONS.msRollButton:SetHeight(20)
      BUTTONS.msRollButton:SetText("MS")

BUTTONS.ffaRollButton = CreateFrame("Button", "FFARollButton", FRAMES.tabContainer.page1, "UIPanelButtonGrayTemplate")
      BUTTONS.ffaRollButton:SetPoint("LEFT", BUTTONS.osRollButton, "RIGHT", 4, 0)
      BUTTONS.ffaRollButton:SetWidth(30)
      BUTTONS.ffaRollButton:SetHeight(20)
      BUTTONS.ffaRollButton:SetText("FFA")

BUTTONS.announceRollsButton = CreateFrame("Button", "RaidRollButton", FRAMES.tabContainer.page1, "UIPanelButtonGrayTemplate")
      BUTTONS.announceRollsButton:SetPoint("LEFT", BUTTONS.softResRollButton, "RIGHT", 3, 0)
      BUTTONS.announceRollsButton:SetWidth(102)
      BUTTONS.announceRollsButton:SetHeight(20)
      BUTTONS.announceRollsButton:SetText("Announce Rolls")

BUTTONS.newListButton = CreateFrame("Button", "NewListButton", FRAMES.tabContainer.page2, "UIPanelButtonGrayTemplate")
      BUTTONS.newListButton:SetPoint("TOPLEFT", FRAMES.listFrameContainer, "BOTTOMLEFT", -5, -5)
      BUTTONS.newListButton:SetWidth(102)
      BUTTONS.newListButton:SetHeight(20)
      BUTTONS.newListButton:SetText("New List")

BUTTONS.announceRulesButton = CreateFrame("Button", "AnnounceRulesButton", FRAMES.tabContainer.page2, "UIPanelButtonGrayTemplate")
      BUTTONS.announceRulesButton:SetPoint("TOPLEFT", BUTTONS.newListButton, "BOTTOMLEFT", 0, -5)
      BUTTONS.announceRulesButton:SetWidth(102)
      BUTTONS.announceRulesButton:SetHeight(20)
      BUTTONS.announceRulesButton:SetText("Announce Rules")

BUTTONS.scanForSoftResButton = CreateFrame("Button", "ScanForSoftResButton", FRAMES.tabContainer.page2, "UIPanelButtonGrayTemplate")
      BUTTONS.scanForSoftResButton:SetPoint("LEFT", BUTTONS.newListButton, "RIGHT", 4, 0)
      BUTTONS.scanForSoftResButton:SetWidth(102)
      BUTTONS.scanForSoftResButton:SetHeight(20)
      BUTTONS.scanForSoftResButton:SetText("Scan SoftResses")

BUTTONS.addPlayerSoftResButton = CreateFrame("Button", "AddPlayerSoftResButton", FRAMES.tabContainer.page2, "UIPanelButtonGrayTemplate")
      BUTTONS.addPlayerSoftResButton:SetPoint("LEFT", BUTTONS.scanForSoftResButton, "RIGHT", 4, 0)
      BUTTONS.addPlayerSoftResButton:SetWidth(102)
      BUTTONS.addPlayerSoftResButton:SetHeight(20)
      BUTTONS.addPlayerSoftResButton:SetText("Add SoftRes")

BUTTONS.removePlayerDropDown = CreateFrame("Button", "RemovePlayerDropDown", FRAMES.tabContainer.page2, "UIDropDownMenuTemplate")
      BUTTONS.removePlayerDropDown:SetPoint("LEFT", BUTTONS.announceRulesButton, "RIGHT", -12, -2)
            
      UIDropDownMenu_SetWidth(BUTTONS.removePlayerDropDown, 83)
      UIDropDownMenu_SetButtonWidth(BUTTONS.removePlayerDropDown, 102)
      UIDropDownMenu_JustifyText(BUTTONS.removePlayerDropDown, "LEFT")  

BUTTONS.removePlayerButton = CreateFrame("Button", "RemovePlayerButton", FRAMES.tabContainer.page2, "UIPanelButtonGrayTemplate")
      BUTTONS.removePlayerButton:SetPoint("TOP", BUTTONS.addPlayerSoftResButton, "BOTTOM", 0, -5)
      BUTTONS.removePlayerButton:SetWidth(102)
      BUTTONS.removePlayerButton:SetHeight(20)
      BUTTONS.removePlayerButton:SetText("Remove Player")