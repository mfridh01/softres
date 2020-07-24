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
                                          width = 314-30,
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
                  dice = "|TInterface\\Buttons\\UI-GroupLoot-Dice-Up:10:10:0:0|t",
                  skull = "|TInterface\\TARGETINGFRAME\\UI-RaidTargetingIcon_8:10:10:0:0|t",
                  quest = "|TInterface\\GossipFrame\\AvailableQuestIcon:10:10:0:0|t",
                  cancel = "|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:14:14:0:0|t",
                  indicatorGreen = "|TInterface\\COMMON\\Indicator-Green:10:10:0:0|t",
                  indicatorRed = "|TInterface\\COMMON\\Indicator-Red:10:10:0:0|t",
                  loot = "|TInterface\\GroupFrame\\UI-Group-MasterLooter:10:10:0:0|t",
                  softResBag = "|TInterface\\Store\\category-icon-bag:30:30:-5:0|t",
            },
            state = {
                  softResEnabled = true,
                  autoShowOnLoot = true,
                  autoHideOnLootDone = false,
                  addPenalty = true,
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
            },
            dropDecay = {
                  ms = {
                        minValue = 0,
                        maxValue = 100,
                        default = 10,
                        value = 10,
                  },
                  os = {
                        minValue = 0,
                        maxValue = 100,
                        default = 5,
                        value = 5,
                  }, 
            },
            itemRarity = {
                  minValue = 0, -- gray
                  maxValue = 5, -- legendary
                  value = 2, -- 0 = gray, 1 = white, 2 = green, 3 = blue, 4 = purple, 5 = orange
                  default = 2,
            },
            extraInformation = {
                  default = "Ω SoftRes, by Snits-NoggenfoggerEU",
                  value = "Ω SoftRes, by Snits-NoggenfoggerEU",
            },
            colors = {
                  green = "|cFF00FF00",
                  red = "|cFFFF0000",
                  yellow = "|cFFFFFF00",
            },
      }
end

-- Apply values from saved list, to the frames.
function SoftRes.ui:useSavedConfigValues()
      local CONFIG_UI_FRAMES = SoftResConfig.ui.frames
      local CONFIG_STATE = SoftResConfig.state
      local CONFIG_TIMERS = SoftResConfig.timers
      local CONFIG_DECAY = SoftResConfig.dropDecay

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
      
      -- Shoud we add the penalty or not?
      BUTTONS.addPenaltyButton:SetChecked(CONFIG_STATE.addPenalty)

      -- Enabled or not?
      SoftRes.enabled = CONFIG_STATE.softResEnabled

      FRAMES.softResRollTimerEditBox:SetText(CONFIG_TIMERS.softRes.value)
      FRAMES.msRollTimerEditBox:SetText(CONFIG_TIMERS.ms.value)
      FRAMES.osRollTimerEditBox:SetText(CONFIG_TIMERS.os.value)
      FRAMES.itemRarityEditBox:SetText(SoftResConfig.itemRarity.value)

      FRAMES.msDropDecayEditBox:SetText(CONFIG_DECAY.ms.value)
      FRAMES.osDropDecayEditBox:SetText(CONFIG_DECAY.os.value)

      FRAMES.extraInfoEditBox:SetText(SoftResConfig.extraInformation.value)
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
            FRAMES.mainFrame.titleRight:SetPoint("TOPLEFT", FRAMES.mainFrame.TitleBg, "TOPRIGHT", -50, -3)
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

FRAMES.addonIndicator = CreateFrame("Frame", "AddonIndicatorFrame", FRAMES.mainFrame)
      FRAMES.addonIndicator:SetPoint("TOPRIGHT", FRAMES.mainFrame, "TOPRIGHT", -7, -25)
      FRAMES.addonIndicator:SetSize(25,25)
      FRAMES.addonIndicator.texture = FRAMES.addonIndicator:CreateTexture("AddonIndicatorFrameTexture", "OVERLAY")
      FRAMES.addonIndicator.texture:SetAllPoints(true)
      FRAMES.addonIndicator.texture:SetTexture("Interface\\COMMON\\Indicator-Green")


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
            FRAMES.tabContainer.page1:Hide()

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
            FRAMES.rollFrame.fs:SetFont(FRAMES.rollFrame.fs:GetFont(), 12)
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
            FRAMES.announcedItemFrame.fs:SetText("Drag an item here, or loot too start.")

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
      FRAMES.tabContainer.page2:Show()

FRAMES.listFrameContainer = CreateFrame("ScrollFrame", "ListFrameContainer", FRAMES.tabContainer.page2, "UIPanelScrollFrameTemplate")
      FRAMES.listFrameContainer:SetPoint("TOPLEFT", FRAMES.tabContainer.page2, "TOPLEFT", 5, -5)

      
      local  listScrollbarName = FRAMES.listFrameContainer:GetName()
      FRAMES.listFrameContainer.scrollBar = _G[listScrollbarName .. "ScrollBar"]
      FRAMES.listFrameContainer.scrollUpButton = _G[listScrollbarName .. "ScrollBarScrollUpButton"]
      FRAMES.listFrameContainer.scrollDownButton = _G[listScrollbarName .. "ScrollBarScrollDownButton"]

            FRAMES.listFrameContainer.scrollUpButton:ClearAllPoints()
            FRAMES.listFrameContainer.scrollUpButton:SetPoint("TOPRIGHT", FRAMES.listFrameContainer, "TOPRIGHT", -10+30, 0)
      
            FRAMES.listFrameContainer.scrollDownButton:ClearAllPoints()
            FRAMES.listFrameContainer.scrollDownButton:SetPoint("BOTTOMRIGHT", FRAMES.listFrameContainer, "BOTTOMRIGHT", -10+30, 0)      

            FRAMES.listFrameContainer.scrollBar:ClearAllPoints()
            FRAMES.listFrameContainer.scrollBar:SetPoint("TOP", FRAMES.listFrameContainer.scrollUpButton, "BOTTOM", 0, 0)
            FRAMES.listFrameContainer.scrollBar:SetPoint("BOTTOM", FRAMES.listFrameContainer.scrollDownButton, "TOP", 0, 0)

      FRAMES.listFrameContainer.child = CreateFrame("Frame")
      FRAMES.listFrameContainer:SetScrollChild(FRAMES.listFrameContainer.child)

      FRAMES.listFrame = CreateFrame("ScrollingMessageFrame", "testframe", FRAMES.listFrameContainer.child) -- asdf
            FRAMES.listFrame:SetSize(500, 24)
            FRAMES.listFrame:SetPoint("TOPLEFT", FRAMES.listFrameContainer.child, "TOPLEFT", 0, 0)
            FRAMES.listFrame:SetFont("Fonts\\FRIZQT__.ttf", 12)
            FRAMES.listFrame:SetJustifyH("LEFT")
            FRAMES.listFrame:SetJustifyV("TOP")
            FRAMES.listFrame:SetMaxLines(500)
            FRAMES.listFrame:SetFading(false)
            FRAMES.listFrame:SetHyperlinksEnabled(true)
            FRAMES.listFrame:SetInsertMode("BOTTOM")
            FRAMES.listFrame:EnableMouse(true)

-- Page 3
FRAMES.tabContainer.page3 = CreateFrame("Frame", "TabPagesPage3", FRAMES.mainFrame)
      FRAMES.tabContainer.page3:SetPoint("TOPLEFT", FRAMES.tabContainer, "TOPLEFT", 7, -10)
      FRAMES.tabContainer.page3:SetSize(313, 157)
      FRAMES.tabContainer.page3:Hide()

FRAMES.itemRarityEditBox = CreateFrame("EditBox", "ItemRarityEditBox", FRAMES.tabContainer.page3, "InputBoxTemplate")
      FRAMES.itemRarityEditBox:SetPoint("TOPLEFT", FRAMES.tabContainer.page3, "TOPLEFT", 8, -45)
      FRAMES.itemRarityEditBox:SetWidth(40)
      FRAMES.itemRarityEditBox:SetHeight(20)
      FRAMES.itemRarityEditBox:ClearFocus() 
      FRAMES.itemRarityEditBox:SetAutoFocus(false)
      FRAMES.itemRarityEditBox:SetMaxLetters(1)
      FRAMES.itemRarityEditBox:SetAltArrowKeyMode(true)
      FRAMES.itemRarityEditBox:EnableMouse(true)
      FRAMES.itemRarityEditBox:SetText("2")

      FRAMES.itemRarityEditBox.fs = FRAMES.itemRarityEditBox:CreateFontString(nil, "OVERLAY")
            FRAMES.itemRarityEditBox.fs:SetFontObject("GameFontHighlightSmall")
            FRAMES.itemRarityEditBox.fs:SetPoint("LEFT", FRAMES.itemRarityEditBox, "RIGHT", 5, -1)
            FRAMES.itemRarityEditBox.fs:SetText("Min. handled itemrarirty. (0=gray, 5=legendary)")
            FRAMES.itemRarityEditBox.fs:SetJustifyH("Left")

