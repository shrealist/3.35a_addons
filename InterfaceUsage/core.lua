local modName = "InterfaceUsage";
local core = CreateFrame("Frame",modName,UIParent);

-- Constants
local ITEM_HEIGHT;
local NUM_ITEMS = 20;
local DEFAULT_TEXT_COLOR = { 1, 1, 1 };

-- Variables
local updateInterval = 1;
local pollData;

-- Polling Type Data
local PollTypeData = {};
core.PollTypeData = PollTypeData;

--------------------------------------------------------------------------------------------------------
--                                                Code                                                --
--------------------------------------------------------------------------------------------------------

-- Update Scroll List
local function EntryList_Update()
	FauxScrollFrame_Update(core.scroll,#pollData.data,#core.entries,ITEM_HEIGHT);
	local index = core.scroll.offset;
	local columns = pollData;
	for i = 1, NUM_ITEMS do
		index = (index + 1);
		local btn = core.entries[i];
		local entry = pollData.data[index];
		if (entry) then
			for index, column in ipairs(columns) do
				local field = btn.fields[index];
				local value = entry[column.label];
				if (not value) or (value == 0) then
					field:SetText("");
				else
					field:SetFormattedText(column.fmt or "%s",value);
				end
			end
			btn:Show();
		else
			btn:Hide();
		end
	end
end

-- SortFunc
local function SortFunc(a,b)
	local sortMethod = pollData.sortMethod;
	if (a[sortMethod] == b[sortMethod]) then
		return a.name > b.name;
	elseif (type(a[sortMethod]) == "number") then
		return (a[sortMethod] or 0) > (b[sortMethod] or 0);
	else
		return (a[sortMethod] or "") < (b[sortMethod] or "");
	end
end

-- Set Polling Type
local function SetPollingIndex(index)
	pollData = PollTypeData[index];
	-- Initialize Poll
	if (pollData.OnInitialize) then
		pollData:OnInitialize();
		pollData.OnInitialize = nil;
		if (pollData.OnReset) then
			pollData:OnReset();
		end
	end
	-- Update Columns
	for i = 1, NUM_ITEMS do
		local btn = core.entries[i];
		local left = 0;
		for index, fs in ipairs(btn.fields) do
			local column = pollData[index];
			if (column) then
				left = (left + (column.offset or 0));
				fs:ClearAllPoints();
				fs:SetPoint(column.align or "RIGHT",btn,"LEFT",left,0);
				fs:SetTextColor(unpack(column.color or DEFAULT_TEXT_COLOR));
				fs:Show();
			else
				fs:Hide();
			end
		end
	end
	-- Misc
	core.dropDown2:InitSelectedItem(pollData.sortMethod);
	core.nextUpdate = 0;
end

-- Create Poll Type
function core:CreatePollType(title)
	local poll = { title = title };
	PollTypeData[#PollTypeData + 1] = poll;
	return poll;
end

--------------------------------------------------------------------------------------------------------
--                                       Frame Scripts & Events                                       --
--------------------------------------------------------------------------------------------------------

-- OnUpdate
local function OnUpdate(self,elapsed)
	self.nextUpdate = (self.nextUpdate - elapsed);
	if (self.nextUpdate <= 0) then
		if (pollData) then
			if (pollData.OnPoll) then
				pollData:OnPoll();
			end
			sort(pollData.data,SortFunc);
			self.header:SetText(pollData.title.." (|cffffff00"..#pollData.data.."|r)");
			EntryList_Update();
		end
		self.nextUpdate = updateInterval;
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Widget Creation                                          --
--------------------------------------------------------------------------------------------------------

core:SetWidth(560);
core:SetHeight(420);
core:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3 } });
core:SetBackdropColor(0.1,0.22,0.35,1);
core:SetBackdropBorderColor(0.1,0.1,0.1,1);
core:EnableMouse(1);
core:SetMovable(1);
core:SetFrameStrata("HIGH");
core:SetToplevel(1);
core:SetPoint("CENTER");
core:Hide();

core:SetScript("OnUpdate",OnUpdate);
core:SetScript("OnMouseDown",core.StartMoving);
core:SetScript("OnMouseUp",core.StopMovingOrSizing);

core.outline = CreateFrame("Frame",nil,core);
core.outline:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } });
core.outline:SetBackdropColor(0.1,0.1,0.2,1);
core.outline:SetBackdropBorderColor(0.8,0.8,0.9,0.4);
core.outline:SetPoint("TOPLEFT",12,-38);
core.outline:SetPoint("BOTTOMRIGHT",-12,42);

core.close = CreateFrame("Button",nil,core,"UIPanelCloseButton");
core.close:SetPoint("TOPRIGHT",-5,-5);
core.close:SetScript("OnClick",function() core:Hide(); end);

core.header = core:CreateFontString(nil,"ARTWORK","GameFontHighlight");
core.header:SetFont(core.header:GetFont(),24,"THICKOUTLINE");
core.header:SetPoint("TOPLEFT",12,-12);

-- Reset Button
core.btnReset = CreateFrame("Button",nil,core,"UIPanelButtonTemplate");
core.btnReset:SetWidth(75);
core.btnReset:SetHeight(24);
core.btnReset:SetPoint("BOTTOMRIGHT",-12,12);
core.btnReset:SetScript("OnClick",function(self) if (pollData.OnReset) then pollData:OnReset(); core.nextUpdate = 0; end end);
core.btnReset:SetText("Reset");

