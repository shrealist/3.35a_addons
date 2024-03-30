local core = InterfaceUsage;
local poll = core:CreatePollType("Event Calls");

local eventList = {};

poll.sortMethod = "countTotal";

-- Columns
poll[1] = { label = "name", align = "LEFT" };
poll[2] = { label = "count",			color = { 0.5, 0.75, 1 }, offset = 400, fmt = "%d" };
poll[3] = { label = "countTotal",		color = { 0.5, 0.75, 1 }, offset = 100, fmt = "%d" };

-- HOOK: OnEvent
local function OnEventHook(self,event,...)
	local eventData = eventList[event];
	if (not eventData) then
		eventData = { name = event, count = 0, countTotal = 0, countLast = 0 };
		eventList[event] = eventData;
		poll.data[#poll.data + 1] = eventData;
	end
	eventData.countTotal = (eventData.countTotal + 1);
end

-- OnInitialize
function poll:OnInitialize()
	self.data = {};
	local frame = EnumerateFrames();
	while (frame) do
		if (frame:GetScript("OnEvent")) then
			frame:HookScript("OnEvent",OnEventHook);
		end
		frame = EnumerateFrames(frame);
	end
end

-- OnReset
function poll:OnPoll()
	for event, data in next, eventList do
		data.count = (data.countTotal - data.countLast);
		data.countLast = data.countTotal;
	end
end

-- OnReset
function poll:OnReset()
	for event, data in next, eventList do
		data.countTotal = 0;
	end
end