FRAMES.softResRollTimerEditBox = CreateFrame("EditBox", "SoftResRollTimerEditBox", FRAMES.tabContainer.page3, "InputBoxTemplate")
      FRAMES.softResRollTimerEditBox:SetPoint("TOPLEFT", FRAMES.itemRarityEditBox, "BOTTOMLEFT", 60, -32)
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
            FRAMES.softResRollTimerEditBox.fs:SetPoint("RIGHT", FRAMES.softResRollTimerEditBox, "LEFT", -8, 0)
            FRAMES.softResRollTimerEditBox.fs:SetText("SoftRes")
            FRAMES.softResRollTimerEditBox.fs:SetJustifyH("Right")

      FRAMES.softResRollTimerEditBox.title = FRAMES.softResRollTimerEditBox:CreateFontString(nil, "OVERLAY")
            FRAMES.softResRollTimerEditBox.title:SetFontObject("GameFontHighlightSmall")
            FRAMES.softResRollTimerEditBox.title:SetPoint("BOTTOMLEFT", FRAMES.softResRollTimerEditBox, "TOPLEFT", 8, 0)
            FRAMES.softResRollTimerEditBox.title:SetText("Roll timers. (Min: 10, Max: 20)")
            FRAMES.softResRollTimerEditBox.title:SetJustifyH("Right")

      FRAMES.softResRollTimerEditBox.mainTitle = FRAMES.softResRollTimerEditBox:CreateFontString(nil, "OVERLAY")
            FRAMES.softResRollTimerEditBox.mainTitle:SetFontObject("GameFontHighlightSmall")
            FRAMES.softResRollTimerEditBox.mainTitle:SetPoint("BOTTOMLEFT", FRAMES.softResRollTimerEditBox, "TOPLEFT", 18, 12)
            FRAMES.softResRollTimerEditBox.mainTitle:SetText("-----[ SoftRes Rules. ]-----")
            FRAMES.softResRollTimerEditBox.mainTitle:SetJustifyH("Right")

FRAMES.msRollTimerEditBox = CreateFrame("EditBox", "MSRollTimerEditBox", FRAMES.tabContainer.page3, "InputBoxTemplate")
      FRAMES.msRollTimerEditBox:SetPoint("LEFT", FRAMES.softResRollTimerEditBox, "RIGHT", 50, 0)
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
            FRAMES.msRollTimerEditBox.fs:SetPoint("RIGHT", FRAMES.msRollTimerEditBox, "LEFT", -8, 0)
            FRAMES.msRollTimerEditBox.fs:SetText("MS")
            FRAMES.msRollTimerEditBox.fs:SetJustifyH("Left")

FRAMES.osRollTimerEditBox = CreateFrame("EditBox", "OSRollTimerEditBox", FRAMES.tabContainer.page3, "InputBoxTemplate")
      FRAMES.osRollTimerEditBox:SetPoint("LEFT", FRAMES.msRollTimerEditBox, "RIGHT", 60, 0)
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
            FRAMES.osRollTimerEditBox.fs:SetPoint("RIGHT", FRAMES.osRollTimerEditBox, "LEFT", -8, 0)
            FRAMES.osRollTimerEditBox.fs:SetText("OS/FFA")
            FRAMES.osRollTimerEditBox.fs:SetJustifyH("Left")

FRAMES.msDropDecayEditBox = CreateFrame("EditBox", "MSDropDecayEditBox", FRAMES.tabContainer.page3, "InputBoxTemplate")
      FRAMES.msDropDecayEditBox:SetPoint("TOPLEFT", FRAMES.softResRollTimerEditBox, "BOTTOMLEFT", -60, 0)
      FRAMES.msDropDecayEditBox:SetWidth(40)
      FRAMES.msDropDecayEditBox:SetHeight(20)
      FRAMES.msDropDecayEditBox:ClearFocus() 
      FRAMES.msDropDecayEditBox:SetAutoFocus(false)
      FRAMES.msDropDecayEditBox:SetMaxLetters(3)
      FRAMES.msDropDecayEditBox:SetAltArrowKeyMode(true)
      FRAMES.msDropDecayEditBox:EnableMouse(true)
      FRAMES.msDropDecayEditBox:SetText("15")

      FRAMES.msDropDecayEditBox.fs = FRAMES.msDropDecayEditBox:CreateFontString(nil, "OVERLAY")
            FRAMES.msDropDecayEditBox.fs:SetFontObject("GameFontHighlightSmall")
            FRAMES.msDropDecayEditBox.fs:SetPoint("LEFT", FRAMES.msDropDecayEditBox, "RIGHT", 5, -1)
            FRAMES.msDropDecayEditBox.fs:SetText("MS Roll reduction on loot. (Min: 0, Max: 100)")
            FRAMES.msDropDecayEditBox.fs:SetJustifyH("Left")

FRAMES.osDropDecayEditBox = CreateFrame("EditBox", "OSDropDecayEditBox", FRAMES.tabContainer.page3, "InputBoxTemplate")
      FRAMES.osDropDecayEditBox:SetPoint("TOPLEFT", FRAMES.msDropDecayEditBox, "BOTTOMLEFT", 0, 0)
      FRAMES.osDropDecayEditBox:SetWidth(40)
      FRAMES.osDropDecayEditBox:SetHeight(20)
      FRAMES.osDropDecayEditBox:ClearFocus() 
      FRAMES.osDropDecayEditBox:SetAutoFocus(false)
      FRAMES.osDropDecayEditBox:SetMaxLetters(3)
      FRAMES.osDropDecayEditBox:SetAltArrowKeyMode(true)
      FRAMES.osDropDecayEditBox:EnableMouse(true)
      FRAMES.osDropDecayEditBox:SetText("15")

FRAMES.osDropDecayEditBox.fs = FRAMES.osDropDecayEditBox:CreateFontString(nil, "OVERLAY")
      FRAMES.osDropDecayEditBox.fs:SetFontObject("GameFontHighlightSmall")
      FRAMES.osDropDecayEditBox.fs:SetPoint("LEFT", FRAMES.osDropDecayEditBox, "RIGHT", 5, -1)
      FRAMES.osDropDecayEditBox.fs:SetText("OS Roll reduction on loot. (Min: 0, Max: 100)")
      FRAMES.osDropDecayEditBox.fs:SetJustifyH("Left")

-- Extra info edit box.
FRAMES.extraInfoEditBox = CreateFrame("EditBox", "ExtraInfoEditBox", FRAMES.tabContainer.page3, "InputBoxTemplate")
      FRAMES.extraInfoEditBox:SetPoint("BOTTOM", FRAMES.mainFrame, "BOTTOM", 0, 15)
      FRAMES.extraInfoEditBox:SetWidth(250)
      FRAMES.extraInfoEditBox:SetHeight(20)
      FRAMES.extraInfoEditBox:ClearFocus() 
      FRAMES.extraInfoEditBox:SetAutoFocus(false)
      FRAMES.extraInfoEditBox:SetMaxLetters(100)
      FRAMES.extraInfoEditBox:SetAltArrowKeyMode(true)
      FRAMES.extraInfoEditBox:EnableMouse(true)
      FRAMES.extraInfoEditBox:SetText("Ω SoftRes, by Snits-NoggenfoggerEU")

      FRAMES.extraInfoEditBox.mainTitle = FRAMES.extraInfoEditBox:CreateFontString(nil, "OVERLAY")
            FRAMES.extraInfoEditBox.mainTitle:SetFontObject("GameFontHighlightSmall")
            FRAMES.extraInfoEditBox.mainTitle:SetPoint("TOP", FRAMES.extraInfoEditBox, "TOP", 0, 15)
            FRAMES.extraInfoEditBox.mainTitle:SetText("Extra row for custom information.")
            FRAMES.extraInfoEditBox.mainTitle:SetJustifyH("Center")

-- Buttons.
-----------
BUTTONS.tabButtonPage = {}

BUTTONS.tabButtonPage[2] = CreateFrame("Button", "TabButtonPage2", FRAMES.mainFrame, "TabButtonTemplate")
      BUTTONS.tabButtonPage[2].active = true
      BUTTONS.tabButtonPage[2]:SetFrameLevel(3)
      BUTTONS.tabButtonPage[2]:SetPoint("BOTTOMLEFT", FRAMES.tabContainer, "TOPLEFT", 15, -3)
      BUTTONS.tabButtonPage[2]:SetSize(100, 20)
      BUTTONS.tabButtonPage[2]:SetText("SoftRes List")

BUTTONS.tabButtonPage[1] = CreateFrame("Button", "TabButtonPage1", FRAMES.mainFrame, "TabButtonTemplate")
      BUTTONS.tabButtonPage[1].active = false
      BUTTONS.tabButtonPage[1]:SetFrameLevel(2)
      BUTTONS.tabButtonPage[1]:SetPoint("LEFT", BUTTONS.tabButtonPage[2], "RIGHT", 2, 0)
      BUTTONS.tabButtonPage[1]:SetSize(100, 20)
      BUTTONS.tabButtonPage[1]:SetText("Items / rolls")

BUTTONS.tabButtonPage[3] = CreateFrame("Button", "TabButtonPage3", FRAMES.mainFrame, "TabButtonTemplate")
      BUTTONS.tabButtonPage[3].active = false
      BUTTONS.tabButtonPage[3]:SetFrameLevel(2)
      BUTTONS.tabButtonPage[3]:SetPoint("LEFT", BUTTONS.tabButtonPage[1], "RIGHT", 2, 0)
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
      BUTTONS.prepareItemButton:Hide()
      BUTTONS.prepareItemButton:SetText("Prepare Item")
      
