-- UI-Handling.
---------------
-- Create a new config list, with default values.
function SoftRes.ui:createDefaultSoftResConfigList()
      SoftResConfig = {
            ui = {
                  mainFrame = {
                        size = {
                              full = {
                                    width = 700,
                                    height = 550,
                              }
                        }
                  },
                  listFrame = {
                        size = {
                              full = {
                                    width = 250,
                                    height = 400,
                              }
                        }
                  }

            }
      }
end

-- Apply values from saved list, to the frames.
function SoftRes.ui:useSavedConfigValues()
      SoftRes.ui.mainFrame:SetSize(SoftResConfig.ui.mainFrame.size.full.width, SoftResConfig.ui.mainFrame.size.full.height)
      SoftRes.ui.listFrame:SetSize(SoftResConfig.ui.listFrame.size.full.width, SoftResConfig.ui.listFrame.size.full.height)
end
--------------------------------------------------------------------



-- UI BEGINS HERE.
------------------

local ui = SoftRes.ui

--Frames


SoftRes.ui.mainFrame = CreateFrame("Frame", "SoftResMainFrame", UIParent, "BasicFrameTemplateWithInset")
      SoftRes.ui.mainFrame:SetFrameStrata("HIGH")
      SoftRes.ui.mainFrame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -10)
      SoftRes.ui.mainFrame:SetMovable(true)
      SoftRes.ui.mainFrame:EnableMouse(true)
      SoftRes.ui.mainFrame:RegisterForDrag("LeftButton")
      SoftRes.ui.mainFrame:SetScript("OnDragStart", SoftRes.ui.mainFrame.StartMoving)
      SoftRes.ui.mainFrame:SetScript("OnDragStop", SoftRes.ui.mainFrame.StopMovingOrSizing)

      SoftRes.ui.mainFrame.title = SoftRes.ui.mainFrame:CreateFontString(nil, "Overlay")
            SoftRes.ui.mainFrame.title:SetFontObject("GameFontHighlight")
            SoftRes.ui.mainFrame.title:SetPoint("TOP", SoftRes.ui.mainFrame.TitleBg, "TOP", 0, -3)
            SoftRes.ui.mainFrame.title:SetText("SoftRes - A Soft-Reservation- and Loot distribution helper.")

      SoftRes.ui.mainFrame.fs = SoftRes.ui.mainFrame:CreateFontString(nil, "Overlay")
      SoftRes.ui.mainFrame.fs:SetFontObject("GameFontHighlight")
      SoftRes.ui.mainFrame.fs:SetPoint("TOPLEFT", SoftRes.ui.mainFrame, "TOPLEFT", 15, -32)
      SoftRes.ui.mainFrame.fs:SetJustifyH("LEFT")
      SoftRes.ui.mainFrame.fs:SetText("Soft reserve - List")

      ui.listFrame = CreateFrame("ScrollFrame", "ListFrame", SoftRes.ui.mainFrame, "UIPanelScrollFrameTemplate")
            ui.listFrame:SetPoint("TOPLEFT", ui.mainFrame, "TOPLEFT", -12,-30)
            ui.listFrame:SetSize(250,400)

            ui.listFrameChild = CreateFrame("Frame")
            ui.listFrame.scrollBar = _G["ListFrameScrollBar"]
            ui.listFrame.scrollUpButton = _G["ListFrameScrollBarScrollUpButton"]
            ui.listFrame.scrollDownButton = _G["ListFrameScrollBarScrollDownButton"]
            ui.listFrame.scrollUpButton:ClearAllPoints()
            ui.listFrame.scrollUpButton:SetPoint("TOPRIGHT", ui.listFrame, "TOPRIGHT", 0, 0)

            ui.listFrame.scrollDownButton:ClearAllPoints()
            ui.listFrame.scrollDownButton:SetPoint("BOTTOMRIGHT", ui.ListFrame, "BOTTOMRIGHT", 0, 0)

            ui.listFrame.scrollBar:ClearAllPoints()
            ui.listFrame.scrollBar:SetPoint("TOP", ui.listFrame.scrollUpButton, "BOTTOM", 0, -2)
            ui.listFrame.scrollBar:SetPoint("BOTTOM", ui.listFrame.scrollDownButton, "TOP", 0, 2)

            ui.listFrame:SetScrollChild(ui.listFrameChild)
            ui.listFrameChild:SetSize(ui.listFrame:GetWidth(), ui.listFrame:GetHeight()) -- denna ändras i förhållande till hur många items man har

            ui.moduleOptions = CreateFrame("Frame", nil, ui.listFrameChild)
            ui.moduleOptions:SetAllPoints(ui.listFrameChild)
            ui.moduleOptions:EnableMouse()

            ui.moduleOptions.fs = ui.moduleOptions:CreateFontString(nil, "OVERLAY")
            ui.moduleOptions.fs:SetFontObject("GameFontHighlight")
            ui.moduleOptions.fs:SetPoint("TOPLEFT", ui.moduleOptions, "TOPLEFT", 25, 0)
            ui.moduleOptions.fs:SetText("SoftRes -> By Snits")
            ui.moduleOptions.fs:SetJustifyH("Left")
            
            
--Buttons

SoftRes.ui.buttons.testButton = CreateFrame("Button", "testButton", SoftRes.ui.mainFrame, "UIPanelButtonGrayTemplate")
      SoftRes.ui.buttons.testButton:SetPoint("TOP", SoftRes.ui.mainFrame, "TOP", 0, 0)
      SoftRes.ui.buttons.testButton:SetWidth(100)
      SoftRes.ui.buttons.testButton:SetHeight(20)
      SoftRes.ui.buttons.testButton:SetText("|TInterface\\FriendsFrame\\InformationIcon:10:10:0:0|t")





