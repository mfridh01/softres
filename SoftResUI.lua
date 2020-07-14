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
                                          height = 387,
                                    }
                              },
                              hidden = false,
                        },
                        tabContainer = {
                              pages = {
                              },
                              size = {
                                    full = {
                                          width = 327,
                                          height = 330,
                                    },
                              },
                              hidden = false,
                        },
                        rollFrameContainer = {
                              size = {
                                    full = {
                                          width = 296,
                                          height = 210,
                                    },
                              },
                              hidden = false,
                              child = {
                                    size = {
                                          width = 300,
                                          height = 330,
                                    },
                              },
                        }
                  }
            }
      }
end

-- Apply values from saved list, to the frames.
function SoftRes.ui:useSavedConfigValues()
      local CONFIG_UI_FRAMES = SoftResConfig.ui.frames
      FRAMES.mainFrame:SetSize(CONFIG_UI_FRAMES.mainFrame.size.full.width / UIParent:GetScale(), CONFIG_UI_FRAMES.mainFrame.size.full.height / UIParent:GetScale())
      FRAMES.tabContainer:SetSize(CONFIG_UI_FRAMES.tabContainer.size.full.width, CONFIG_UI_FRAMES.tabContainer.size.full.height)
      FRAMES.rollFrameContainer:SetSize(CONFIG_UI_FRAMES.rollFrameContainer.size.full.width, CONFIG_UI_FRAMES.rollFrameContainer.size.full.height)
      FRAMES.rollFrameContainer.child:SetSize(CONFIG_UI_FRAMES.rollFrameContainer.child.size.width, CONFIG_UI_FRAMES.rollFrameContainer.child.size.height)
end
--------------------------------------------------------------------

-- UI BEGINS HERE.
------------------

--Frames
FRAMES.mainFrame = CreateFrame("Frame", "SoftResMainFrame", UIParent, "BasicFrameTemplate")
      FRAMES.mainFrame:SetFrameStrata("HIGH")
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

FRAMES.tabContainer = CreateFrame("Frame", "TabContainer", FRAMES.mainframe, "InsetFrameTemplate2")
      FRAMES.tabContainer:SetFrameStrata("DIALOG")
      FRAMES.tabContainer:SetPoint("TOPLEFT", FRAMES.mainFrame, "TOPLEFT", 4, -51)

      FRAMES.tabContainer.page1 = CreateFrame("Frame", "TabPagesPage1", FRAMES.tabContainer)
            FRAMES.tabContainer.page1:SetPoint("TOPLEFT", FRAMES.tabContainer, "TOPLEFT", 6, -6)
            FRAMES.tabContainer.page1:SetSize(314,240)
            FRAMES.tabContainer.page1:SetBackdrop({
                  bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
                  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
                  tile     = true,
                  tileSize = 32,
                  edgeSize = 32,
                  insets   = { left = 8, right = 8, top = 8, bottom = 8 }
            })

FRAMES.rollFrameContainer = CreateFrame("ScrollFrame", "RollFrameContainer", FRAMES.tabContainer.page1, "UIPanelScrollFrameTemplate")
      FRAMES.rollFrameContainer:SetPoint("TOPLEFT", FRAMES.tabContainer.page1, "TOPLEFT", 15, -15)

      
      local  scrollbarName = FRAMES.rollFrameContainer:GetName()
      FRAMES.rollFrameContainer.scrollBar = _G[scrollbarName .. "ScrollBar"]
      FRAMES.rollFrameContainer.scrollUpButton = _G[scrollbarName .. "ScrollBarScrollUpButton"]
      FRAMES.rollFrameContainer.scrollDownButton = _G[scrollbarName .. "ScrollBarScrollDownButton"]

            FRAMES.rollFrameContainer.scrollUpButton:ClearAllPoints()
            FRAMES.rollFrameContainer.scrollUpButton:SetPoint("TOPRIGHT", FRAMES.rollFrameContainer, "TOPRIGHT", -10, 0)
      
            FRAMES.rollFrameContainer.scrollDownButton:ClearAllPoints()
            FRAMES.rollFrameContainer.scrollDownButton:SetPoint("BOTTOMRIGHT", FRAMES.rollFrameContainer, "BOTTOMRIGHT", -10, 0)      

            FRAMES.rollFrameContainer.scrollBar:ClearAllPoints()
            FRAMES.rollFrameContainer.scrollBar:SetPoint("TOP", FRAMES.rollFrameContainer.scrollUpButton, "BOTTOM", 0, 0)
            FRAMES.rollFrameContainer.scrollBar:SetPoint("BOTTOM", FRAMES.rollFrameContainer.scrollDownButton, "TOP", 0, 0)

      FRAMES.rollFrameContainer.child = CreateFrame("Frame")
      FRAMES.rollFrameContainer:SetScrollChild(FRAMES.rollFrameContainer.child)

