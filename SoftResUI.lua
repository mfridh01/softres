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
            },
            icons = {
                  redCross = "|TInterface\\RaidFrame\\ReadyCheck-NotReady:10:10:0:0|t",
                  questionMark = "|TInterface\\RaidFrame\\ReadyCheck-Waiting:10:10:0:0|t",
                  readyCheck = "|TInterface\\RaidFrame\\ReadyCheck-Ready:10:10:0:0|t",
                  noLoot = "|TInterface\\COMMON\\icon-noloot:10:10:0:0|t",
            },
            state = {
                  softResEnabled = true,
                  autoShowOnLoot = true,
                  autoHideOnLootDone = true,
            },
            timers = {
                  softRes = {
                        minValue = 10,
                        maxValue = 20,
                        default = 15,
                        value = 15,
                  },
                  ms = {
                        minValue = 10,
                        maxValue = 20,
                        default = 15,
                        value = 15,
                  }, 
                  os = {
                        minValue = 10,
                        maxValue = 20,
                        default = 15,
                        value = 15,
                  }, 
                  ffa = {
                        minValue = 10,
                        maxValue = 20,
                        default = 15,
                        value = 15,
                  }, 
            },
      }
end

-- Apply values from saved list, to the frames.
function SoftRes.ui:useSavedConfigValues()
      local CONFIG_UI_FRAMES = SoftResConfig.ui.frames
      local CONFIG_STATE = SoftResConfig.state
      local CONFIG_TIMERS = SoftResConfig.timers

      FRAMES.mainFrame:SetSize(CONFIG_UI_FRAMES.mainFrame.size.full.width, CONFIG_UI_FRAMES.mainFrame.size.full.height)
      FRAMES.tabContainer:SetSize(CONFIG_UI_FRAMES.tabContainer.size.full.width, CONFIG_UI_FRAMES.tabContainer.size.full.height)
      FRAMES.rollFrameContainer:SetSize(CONFIG_UI_FRAMES.rollFrameContainer.size.full.width, CONFIG_UI_FRAMES.rollFrameContainer.size.full.height)
      FRAMES.rollFrameContainer.child:SetSize(CONFIG_UI_FRAMES.rollFrameContainer.child.size.width, CONFIG_UI_FRAMES.rollFrameContainer.child.size.height)
      FRAMES.listFrameContainer:SetSize(CONFIG_UI_FRAMES.listFrameContainer.size.full.width, CONFIG_UI_FRAMES.listFrameContainer.size.full.height)
      FRAMES.listFrameContainer.child:SetSize(CONFIG_UI_FRAMES.listFrameContainer.child.size.width, CONFIG_UI_FRAMES.listFrameContainer.child.size.height)

      -- config
      BUTTONS.enableSoftResAddon:SetChecked(CONFIG_STATE.softResEnabled)
      BUTTONS.autoShowWindowCheckButton:SetChecked(CONFIG_STATE.autoShowOnLoot)
      BUTTONS.autoHideWindowCheckButton:SetChecked(CONFIG_STATE.autoHideOnLootDone)

      FRAMES.softResRollTimerEditBox:SetText(CONFIG_TIMERS.softRes.value)
      FRAMES.msRollTimerEditBox:SetText(CONFIG_TIMERS.ms.value)
      FRAMES.osRollTimerEditBox:SetText(CONFIG_TIMERS.os.value)
      FRAMES.ffaRollTimerEditBox:SetText(CONFIG_TIMERS.ffa.value)
end
--------------------------------------------------------------------

-- UI BEGINS HERE.
------------------

