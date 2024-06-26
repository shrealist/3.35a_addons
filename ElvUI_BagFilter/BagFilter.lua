if not IsAddOnLoaded('ElvUI') then return; end

local E, L, V, P, G = unpack(ElvUI); -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local B = E:GetModule('Bags');

local U = select(2, ...);
local L = {};

local function SetSlotFilter(self, bagID, slotID)
    local f = B:GetContainerFrame(bagID > NUM_BAG_SLOTS or bagID == BANK_CONTAINER);
    if not (f and f.FilterHolder) then return; end

    if f.FilterHolder.active and self.Bags[bagID] and self.Bags[bagID][slotID] then
        local link = GetContainerItemLink(bagID, slotID);
        local location = { bagID = bagID, slotIndex = slotID };
        if not link or f.FilterHolder[f.FilterHolder.active].filter(location, link, select(6, GetItemInfo(link))) then
            self.Bags[bagID][slotID].searchOverlay:Hide();
        else
            self.Bags[bagID][slotID].searchOverlay:Show();
        end
    end
end

local function SetFilter(self)
    -- B.BagFrame.editBox:SetText("武器 !史诗 | 护甲 !史诗")
    -- B:UpdateSearch()
    
    local f = B:GetContainerFrame(self.isBank);
    if not (f and f.FilterHolder) then return; end

    for i = 1, U.numFilters do
        if i ~= self:GetID() then
            f.FilterHolder[i]:SetChecked(nil);
        end
    end
    f.FilterHolder.active = self:GetID();
    local s = f.FilterHolder[f.FilterHolder.active].filter_string;
    if s == ALL then
        B.BagFrame.editBox:SetText('')
    elseif s ~= '' then
        B.BagFrame.editBox:SetText(s)
    else
        B.BagFrame.editBox:SetText('')
        for i, bagID in ipairs(f.BagIDs) do
            if f.Bags[bagID] then
                for slotID = 1, f.Bags[bagID].numSlots do
                    SetSlotFilter(f, bagID, slotID);
                end
            end
        end
    end


end

local function ResetFilter(self)
    local f = B:GetContainerFrame(self.isBank);
    if not (f and f.FilterHolder) then return; end

    if f.FilterHolder.active then
        f.FilterHolder[f.FilterHolder.active]:SetChecked(nil);
        f.FilterHolder.active = nil;

        for i, bagID in ipairs(f.BagIDs) do
            if f.Bags[bagID] then
                for slotID = 1, f.Bags[bagID].numSlots do
                    if f.Bags[bagID][slotID] then
                        f.Bags[bagID][slotID].searchOverlay:Hide();
                    end
                end
            end
        end
    end
end

local function AddFilterButtons(f, isBank)
    local buttonSize = isBank and B.db.bankSize or B.db.bagSize;
    local buttonSpacing = E.Border * 2;
    local lastContainerButton;

    for i, filter in ipairs(U.Filters) do
        if not f.FilterHolder[i] then
            local name, icon, func, filter_string = unpack(filter);

            if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
                f.FilterHolder[i] = CreateFrame('CheckButton', nil, f.FilterHolder);
            else
                f.FilterHolder[i] = CreateFrame('CheckButton', nil, f.FilterHolder, 'BackdropTemplate');
            end
            f.FilterHolder[i]:SetTemplate('Default', true);
            f.FilterHolder[i]:StyleButton();
            f.FilterHolder[i]:SetNormalTexture('');
            f.FilterHolder[i]:SetPushedTexture('');
            f.FilterHolder[i].ttText = name;
            f.FilterHolder[i].filter = func;
            f.FilterHolder[i].filter_string = filter_string;
            f.FilterHolder[i].isBank = isBank;
            f.FilterHolder[i]:SetScript('OnEnter', B.Tooltip_Show);
            f.FilterHolder[i]:SetScript('OnLeave', B.Tooltip_Hide);
            f.FilterHolder[i]:SetScript('OnClick', SetFilter);
            f.FilterHolder[i]:SetScript('OnHide', ResetFilter);
            f.FilterHolder[i]:SetID(i);

            f.FilterHolder[i].iconTexture = f.FilterHolder[i]:CreateTexture();
            f.FilterHolder[i].iconTexture:SetInside();
            f.FilterHolder[i].iconTexture:SetTexCoord(unpack(E.TexCoords));
            f.FilterHolder[i].iconTexture:SetTexture(icon);
        end

        f.FilterHolder:Size(((buttonSize + buttonSpacing) * i) + buttonSpacing, buttonSize + (buttonSpacing * 2));

        f.FilterHolder[i]:Size(buttonSize);
        f.FilterHolder[i]:ClearAllPoints();
        if i == 1 then
            f.FilterHolder[i]:SetPoint('BOTTOMLEFT', f.FilterHolder, 'BOTTOMLEFT', buttonSpacing, buttonSpacing)
        else
            f.FilterHolder[i]:SetPoint('LEFT', lastContainerButton, 'RIGHT', buttonSpacing, 0);
        end

        lastContainerButton = f.FilterHolder[i];
    end