FRAMES.rollFrame = CreateFrame("Frame", nil, FRAMES.rollFrameContainer.child)
      FRAMES.rollFrame:SetAllPoints(FRAMES.rollFrameContainer.child)
      FRAMES.rollFrame:EnableMouse()

      FRAMES.rollFrame.fs = FRAMES.rollFrame:CreateFontString(nil, "OVERLAY") -- This is the main list FontString. Populate this one.
            FRAMES.rollFrame.fs:SetFontObject("GameFontHighlight")
            FRAMES.rollFrame.fs:SetPoint("TOPLEFT", FRAMES.rollFrame, "TOPLEFT", 0, 0)
            FRAMES.rollFrame.fs:SetText("SoftRes -> By Snits")
            FRAMES.rollFrame.fs:SetJustifyH("Left")
            
-- Buttons
BUTTONS.tabButtonPage = {}

BUTTONS.testButton = CreateFrame("Button", "testButton", FRAMES.mainFrame, "UIPanelButtonGrayTemplate")
      BUTTONS.testButton:SetPoint("TOP", FRAMES.mainFrame, "TOP", 0, 0)
      BUTTONS.testButton:SetWidth(100)
      BUTTONS.testButton:SetHeight(20)
      BUTTONS.testButton:SetText("|TInterface\\FriendsFrame\\InformationIcon:10:10:0:0|t")

BUTTONS.tabButtonPage[1] = CreateFrame("Button", "TabButtonPage1", FRAMES.mainFrame, "TabButtonTemplate")
      BUTTONS.tabButtonPage[1]:SetFrameStrata("DIALOG")
      BUTTONS.tabButtonPage[1]:SetPoint("TOPLEFT", FRAMES.mainFrame, "TOPLEFT", 15, -40)
      BUTTONS.tabButtonPage[1]:SetSize(100, 20)
      BUTTONS.tabButtonPage[1]:SetText("Items / rolls")

BUTTONS.tabButtonPage[2] = CreateFrame("Button", "TabButtonPage2", FRAMES.mainFrame, "TabButtonTemplate")
      BUTTONS.tabButtonPage[2]:SetPoint("LEFT", BUTTONS.tabButtonPage[1], "RIGHT", 2, 0)
      BUTTONS.tabButtonPage[2]:SetSize(100, 20)
      BUTTONS.tabButtonPage[2]:SetText("SoftRes List")

BUTTONS.tabButtonPage[3] = CreateFrame("Button", "TabButtonPage3", FRAMES.mainFrame, "TabButtonTemplate")
      BUTTONS.tabButtonPage[3]:SetPoint("LEFT", BUTTONS.tabButtonPage[2], "RIGHT", 2, 0)
      BUTTONS.tabButtonPage[3]:SetSize(100, 20)
      BUTTONS.tabButtonPage[3]:SetText("Config")


      -- Resizing tabs.
      for i = 1, #BUTTONS.tabButtonPage do
            PanelTemplates_TabResize(BUTTONS.tabButtonPage[i], 0)
      end


      