-- Frames.
----------
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
      
      FRAMES.mainFrame.titleCenter = FRAMES.mainFrame:CreateFontString(nil, "Overlay")
            FRAMES.mainFrame.titleCenter:SetFontObject("GameFontHighlight")
            FRAMES.mainFrame.titleCenter:SetPoint("TOP", FRAMES.mainFrame.TitleBg, "TOP", 3, -3)
            FRAMES.mainFrame.titleCenter:SetText("")
      
      FRAMES.mainFrame.titleRight = FRAMES.mainFrame:CreateFontString(nil, "Overlay")
            FRAMES.mainFrame.titleRight:SetFontObject("GameFontHighlight")
            FRAMES.mainFrame.titleRight:SetPoint("TOPLEFT", FRAMES.mainFrame.TitleBg, "TOPRIGHT", -40, -3)
            FRAMES.mainFrame.titleRight:SetText("")

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
            FRAMES.rollFrame.fs:SetText("")
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

      FRAMES.announcedItemFrame.fs = FRAMES.announcedItemFrame:CreateFontString(nil, "OVERLAY")
            FRAMES.announcedItemFrame.fs:SetFontObject("GameFontHighlightSmall")
            FRAMES.announcedItemFrame.fs:SetPoint("CENTER", FRAMES.announcedItemFrame, "CENTER", 0, 0)
            FRAMES.announcedItemFrame.fs:SetText("")

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
            FRAMES.listFrame.fs:SetFont(FRAMES.listFrame.fs:GetFont(), 11)
            FRAMES.listFrame.fs:SetPoint("TOPLEFT", FRAMES.listFrame, "TOPLEFT", 0, 0)
            FRAMES.listFrame.fs:SetText("Testrad-01\nTestrad-02\nTestrad-03\nTestrad-04\nTestrad-05\nTestrad-06\nTestrad-07\nTestrad-08\nTestrad-09\nTestrad-10\nTestrad-11\nTestrad-12")
            FRAMES.listFrame.fs:SetJustifyH("Left")

-- Page 3
FRAMES.tabContainer.page3 = CreateFrame("Frame", "TabPagesPage3", FRAMES.mainFrame)
      FRAMES.tabContainer.page3:SetPoint("TOPLEFT", FRAMES.tabContainer, "TOPLEFT", 7, -10)
      FRAMES.tabContainer.page3:SetSize(313, 157)
      FRAMES.tabContainer.page3:Hide()

FRAMES.softResRollTimerEditBox = CreateFrame("EditBox", "SoftResRollTimerEditBox", FRAMES.tabContainer.page3, "InputBoxTemplate")
      FRAMES.softResRollTimerEditBox:SetPoint("TOPLEFT", FRAMES.tabContainer.page3, "TOPLEFT", 8, -75)
      FRAMES.softResRollTimerEditBox:SetWidth(40)
      FRAMES.softResRollTimerEditBox:SetHeight(20)
      FRAMES.softResRollTimerEditBox:ClearFocus() 
      FRAMES.softResRollTimerEditBox:SetAutoFocus(false)
      FRAMES.softResRollTimerEditBox:SetMaxLetters(2)
      FRAMES.softResRollTimerEditBox:SetAltArrowKeyMode(true)
      FRAMES.softResRollTimerEditBox:EnableMouse(true)
      FRAMES.softResRollTimerEditBox:SetText("15")
      FRAMES.softResRollTimerEditBox.fs = FRAMES.softResRollTimerEditBox:CreateFontString(nil, "OVERLAY")
            FRAMES.softResRollTimerEditBox.fs:SetFontObject("GameFontHighlightSmall")
            FRAMES.softResRollTimerEditBox.fs:SetPoint("LEFT", FRAMES.softResRollTimerEditBox, "RIGHT", 5, -1)
            FRAMES.softResRollTimerEditBox.fs:SetText("SoftRes Roll timer. (min: 10, max: 20)")
            FRAMES.softResRollTimerEditBox.fs:SetJustifyH("Left")

