local core = InterfaceUsage;
local onEvent = core:CreatePollType("Frame OnEvent Usage");
local onUpdate = core:CreatePollType("Frame OnUpdate Usage");

local debugprofilestart = debugprofilestart;
local debugprofilestop = debugprofilestop;

--------------------------------------------------------------------------------------------------------
--                                           Shared Function                                          --
--------------------------------------------------------------------------------------------------------

-- OnInitialize
local function OnInitialize(self)
	self.data = {};
	local frame = EnumerateFrames();
	while (frame) do
		local scriptFunc = frame:GetScript(self.scriptType);
		if (scriptFunc) then
			frame:SetScript(self.scriptType,self.hookFunc);
			self.hookedFrames[frame] = { frame = frame, name = frame:GetName() or "|cffa0a0a0"..tostring(frame), time = 0, totalTime = 0, calls = 0, scriptFunc = scriptFunc };
			self.data[#self.data + 1] = self.hookedFrames[frame];
		end
		frame = EnumerateFrames(frame);
	end
end

-- OnReset
function OnReset(self)
	for frame, data in next, self.hookedFrames do
		data.totalTime = 0;
		data.calls = 0;
	end
end

--------------------------------------------------------------------------------------------------------
--                                           OnEvent Polling                                          --
--------------------------------------------------------------------------------------------------------

onEvent.hookedFrames = {};
onEvent.scriptType = "OnEvent";
onEvent.sortMethod = "totalTime";
onEvent.OnInitialize = OnInitialize;
onEvent.OnReset = OnReset;

-- Columns
onEvent[1] = { label = "name", align = "LEFT" };
onEvent[2] = { label = "time",			color = { 0.5, 0.75, 1 }, offset = 330, fmt = "%.4f" };
onEvent[3] = { label = "totalTime",		color = { 0.5, 0.75, 1 }, offset = 100, fmt = "%.4f" };
onEvent[4] = { label = "calls",			color = { 0.5, 0.75, 1 }, offset = 70, fmt = "%d" };

-- HOOK: OnEvent
function onEvent.hookFunc(self,event,...)
	local data = onEvent.hookedFrames[self];
	debugprofilestart();
	data.scriptFunc(self,event,...);
	data.time = debugprofilestop();
	data.totalTime = (data.totalTime + data.time);
	data.calls = (data.calls + 1);
end

--------------------------------------------------------------------------------------------------------
--                                          OnUpdate Polling                                          --
--------------------------------------------------------------------------------------------------------

onUpdate.hookedFrames = {};
onUpdate.scriptType = "OnUpdate";
onUpdate.sortMethod = "totalTime";
onUpdate.OnInitialize = OnInitialize;
onUpdate.OnReset = OnReset;

-- Columns
onUpdate[1] = { label = "name", align = "LEFT" };
onUpdate[2] = { label = "time",			color = { 0.5, 0.75, 1 }, offset = 330, fmt = "%.4f" };
onUpdate[3] = { label = "totalTime",	color = { 0.5, 0.75, 1 }, offset = 100, fmt = "%.4f" };
onUpdate[4] = { label = "calls",		color = { 0.5, 0.75, 1 }, offset = 70, fmt = "%d" };

-- HOOK: OnUpdate
function onUpdate.hookFunc(self,event,...)
	local data = onUpdate.hookedFrames[self];
	debugprofilestart();
	data.scriptFunc(self,event,...);
	data.time = debugprofilestop();
	data.totalTime = (data.totalTime + data.time);
	data.calls = (data.calls + 1);
end