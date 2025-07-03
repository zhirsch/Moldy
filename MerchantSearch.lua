local memory = {}

local function MoldyMerchantSearch_UpdateResults(query)
    for i = 1, MERCHANT_ITEMS_PER_PAGE do
        local item = _G["MerchantItem"..i]
        local name = item.Name:GetText()
        if name and name:lower():find(query) then
            item:SetAlpha(1.0)
        else
            item:SetAlpha(0.3)
        end
    end
end

local searchBox = CreateFrame("EditBox", "MoldyMerchantSearchBox", MerchantFrame, "InputBoxTemplate")
searchBox:SetSize(120, 20)
searchBox:SetPoint("TOPRIGHT", MerchantFrame, "TOPRIGHT", -8, -32)
searchBox:SetAutoFocus(false)
searchBox:SetScript("OnEscapePressed", searchBox.ClearFocus)
searchBox:SetScript("OnEnterPressed", searchBox.ClearFocus)
searchBox:SetScript("OnTextChanged", function(self)
    MoldyMerchantSearch_UpdateResults(self:GetText():lower())
end)

local clearButton = CreateFrame("Button", "MoldyMerchantSearchClearButton", searchBox)
clearButton:SetSize(14, 14)
clearButton:SetPoint("RIGHT", -4, 0)
clearButton:SetNormalFontObject("GameFontHighlightSmall")
clearButton:SetText("×")
clearButton:SetShown(false)
clearButton:SetScript("OnClick", function()
    searchBox:SetText("")
    searchBox:ClearFocus()
end)

local placeholder = searchBox:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
placeholder:SetPoint("LEFT", 6, 0)
placeholder:SetText("Search")
placeholder:SetJustifyH("LEFT")
placeholder:SetShown(true)

local function UpdateSearchUI()
    local text = searchBox:GetText()
    placeholder:SetShown(text == "" and not searchBox:HasFocus())
    clearButton:SetShown(text ~= "")

    local guid = UnitGUID("npc")
    if guid then memory[guid] = text end

    MoldyMerchantSearch_UpdateResults(text:lower())
end

searchBox:SetScript("OnTextChanged", UpdateSearchUI)
searchBox:SetScript("OnEditFocusGained", UpdateSearchUI)
searchBox:SetScript("OnEditFocusLost", UpdateSearchUI)

MerchantFrame:HookScript("OnShow", function()
    local guid = UnitGUID("npc")
    local remembered = (guid and memory[guid]) or ""
    searchBox:SetText(remembered)
end)

hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
    local guid = UnitGUID("npc")
    local remembered = (guid and memory[guid]) or ""
    MoldyMerchantSearch_UpdateResults(remembered:lower())
end)