FRAMES.msRollTimerEditBox = CreateFrame("EditBox", "MSRollTimerEditBox", FRAMES.tabContainer.page3, "InputBoxTemplate")
      FRAMES.msRollTimerEditBox:SetPoint("TOPLEFT", FRAMES.softResRollTimerEditBox, "BOTTOMLEFT", 0, 0)
      FRAMES.msRollTimerEditBox:SetWidth(40)
      FRAMES.msRollTimerEditBox:SetHeight(20)
      FRAMES.msRollTimerEditBox:ClearFocus() 
      FRAMES.msRollTimerEditBox:SetAutoFocus(false)
      FRAMES.msRollTimerEditBox:SetMaxLetters(2)
      FRAMES.msRollTimerEditBox:SetAltArrowKeyMode(true)
      FRAMES.msRollTimerEditBox:EnableMouse(true)
      FRAMES.msRollTimerEditBox:SetText("15")

      FRAMES.msRollTimerEditBox.fs = FRAMES.msRollTimerEditBox:CreateFontString(nil, "OVERLAY")
            FRAMES.msRollTimerEditBox.fs:SetFontObject("GameFontHighlightSmall")
            FRAMES.msRollTimerEditBox.fs:SetPoint("LEFT", FRAMES.msRollTimerEditBox, "RIGHT", 5, -1)
            FRAMES.msRollTimerEditBox.fs:SetText("MS Roll timer. (min: 10, max: 20)")
            FRAMES.msRollTimerEditBox.fs:SetJustifyH("Left")

FRAMES.osRollTimerEditBox = CreateFrame("EditBox", "OSRollTimerEditBox", FRAMES.tabContainer.page3, "InputBoxTemplate")
      FRAMES.osRollTimerEditBox:SetPoint("TOPLEFT", FRAMES.msRollTimerEditBox, "BOTTOMLEFT", 0, 0)
      FRAMES.osRollTimerEditBox:SetWidth(40)
      FRAMES.osRollTimerEditBox:SetHeight(20)
      FRAMES.osRollTimerEditBox:ClearFocus() 
      FRAMES.osRollTimerEditBox:SetAutoFocus(false)
      FRAMES.osRollTimerEditBox:SetMaxLetters(2)
      FRAMES.osRollTimerEditBox:SetAltArrowKeyMode(true)
      FRAMES.osRollTimerEditBox:EnableMouse(true)
      FRAMES.osRollTimerEditBox:SetText("15")

      FRAMES.osRollTimerEditBox.fs = FRAMES.osRollTimerEditBox:CreateFontString(nil, "OVERLAY")
            FRAMES.osRollTimerEditBox.fs:SetFontObject("GameFontHighlightSmall")
            FRAMES.osRollTimerEditBox.fs:SetPoint("LEFT", FRAMES.osRollTimerEditBox, "RIGHT", 5, -1)
            FRAMES.osRollTimerEditBox.fs:SetText("OS Roll timer. (min: 10, max: 20)")
            FRAMES.osRollTimerEditBox.fs:SetJustifyH("Left")

FRAMES.ffaRollTimerEditBox = CreateFrame("EditBox", "FFARollTimerEditBox", FRAMES.tabContainer.page3, "InputBoxTemplate")
      FRAMES.ffaRollTimerEditBox:SetPoint("TOPLEFT", FRAMES.osRollTimerEditBox, "BOTTOMLEFT", 0, 0)
      FRAMES.ffaRollTimerEditBox:SetWidth(40)
      FRAMES.ffaRollTimerEditBox:SetHeight(20)
      FRAMES.ffaRollTimerEditBox:ClearFocus() 
      FRAMES.ffaRollTimerEditBox:SetAutoFocus(false)
      FRAMES.ffaRollTimerEditBox:SetMaxLetters(2)
      FRAMES.ffaRollTimerEditBox:SetAltArrowKeyMode(true)
      FRAMES.ffaRollTimerEditBox:EnableMouse(true)
      FRAMES.ffaRollTimerEditBox:SetText("15")

      FRAMES.ffaRollTimerEditBox.fs = FRAMES.ffaRollTimerEditBox:CreateFontString(nil, "OVERLAY")
            FRAMES.ffaRollTimerEditBox.fs:SetFontObject("GameFontHighlightSmall")
            FRAMES.ffaRollTimerEditBox.fs:SetPoint("LEFT", FRAMES.ffaRollTimerEditBox, "RIGHT", 5, -1)
            FRAMES.ffaRollTimerEditBox.fs:SetText("FFA Roll timer. (min: 10, max: 20)")
            FRAMES.ffaRollTimerEditBox.fs:SetJustifyH("Left")