BUTTONS.softResRollButton = CreateFrame("Button", "SoftResRollButton", FRAMES.tabContainer.page1, "UIPanelButtonGrayTemplate")
      BUTTONS.softResRollButton:SetPoint("LEFT", BUTTONS.prepareItemButton, "RIGHT", 3, 0)
      BUTTONS.softResRollButton:SetWidth(102)
      BUTTONS.softResRollButton:SetHeight(20)
      BUTTONS.softResRollButton:Hide()
      BUTTONS.softResRollButton:SetText("SoftRes Roll")

      BUTTONS.raidRollButton = CreateFrame("Button", "RaidRollButton", FRAMES.tabContainer.page1, "UIPanelButtonGrayTemplate")
      BUTTONS.raidRollButton:SetPoint("TOPLEFT", BUTTONS.softResRollButton, "BOTTOMLEFT", 0, -2)
      BUTTONS.raidRollButton:SetWidth(102)
      BUTTONS.raidRollButton:SetHeight(20)
      BUTTONS.raidRollButton:Hide()
      BUTTONS.raidRollButton:SetText("Raid Roll")

BUTTONS.osRollButton = CreateFrame("Button", "OSRollButton", FRAMES.tabContainer.page1, "UIPanelButtonGrayTemplate")
      BUTTONS.osRollButton:SetPoint("TOP", BUTTONS.prepareItemButton, "BOTTOM", 0, -2)
      BUTTONS.osRollButton:SetWidth(30)
      BUTTONS.osRollButton:SetHeight(20)
      BUTTONS.osRollButton:Hide()
      BUTTONS.osRollButton:SetText("OS")

BUTTONS.msRollButton = CreateFrame("Button", "MSRollButton", FRAMES.tabContainer.page1, "UIPanelButtonGrayTemplate")
      BUTTONS.msRollButton:SetPoint("RIGHT", BUTTONS.osRollButton, "LEFT", -4, -0)
      BUTTONS.msRollButton:SetWidth(30)
      BUTTONS.msRollButton:SetHeight(20)
      BUTTONS.msRollButton:Hide()
      BUTTONS.msRollButton:SetText("MS")

BUTTONS.ffaRollButton = CreateFrame("Button", "FFARollButton", FRAMES.tabContainer.page1, "UIPanelButtonGrayTemplate")
      BUTTONS.ffaRollButton:SetPoint("LEFT", BUTTONS.osRollButton, "RIGHT", 4, 0)
      BUTTONS.ffaRollButton:SetWidth(30)
      BUTTONS.ffaRollButton:SetHeight(20)
      BUTTONS.ffaRollButton:Hide()
      BUTTONS.ffaRollButton:SetText("FFA")

BUTTONS.announceRollsButton = CreateFrame("Button", "RaidRollButton", FRAMES.tabContainer.page1, "UIPanelButtonGrayTemplate")
      BUTTONS.announceRollsButton:SetPoint("LEFT", BUTTONS.softResRollButton, "RIGHT", 3, 0)
      BUTTONS.announceRollsButton:SetWidth(102)
      BUTTONS.announceRollsButton:SetHeight(20)
      BUTTONS.announceRollsButton:Hide()
      BUTTONS.announceRollsButton:SetText("Announce Result")

BUTTONS.cancelEverythingButton = CreateFrame("Button", "CancelEverythingButton", FRAMES.tabContainer.page1, "UIPanelButtonGrayTemplate")
      BUTTONS.cancelEverythingButton:SetPoint("BOTTOMRIGHT", FRAMES.tabContainer, "BOTTOMRIGHT", -7, 10)
      BUTTONS.cancelEverythingButton:SetWidth(25)
      BUTTONS.cancelEverythingButton:SetHeight(20)
      BUTTONS.cancelEverythingButton:SetText("|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:14:14:0:0|t")

BUTTONS.skipItemButton = CreateFrame("Button", "RaidRollButton", FRAMES.tabContainer.page1, "UIPanelButtonGrayTemplate")
      BUTTONS.skipItemButton:SetPoint("TOPLEFT", BUTTONS.announceRollsButton, "BOTTOMLEFT", 0, -2)
      BUTTONS.skipItemButton:SetWidth(75)
      BUTTONS.skipItemButton:SetHeight(20)
      BUTTONS.skipItemButton:Hide()
      BUTTONS.skipItemButton:SetText("Next Item")

BUTTONS.addPenaltyButton = CreateFrame("CheckButton", "addPenaltyButton", FRAMES.tabContainer.page1, "UICheckButtonTemplate")
      BUTTONS.addPenaltyButton:SetPoint("LEFT", BUTTONS.prepareItemButton, "LEFT", 0, 0)
      BUTTONS.addPenaltyButton:SetWidth(20)
      BUTTONS.addPenaltyButton:SetHeight(20)
      BUTTONS.addPenaltyButton:SetChecked(true)
      BUTTONS.addPenaltyButton:Hide()

      BUTTONS.addPenaltyButton.fs = BUTTONS.addPenaltyButton:CreateFontString(nil, "OVERLAY")
            BUTTONS.addPenaltyButton.fs:SetFontObject("GameFontHighlight")
            BUTTONS.addPenaltyButton.fs:SetPoint("LEFT", BUTTONS.addPenaltyButton, "RIGHT", 0, 0)
            BUTTONS.addPenaltyButton.fs:SetJustifyH("LEFT")
            BUTTONS.addPenaltyButton.fs:SetText("Add penalty (MS/OS)")

-- Buttons page 2.
BUTTONS.newListButton = CreateFrame("Button", "NewListButton", FRAMES.tabContainer.page2, "UIPanelButtonGrayTemplate")
      BUTTONS.newListButton:SetPoint("TOPLEFT", FRAMES.listFrameContainer, "BOTTOMLEFT", -5, -5)
      BUTTONS.newListButton:SetWidth(102)
      BUTTONS.newListButton:SetHeight(20)
      BUTTONS.newListButton:SetText("New List")

BUTTONS.announceRulesButton = CreateFrame("Button", "AnnounceRulesButton", FRAMES.tabContainer.page2, "UIPanelButtonGrayTemplate")
      BUTTONS.announceRulesButton:SetPoint("LEFT", BUTTONS.newListButton, "RIGHT", 4, 0)
      BUTTONS.announceRulesButton:SetWidth(102)
      BUTTONS.announceRulesButton:SetHeight(20)
      BUTTONS.announceRulesButton:SetText("Announce Rules")

BUTTONS.scanForSoftResButton = CreateFrame("Button", "ScanForSoftResButton", FRAMES.tabContainer.page2, "UIPanelButtonGrayTemplate")
      BUTTONS.scanForSoftResButton:SetPoint("LEFT", BUTTONS.announceRulesButton, "RIGHT", 4, 0)
      BUTTONS.scanForSoftResButton:SetWidth(102)
      BUTTONS.scanForSoftResButton:SetHeight(20)
      BUTTONS.scanForSoftResButton.normalText = "Scan SoftRes"
      BUTTONS.scanForSoftResButton.activeText = "Scanning"
      BUTTONS.scanForSoftResButton:SetText(BUTTONS.scanForSoftResButton.normalText)

BUTTONS.addPlayerSoftResButton = CreateFrame("Button", "AddPlayerSoftResButton", FRAMES.tabContainer.page2, "UIPanelButtonGrayTemplate")
      BUTTONS.addPlayerSoftResButton:SetPoint("TOPLEFT", BUTTONS.newListButton, "BOTTOMLEFT", 0, -5)
      BUTTONS.addPlayerSoftResButton:SetWidth(102)
      BUTTONS.addPlayerSoftResButton:SetHeight(20)
      BUTTONS.addPlayerSoftResButton:SetText("Edit Player")

BUTTONS.editPlayerButton = CreateFrame("Button", "EditPlayerButton", FRAMES.tabContainer.page2, "UIPanelButtonGrayTemplate")
      BUTTONS.editPlayerButton:SetPoint("LEFT", BUTTONS.addPlayerSoftResButton, "RIGHT", 4, 0)
      BUTTONS.editPlayerButton:SetWidth(102)
      BUTTONS.editPlayerButton:SetHeight(20)
      BUTTONS.editPlayerButton:SetText("Edit Loot")
      BUTTONS.editPlayerButton:Show()

BUTTONS.deletePlayerButton = CreateFrame("Button", "DeletePlayerButton", FRAMES.tabContainer.page2, "UIPanelButtonGrayTemplate")
      BUTTONS.deletePlayerButton:SetPoint("LEFT", BUTTONS.editPlayerButton, "RIGHT", 4, 0)
      BUTTONS.deletePlayerButton:SetWidth(102)
      BUTTONS.deletePlayerButton:SetHeight(20)
      BUTTONS.deletePlayerButton:SetText("Delete Player")

-- Buttons Page 3
BUTTONS.enableSoftResAddon = CreateFrame("CheckButton", "EnableSoftResAddon", FRAMES.tabContainer.page3, "UICheckButtonTemplate")
      BUTTONS.enableSoftResAddon:SetPoint("TOPLEFT", FRAMES.tabContainer.page3, "TOPLEFT", 0, 5)
      BUTTONS.enableSoftResAddon:SetWidth(20)
      BUTTONS.enableSoftResAddon:SetHeight(20)
      BUTTONS.enableSoftResAddon:SetChecked(false)

      BUTTONS.enableSoftResAddon.fs = BUTTONS.enableSoftResAddon:CreateFontString(nil, "OVERLAY")
            BUTTONS.enableSoftResAddon.fs:SetFontObject("GameFontHighlight")
            BUTTONS.enableSoftResAddon.fs:SetPoint("LEFT", BUTTONS.enableSoftResAddon, "RIGHT", 0, 0)
            BUTTONS.enableSoftResAddon.fs:SetJustifyH("LEFT")
            BUTTONS.enableSoftResAddon.fs:SetText("Enable SoftRes Addon.")

