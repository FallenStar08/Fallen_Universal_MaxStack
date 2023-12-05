Ext.Require("Shared/_Globals.lua")
Ext.Require("Shared/_Utils.lua")
_G.MaxStackAmount = 99999999

function MaxStackThings()
    print("Doing")
    local startTime = Ext.Utils.MonotonicTime()
    local templates = Ext.Template.GetAllRootTemplates()
    local localTemplates = Ext.Template.GetAllLocalTemplates()
    for k, v in pairs(templates) do
        if v.TemplateType == "item" and v.InventoryType == 0 then
            v.MaxStackAmount = _G.MaxStackAmount
        end
    end
    for k, v in pairs(localTemplates) do
        if v.TemplateType == "item" and v.InventoryType == 0 then
            v.MaxStackAmount = _G.MaxStackAmount
        end
    end
    local endTime = Ext.Utils.MonotonicTime()
    local elapsedTime = endTime - startTime
    BasicPrint("Templates MaxStackAmount modified in " .. elapsedTime .. " milliseconds!", _, _, "Fall_MaxStack", true)
end

--Just In Case...
Ext.Osiris.RegisterListener("TemplateAddedTo", 4, "after", function(root, item, inventoryHolder, addType)
    if Osi.IsContainer(item) == 0 then
        local entity = Ext.Entity.Get(item)
        if entity.ServerItem then
            entity.ServerItem.Item.Template.MaxStackAmount = _G.MaxStackAmount
        end
    end
end)

--Ext.Events.StatsLoaded:Subscribe(MaxStackThings)
Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", MaxStackThings)
