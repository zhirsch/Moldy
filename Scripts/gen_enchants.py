#!/usr/bin/python3

import io
import itertools
import math
import pandas as pd
import pandasql
import requests_cache
import sys

ITEM_CLASS_WEAPON = 2
ITEM_CLASS_ARMOR = 4

# Enum.ItemWeaponSubclass
WEAPON_SUBCLASSES = {
     0: "Axe1H",
     1: "Axe2H",
     2: "Bows",
     3: "Guns",
     4: "Mace1H",
     5: "Mace2H",
     6: "Polearm",
     7: "Sword1H",
     8: "Sword2H",
     9: "Warglaive",
    10: "Staff",
    11: "Bearclaw",
    12: "Catclaw",
    13: "Unarmed",
    14: "Generic",
    15: "Dagger",
    16: "Thrown",
    17: "Obsolete3",
    18: "Crossbow",
    19: "Wand",
    20: "Fishingpole",
}

WEAPON_SUBCLASS_TO_INVENTORY_TYPES = {
    "Axe1H":       {"INVTYPE_WEAPON", "INVTYPE_WEAPONMAINHAND", "INVTYPE_WEAPONOFFHAND"},
    "Axe2H":       {"INVTYPE_2HWEAPON"},
    "Bows":        {"INVTYPE_RANGED"},
    "Guns":        {"INVTYPE_RANGED"},
    "Mace1H":      {"INVTYPE_WEAPON", "INVTYPE_WEAPONMAINHAND", "INVTYPE_WEAPONOFFHAND"},
    "Mace2H":      {"INVTYPE_2HWEAPON"},
    "Polearm":     {"INVTYPE_2HWEAPON"},
    "Sword1H":     {"INVTYPE_WEAPON", "INVTYPE_WEAPONMAINHAND", "INVTYPE_WEAPONOFFHAND"},
    "Sword2H":     {"INVTYPE_2HWEAPON"},
    "Warglaive":   set(),
    "Staff":       {"INVTYPE_2HWEAPON"},
    "Bearclaw":    set(),
    "Catclaw":     set(),
    "Unarmed":     set(),
    "Generic":     set(),
    "Dagger":      {"INVTYPE_WEAPON", "INVTYPE_WEAPONMAINHAND", "INVTYPE_WEAPONOFFHAND"},
    "Thrown":      {"INVTYPE_RANGED"},
    "Obsolete3":   set(),
    "Crossbow":    {"INVTYPE_RANGED"},
    "Wand":        {"INVTYPE_RANGED"},
    "Wand":        {"INVTYPE_RANGED", "INVTYPE_RANGEDRIGHT"},
    "Fishingpole": {"INVTYPE_2HWEAPON"},
}

# Enum.ItemArmorSubclass
ARMOR_SUBCLASSES = {
     0: "Generic",
     1: "Cloth",
     2: "Leather",
     3: "Mail",
     4: "Plate",
     5: "Cosmetic",
     6: "Shield",
     7: "Libram",
     8: "Idol",
     9: "Totem",
    10: "Sigil",
    11: "Relic",
}

ARMOR_SUBCLASS_TO_INVENTORY_TYPES = {
    "Generic": [],
    "Cloth": [],
    "Leather": [],
    "Mail": [],
    "Plate": [],
    "Cosmetic": [],
    "Shield": ["INVTYPE_SHIELD"],
    "Libram": [],
    "Idol": [],
    "Totem": [],
    "Sigil": [],
    "Relic": [],
}