-- Buttons.
-----------
BUTTONS.tabButtonPage = {}

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

-- Buttons page 1.
BUTTONS.announcedItemButton = CreateFrame("Button", "announcedItemButton", FRAMES.tabContainer.page1)
      BUTTONS.announcedItemButton:SetSize(32, 32)
      BUTTONS.announcedItemButton:SetPoint("TOPLEFT", FRAMES.rollFrameContainer, "BOTTOMLEFT", -3, -8)

      BUTTONS.announcedItemButton:EnableMouse(true)
      BUTTONS.announcedItemButton:RegisterForClicks("RightButtonUp", "LeftButtonUp")
      BUTTONS.announcedItemButton:SetScript("OnDragStart", BUTTONS.announcedItemButton.StartMoving)
      BUTTONS.announcedItemButton:SetScript("OnDragStop", BUTTONS.announcedItemButton.StopMovingOrSizing)
      BUTTONS.announcedItemButton:SetBackdrop({
            bgFile   = "interface\\buttons\\ui-emptyslot-white",
            edgeFile = nil,
            tile     = true,
            tileSize = 0,
            edgeSize = 0,
            insets   = { left = -8, right = -8, top = -8, bottom = -8 }
      })
      BUTTONS.announcedItemButton.texture = BUTTONS.announcedItemButton:CreateTexture("announcedItemButtonTexture", "OVERLAY")
      BUTTONS.announcedItemButton.texture:SetAllPoints(true)
      BUTTONS.announcedItemButton.defaultTexture = BUTTONS.announcedItemButton.texture:GetTexture()

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
      BUTTONS.announceRollsButton:SetText("Announce Result")

-- Buttons page 2.
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
      BUTTONS.scanForSoftResButton.normalText = "Scan SoftRes"
      BUTTONS.scanForSoftResButton.activeText = "Scanning"
      BUTTONS.scanForSoftResButton:SetText(BUTTONS.scanForSoftResButton.normalText)

BUTTONS.addPlayerSoftResButton = CreateFrame("Button", "AddPlayerSoftResButton", FRAMES.tabContainer.page2, "UIPanelButtonGrayTemplate")
      BUTTONS.addPlayerSoftResButton:SetPoint("LEFT", BUTTONS.scanForSoftResButton, "RIGHT", 4, 0)
      BUTTONS.addPlayerSoftResButton:SetWidth(102)
      BUTTONS.addPlayerSoftResButton:SetHeight(20)
      BUTTONS.addPlayerSoftResButton:SetText("Add SoftRes")

BUTTONS.editPlayerDropDown = CreateFrame("Button", "EditPlayerDropDown", FRAMES.tabContainer.page2, "UIDropDownMenuTemplate")
      BUTTONS.editPlayerDropDown:SetPoint("LEFT", BUTTONS.announceRulesButton, "RIGHT", -12, -2)
            
      UIDropDownMenu_SetWidth(BUTTONS.editPlayerDropDown, 83)
      UIDropDownMenu_SetButtonWidth(BUTTONS.editPlayerDropDown, 102)
      UIDropDownMenu_JustifyText(BUTTONS.editPlayerDropDown, "LEFT")  