-- CheckButton: Script Profiling
local chk = CreateFrame("CheckButton",nil,core);
chk:SetWidth(24);
chk:SetHeight(24);
chk:SetPoint("BOTTOMRIGHT",-210,12);
chk:SetChecked(GetCVar("scriptProfile") == "1");
chk:SetScript("OnClick",function(self) SetCVar("scriptProfile",self:GetChecked() and 1 or 0); ReloadUI(); end);

chk:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up");
chk:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down");
chk:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight");
chk:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled");
chk:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check");

chk.text = chk:CreateFontString("ARTWORK",nil,"GameFontNormalSmall");
chk.text:SetPoint("LEFT",chk,"RIGHT",0,1);
chk.text:SetText("Enable Script Profiling");
chk:SetHitRectInsets(0,chk.text:GetWidth() * -1,0,0);

core.profiling = chk;

-- Entry OnEnter
local function Entry_OnEnter(self)
	local index = (core.scroll.offset + self.index);
	GameTooltip_SetDefaultAnchor(GameTooltip,self);
	GameTooltip:AddLine(pollData.data[index].name,1,1,1);
	for name, value in next, pollData.data[index] do
		if (name ~= "name") then
			GameTooltip:AddDoubleLine(name,tostring(value),nil,nil,nil,1,1,1);
		end
	end
	GameTooltip:Show();
end

-- Hide GTT
local function HideGTT()
	GameTooltip:Hide();
end

-- Create Entries
ITEM_HEIGHT = (core.outline:GetHeight() - 16) / NUM_ITEMS - 1;
core.entries = {};
for i = 1, NUM_ITEMS do
	local btn = CreateFrame("Button",nil,core.outline);
	btn:SetWidth(ITEM_HEIGHT);
	btn:SetHeight(ITEM_HEIGHT);
	btn:RegisterForClicks("AnyUp");
	btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
	btn:SetScript("OnEnter",Entry_OnEnter);
	btn:SetScript("OnLeave",HideGTT);
	btn:Hide();
	btn.index = i;

	if (i == 1) then
		btn:SetPoint("TOPLEFT",8,-8);
		btn:SetPoint("TOPRIGHT",-23,-8);
	else
		btn:SetPoint("TOPLEFT",core.entries[i - 1],"BOTTOMLEFT",0,-1);
		btn:SetPoint("TOPRIGHT",core.entries[i - 1],"BOTTOMRIGHT",0,-1);
	end

	btn.fields = {};
	for n = 1, 6 do
		btn.fields[n] = btn:CreateFontString(nil,"ARTWORK","GameFontNormal");
	end

	core.entries[i] = btn;
end

core.scroll = CreateFrame("ScrollFrame",modName.."Scroll",core,"FauxScrollFrameTemplate");
core.scroll:SetPoint("TOPLEFT",core.entries[1]);
core.scroll:SetPoint("BOTTOMRIGHT",core.entries[#core.entries],-6,-1);
core.scroll:SetScript("OnVerticalScroll",function(self,offset) FauxScrollFrame_OnVerticalScroll(self,offset,ITEM_HEIGHT,EntryList_Update) end);

--------------------------------------------------------------------------------------------------------
--                                      DropDown - Polling Type                                       --
--------------------------------------------------------------------------------------------------------

local function DropDown_Init(dropDown,list)
	for index, poll in ipairs(PollTypeData) do
		local tbl = list[#list + 1];
		tbl.text = (poll.OnInitialize and "" or "|cff80ff80")..poll.title; tbl.value = index; tbl.checked = (poll == pollData);
	end
end

local function DropDown_SelectValue(dropDown,entry,index)
	SetPollingIndex(index);
	dropDown.label:SetText("|cff80ff80"..pollData.title);
end

core.dropDown = AzDropDown.CreateDropDown(core,150,true,DropDown_Init,DropDown_SelectValue);
core.dropDown:SetPoint("BOTTOMLEFT",12,12);

--------------------------------------------------------------------------------------------------------
--                                           DropDown - Sort                                          --
--------------------------------------------------------------------------------------------------------

local function DropDown2_Init(dropDown,list)
	if (pollData) then
		for index, column in ipairs(pollData) do
			list[index].text = column.label; list[index].value = column.label; list[index].checked = (pollData.sortMethod == column.label);
		end
	end
end

local function DropDown2_SelectValue(dropDown,entry,index)
	pollData.sortMethod = entry.value;
	core.nextUpdate = 0;
end

core.dropDown2 = AzDropDown.CreateDropDown(core,140,true,DropDown2_Init,DropDown2_SelectValue);
core.dropDown2:SetPoint("LEFT",core.dropDown,"RIGHT",8,0);

--------------------------------------------------------------------------------------------------------
--                                           Slash Handling                                           --
--------------------------------------------------------------------------------------------------------
_G["SLASH_"..modName.."1"] = "/iu";
SlashCmdList[modName] = function(cmd)
	-- Extract Parameters
	local param1, param2 = cmd:match("^([^%s]+)%s*(.*)$");
	param1 = (param1 and param1:lower() or cmd:lower());
	-- Options
	if (param1 == "") then
		core.nextUpdate = 0;
		core:Show();
	-- Invalid or No Command
	else
		UpdateAddOnMemoryUsage();
		AzMsg(format("----- |2%s|r |1%s|r ----- |1%.2f |2kb|r -----",modName,GetAddOnMetadata(modName,"Version"),GetAddOnMemoryUsage(modName)));
		AzMsg("The following |2parameters|r are valid for this addon:");
		AzMsg("- none");
	end
end