# Enum.InventoryType
INVENTORY_TYPES = {
     0: "INVTYPE_NON_EQUIP",
     1: "INVTYPE_HEAD",
     2: "INVTYPE_NECK",
     3: "INVTYPE_SHOULDER",
     4: "INVTYPE_BODY",
     5: "INVTYPE_CHEST",
     6: "INVTYPE_WAIST",
     7: "INVTYPE_LEGS",
     8: "INVTYPE_FEET",
     9: "INVTYPE_WRIST",
    10: "INVTYPE_HAND",
    11: "INVTYPE_FINGER",
    12: "INVTYPE_TRINKET",
    13: "INVTYPE_WEAPON",
    14: "INVTYPE_SHIELD",
    15: "INVTYPE_RANGED",
    16: "INVTYPE_CLOAK",
    17: "INVTYPE_2HWEAPON",
    18: "INVTYPE_BAG",
    19: "INVTYPE_TABARD",
    20: "INVTYPE_ROBE",
    21: "INVTYPE_WEAPONMAINHAND",
    22: "INVTYPE_WEAPONOFFHAND",
    23: "INVTYPE_HOLDABLE",
    24: "INVTYPE_AMMO",
    25: "INVTYPE_THROWN",
    26: "INVTYPE_RANGEDRIGHT",
    27: "INVTYPE_QUIVER",
    28: "INVTYPE_RELIC",
    29: "INVTYPE_PROFESSION_TOOL",
    30: "INVTYPE_PROFESSION_GEAR",
    31: "INVTYPE_EQUIPABLESPELL_OFFENSIVE",
    32: "INVTYPE_EQUIPABLESPELL_UTILITY",
    33: "INVTYPE_EQUIPABLESPELL_DEFENSIVE",
    34: "INVTYPE_EQUIPABLESPELL_WEAPON",
}


SPELL_BLACKLIST = {
    # Temporary
    # Temporary enchants
    2605, # https://www.wowhead.com/wotlk/spell=2605/sharpen-blade
}

ITEM_BLACKLIST = {
    # Missing
    72070, # https://www.wowhead.com/mop-classic/item=72070/enchant-gloves-assault

    41605, # https://www.wowhead.com/wotlk/item=41605/zzdeprecated-sanctified-spellthread
    41606, # https://www.wowhead.com/wotlk/item=41606/zzdeprecated-masters-spellthread

    # Two items give the same enchant, arbitrarily pick one of them.
    37311, # https://www.wowhead.com/mop-classic/item=37311/skybreaker-whip
    68774, # https://www.wowhead.com/cata/item=68774/greater-inscription-of-vicious-agility
}

# Cataclysm (unknown): 4.4.0.54737
# Mists of Panderia (pre-patch): 5.5.0.61798
# Mists of Pandaria (pre-patch): 5.5.0.61798
# Mists of Pandaria (phase 1): 5.5.0.62959
if len(sys.argv) <= 1:
    sys.exit("usage: python3 gen_enchants.py <build>")

BUILD = sys.argv[1]
URL_PATTERN = "https://wago.tools/db2/{}/csv?build={}"
SESSION = requests_cache.CachedSession("db-wago.tools")


def load_db(name, build=BUILD, **kwargs):
    with SESSION.get(URL_PATTERN.format(name, build)) as fd:
        return pd.read_csv(io.StringIO(fd.text), **kwargs)

TABLES = [
    "ItemEffect",
    "ItemSparse",
    "SpellEffect",
    "SpellEquippedItems",
    "SpellName",
]
DATA_FRAMES = {table: load_db(table) for table in TABLES}

sqldf = lambda q: pandasql.sqldf(q, DATA_FRAMES)

# Add any spells that start with "QAEnchant " to the blacklist
for row in sqldf("SELECT ID FROM SpellName WHERE Name_lang LIKE \"QAEnchant %\"").itertuples():
    SPELL_BLACKLIST.add(row.ID)


def flatten(matrix):
    return set(itertools.chain.from_iterable(matrix))

def expand_mask(lookup_table, mask):
    return {v for k, v in lookup_table.items() if (mask & (1 << k)) != 0}

def get_weapon_inventory_types_from_subclass_mask(mask):
    subclasses = expand_mask(WEAPON_SUBCLASSES, mask)
    return flatten(WEAPON_SUBCLASS_TO_INVENTORY_TYPES[subclass] for subclass in subclasses)

def get_armor_inventory_types_from_subclass_mask(mask):
    subclasses = expand_mask(ARMOR_SUBCLASSES, mask)
    return flatten(ARMOR_SUBCLASS_TO_INVENTORY_TYPES[subclass] for subclass in subclasses)

def get_inventory_types_from_mask(mask):
    return expand_mask(INVENTORY_TYPES, mask)

def get_inventory_types(allowed_item_class, allowed_item_subclass_mask, allowed_item_inventory_type_mask):
    output = get_inventory_types_from_mask(allowed_item_inventory_type_mask)

    if allowed_item_class == ITEM_CLASS_WEAPON:
        output.update(get_weapon_inventory_types_from_subclass_mask(allowed_item_subclass_mask))
    if allowed_item_class == ITEM_CLASS_ARMOR:
        output.update(get_armor_inventory_types_from_subclass_mask(allowed_item_subclass_mask))

    return frozenset(output)