BUTTONS.editPlayerButton = CreateFrame("Button", "EditPlayerButton", FRAMES.tabContainer.page2, "UIPanelButtonGrayTemplate")
      BUTTONS.editPlayerButton:SetPoint("TOP", BUTTONS.addPlayerSoftResButton, "BOTTOM", 0, -5)
      BUTTONS.editPlayerButton:SetWidth(102)
      BUTTONS.editPlayerButton:SetHeight(20)
      BUTTONS.editPlayerButton:SetText("Edit Player")

-- Buttons Page 3
BUTTONS.enableSoftResAddon = CreateFrame("CheckButton", "EnableSoftResAddon", FRAMES.tabContainer.page3, "UICheckButtonTemplate")
      BUTTONS.enableSoftResAddon:SetPoint("TOPLEFT", FRAMES.tabContainer.page3, "TOPLEFT", 0, 0)
      BUTTONS.enableSoftResAddon:SetWidth(25)
      BUTTONS.enableSoftResAddon:SetHeight(25)
      BUTTONS.enableSoftResAddon:SetChecked(false)

      BUTTONS.enableSoftResAddon.fs = BUTTONS.enableSoftResAddon:CreateFontString(nil, "OVERLAY")
            BUTTONS.enableSoftResAddon.fs:SetFontObject("GameFontHighlight")
            BUTTONS.enableSoftResAddon.fs:SetPoint("LEFT", BUTTONS.enableSoftResAddon, "RIGHT", 3, 0)
            BUTTONS.enableSoftResAddon.fs:SetJustifyH("LEFT")
            BUTTONS.enableSoftResAddon.fs:SetText("Enable SoftRes Addon.")

BUTTONS.autoShowWindowCheckButton = CreateFrame("CheckButton", "AutoShowWindowCheckButton", FRAMES.tabContainer.page3, "UICheckButtonTemplate")
      BUTTONS.autoShowWindowCheckButton:SetPoint("TOPLEFT", BUTTONS.enableSoftResAddon, "BOTTOMLEFT", 0, 0)
      BUTTONS.autoShowWindowCheckButton:SetWidth(25)
      BUTTONS.autoShowWindowCheckButton:SetHeight(25)
      BUTTONS.autoShowWindowCheckButton:SetChecked(false)

      BUTTONS.autoShowWindowCheckButton.fs = BUTTONS.autoShowWindowCheckButton:CreateFontString(nil, "OVERLAY")
            BUTTONS.autoShowWindowCheckButton.fs:SetFontObject("GameFontHighlight")
            BUTTONS.autoShowWindowCheckButton.fs:SetPoint("LEFT", BUTTONS.autoShowWindowCheckButton, "RIGHT", 3, 0)
            BUTTONS.autoShowWindowCheckButton.fs:SetJustifyH("LEFT")
            BUTTONS.autoShowWindowCheckButton.fs:SetText("Auto-show window on loot.")

BUTTONS.autoHideWindowCheckButton = CreateFrame("CheckButton", "AautoHideWindowCheckButton", FRAMES.tabContainer.page3, "UICheckButtonTemplate")
      BUTTONS.autoHideWindowCheckButton:SetPoint("TOPLEFT", BUTTONS.autoShowWindowCheckButton, "BOTTOMLEFT", 0, 0)
      BUTTONS.autoHideWindowCheckButton:SetWidth(25)
      BUTTONS.autoHideWindowCheckButton:SetHeight(25)
      BUTTONS.autoHideWindowCheckButton:SetChecked(false)
      
      BUTTONS.autoHideWindowCheckButton.fs = BUTTONS.autoHideWindowCheckButton:CreateFontString(nil, "OVERLAY")
            BUTTONS.autoHideWindowCheckButton.fs:SetFontObject("GameFontHighlight")
            BUTTONS.autoHideWindowCheckButton.fs:SetPoint("LEFT", BUTTONS.autoHideWindowCheckButton, "RIGHT", 3, 0)
            BUTTONS.autoHideWindowCheckButton.fs:SetJustifyH("LEFT")
            BUTTONS.autoHideWindowCheckButton.fs:SetText("Auto-hide window when done looting.")