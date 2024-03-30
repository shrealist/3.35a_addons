local core = InterfaceUsage;
local mem = core:CreatePollType("Addon Memory Usage");
local cpu = core:CreatePollType("Addon CPU Usage");

local GetAddOnCPUUsage = GetAddOnCPUUsage;
local GetAddOnMemoryUsage = GetAddOnMemoryUsage;

-- Addons OnInitialize
local function OnInitialize(self)
	self.data = {};
	for i = 1, GetNumAddOns() do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i);
		self.data[i] = { name = name, title = title, enabled = enabled, loadable = loadable, reason = reason, security = security };
	end
end

--------------------------------------------------------------------------------------------------------
--                                            Memory Module                                           --
--------------------------------------------------------------------------------------------------------

mem.sortMethod = "memUsageGrowth";
mem.OnInitialize = OnInitialize;

-- Columns
mem[1] = { label = "name", align = "LEFT" };
mem[2] = { label = "memUsage",			color = { 0.5, 0.75, 1 }, offset = 360, fmt = "%.2f" };
mem[3] = { label = "memUsageTotal",		color = { 0.5, 0.75, 1 }, offset = 70, fmt = "%.2f" };
mem[4] = { label = "memUsageGrowth",	color = { 0.5, 0.75, 1 }, offset = 70, fmt = "%.2f" };

-- OnPoll
function mem:OnPoll()
	UpdateAddOnMemoryUsage();
	for index, addon in ipairs(self.data) do
		addon.memUsagePrev = (addon.memUsageTotal or 0);
		addon.memUsageTotal = GetAddOnMemoryUsage(addon.name);
		addon.memUsage = (addon.memUsageTotal - addon.memUsagePrev);
		addon.memUsageGrowth = (addon.memUsageTotal - addon.memUsageStart);
	end
end

-- OnReset
function mem:OnReset()
	UpdateAddOnMemoryUsage();
	for index, addon in ipairs(self.data) do
		addon.memUsageStart = GetAddOnMemoryUsage(addon.name);
	end
end

--------------------------------------------------------------------------------------------------------
--                                             CPU Module                                             --
--------------------------------------------------------------------------------------------------------

cpu.sortMethod = "cpuTimeGrowth";
cpu.OnInitialize = OnInitialize;

-- Columns
cpu[1] = { label = "name", align = "LEFT" };
cpu[2] = { label = "cpuTime",			color = { 0.5, 0.75, 1 }, offset = 360, fmt = "%.3f" };
cpu[3] = { label = "cpuTimeTotal",		color = { 0.5, 0.75, 1 }, offset = 70, fmt = "%.2f" };
cpu[4] = { label = "cpuTimeGrowth",		color = { 0.5, 0.75, 1 }, offset = 70, fmt = "%.2f" };

-- OnPoll
function cpu:OnPoll()
	UpdateAddOnCPUUsage();
	for index, addon in ipairs(self.data) do
		addon.cpuTimePrev = (addon.cpuTimeTotal or 0);
		addon.cpuTimeTotal = GetAddOnCPUUsage(addon.name);
		addon.cpuTime = (addon.cpuTimeTotal - addon.cpuTimePrev);
		addon.cpuTimeGrowth = (addon.cpuTimeTotal - addon.cpuTimeStart);
	end
end

-- OnReset
function cpu:OnReset()
	UpdateAddOnCPUUsage();
	for index, addon in ipairs(self.data) do
		addon.cpuTimeStart = GetAddOnCPUUsage(addon.name);
	end
end