BUTTONS.autoShowWindowCheckButton = CreateFrame("CheckButton", "AutoShowWindowCheckButton", FRAMES.tabContainer.page3, "UICheckButtonTemplate")
      BUTTONS.autoShowWindowCheckButton:SetPoint("TOPLEFT", BUTTONS.enableSoftResAddon, "BOTTOMLEFT", 0, 5)
      BUTTONS.autoShowWindowCheckButton:SetWidth(20)
      BUTTONS.autoShowWindowCheckButton:SetHeight(20)
      BUTTONS.autoShowWindowCheckButton:SetChecked(false)

      BUTTONS.autoShowWindowCheckButton.fs = BUTTONS.autoShowWindowCheckButton:CreateFontString(nil, "OVERLAY")
            BUTTONS.autoShowWindowCheckButton.fs:SetFontObject("GameFontHighlight")
            BUTTONS.autoShowWindowCheckButton.fs:SetPoint("LEFT", BUTTONS.autoShowWindowCheckButton, "RIGHT", 0, 0)
            BUTTONS.autoShowWindowCheckButton.fs:SetJustifyH("LEFT")
            BUTTONS.autoShowWindowCheckButton.fs:SetText("Auto-show window on loot.")

BUTTONS.autoHideWindowCheckButton = CreateFrame("CheckButton", "AautoHideWindowCheckButton", FRAMES.tabContainer.page3, "UICheckButtonTemplate")
      BUTTONS.autoHideWindowCheckButton:SetPoint("TOPLEFT", BUTTONS.autoShowWindowCheckButton, "BOTTOMLEFT", 0, 5)
      BUTTONS.autoHideWindowCheckButton:SetWidth(20)
      BUTTONS.autoHideWindowCheckButton:SetHeight(20)
      BUTTONS.autoHideWindowCheckButton:SetChecked(false)
      
      BUTTONS.autoHideWindowCheckButton.fs = BUTTONS.autoHideWindowCheckButton:CreateFontString(nil, "OVERLAY")
            BUTTONS.autoHideWindowCheckButton.fs:SetFontObject("GameFontHighlight")
            BUTTONS.autoHideWindowCheckButton.fs:SetPoint("LEFT", BUTTONS.autoHideWindowCheckButton, "RIGHT", 0, 0)
            BUTTONS.autoHideWindowCheckButton.fs:SetJustifyH("LEFT")
            BUTTONS.autoHideWindowCheckButton.fs:SetText("Auto-hide window when done looting.")