end

local function AddMenuButton(isBank)
    if E.private.bags.enable ~= true then return; end
    local f = B:GetContainerFrame(isBank);

    if not f or f.FilterHolder then return; end
    if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        f.FilterHolder = CreateFrame('Button', nil, f);
    else
        f.FilterHolder = CreateFrame('Button', nil, f, 'BackdropTemplate');
    end
    f.FilterHolder:Point('BOTTOMLEFT', f, 'TOPLEFT', 0, 1);
    f.FilterHolder:SetTemplate('Transparent');
    f.FilterHolder:Hide();

    if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
        f.filterButton = CreateFrame('Button', nil, f.holderFrame);
    else
        f.filterButton = CreateFrame('Button', nil, f.holderFrame, 'BackdropTemplate');
    end
    f.filterButton:SetSize(16 + E.Border, 16 + E.Border);
    f.filterButton:SetTemplate();
    f.filterButton:SetPoint("RIGHT", f.sortButton, "LEFT", -5, 0);
    f.filterButton:SetNormalTexture('Interface/AddOns/ElvUI_Bagfilter/BagFilter');
    -- if E.TexCoords ~= nil then
    --     f.filterButton:GetNormalTexture():SetTexCoord(unpack(E.TexCoords));
    -- end
    -- f.filterButton:GetNormalTexture():SetInside();
    f.filterButton:SetPushedTexture('Interface/AddOns/ElvUI_Bagfilter/BagFilter');
    -- if E.TexCoords ~= nil then
    --     f.filterButton:GetPushedTexture():SetTexCoord(unpack(E.TexCoords));
    -- end
    -- f.filterButton:GetPushedTexture():SetInside();
    f.filterButton:StyleButton(nil, true);
    f.filterButton.ttText = L.Filter;
    f.filterButton:SetScript('OnEnter', B.Tooltip_Show);
    f.filterButton:SetScript('OnLeave', B.Tooltip_Hide);
    f.filterButton:SetScript('OnClick', function()
        f.ContainerHolder:Hide();
        ToggleFrame(f.FilterHolder);
    end);

    f.bagsButton:HookScript('OnClick', function()
        f.FilterHolder:Hide();
    end);

    -- realign
    f.bagsButton:SetPoint("RIGHT", f.filterButton, "LEFT", -5, 0);

    AddFilterButtons(f, isBank);
end