class Enchant:

    def __init__(self, enchant_id, spell_id, spell_name, inventory_types):
        self.enchant_id = enchant_id
        self.spell_id = spell_id
        self.spell_name = spell_name
        self.inventory_types = inventory_types
        self.items = []

    def get_spell_link(self):
        return "spell:%d" % self.spell_id

    def get_item_link(self):
        if not self.items:
            return None

        if len(self.items) == 1:
            (item,) = self.items
            return "item:%d" % item.item_id

        factions = {item.faction_id: item for item in self.items if item.faction_id != 0}
        if len(factions) == 1:
            (item,) = factions.values()
            return "item:%d" % item.item_id
        if len(factions) == 2:
            # Arbitrarily pick the Horde version of items.
            if 946 in factions and 947 in factions:
                return "item:%d" % factions[947].item_id
            if 1037 in factions and 1052 in factions:
                return "item:%d" % factions[1052].item_id

        buy_prices = {item.item_id: item.buy_price for item in self.items if item.buy_price == 0}
        if len(buy_prices) == 1:
            (item_id,) = buy_prices.keys()
            return "item:%d" % item_id

        raise ValueError("%d: %s" % (self.spell_id, self.items))


class Item:

    def __init__(self, item_id, faction_id, buy_price):
        self.item_id = item_id
        self.faction_id = faction_id
        self.buy_price = buy_price

    def __repr__(self):
        return "Item{id=%s}" % self.item_id


sql = """\
SELECT
  SpellEffect.EffectMiscValue_0 AS EnchantID,
  SpellEffect.SpellID,
  SpellName.Name_lang AS SpellName,
  SpellEquippedItems.EquippedItemClass,
  SpellEquippedItems.EquippedItemSubclass,
  SpellEquippedItems.EquippedItemInvTypes,
  ItemEffect.ParentItemID AS ItemID,
  COALESCE(ItemSparse.MinFactionID, 0) AS FactionID,
  ItemSparse.BuyPrice
FROM
  SpellEffect
INNER JOIN
  SpellName
ON
  SpellName.ID = SpellEffect.SpellID
INNER JOIN
  SpellEquippedItems
ON
  SpellEquippedItems.SpellID = SpellEffect.SpellID
LEFT JOIN
  ItemEffect
ON
  ItemEffect.SpellID = SpellEffect.SpellID
  AND ItemEffect.TriggerType = 0
LEFT JOIN
  ItemSparse
ON
  ItemSparse.ID = ItemEffect.ParentItemID
WHERE
  SpellEffect.Effect == 53
"""
df = sqldf(sql)

enchants = {}
for row in df.itertuples():
    enchant_id = row.EnchantID
    if enchant_id == 1898 and row.SpellID == 27964:
        # https://www.wowhead.com/wotlk/spell=27964/enchant-weapon-major-spirit
        # is wrongly marked as enchanting Lifestealing.
        enchant_id = 1183

    spell_id = row.SpellID
    item_id = None if math.isnan(row.ItemID) else int(row.ItemID)

    if spell_id in SPELL_BLACKLIST:
        continue
    if item_id in ITEM_BLACKLIST:
        continue

    spell_name = row.SpellName
    faction_id = int(row.FactionID)
    buy_price = None if math.isnan(row.BuyPrice) else int(row.BuyPrice)
    inventory_types = get_inventory_types(row.EquippedItemClass, row.EquippedItemSubclass, row.EquippedItemInvTypes)

    key = (enchant_id, spell_id, inventory_types)
    if key not in enchants:
        enchants[key] = Enchant(enchant_id, spell_id, spell_name, inventory_types)
    if item_id:
        enchants[key].items.append(Item(item_id, faction_id, buy_price))

for _, enchant in sorted(enchants.items()):
    print("-- " + enchant.spell_name)
    item_link = enchant.get_item_link()
    item_link_str = "\"%s\"" % item_link if item_link else "nil"
    inventory_types_str = "{\"%s\"}" % "\", \"".join(sorted(enchant.inventory_types))
    print("Moldy.Enchants:add(%d, \"%s\", %s, %s)" % (enchant.enchant_id, enchant.get_spell_link(), item_link_str, inventory_types_str))
