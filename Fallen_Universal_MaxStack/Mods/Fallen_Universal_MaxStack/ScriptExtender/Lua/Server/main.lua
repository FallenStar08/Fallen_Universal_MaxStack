_G.MaxStackAmount = 99999999

--Just In Case...
Ext.Osiris.RegisterListener("TemplateAddedTo", 4, "after", function(root, item, inventoryHolder, addType)
    if Osi.IsContainer(item) == 0 then
        local entity = Ext.Entity.Get(item)
        if entity.ServerItem then
            entity.ServerItem.Item.Template.MaxStackAmount = _G.MaxStackAmount
        end
    end
end)

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(level, isEditorMode)
    local templates=Ext.Template.GetAllRootTemplates()
    for k,v in pairs(templates) do
        if v.TemplateType=="item" and v.InventoryType == 0 then
            v.MaxStackAmount=_G.MaxStackAmount
        end
    end
end)