do

    local action_item_classes = {GetAuctionItemClasses()}
    -- "Weapon"
    -- "Armor"
    -- "Container"
    -- "Consumable"
    -- "Glyph"
    -- "Trade Goods"
    -- "Projectile"
    -- "Quiver"
    -- "Recipe"
    -- "Gem"
    -- "Miscallaneous"
    -- "Quest"
    AUCTION_CATEGORY_WEAPONS = action_item_classes[1]
    AUCTION_CATEGORY_ARMOR = action_item_classes[2]
    AUCTION_CATEGORY_CONTAINERS = action_item_classes[3]
    AUCTION_CATEGORY_CONSUMABLES = action_item_classes[4]
    AUCTION_CATEGORY_GLYPHS = action_item_classes[5]
    AUCTION_CATEGORY_TRADE_GOODS = action_item_classes[6]


    AUCTION_CATEGORY_RECIPES = action_item_classes[9]
    AUCTION_CATEGORY_GEMS = action_item_classes[10]
    AUCTION_CATEGORY_MISCELLANEOUS = action_item_classes[11]
    AUCTION_CATEGORY_QUEST_ITEMS = action_item_classes[12]

    AUCTION_CATEGORY_BATTLE_PETS = "Battle Pets"
    AUCTION_CATEGORY_ITEM_ENHANCEMENT = "enchantment"
    ALL = "All"
    NEW = "New"

    L.Weapon = AUCTION_CATEGORY_WEAPONS;
    L.Armor = AUCTION_CATEGORY_ARMOR;
    L.Container = AUCTION_CATEGORY_CONTAINERS;
    L.Consumable = AUCTION_CATEGORY_CONSUMABLES;
    L.Glyph = AUCTION_CATEGORY_GLYPHS;
    L.TradeGood = AUCTION_CATEGORY_TRADE_GOODS;
    L.Recipe = AUCTION_CATEGORY_RECIPES;
    L.Gem = AUCTION_CATEGORY_GEMS;
    L.Misc = AUCTION_CATEGORY_MISCELLANEOUS;
    L.Quest = AUCTION_CATEGORY_QUEST_ITEMS;
    L.BattlePets = AUCTION_CATEGORY_BATTLE_PETS;
    L.Enhancement = AUCTION_CATEGORY_ITEM_ENHANCEMENT;
    L.New = NEW;

    L.All = ALL;
    L.Equipment = L.Weapon .. ' & ' .. L.Armor;
    L.Filter = FILTER;

    U.Filters = {
        { L.All, 'Interface/Icons/INV_Misc_EngGizmos_17',
          function(location, link, type, subType)
              return true;
          end,
          ALL
        },
        { L.Equipment, 'Interface/Icons/INV_Chest_Chain_04',
          function(location, link, type, subType)
              return type == AUCTION_CATEGORY_ARMOR or
                     type == AUCTION_CATEGORY_WEAPONS;
          end,
          AUCTION_CATEGORY_WEAPONS..' !史诗'..' | '..AUCTION_CATEGORY_ARMOR..' !史诗'
        },
        { L.Consumable, 'Interface/Icons/INV_Potion_93',
          function(location, link, type, subType)
              return type == AUCTION_CATEGORY_CONSUMABLES;
          end,
          AUCTION_CATEGORY_CONSUMABLES
        },
        { L.Quest, 'Interface/QuestFrame/UI-QuestLog-BookIcon',
          function(location, link, type, subType)
              return type == AUCTION_CATEGORY_QUEST_ITEMS;
          end,
          AUCTION_CATEGORY_QUEST_ITEMS
        },
        { L.TradeGood, 'Interface/Icons/INV_Fabric_Silk_02',
          function(location, link, type, subType)
              return type == AUCTION_CATEGORY_TRADE_GOODS or
                     type == AUCTION_CATEGORY_RECIPES or
                     type == AUCTION_CATEGORY_GEMS or
                     type == AUCTION_CATEGORY_ITEM_ENHANCEMENT or
                     type == AUCTION_CATEGORY_GLYPHS;
          end,
          ''
        },
        { L.Misc, 'Interface/Icons/INV_Misc_Rune_01',
          function(location, link, type, subType)
              return type == LE_ITEM_CLASS_MISCELLANEOUS or
                     type == LE_ITEM_CLASS_CONTAINER;
          end,
          ''
        },
        { L.New, 'Interface/PaperDollInfoFrame/UI-GearManager-ItemIntoBag',
          function(location, link, type, subType)
              return C_NewItems.IsNewItem(location.bagID, location.slotIndex);
          end,
          ''
        }
    };

    U.numFilters = #U.Filters;

    hooksecurefunc(B, 'Layout', function(self, isBank)
        AddMenuButton(isBank);
    end);

    hooksecurefunc(B, 'UpdateSlot', function(self, frame, bagID, slotID)
        SetSlotFilter(frame, bagID, slotID);
    end);
end
