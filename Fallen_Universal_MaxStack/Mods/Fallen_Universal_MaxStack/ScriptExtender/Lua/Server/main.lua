local MaxStackAmount = 99999999

local exclusion = {
    ["1ec327be-3b7f-4502-9586-860e057e09ae"] = "TadpoleJar",
}

-- Sets the MaxStackAmount property to a large value for all local item templates.
-- This allows stacking items like potions and scrolls & equipments up to a very high amount.
-- Called after the level has started.
local function MaxStackLocalTemplates()
    local startTime = Ext.Utils.MonotonicTime()
    ---@class GameObjectTemplate
    local localTemplates = Ext.Template.GetAllLocalTemplates() or {}
    for k, v in pairs(localTemplates) do
        if v.TemplateType == "item" and v.InventoryType == 0 and not exclusion[v.Id] then
            v.MaxStackAmount = MaxStackAmount
        end
    end
    local endTime = Ext.Utils.MonotonicTime()
    local elapsedTime = endTime - startTime
    BasicPrint("Local Templates MaxStackAmount modified in " .. elapsedTime .. " milliseconds!", _, _, "Fall_MaxStack",
        true)
end
-- Sets the MaxStackAmount property to a large value for all root item templates.
-- This allows stacking items like potions and scrolls & equipments  up to a very high amount.
-- Called before the level has started.
local function MaxStackRootTemplates()
    local startTime = Ext.Utils.MonotonicTime()
    ---@class GameObjectTemplate
    local templates = Ext.Template.GetAllRootTemplates() or {}
    for k, v in pairs(templates) do
        if v.TemplateType == "item" and v.InventoryType == 0 and not exclusion[v.Id] then
            v.MaxStackAmount = MaxStackAmount
            v.InventoryType = v.InventoryType == 0 and 1 or v.InventoryType
        end
    end
    local endTime = Ext.Utils.MonotonicTime()
    local elapsedTime = endTime - startTime
    BasicPrint("Root Templates MaxStackAmount modified in " .. elapsedTime .. " milliseconds!", _, _, "Fall_MaxStack",
        true)
end

Ext.Osiris.RegisterListener("TemplateAddedTo", 4, "after", function(root, item, inventoryHolder, addType)
    if Osi.IsContainer(item) == 0 then
        local entity = Ext.Entity.Get(item)
        if entity.ServerItem and not exclusion[entity.ServerItem.Template.Id] then
            entity.ServerItem.Template.MaxStackAmount = MaxStackAmount
        end
    end
end)

Ext.Events.SessionLoading:Subscribe(MaxStackRootTemplates)
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", MaxStackLocalTemplates)