-- Custom popup window for adding player.
FRAMES.editPlayerAddPlayerPopupWindow = CreateFrame("Frame", "editPlayerAddPlayerPopupWindow", FRAMES.mainFrame, "BasicFrameTemplate")
      FRAMES.editPlayerAddPlayerPopupWindow:SetFrameStrata("FULLSCREEN")
      FRAMES.editPlayerAddPlayerPopupWindow:SetPoint("TOP", UIParent, "TOP", 0, -100)
      FRAMES.editPlayerAddPlayerPopupWindow:SetSize(300, 250)
      FRAMES.editPlayerAddPlayerPopupWindow:SetMovable(true)
      FRAMES.editPlayerAddPlayerPopupWindow:EnableMouse(true)
      FRAMES.editPlayerAddPlayerPopupWindow:RegisterForDrag("LeftButton")
      FRAMES.editPlayerAddPlayerPopupWindow:SetScript("OnDragStart", FRAMES.editPlayerAddPlayerPopupWindow.StartMoving)
      FRAMES.editPlayerAddPlayerPopupWindow:SetScript("OnDragStop", FRAMES.editPlayerAddPlayerPopupWindow.StopMovingOrSizing)
      FRAMES.editPlayerAddPlayerPopupWindow:Hide()

      FRAMES.editPlayerAddPlayerPopupWindow.title = FRAMES.editPlayerAddPlayerPopupWindow:CreateFontString(nil, "Overlay")
            FRAMES.editPlayerAddPlayerPopupWindow.title:SetFontObject("GameFontHighlight")
            FRAMES.editPlayerAddPlayerPopupWindow.title:SetPoint("TOPLEFT", FRAMES.editPlayerAddPlayerPopupWindow.TitleBg, "TOPLEFT", 3, -3)
            FRAMES.editPlayerAddPlayerPopupWindow.title:SetText("Ω SoftRes")
      
      FRAMES.editPlayerAddPlayerPopupWindow.titleCenter = FRAMES.editPlayerAddPlayerPopupWindow:CreateFontString(nil, "Overlay")
            FRAMES.editPlayerAddPlayerPopupWindow.titleCenter:SetFontObject("GameFontHighlight")
            FRAMES.editPlayerAddPlayerPopupWindow.titleCenter:SetPoint("TOP", FRAMES.editPlayerAddPlayerPopupWindow.TitleBg, "TOP", 0, -3)
            FRAMES.editPlayerAddPlayerPopupWindow.titleCenter:SetText("Edit Player")

      BUTTONS.editPlayerPopUpEditPlayerButton = CreateFrame("Button", "editPlayerPopUpAddPlayerButton", FRAMES.editPlayerAddPlayerPopupWindow, "UIPanelButtonGrayTemplate")
            BUTTONS.editPlayerPopUpEditPlayerButton:SetPoint("TOP", FRAMES.editPlayerAddPlayerPopupWindow, "TOP", 55, -30)
            BUTTONS.editPlayerPopUpEditPlayerButton:SetWidth(102)
            BUTTONS.editPlayerPopUpEditPlayerButton:SetHeight(20)
            BUTTONS.editPlayerPopUpEditPlayerButton:SetText("Edit Player")

      BUTTONS.editPlayerPopUpAddPlayerButton = CreateFrame("Button", "editPlayerPopUpAddPlayerButton", FRAMES.editPlayerAddPlayerPopupWindow, "UIPanelButtonGrayTemplate")
            BUTTONS.editPlayerPopUpAddPlayerButton:SetPoint("TOP", FRAMES.editPlayerAddPlayerPopupWindow, "TOP", -55, -30)
            BUTTONS.editPlayerPopUpAddPlayerButton:SetWidth(102)
            BUTTONS.editPlayerPopUpAddPlayerButton:SetHeight(20)
            BUTTONS.editPlayerPopUpAddPlayerButton:SetText("Add Player")

      FRAMES.addPlayerPopupWindow = CreateFrame("Frame", "addPlayerPopupWindow", FRAMES.editPlayerAddPlayerPopupWindow)
            FRAMES.addPlayerPopupWindow:SetPoint("TOP", FRAMES.editPlayerAddPlayerPopupWindow, "TOP", 0, -50)
            FRAMES.addPlayerPopupWindow:SetSize(300, 200)
            FRAMES.addPlayerPopupWindow:Hide()

      FRAMES.addPlayerNameEditBox = CreateFrame("EditBox", "addPlayerNameEditBox", FRAMES.addPlayerPopupWindow, "InputBoxTemplate")
            FRAMES.addPlayerNameEditBox:SetPoint("TOP", FRAMES.addPlayerPopupWindow, "TOP", 0, -75)
            FRAMES.addPlayerNameEditBox:SetWidth(100)
            FRAMES.addPlayerNameEditBox:SetHeight(20)
            FRAMES.addPlayerNameEditBox:ClearFocus()
            FRAMES.addPlayerNameEditBox:SetAutoFocus(false)
            FRAMES.addPlayerNameEditBox:SetMaxLetters(12)
            FRAMES.addPlayerNameEditBox:SetAltArrowKeyMode(false)
            FRAMES.addPlayerNameEditBox:EnableMouse(true)
            FRAMES.addPlayerNameEditBox:SetText("")
            FRAMES.addPlayerNameEditBox:SetJustifyH("Center")
      
      FRAMES.addPlayerNameEditBox.fs = FRAMES.addPlayerNameEditBox:CreateFontString(nil, "OVERLAY")
            FRAMES.addPlayerNameEditBox.fs:SetFontObject("GameFontHighlight")
            FRAMES.addPlayerNameEditBox.fs:SetPoint("BOTTOM", FRAMES.addPlayerNameEditBox, "TOP", 0, 5)
            FRAMES.addPlayerNameEditBox.fs:SetText("To add a new player\nsimply enter the Player name \n and (or not) the linked item.\n\nPlayer Name:")
            FRAMES.addPlayerNameEditBox.fs:SetJustifyH("Center")
      
      FRAMES.addPlayerItemEditBox = CreateFrame("EditBox", "addPlayerItemEditBox", FRAMES.addPlayerPopupWindow, "InputBoxTemplate")
            FRAMES.addPlayerItemEditBox:SetPoint("TOP", FRAMES.addPlayerNameEditBox, "BOTTOM", 0, -37)
            FRAMES.addPlayerItemEditBox:SetWidth(200)
            FRAMES.addPlayerItemEditBox:SetHeight(20)
            FRAMES.addPlayerItemEditBox:ClearFocus()
            FRAMES.addPlayerItemEditBox:SetAutoFocus(false)
            FRAMES.addPlayerItemEditBox:SetMaxLetters(100)
            FRAMES.addPlayerItemEditBox:SetAltArrowKeyMode(false)
            FRAMES.addPlayerItemEditBox:EnableMouse(true)
            FRAMES.addPlayerItemEditBox:SetHyperlinksEnabled(true)
            FRAMES.addPlayerItemEditBox:SetText("")
            FRAMES.addPlayerItemEditBox:SetJustifyH("Center")
      
            FRAMES.addPlayerItemEditBox.fs = FRAMES.addPlayerItemEditBox:CreateFontString(nil, "OVERLAY")
                  FRAMES.addPlayerItemEditBox.fs:SetFontObject("GameFontHighlight")
                  FRAMES.addPlayerItemEditBox.fs:SetPoint("BOTTOM", FRAMES.addPlayerItemEditBox, "TOP", 0, 5)
                  FRAMES.addPlayerItemEditBox.fs:SetText("Hold SHIFT and click an itemLink to add it.")
                  FRAMES.addPlayerItemEditBox.fs:SetJustifyH("Center")

      BUTTONS.addPlayerPopUpAddButton = CreateFrame("Button", "addPlayerPopUpAddButton", FRAMES.addPlayerPopupWindow, "UIPanelButtonGrayTemplate")
            BUTTONS.addPlayerPopUpAddButton:SetPoint("BOTTOM", FRAMES.addPlayerPopupWindow, "BOTTOM", -55, 10)
            BUTTONS.addPlayerPopUpAddButton:SetWidth(102)
            BUTTONS.addPlayerPopUpAddButton:SetHeight(20)
            BUTTONS.addPlayerPopUpAddButton:SetText("Add Player")
      
      BUTTONS.addPlayerPopUpCancelButton = CreateFrame("Button", "addPlayerPopUpCancelButton", FRAMES.addPlayerPopupWindow, "UIPanelButtonGrayTemplate")
            BUTTONS.addPlayerPopUpCancelButton:SetPoint("BOTTOM", FRAMES.addPlayerPopupWindow, "BOTTOM", 55, 10)
            BUTTONS.addPlayerPopUpCancelButton:SetWidth(102)
            BUTTONS.addPlayerPopUpCancelButton:SetHeight(20)
            BUTTONS.addPlayerPopUpCancelButton:SetText("Cancel")

      BUTTONS.addPlayerTargetNameButton = CreateFrame("Button", "addPlayerTargetNameButton", FRAMES.addPlayerPopupWindow, "UIPanelButtonGrayTemplate")
            BUTTONS.addPlayerTargetNameButton:SetPoint("LEFT", FRAMES.addPlayerNameEditBox, "RIGHT", 5, 0)
            BUTTONS.addPlayerTargetNameButton:SetWidth(70)
            BUTTONS.addPlayerTargetNameButton:SetHeight(20)
            BUTTONS.addPlayerTargetNameButton:SetText("Target")

      BUTTONS.addPlayerItemClearButton = CreateFrame("Button", "addPlayerItemClearButton", FRAMES.addPlayerPopupWindow, "UIPanelButtonGrayTemplate")
            BUTTONS.addPlayerItemClearButton:SetPoint("LEFT", FRAMES.addPlayerItemEditBox, "RIGHT", 5, 0)
            BUTTONS.addPlayerItemClearButton:SetWidth(30)
            BUTTONS.addPlayerItemClearButton:SetHeight(20)
            BUTTONS.addPlayerItemClearButton:SetText("|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:14:14:0:0|t")

      -- EDIT
      FRAMES.editPlayerEditPopupWindow = CreateFrame("Frame", "editPlayerEditPopupWindow", FRAMES.editPlayerAddPlayerPopupWindow)
            FRAMES.editPlayerEditPopupWindow:SetPoint("TOP", FRAMES.editPlayerAddPlayerPopupWindow, "TOP", 0, -75)
            FRAMES.editPlayerEditPopupWindow:SetSize(300, 200)
            FRAMES.editPlayerEditPopupWindow:Hide()

      BUTTONS.editPlayerEditDropDown = CreateFrame("Button", "editPlayerEditDropDown", FRAMES.editPlayerEditPopupWindow, "UIDropDownMenuTemplate")
            BUTTONS.editPlayerEditDropDown:SetPoint("TOP", FRAMES.editPlayerEditPopupWindow, "TOP", 0, 0)
                  
            UIDropDownMenu_SetWidth(BUTTONS.editPlayerEditDropDown, 83)
            UIDropDownMenu_SetButtonWidth(BUTTONS.editPlayerEditDropDown, 102)
            UIDropDownMenu_JustifyText(BUTTONS.editPlayerEditDropDown, "LEFT")
      
      BUTTONS.editPlayerEditDropDown.fs = BUTTONS.editPlayerEditDropDown:CreateFontString(nil, "OVERLAY")
            BUTTONS.editPlayerEditDropDown.fs:SetFontObject("GameFontHighlight")
            BUTTONS.editPlayerEditDropDown.fs:SetPoint("BOTTOM", BUTTONS.editPlayerEditDropDown, "TOP", 0, 5)
            BUTTONS.editPlayerEditDropDown.fs:SetText("Choose the player to edit.")
            BUTTONS.editPlayerEditDropDown.fs:SetJustifyH("Center")
      
      FRAMES.editPlayerEditItemEditBox = CreateFrame("EditBox", "editPlayerEditItemEditBox", FRAMES.editPlayerEditPopupWindow, "InputBoxTemplate")
            FRAMES.editPlayerEditItemEditBox:SetPoint("TOP", BUTTONS.editPlayerEditDropDown, "BOTTOM", 0, -25)
            FRAMES.editPlayerEditItemEditBox:SetWidth(200)
            FRAMES.editPlayerEditItemEditBox:SetHeight(20)
            FRAMES.editPlayerEditItemEditBox:ClearFocus()
            FRAMES.editPlayerEditItemEditBox:SetAutoFocus(false)
            FRAMES.editPlayerEditItemEditBox:SetMaxLetters(100)
            FRAMES.editPlayerEditItemEditBox:SetAltArrowKeyMode(false)
            FRAMES.editPlayerEditItemEditBox:EnableMouse(true)
            FRAMES.editPlayerEditItemEditBox:SetHyperlinksEnabled(true)
            FRAMES.editPlayerEditItemEditBox:SetText("")
            FRAMES.editPlayerEditItemEditBox:SetJustifyH("Center")
      
            FRAMES.editPlayerEditItemEditBox.fs = FRAMES.editPlayerEditItemEditBox:CreateFontString(nil, "OVERLAY")
                  FRAMES.editPlayerEditItemEditBox.fs:SetFontObject("GameFontHighlight")
                  FRAMES.editPlayerEditItemEditBox.fs:SetPoint("BOTTOM", FRAMES.editPlayerEditItemEditBox, "TOP", 0, 5)
                  FRAMES.editPlayerEditItemEditBox.fs:SetText("Hold SHIFT and click an itemLink to add it.")
                  FRAMES.editPlayerEditItemEditBox.fs:SetJustifyH("Center")

      BUTTONS.editPlayerEditSoftResButton = CreateFrame("CheckButton", "editPlayerEditSoftResButton", FRAMES.editPlayerEditPopupWindow, "UICheckButtonTemplate")
            BUTTONS.editPlayerEditSoftResButton:SetPoint("TOP", FRAMES.editPlayerEditItemEditBox, "BOTTOM", -50, -8)
            BUTTONS.editPlayerEditSoftResButton:SetWidth(20)
            BUTTONS.editPlayerEditSoftResButton:SetHeight(20)
            BUTTONS.editPlayerEditSoftResButton:SetChecked(true)
            BUTTONS.editPlayerEditSoftResButton:Hide()
      
            BUTTONS.editPlayerEditSoftResButton.fs = BUTTONS.editPlayerEditSoftResButton:CreateFontString(nil, "OVERLAY")
                  BUTTONS.editPlayerEditSoftResButton.fs:SetFontObject("GameFontHighlight")
                  BUTTONS.editPlayerEditSoftResButton.fs:SetPoint("LEFT", BUTTONS.editPlayerEditSoftResButton, "RIGHT", 5, 0)
                  BUTTONS.editPlayerEditSoftResButton.fs:SetJustifyH("LEFT")
                  BUTTONS.editPlayerEditSoftResButton.fs:SetText("Received SoftReserved Item")

      BUTTONS.editPlayerPopUpEditButton = CreateFrame("Button", "editPlayerPopUpEditButton", FRAMES.editPlayerEditPopupWindow, "UIPanelButtonGrayTemplate")
            BUTTONS.editPlayerPopUpEditButton:SetPoint("BOTTOM", FRAMES.editPlayerAddPlayerPopupWindow, "BOTTOM", -55, 10)
            BUTTONS.editPlayerPopUpEditButton:SetWidth(102)
            BUTTONS.editPlayerPopUpEditButton:SetHeight(20)
            BUTTONS.editPlayerPopUpEditButton:SetText("Edit Player")
            BUTTONS.editPlayerPopUpEditButton:Hide()
      
      BUTTONS.editPlayerEditPopUpCancelButton = CreateFrame("Button", "editPlayerEditPopUpCancelButton", FRAMES.editPlayerEditPopupWindow, "UIPanelButtonGrayTemplate")
            BUTTONS.editPlayerEditPopUpCancelButton:SetPoint("BOTTOM", FRAMES.editPlayerAddPlayerPopupWindow, "BOTTOM", 55, 10)
            BUTTONS.editPlayerEditPopUpCancelButton:SetWidth(102)
            BUTTONS.editPlayerEditPopUpCancelButton:SetHeight(20)
            BUTTONS.editPlayerEditPopUpCancelButton:SetText("Cancel")

      BUTTONS.editPlayerEditItemClearButton = CreateFrame("Button", "editPlayerEditItemClearButton", FRAMES.editPlayerEditPopupWindow, "UIPanelButtonGrayTemplate")
            BUTTONS.editPlayerEditItemClearButton:SetPoint("LEFT", FRAMES.editPlayerEditItemEditBox, "RIGHT", 5, 0)
            BUTTONS.editPlayerEditItemClearButton:SetWidth(30)
            BUTTONS.editPlayerEditItemClearButton:SetHeight(20)
            BUTTONS.editPlayerEditItemClearButton:SetText("|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:14:14:0:0|t")

