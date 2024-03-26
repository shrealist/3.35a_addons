local E, L, V, P, G = unpack(select(2, ...))
local Sticky = E.Libs.SimpleSticky

local _G = _G
local type, unpack, pairs, error = type, unpack, pairs, error
local format, split, find = format, strsplit, strfind

local CreateFrame = CreateFrame
local IsShiftKeyDown = IsShiftKeyDown
local InCombatLockdown = InCombatLockdown
local IsControlKeyDown = IsControlKeyDown
local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT

E.CreatedMovers = {}
E.DisabledMovers = {}

local function SizeChanged(frame)
	if InCombatLockdown() then return end

	if frame.dirtyWidth and frame.dirtyHeight then
		frame.mover:Size(frame.dirtyWidth, frame.dirtyHeight)
	else
		frame.mover:Size(frame:GetSize())
	end
end

local function GetPoint(obj)
	local point, anchor, secondaryPoint, x, y = obj:GetPoint()
	if not anchor then anchor = E.UIParent end

	return format("%s,%s,%s,%d,%d", point, anchor:GetName(), secondaryPoint, E:Round(x), E:Round(y))
end

local function GetSettingPoints(name)
	local db = E.db.movers and E.db.movers[name]
	if db then
		local delim = (find(db, "\031") and "\031") or ","
		return split(delim, db)
	end
end

local function UpdateCoords(self)
	local mover = self.child
	local x, y, _, nudgePoint, nudgeInversePoint = E:CalculateMoverPoints(mover)

	local coordX, coordY = E:GetXYOffset(nudgeInversePoint, 1)
	local nudgeFrame = _G.ElvUIMoverNudgeWindow

	nudgeFrame:ClearAllPoints()
	nudgeFrame:Point(nudgePoint, mover, nudgeInversePoint, coordX, coordY)
	E:UpdateNudgeFrame(mover, x, y)
end

local isDragging = false
local coordFrame = CreateFrame("Frame")
coordFrame:SetScript("OnUpdate", UpdateCoords)
coordFrame:Hide()

