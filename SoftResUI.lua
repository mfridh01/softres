-- UI-Handling.
---------------

-- globals
FRAMES = SoftRes.ui.frames
BUTTONS = SoftRes.ui.buttons

-- Create a new config list, with default values.
function SoftRes.ui:createDefaultSoftResConfigList()
      SoftResConfig = {
            ui = {
                  frames = {
                        mainFrame = {
                              size = {
                                    full = {
                                          width = 338,
                                          height = 550,
                                    }
                              },
                              hidden = false,
                        },
                        listFrame = {
                              size = {
                                    full = {
                                          width = 250,
                                          height = 400,
                                    },
                              hidden = false,
                              }
                        }
                  }
            }
      }
end

-- Apply values from saved list, to the frames.
function SoftRes.ui:useSavedConfigValues()
      FRAMES.mainFrame:SetSize(SoftResConfig.ui.mainFrame.size.full.width, SoftResConfig.ui.mainFrame.size.full.height)
      FRAMES.listFrame:SetSize(SoftResConfig.ui.listFrame.size.full.width, SoftResConfig.ui.listFrame.size.full.height)
end
--------------------------------------------------------------------

-- UI BEGINS HERE.
------------------

--Frames
FRAMES.mainFrame = CreateFrame("Frame", "SoftResMainFrame", UIParent, "BasicFrameTemplateWithInset")
      FRAMES.mainFrame:SetFrameStrata("HIGH")
      FRAMES.mainFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -10)
      FRAMES.mainFrame:SetMovable(true)
      FRAMES.mainFrame:EnableMouse(true)
      FRAMES.mainFrame:RegisterForDrag("LeftButton")
      FRAMES.mainFrame:SetScript("OnDragStart", FRAMES.mainFrame.StartMoving)
      FRAMES.mainFrame:SetScript("OnDragStop", FRAMES.mainFrame.StopMovingOrSizing)

      FRAMES.mainFrame.title = FRAMES.mainFrame:CreateFontString(nil, "Overlay")
            FRAMES.mainFrame.title:SetFontObject("GameFontHighlight")
            FRAMES.mainFrame.title:SetPoint("TOP", FRAMES.mainFrame.TitleBg, "TOP", 0, -3)
            FRAMES.mainFrame.title:SetText("SoftRes - A Soft-Reservation- and Loot distribution helper.")

      FRAMES.mainFrame.fs = FRAMES.mainFrame:CreateFontString(nil, "Overlay")
            FRAMES.mainFrame.fs:SetFontObject("GameFontHighlight")
            FRAMES.mainFrame.fs:SetPoint("TOPLEFT", FRAMES.mainFrame, "TOPLEFT", 15, -32)
            FRAMES.mainFrame.fs:SetJustifyH("LEFT")
            FRAMES.mainFrame.fs:SetText("Soft reserve - List")

      FRAMES.listFrame = CreateFrame("ScrollFrame", "ListFrame", FRAMES.mainFrame, "UIPanelScrollFrameTemplate")
            FRAMES.listFrame:SetPoint("TOPLEFT", FRAMES.mainFrame, "TOPLEFT", -12,-30)
            FRAMES.listFrame:SetSize(250,400)
                        
            FRAMES.listFrame.scrollBar = _G["ListFrameScrollBar"]
                  FRAMES.listFrame.scrollBar:ClearAllPoints()
                  FRAMES.listFrame.scrollBar:SetPoint("TOP", FRAMES.listFrame.scrollUpButton, "BOTTOM", 0, -2)
                  FRAMES.listFrame.scrollBar:SetPoint("BOTTOM", FRAMES.listFrame.scrollDownButton, "TOP", 0, 2)

            FRAMES.listFrame.scrollUpButton = _G["ListFrameScrollBarScrollUpButton"]
                  FRAMES.listFrame.scrollUpButton:ClearAllPoints()
                  FRAMES.listFrame.scrollUpButton:SetPoint("TOPRIGHT", FRAMES.listFrame, "TOPRIGHT", 0, 0)
            
            FRAMES.listFrame.scrollDownButton = _G["ListFrameScrollBarScrollDownButton"]
                  FRAMES.listFrame.scrollDownButton:ClearAllPoints()
                  FRAMES.listFrame.scrollDownButton:SetPoint("BOTTOMRIGHT", FRAMES.listFrame, "BOTTOMRIGHT", 0, 0)      


            FRAMES.listFrame.child = CreateFrame("Frame")
            FRAMES.listFrame.child:SetSize(FRAMES.listFrame:GetWidth(), FRAMES.listFrame:GetHeight()) -- This is the size of the scrollable list, Change the height accordingly.

            FRAMES.listFrame:SetScrollChild(FRAMES.listFrameChild)       

      FRAMES.moduleOptions = CreateFrame("Frame", nil, FRAMES.listFrame.child)
            FRAMES.moduleOptions:SetAllPoints(FRAMES.listFrame.child)
            FRAMES.moduleOptions:EnableMouse()

            FRAMES.moduleOptions.fs = FRAMES.moduleOptions:CreateFontString(nil, "OVERLAY") -- This is the main list FontString. Populate this one.
                  FRAMES.moduleOptions.fs:SetFontObject("GameFontHighlight")
                  FRAMES.moduleOptions.fs:SetPoint("TOPLEFT", FRAMES.moduleOptions, "TOPLEFT", 25, 0)
                  FRAMES.moduleOptions.fs:SetText("SoftRes -> By Snits")
                  FRAMES.moduleOptions.fs:SetJustifyH("Left")
            
-- Buttons
BUTTONS.testButton = CreateFrame("Button", "testButton", FRAMES.mainFrame, "UIPanelButtonGrayTemplate")
      BUTTONS.testButton:SetPoint("TOP", FRAMES.mainFrame, "TOP", 0, 0)
      BUTTONS.testButton:SetWidth(100)
      BUTTONS.testButton:SetHeight(20)
      BUTTONS.testButton:SetText("|TInterface\\FriendsFrame\\InformationIcon:10:10:0:0|t")