-- Custom popup window for deleteing a player.
FRAMES.deletePlayerPopupWindow = CreateFrame("Frame", "deletePlayerPopupWindow", FRAMES.mainFrame, "BasicFrameTemplate")
      FRAMES.deletePlayerPopupWindow:SetFrameStrata("FULLSCREEN")
      FRAMES.deletePlayerPopupWindow:SetPoint("TOP", UIParent, "TOP", 0, -100)
      FRAMES.deletePlayerPopupWindow:SetSize(300, 200)
      FRAMES.deletePlayerPopupWindow:SetMovable(true)
      FRAMES.deletePlayerPopupWindow:EnableMouse(true)
      FRAMES.deletePlayerPopupWindow:RegisterForDrag("LeftButton")
      FRAMES.deletePlayerPopupWindow:SetScript("OnDragStart", FRAMES.deletePlayerPopupWindow.StartMoving)
      FRAMES.deletePlayerPopupWindow:SetScript("OnDragStop", FRAMES.deletePlayerPopupWindow.StopMovingOrSizing)
      FRAMES.deletePlayerPopupWindow:Hide()

      FRAMES.deletePlayerPopupWindow.title = FRAMES.deletePlayerPopupWindow:CreateFontString(nil, "Overlay")
            FRAMES.deletePlayerPopupWindow.title:SetFontObject("GameFontHighlight")
            FRAMES.deletePlayerPopupWindow.title:SetPoint("TOPLEFT", FRAMES.deletePlayerPopupWindow.TitleBg, "TOPLEFT", 3, -3)
            FRAMES.deletePlayerPopupWindow.title:SetText("Ω SoftRes")
      
      FRAMES.deletePlayerPopupWindow.titleCenter = FRAMES.deletePlayerPopupWindow:CreateFontString(nil, "Overlay")
            FRAMES.deletePlayerPopupWindow.titleCenter:SetFontObject("GameFontHighlight")
            FRAMES.deletePlayerPopupWindow.titleCenter:SetPoint("TOP", FRAMES.deletePlayerPopupWindow.TitleBg, "TOP", 0, -3)
            FRAMES.deletePlayerPopupWindow.titleCenter:SetText("Delete Player")
    
      BUTTONS.deletePlayerDropDown = CreateFrame("Button", "DeletePlayerDropDown", FRAMES.deletePlayerPopupWindow, "UIDropDownMenuTemplate")
            BUTTONS.deletePlayerDropDown:SetPoint("TOP", FRAMES.deletePlayerPopupWindow, "TOP", 0, -75)
                  
            UIDropDownMenu_SetWidth(BUTTONS.deletePlayerDropDown, 83)
            UIDropDownMenu_SetButtonWidth(BUTTONS.deletePlayerDropDown, 102)
            UIDropDownMenu_JustifyText(BUTTONS.deletePlayerDropDown, "LEFT")

      BUTTONS.deletePlayerDropDown.fs = BUTTONS.deletePlayerDropDown:CreateFontString(nil, "OVERLAY")
            BUTTONS.deletePlayerDropDown.fs:SetFontObject("GameFontHighlight")
            BUTTONS.deletePlayerDropDown.fs:SetPoint("TOP", FRAMES.deletePlayerPopupWindow, "TOP", 0, -40)
            BUTTONS.deletePlayerDropDown.fs:SetText("To delete a player, just choose it in the drop-down.\nThen write 'delete' in the editBox.")
            BUTTONS.deletePlayerDropDown.fs:SetJustifyH("Center")

      FRAMES.deletePlayerEditBox = CreateFrame("EditBox", "deletePlayerEditBox", FRAMES.deletePlayerPopupWindow, "InputBoxTemplate")
            FRAMES.deletePlayerEditBox:SetPoint("TOP", BUTTONS.deletePlayerDropDown, "BOTTOM", 0, -25)
            FRAMES.deletePlayerEditBox:SetWidth(150)
            FRAMES.deletePlayerEditBox:SetHeight(20)
            FRAMES.deletePlayerEditBox:ClearFocus()
            FRAMES.deletePlayerEditBox:SetAutoFocus(false)
            FRAMES.deletePlayerEditBox:SetMaxLetters(6)
            FRAMES.deletePlayerEditBox:SetAltArrowKeyMode(false)
            FRAMES.deletePlayerEditBox:EnableMouse(true)
            FRAMES.deletePlayerEditBox:SetText("")
            FRAMES.deletePlayerEditBox:SetJustifyH("Center")
      
            FRAMES.deletePlayerEditBox.fs = FRAMES.deletePlayerEditBox:CreateFontString(nil, "OVERLAY")
                  FRAMES.deletePlayerEditBox.fs:SetFontObject("GameFontHighlight")
                  FRAMES.deletePlayerEditBox.fs:SetPoint("BOTTOM", FRAMES.deletePlayerEditBox, "TOP", 0, 5)
                  FRAMES.deletePlayerEditBox.fs:SetText("Write 'delete' to continue.")
                  FRAMES.deletePlayerEditBox.fs:SetJustifyH("Center")

      BUTTONS.deletePlayerPopUpDeleteButton = CreateFrame("Button", "deletePlayerPopUpDeleteButton", FRAMES.deletePlayerPopupWindow, "UIPanelButtonGrayTemplate")
            BUTTONS.deletePlayerPopUpDeleteButton:SetPoint("BOTTOM", FRAMES.deletePlayerPopupWindow, "BOTTOM", -55, 10)
            BUTTONS.deletePlayerPopUpDeleteButton:SetWidth(102)
            BUTTONS.deletePlayerPopUpDeleteButton:SetHeight(20)
            BUTTONS.deletePlayerPopUpDeleteButton:SetText("Delete Player")
            BUTTONS.deletePlayerPopUpDeleteButton:Hide()
      
      BUTTONS.deletePlayerPopUpCancelButton = CreateFrame("Button", "deletePlayerPopUpCancelButton", FRAMES.deletePlayerPopupWindow, "UIPanelButtonGrayTemplate")
            BUTTONS.deletePlayerPopUpCancelButton:SetPoint("BOTTOM", FRAMES.deletePlayerPopupWindow, "BOTTOM", 55, 10)
            BUTTONS.deletePlayerPopUpCancelButton:SetWidth(102)
            BUTTONS.deletePlayerPopUpCancelButton:SetHeight(20)
            BUTTONS.deletePlayerPopUpCancelButton:SetText("Cancel")