local function UpdateMover(parent, name, text, overlay, snapOffset, postdrag, shouldDisable, configString)
	if not parent then return end --If for some reason the parent isnt loaded yet
	if E.CreatedMovers[name].Created then return end

	if overlay == nil then overlay = true end

	--Use dirtyWidth / dirtyHeight to set initial size if possible
	local width = parent.dirtyWidth or parent:GetWidth()
	local height = parent.dirtyHeight or parent:GetHeight()

	local f = CreateFrame("Button", name, E.UIParent)
	f:SetClampedToScreen(true)
	f:RegisterForDrag("LeftButton", "RightButton")
	f:SetFrameLevel(parent:GetFrameLevel() + 1)
	f:SetFrameStrata(overlay and "DIALOG" or "BACKGROUND")
	f:EnableMouseWheel(true)
	f:SetMovable(true)
	f:SetTemplate("Transparent", nil, nil, true)
	f:Size(width, height)
	f:Hide()

	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:FontTemplate()
	fs:SetJustifyH("CENTER")
	fs:Point("CENTER")
	fs:SetText(text or name)
	fs:SetTextColor(unpack(E.media.rgbvaluecolor))
	f:SetFontString(fs)

	f.text = fs
	f.name = name
	f.parent = parent
	f.overlay = overlay
	f.postdrag = postdrag
	f.textString = text or name
	f.snapOffset = snapOffset or -2
	f.shouldDisable = shouldDisable
	f.configString = configString

	E.CreatedMovers[name].mover = f
	E.snapBars[#E.snapBars + 1] = f

	local point1, relativeTo1, relativePoint1, xOffset1, yOffset1 = parent:GetPoint()
	local point2, relativeTo2, relativePoint2, xOffset2, yOffset2 = GetSettingPoints(name)
	if not point2 then -- fallback to the parents point if the setting doesn't exist
		point2, relativeTo2, relativePoint2, xOffset2, yOffset2 = point1, relativeTo1, relativePoint1, xOffset1, yOffset1
	end

	f:ClearAllPoints()
	f:Point(point2, relativeTo2, relativePoint2, xOffset2, yOffset2)

	parent:SetScript("OnSizeChanged", SizeChanged)
	parent:ClearAllPoints()
	parent:Point(point1, f, 0, 0)
	parent.mover = f

	local function OnDragStart(self)
		if InCombatLockdown() then E:Print(ERR_NOT_IN_COMBAT) return end

		if ElvUIGrid then
			E:UIFrameFadeIn(ElvUIGrid, 0.75, ElvUIGrid:GetAlpha(), 1)
		end

		if E.db.general.stickyFrames then
			Sticky:StartMoving(self, E.snapBars, f.snapOffset, f.snapOffset, f.snapOffset, f.snapOffset)
		else
			self:StartMoving()
		end

		coordFrame.child = self
		coordFrame:Show()
		isDragging = true
	end

	local function OnDragStop(self)
		if InCombatLockdown() then E:Print(ERR_NOT_IN_COMBAT) return end

		if ElvUIGrid and E.ConfigurationMode then
			E:UIFrameFadeOut(ElvUIGrid, 0.75, ElvUIGrid:GetAlpha(), 0.4)
		end

		isDragging = false
		if E.db.general.stickyFrames then
			Sticky:StopMoving(self)
		else
			self:StopMovingOrSizing()
		end

		local x2, y2, p2 = E:CalculateMoverPoints(self)
		self:ClearAllPoints()
		local overridePoint
		if self.positionOverride then
			if self.positionOverride == "BOTTOM" or self.positionOverride == "TOP" then
				overridePoint = "BOTTOM"
			else
				overridePoint = "BOTTOMLEFT"
			end
		end

		self:Point(self.positionOverride or p2, E.UIParent, overridePoint and overridePoint or p2, x2, y2)
		if self.positionOverride then
			self.parent:ClearAllPoints()
			self.parent:Point(self.positionOverride, self, self.positionOverride)
		end

		E:SaveMoverPosition(name)

		coordFrame.child = nil
		coordFrame:Hide()

		if postdrag ~= nil and (type(postdrag) == "function") then
			postdrag(self, E:GetScreenQuadrant(self))
		end

		self:SetUserPlaced(false)
	end

	local function OnEnter(self)
		if isDragging then return end
		for key in pairs(E.CreatedMovers) do
			local mover = _G[key]
			if mover:IsShown() and mover ~= self then
				E:UIFrameFadeOut(mover, 0.75, mover:GetAlpha(), 0.5)
			end
		end

		self.text:SetTextColor(1, 1, 1)
		E.AssignFrameToNudge(self)
		coordFrame.child = self
		coordFrame:GetScript("OnUpdate")(coordFrame)
	end

	local function OnLeave(self)
		if isDragging then return end
		for key in pairs(E.CreatedMovers) do
			local mover = _G[key]
			if mover:IsShown() and mover ~= self then
				E:UIFrameFadeIn(mover, 0.75, mover:GetAlpha(), 1)
			end
		end

		self.text:SetTextColor(unpack(E.media.rgbvaluecolor))
	end

	local function OnMouseUp(_, button)
		if button == "LeftButton" and not isDragging then
			if ElvUIMoverNudgeWindow:IsShown() then
				ElvUIMoverNudgeWindow:Hide()
			else
				ElvUIMoverNudgeWindow:Show()
			end
		end
	end

	local function OnMouseDown(self, button)
		if button == "RightButton" then
			--Allow resetting of anchor by Ctrl+RightClick
			if IsControlKeyDown() and self.textString then
				E:ResetMovers(self.textString)
			elseif IsShiftKeyDown() then --Allow hiding a mover temporarily
				self:Hide()
			elseif self.configString then --OpenConfig
				E:ToggleOptionsUI(self.configString)
			end
		end
	end

	local function OnShow(self)
		self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
		self.text:FontTemplate()
	end

	local function OnMouseWheel(_, delta)
		if IsShiftKeyDown() then
			E:NudgeMover(delta)
		else
			E:NudgeMover(nil, delta)
		end
	end

	f:SetScript("OnDragStart", OnDragStart)
	f:SetScript("OnMouseUp", E.AssignFrameToNudge)
	f:SetScript("OnDragStop", OnDragStop)
	f:SetScript("OnEnter", OnEnter)
	f:SetScript("OnMouseUp", OnMouseUp)
	f:SetScript("OnMouseDown", OnMouseDown)
	f:SetScript("OnLeave", OnLeave)
	f:SetScript("OnShow", OnShow)
	f:SetScript("OnMouseWheel", OnMouseWheel)

	if postdrag ~= nil and type(postdrag) == "function" then
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:SetScript("OnEvent", function(self)
			postdrag(f, E:GetScreenQuadrant(f))
			self:UnregisterAllEvents()
		end)
	end

	E.CreatedMovers[name].Created = true
end

function E:CalculateMoverPoints(mover, nudgeX, nudgeY)
	local screenWidth, screenHeight, screenCenter = E.UIParent:GetRight(), E.UIParent:GetTop(), E.UIParent:GetCenter()
	local x, y = mover:GetCenter()

	local LEFT = screenWidth / 3
	local RIGHT = screenWidth * 2 / 3
	local TOP = screenHeight / 2
	local point, nudgePoint, nudgeInversePoint

	if y >= TOP then
		point = "TOP"
		nudgePoint = "TOP"
		nudgeInversePoint = "BOTTOM"
		y = -(screenHeight - mover:GetTop())
	else
		point = "BOTTOM"
		nudgePoint = "BOTTOM"
		nudgeInversePoint = "TOP"
		y = mover:GetBottom()
	end

	if x >= RIGHT then
		point = point.."RIGHT"
		nudgePoint = "RIGHT"
		nudgeInversePoint = "LEFT"
		x = mover:GetRight() - screenWidth
	elseif x <= LEFT then
		point = point.."LEFT"
		nudgePoint = "LEFT"
		nudgeInversePoint = "RIGHT"
		x = mover:GetLeft()
	else
		x = x - screenCenter
	end

	if mover.positionOverride and (E.diffGetLeft and E.diffGetRight and E.diffGetTop and E.diffGetBottom) then
		if mover.positionOverride == "TOPLEFT" then
			x = mover:GetLeft() - E.diffGetLeft
			y = mover:GetTop() - E.diffGetTop
		elseif mover.positionOverride == "TOPRIGHT" then
			x = mover:GetRight() - E.diffGetRight
			y = mover:GetTop() - E.diffGetTop
		elseif mover.positionOverride == "BOTTOMLEFT" then
			x = mover:GetLeft() - E.diffGetLeft
			y = mover:GetBottom() - E.diffGetBottom
		elseif mover.positionOverride == "BOTTOMRIGHT" then
			x = mover:GetRight() - E.diffGetRight
			y = mover:GetBottom() - E.diffGetBottom
		elseif mover.positionOverride == "BOTTOM" then
			x = mover:GetCenter() - screenCenter
			y = mover:GetBottom() - E.diffGetBottom
		elseif mover.positionOverride == "TOP" then
			x = mover:GetCenter() - screenCenter
			y = mover:GetTop() - E.diffGetTop
		end
	end

	--Update coordinates if nudged
	x = x + (nudgeX or 0)
	y = y + (nudgeY or 0)

	return x, y, point, nudgePoint, nudgeInversePoint
end

function E:HasMoverBeenMoved(name)
	return E.db.movers and E.db.movers[name]
end

function E:SaveMoverPosition(name)
	if not _G[name] then return end
	if not E.db.movers then E.db.movers = {} end

	E.db.movers[name] = GetPoint(_G[name])
end

function E:SetMoverSnapOffset(name, offset)
	local mover = _G[name] and E.CreatedMovers[name]
	if not mover then return end
	mover.mover.snapOffset = offset or -2
	mover.snapoffset = offset or -2
end

function E:SetMoverLayoutPositionPoint(mover, name, frame)
	local layout = E.LayoutMoverPositions[E.db.layoutSetting]
	mover.point = (layout and layout[name]) or E.LayoutMoverPositions.ALL[name] or GetPoint(frame)
end

function E:SaveMoverDefaultPosition(name)
	local mover = _G[name] and E.CreatedMovers[name]
	if not mover then return end

	E:SetMoverLayoutPositionPoint(mover, name, _G[name])

	if mover.postdrag then
		mover.postdrag(_G[name], E:GetScreenQuadrant(_G[name]))
	end
end

function E:CreateMover(parent, name, text, overlay, snapoffset, postdrag, moverTypes, shouldDisable, configString)
	if not moverTypes then moverTypes = "ALL,GENERAL" end

	local mover = E.CreatedMovers[name]
	if mover == nil then
		mover = {}
		mover.type = {}

		E:SetMoverLayoutPositionPoint(mover, name, parent)

		local types = {split(",", moverTypes)}
		for i = 1, #types do
			local moverType = types[i]
			mover.type[moverType] = true
		end

		E.CreatedMovers[name] = mover
	end

	UpdateMover(parent, name, text, overlay, snapoffset, postdrag, shouldDisable, configString)
end

function E:ToggleMovers(show, moverType)
	self.configMode = show

	for name, holder in pairs(E.CreatedMovers) do
		if show and holder.type[moverType] then
			_G[name]:Show()
		else
			_G[name]:Hide()
		end
	end
end

function E:DisableMover(name)
	if self.DisabledMovers[name] then return end

	if not self.CreatedMovers[name] then
		error("mover doesn't exist")
	end

	self.DisabledMovers[name] = {}
	for x, y in pairs(self.CreatedMovers[name]) do
		self.DisabledMovers[name][x] = y
	end

	if self.configMode then
		_G[name]:Hide()
	end

	self.CreatedMovers[name] = nil
end

function E:EnableMover(name)
	if self.CreatedMovers[name] then return end

	if not self.DisabledMovers[name] then
		error("mover doesn't exist")
	end

	self.CreatedMovers[name] = {}
	for x, y in pairs(self.DisabledMovers[name]) do
		self.CreatedMovers[name][x] = y
	end

	if self.configMode then
		_G[name]:Show()
	end

	self.DisabledMovers[name] = nil
end

function E:ResetMovers(arg)
	local all = not arg or arg == ""
	if all then self.db.movers = nil end

	for name, holder in pairs(E.CreatedMovers) do
		if all or (holder.mover and holder.mover.textString == arg) then
			local point, anchor, secondaryPoint, x, y = split(",", holder.point)

			local frame = _G[name]
			if point then
				frame:ClearAllPoints()
				frame:Point(point, anchor, secondaryPoint, x, y)
			end

			if holder.postdrag ~= nil and type(holder.postdrag) == "function" then
				holder.postdrag(frame, E:GetScreenQuadrant(frame))
			end

			if not all then
				if self.db.movers then
					self.db.movers[name] = nil
				end
				break
			end
		end

		E:SaveMoverPosition(name)
	end
end

--Profile Change
function E:SetMoversPositions()
	--E:SetMoversPositions() is the first function called in E:UpdateAll().
	--Because of that, we can allow ourselves to re-enable all disabled movers here,
	--as the subsequent updates to these elements will disable them again if needed.
	for name in pairs(E.DisabledMovers) do
		local disable = E.DisabledMovers[name].shouldDisable
		local shouldDisable = (disable and disable()) or false
		if not shouldDisable then E:EnableMover(name) end
	end

	for name, holder in pairs(E.CreatedMovers) do
		local point, anchor, secondaryPoint, x, y = GetSettingPoints(name)
		if not point then point, anchor, secondaryPoint, x, y = split(",", holder.point) end

		if point then
			local frame = _G[name]
			frame:ClearAllPoints()
			frame:Point(point, anchor, secondaryPoint, x, y)
		end
	end
end

function E:SetMoversClampedToScreen(value)
	for name in pairs(E.CreatedMovers) do
		_G[name]:SetClampedToScreen(value)
	end
end

function E:LoadMovers()
	for name, t in pairs(E.CreatedMovers) do
		UpdateMover(t.parent, name, t.text, t.overlay, t.snapoffset, t.postdrag, t.shouldDisable, t.configString)
	end
end