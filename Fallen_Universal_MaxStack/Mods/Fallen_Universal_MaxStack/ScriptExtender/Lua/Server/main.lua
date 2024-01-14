Ext.Require("Shared/_Globals.lua")
Ext.Require("Shared/_Utils.lua")
local MaxStackAmount = 99999999

local function MaxStackLocalTemplates()
    local startTime = Ext.Utils.MonotonicTime()
    local localTemplates = Ext.Template.GetAllLocalTemplates() or {}
    for k, v in pairs(localTemplates) do
        if v.TemplateType == "item" and v.InventoryType == 0 then
            v.MaxStackAmount = MaxStackAmount
        end
    end
    local endTime = Ext.Utils.MonotonicTime()
    local elapsedTime = endTime - startTime
    BasicPrint("Local Templates MaxStackAmount modified in " .. elapsedTime .. " milliseconds!", _, _, "Fall_MaxStack", true)
end
local function MaxStackRootTemplates()
    local startTime = Ext.Utils.MonotonicTime()
    local templates = Ext.Template.GetAllRootTemplates() or {}
    for k, v in pairs(templates) do
        if v.TemplateType == "item" and v.InventoryType == 0 then
            v.MaxStackAmount = MaxStackAmount
        end
    end
    local endTime = Ext.Utils.MonotonicTime()
    local elapsedTime = endTime - startTime
    BasicPrint("Root Templates MaxStackAmount modified in " .. elapsedTime .. " milliseconds!", _, _, "Fall_MaxStack", true)
end

Ext.Osiris.RegisterListener("TemplateAddedTo", 4, "after", function(root, item, inventoryHolder, addType)
    if Osi.IsContainer(item) == 0 then
        local entity = Ext.Entity.Get(item)
        if entity.ServerItem then
            entity.ServerItem.Template.MaxStackAmount = MaxStackAmount
        end
    end
end)

Ext.Events.SessionLoading:Subscribe(MaxStackRootTemplates)
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", MaxStackLocalTemplates)