-- Custom popup window for editing a player item.
FRAMES.editPlayerEditItemPopupWindow = CreateFrame("Frame", "editPlayerEditItemPopupWindow", FRAMES.mainFrame, "BasicFrameTemplate")
      FRAMES.editPlayerEditItemPopupWindow:SetFrameStrata("FULLSCREEN")
      FRAMES.editPlayerEditItemPopupWindow:SetPoint("TOP", UIParent, "TOP", 0, -100)
      FRAMES.editPlayerEditItemPopupWindow:SetSize(300, 300)
      FRAMES.editPlayerEditItemPopupWindow:SetMovable(true)
      FRAMES.editPlayerEditItemPopupWindow:EnableMouse(true)
      FRAMES.editPlayerEditItemPopupWindow:RegisterForDrag("LeftButton")
      FRAMES.editPlayerEditItemPopupWindow:SetScript("OnDragStart", FRAMES.editPlayerEditItemPopupWindow.StartMoving)
      FRAMES.editPlayerEditItemPopupWindow:SetScript("OnDragStop", FRAMES.editPlayerEditItemPopupWindow.StopMovingOrSizing)
      FRAMES.editPlayerEditItemPopupWindow:Hide()

      FRAMES.editPlayerEditItemPopupWindow.title = FRAMES.editPlayerEditItemPopupWindow:CreateFontString(nil, "Overlay")
            FRAMES.editPlayerEditItemPopupWindow.title:SetFontObject("GameFontHighlight")
            FRAMES.editPlayerEditItemPopupWindow.title:SetPoint("TOPLEFT", FRAMES.editPlayerEditItemPopupWindow.TitleBg, "TOPLEFT", 3, -3)
            FRAMES.editPlayerEditItemPopupWindow.title:SetText("Ω SoftRes")
      
      FRAMES.editPlayerEditItemPopupWindow.titleCenter = FRAMES.editPlayerEditItemPopupWindow:CreateFontString(nil, "Overlay")
            FRAMES.editPlayerEditItemPopupWindow.titleCenter:SetFontObject("GameFontHighlight")
            FRAMES.editPlayerEditItemPopupWindow.titleCenter:SetPoint("TOP", FRAMES.editPlayerEditItemPopupWindow.TitleBg, "TOP", 0, -3)
            FRAMES.editPlayerEditItemPopupWindow.titleCenter:SetText("Remove Penalty")

      BUTTONS.editPlayerPopUpEditItemButton = CreateFrame("Button", "editPlayerPopUpEditItemButton", FRAMES.editPlayerEditItemPopupWindow, "UIPanelButtonGrayTemplate")
            BUTTONS.editPlayerPopUpEditItemButton:SetPoint("TOP", FRAMES.editPlayerEditItemPopupWindow, "TOP", 55, -30)
            BUTTONS.editPlayerPopUpEditItemButton:SetWidth(102)
            BUTTONS.editPlayerPopUpEditItemButton:SetHeight(20)
            BUTTONS.editPlayerPopUpEditItemButton:SetText("Edit Loot")

      BUTTONS.editPlayerPopUpAddItemButton = CreateFrame("Button", "editPlayerPopUpAddItemButton", FRAMES.editPlayerEditItemPopupWindow, "UIPanelButtonGrayTemplate")
            BUTTONS.editPlayerPopUpAddItemButton:SetPoint("TOP", FRAMES.editPlayerEditItemPopupWindow, "TOP", -55, -30)
            BUTTONS.editPlayerPopUpAddItemButton:SetWidth(102)
            BUTTONS.editPlayerPopUpAddItemButton:SetHeight(20)
            BUTTONS.editPlayerPopUpAddItemButton:SetText("Add Loot")
      
      -- Edit player item.
      FRAMES.editPlayerPopupWindow = CreateFrame("Frame", "editPlayerPopupWindow", FRAMES.editPlayerEditItemPopupWindow)
            FRAMES.editPlayerPopupWindow:SetPoint("TOP", FRAMES.editPlayerEditItemPopupWindow, "TOP", 0, -25)
            FRAMES.editPlayerPopupWindow:SetSize(300, 275)
            FRAMES.editPlayerPopupWindow:Hide()

      BUTTONS.editPlayerDropDown = CreateFrame("Button", "EditPlayerDropDown", FRAMES.editPlayerPopupWindow, "UIDropDownMenuTemplate")
            BUTTONS.editPlayerDropDown:SetPoint("TOP", FRAMES.editPlayerPopupWindow, "TOP", -75, -50)
                  
            UIDropDownMenu_SetWidth(BUTTONS.editPlayerDropDown, 83)
            UIDropDownMenu_SetButtonWidth(BUTTONS.editPlayerDropDown, 102)
            UIDropDownMenu_JustifyText(BUTTONS.editPlayerDropDown, "LEFT")

      BUTTONS.editPlayerDropDown.fs = BUTTONS.editPlayerDropDown:CreateFontString(nil, "OVERLAY")
            BUTTONS.editPlayerDropDown.fs:SetFontObject("GameFontHighlight")
            BUTTONS.editPlayerDropDown.fs:SetPoint("BOTTOM", BUTTONS.editPlayerDropDown, "TOP", 0, 5)
            BUTTONS.editPlayerDropDown.fs:SetText("Choose a player.")
            BUTTONS.editPlayerDropDown.fs:SetJustifyH("Center")

      BUTTONS.editPlayerItemDropDown = CreateFrame("Button", "EditPlayerItemDropDown", FRAMES.editPlayerPopupWindow, "UIDropDownMenuTemplate")
            BUTTONS.editPlayerItemDropDown:SetPoint("LEFT", BUTTONS.editPlayerDropDown, "RIGHT", 20, 0)
                  
            UIDropDownMenu_SetWidth(BUTTONS.editPlayerItemDropDown, 83)
            UIDropDownMenu_SetButtonWidth(BUTTONS.editPlayerItemDropDown, 102)
            UIDropDownMenu_JustifyText(BUTTONS.editPlayerItemDropDown, "LEFT")

      BUTTONS.editPlayerItemDropDown.fs = BUTTONS.editPlayerItemDropDown:CreateFontString(nil, "OVERLAY")
            BUTTONS.editPlayerItemDropDown.fs:SetFontObject("GameFontHighlight")
            BUTTONS.editPlayerItemDropDown.fs:SetPoint("BOTTOM", BUTTONS.editPlayerItemDropDown, "TOP", 0, 5)
            BUTTONS.editPlayerItemDropDown.fs:SetText("Choose an item.")
            BUTTONS.editPlayerItemDropDown.fs:SetJustifyH("Center")

      BUTTONS.rollTypeDropDown = CreateFrame("Button", "RollTypeDropDown", FRAMES.editPlayerPopupWindow, "UIDropDownMenuTemplate")
            BUTTONS.rollTypeDropDown:SetPoint("TOP", BUTTONS.editPlayerDropDown, "BOTTOM", 0, -25)
                  
            UIDropDownMenu_SetWidth(BUTTONS.rollTypeDropDown, 83)
            UIDropDownMenu_SetButtonWidth(BUTTONS.rollTypeDropDown, 102)
            UIDropDownMenu_JustifyText(BUTTONS.rollTypeDropDown, "LEFT")

      BUTTONS.rollTypeDropDown.fs = BUTTONS.rollTypeDropDown:CreateFontString(nil, "OVERLAY")
            BUTTONS.rollTypeDropDown.fs:SetFontObject("GameFontHighlight")
            BUTTONS.rollTypeDropDown.fs:SetPoint("BOTTOM", BUTTONS.rollTypeDropDown, "TOP", 0, 5)
            BUTTONS.rollTypeDropDown.fs:SetText("Set the rollType")
            BUTTONS.rollTypeDropDown.fs:SetJustifyH("Center")

      BUTTONS.editPenaltyButton = CreateFrame("CheckButton", "editPenaltyButton", FRAMES.editPlayerPopupWindow, "UICheckButtonTemplate")
            BUTTONS.editPenaltyButton:SetPoint("LEFT", BUTTONS.rollTypeDropDown, "RIGHT", 5, 0)
            BUTTONS.editPenaltyButton:SetWidth(20)
            BUTTONS.editPenaltyButton:SetHeight(20)
            BUTTONS.editPenaltyButton:SetChecked(true)
            BUTTONS.editPenaltyButton:Show()
      
            BUTTONS.editPenaltyButton.fs = BUTTONS.editPenaltyButton:CreateFontString(nil, "OVERLAY")
                  BUTTONS.editPenaltyButton.fs:SetFontObject("GameFontHighlight")
                  BUTTONS.editPenaltyButton.fs:SetPoint("LEFT", BUTTONS.editPenaltyButton, "RIGHT", 5, 0)
                  BUTTONS.editPenaltyButton.fs:SetJustifyH("LEFT")
                  BUTTONS.editPenaltyButton.fs:SetText("Add Penalty")

      FRAMES.deletePlayerItemEditBox = CreateFrame("EditBox", "deletePlayerItemEditBox", FRAMES.editPlayerPopupWindow, "InputBoxTemplate")
            FRAMES.deletePlayerItemEditBox:SetPoint("BOTTOM", FRAMES.editPlayerPopupWindow, "BOTTOM", 0, 40)
            FRAMES.deletePlayerItemEditBox:SetWidth(150)
            FRAMES.deletePlayerItemEditBox:SetHeight(20)
            FRAMES.deletePlayerItemEditBox:ClearFocus()
            FRAMES.deletePlayerItemEditBox:SetAutoFocus(false)
            FRAMES.deletePlayerItemEditBox:SetMaxLetters(6)
            FRAMES.deletePlayerItemEditBox:SetAltArrowKeyMode(false)
            FRAMES.deletePlayerItemEditBox:EnableMouse(true)
            FRAMES.deletePlayerItemEditBox:SetText("")
            FRAMES.deletePlayerItemEditBox:SetJustifyH("Center")

            FRAMES.deletePlayerItemEditBox.fs = FRAMES.deletePlayerItemEditBox:CreateFontString(nil, "OVERLAY")
                  FRAMES.deletePlayerItemEditBox.fs:SetFontObject("GameFontHighlight")
                  FRAMES.deletePlayerItemEditBox.fs:SetPoint("BOTTOM", FRAMES.deletePlayerItemEditBox, "TOP", 0, 5)
                  FRAMES.deletePlayerItemEditBox.fs:SetText("To delete the item from the player\nWrite 'delete' in the editbox then\npress 'Edit Item'.\nWarning! This action is irreversible.")
                  FRAMES.deletePlayerItemEditBox.fs:SetJustifyH("Center")

      BUTTONS.editPlayerPopUpDeleteButton = CreateFrame("Button", "editPlayerPopUpDeleteButton", FRAMES.editPlayerPopupWindow, "UIPanelButtonGrayTemplate")
            BUTTONS.editPlayerPopUpDeleteButton:SetPoint("BOTTOM", FRAMES.editPlayerPopupWindow, "BOTTOM", -55, 10)
            BUTTONS.editPlayerPopUpDeleteButton:SetWidth(102)
            BUTTONS.editPlayerPopUpDeleteButton:SetHeight(20)
            BUTTONS.editPlayerPopUpDeleteButton:SetText("Edit Item")
            BUTTONS.editPlayerPopUpDeleteButton:Hide()
      
      BUTTONS.editPlayerPopUpCancelButton = CreateFrame("Button", "editPlayerPopUpCancelButton", FRAMES.editPlayerPopupWindow, "UIPanelButtonGrayTemplate")
            BUTTONS.editPlayerPopUpCancelButton:SetPoint("BOTTOM", FRAMES.editPlayerPopupWindow, "BOTTOM", 55, 10)
            BUTTONS.editPlayerPopUpCancelButton:SetWidth(102)
            BUTTONS.editPlayerPopUpCancelButton:SetHeight(20)
            BUTTONS.editPlayerPopUpCancelButton:SetText("Cancel")

      -- Add player item.
      FRAMES.editPlayerAddItemPopupWindow = CreateFrame("Frame", "editPlayerAddItemPopupWindow", FRAMES.editPlayerEditItemPopupWindow)
            FRAMES.editPlayerAddItemPopupWindow:SetPoint("TOP", FRAMES.editPlayerEditItemPopupWindow, "TOP", 0, -25)
            FRAMES.editPlayerAddItemPopupWindow:SetSize(300, 275)
            FRAMES.editPlayerAddItemPopupWindow:Show()

      BUTTONS.editPlayerAddItemDropDown = CreateFrame("Button", "editPlayerAddItemDropDown", FRAMES.editPlayerAddItemPopupWindow, "UIDropDownMenuTemplate")
            BUTTONS.editPlayerAddItemDropDown:SetPoint("TOP", FRAMES.editPlayerPopupWindow, "TOP", 0, -50)
                  
            UIDropDownMenu_SetWidth(BUTTONS.editPlayerAddItemDropDown, 102)
            UIDropDownMenu_SetButtonWidth(BUTTONS.editPlayerAddItemDropDown, 102)
            UIDropDownMenu_JustifyText(BUTTONS.editPlayerAddItemDropDown, "LEFT")
      
      BUTTONS.editPlayerAddItemDropDown.fs = BUTTONS.editPlayerAddItemDropDown:CreateFontString(nil, "OVERLAY")
            BUTTONS.editPlayerAddItemDropDown.fs:SetFontObject("GameFontHighlight")
            BUTTONS.editPlayerAddItemDropDown.fs:SetPoint("BOTTOM", BUTTONS.editPlayerAddItemDropDown, "TOP", 0, 5)
            BUTTONS.editPlayerAddItemDropDown.fs:SetText("Choose a player.")
            BUTTONS.editPlayerAddItemDropDown.fs:SetJustifyH("Center")

      FRAMES.editPlayerAddItemEditBox = CreateFrame("EditBox", "editPlayerAddItemEditBox", FRAMES.editPlayerAddItemPopupWindow, "InputBoxTemplate")
            FRAMES.editPlayerAddItemEditBox:SetPoint("TOP", BUTTONS.editPlayerAddItemDropDown, "BOTTOM", 0, -30)
            FRAMES.editPlayerAddItemEditBox:SetWidth(200)
            FRAMES.editPlayerAddItemEditBox:SetHeight(20)
            FRAMES.editPlayerAddItemEditBox:ClearFocus()
            FRAMES.editPlayerAddItemEditBox:SetAutoFocus(false)
            FRAMES.editPlayerAddItemEditBox:SetMaxLetters(100)
            FRAMES.editPlayerAddItemEditBox:SetAltArrowKeyMode(false)
            FRAMES.editPlayerAddItemEditBox:EnableMouse(true)
            FRAMES.editPlayerAddItemEditBox:SetHyperlinksEnabled(true)
            FRAMES.editPlayerAddItemEditBox:SetText("")
            FRAMES.editPlayerAddItemEditBox:SetJustifyH("Center")
      
            FRAMES.editPlayerAddItemEditBox.fs = FRAMES.editPlayerAddItemEditBox:CreateFontString(nil, "OVERLAY")
                  FRAMES.editPlayerAddItemEditBox.fs:SetFontObject("GameFontHighlight")
                  FRAMES.editPlayerAddItemEditBox.fs:SetPoint("BOTTOM", FRAMES.editPlayerAddItemEditBox, "TOP", 0, 5)
                  FRAMES.editPlayerAddItemEditBox.fs:SetText("Hold SHIFT and click an itemLink to add it.")
                  FRAMES.editPlayerAddItemEditBox.fs:SetJustifyH("Center")

            BUTTONS.editPlayerAddItemClearButton = CreateFrame("Button", "editPlayerAddItemClearButton", FRAMES.editPlayerAddItemPopupWindow, "UIPanelButtonGrayTemplate")
                  BUTTONS.editPlayerAddItemClearButton:SetPoint("LEFT", FRAMES.editPlayerAddItemEditBox, "RIGHT", 5, 0)
                  BUTTONS.editPlayerAddItemClearButton:SetWidth(30)
                  BUTTONS.editPlayerAddItemClearButton:SetHeight(20)
                  BUTTONS.editPlayerAddItemClearButton:SetText("|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:14:14:0:0|t")

            BUTTONS.editPlayerAddItemRollTypeDropDown = CreateFrame("Button", "editPlayerAddItemRollTypeDropDown", FRAMES.editPlayerAddItemPopupWindow, "UIDropDownMenuTemplate")
                  BUTTONS.editPlayerAddItemRollTypeDropDown:SetPoint("TOP", FRAMES.editPlayerAddItemEditBox, "BOTTOM", 0, -25)
                        
                  UIDropDownMenu_SetWidth(BUTTONS.editPlayerAddItemRollTypeDropDown, 83)
                  UIDropDownMenu_SetButtonWidth(BUTTONS.editPlayerAddItemRollTypeDropDown, 102)
                  UIDropDownMenu_JustifyText(BUTTONS.editPlayerAddItemRollTypeDropDown, "LEFT")
      
            BUTTONS.editPlayerAddItemRollTypeDropDown.fs = BUTTONS.editPlayerAddItemRollTypeDropDown:CreateFontString(nil, "OVERLAY")
                  BUTTONS.editPlayerAddItemRollTypeDropDown.fs:SetFontObject("GameFontHighlight")
                  BUTTONS.editPlayerAddItemRollTypeDropDown.fs:SetPoint("BOTTOM", BUTTONS.editPlayerAddItemRollTypeDropDown, "TOP", 0, 5)
                  BUTTONS.editPlayerAddItemRollTypeDropDown.fs:SetText("Set the rollType")
                  BUTTONS.editPlayerAddItemRollTypeDropDown.fs:SetJustifyH("Center")

            BUTTONS.editPlayerAddItemPenaltyButton = CreateFrame("CheckButton", "editPlayerAddItemPenaltyButton", FRAMES.editPlayerAddItemPopupWindow, "UICheckButtonTemplate")
                  BUTTONS.editPlayerAddItemPenaltyButton:SetPoint("TOP", BUTTONS.editPlayerAddItemRollTypeDropDown, "BOTTOM", -30, -8)
                  BUTTONS.editPlayerAddItemPenaltyButton:SetWidth(20)
                  BUTTONS.editPlayerAddItemPenaltyButton:SetHeight(20)
                  BUTTONS.editPlayerAddItemPenaltyButton:SetChecked(true)
                  BUTTONS.editPlayerAddItemPenaltyButton:Hide()
            
                  BUTTONS.editPlayerAddItemPenaltyButton.fs = BUTTONS.editPlayerAddItemPenaltyButton:CreateFontString(nil, "OVERLAY")
                        BUTTONS.editPlayerAddItemPenaltyButton.fs:SetFontObject("GameFontHighlight")
                        BUTTONS.editPlayerAddItemPenaltyButton.fs:SetPoint("LEFT", BUTTONS.editPlayerAddItemPenaltyButton, "RIGHT", 5, 0)
                        BUTTONS.editPlayerAddItemPenaltyButton.fs:SetJustifyH("LEFT")
                        BUTTONS.editPlayerAddItemPenaltyButton.fs:SetText("Add Penalty")
            
            BUTTONS.editPlayerAddItemAddButton = CreateFrame("Button", "editPlayerAddItemAddButton", FRAMES.editPlayerAddItemPopupWindow, "UIPanelButtonGrayTemplate")
                  BUTTONS.editPlayerAddItemAddButton:SetPoint("BOTTOM", FRAMES.editPlayerAddItemPopupWindow, "BOTTOM", -55, 10)
                  BUTTONS.editPlayerAddItemAddButton:SetWidth(102)
                  BUTTONS.editPlayerAddItemAddButton:SetHeight(20)
                  BUTTONS.editPlayerAddItemAddButton:SetText("Add Item")
                  BUTTONS.editPlayerAddItemAddButton:Hide()
            
            BUTTONS.editPlayerAddItemCancelButton = CreateFrame("Button", "editPlayerAddItemCancelButton", FRAMES.editPlayerAddItemPopupWindow, "UIPanelButtonGrayTemplate")
                  BUTTONS.editPlayerAddItemCancelButton:SetPoint("BOTTOM", FRAMES.editPlayerAddItemPopupWindow, "BOTTOM", 55, 10)
                  BUTTONS.editPlayerAddItemCancelButton:SetWidth(102)
                  BUTTONS.editPlayerAddItemCancelButton:SetHeight(20)
                  BUTTONS.editPlayerAddItemCancelButton:SetText("Cancel")