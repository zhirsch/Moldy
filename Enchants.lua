local Enchants
Enchants = {
    new = function()
        local self = { map = {}, reported = {} }
        local cls = { __index = Enchants.prototype }
        return setmetatable(self, cls)
    end,
}
Enchants.prototype = {
    add = function(self, enchantId, spellLink, itemLink, invtypes)
        local enchants = GetOrCreateTableEntry(self.map, enchantId, {})
        table.insert(enchants, {
            spellLink = spellLink,
            itemLink = itemLink,
            invtypes = invtypes,
        })
    end,
    get = function(self, link)
        local enchantId = string.match(link, "item:%d+:(%d+):")
        if not enchantId then
            return nil
        end
        local invtype = select(9, GetItemInfo(link))
        local enchants = GetOrCreateTableEntry(self.map, tonumber(enchantId), {})
        local _, enchant = FindInTableIf(enchants, function(e)
            return tContains(e.invtypes, invtype)
        end)
        if not enchant then
            if not self.reported[enchantId] then
                self.reported[enchantId] = true
                Moldy:Printf("Unknown enchant %s on item %s", enchantId, link)
            end
            return "enchant:" .. enchantId
        end
        if enchant.itemLink and GetItemInfoInstant(enchant.itemLink) then
            return enchant.itemLink
        end
        return enchant.spellLink
    end,
}

Moldy.Enchants = Enchants.new()
