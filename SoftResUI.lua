-- UI-Handling.
---------------
-- Create a new config list, with default values.
function SoftRes.ui:createDefaultSoftResConfigList()
      SoftResConfig = {
            ui = {
                  mainFrame = {
                        size = {
                              full = {
                                    width = 555,
                                    height = 700,
                              }
                        }
                  }
            }
      }
end

-- Apply values from saved list, to the frames.
function SoftRes.ui:useSavedConfigValues()
      SoftRes.ui.mainFrame:SetSize(SoftResConfig.ui.mainFrame.size.full.height, SoftResConfig.ui.mainFrame.size.full.width)
end
--------------------------------------------------------------------



-- UI BEGINS HERE.
------------------

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


SoftRes.ui.buttons.testButton = CreateFrame("Button", "testButton", SoftRes.ui.mainFrame, "UIPanelButtonGrayTemplate")
      SoftRes.ui.buttons.testButton:SetPoint("TOP", SoftRes.ui.mainFrame, "TOP", 0, 0)
      SoftRes.ui.buttons.testButton:SetWidth(100)
      SoftRes.ui.buttons.testButton:SetHeight(20)
      SoftRes.ui.buttons.testButton:SetText("|TInterface\\FriendsFrame\\InformationIcon:10:10:0:0|t")





