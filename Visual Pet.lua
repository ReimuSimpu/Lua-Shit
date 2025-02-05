local ChangeItem = function(Class, FromId, ToId)
    local Directory = require(game.ReplicatedStorage.Library.Directory)

    local Dir = Directory[Class]
    if not Dir then 
        return nil, "Invalid Class: " .. Class
    end

    local FromItem = Dir[FromId]
    if not FromItem then 
        return nil, "Invalid From: " .. FromId
    end

    local ToItem = Dir[ToId]
    if not ToItem then 
        return nil, "Invalid To: " .. ToId
    end

    table.clear(FromItem)
    for i, v in pairs(ToItem) do
        FromItem[i] = v
    end

    return true
end

local sus, err = ChangeItem("Pets", "Wild Fire Agony", "Huge Hippo")
print(sus, err)
