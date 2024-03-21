#!/usr/bin/python3

import collections
import csv
import requests_cache


ITEM__CLASS_ID__CONSUMABLE = 0
ITEM__CLASS_ID__QUEST = 12
ITEM__SUBCLASS_ID__ITEM_ENHANCEMENT = 6
ITEM__SUBCLASS_ID__QUEST = 0

ITEM_EFFECT__TRIGGER_TYPE__ON_USE = 0

SPELL_EFFECT__EFFECT__ENCHANT_ITEM = 53

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
    10: "Staff",
    15: "Dagger",
    16: "Thrown",
    18: "Crossbow",
    19: "Wand",
    20: "Fishingpole",
}

WEAPON_SUBCLASS_TO_INVENTORY_TYPES = {
    "Axe1H": ["INVTYPE_WEAPON", "INVTYPE_WEAPONMAINHAND", "INVTYPE_WEAPONOFFHAND"],
    "Axe2H": ["INVTYPE_2HWEAPON"],
    "Bows": ["INVTYPE_RANGED"],
    "Guns": ["INVTYPE_RANGED"],
    "Mace1H": ["INVTYPE_WEAPON", "INVTYPE_WEAPONMAINHAND", "INVTYPE_WEAPONOFFHAND"],
    "Mace2H": ["INVTYPE_2HWEAPON"],
    "Polearm": ["INVTYPE_2HWEAPON"],
    "Sword1H": ["INVTYPE_WEAPON", "INVTYPE_WEAPONMAINHAND", "INVTYPE_WEAPONOFFHAND"],
    "Sword2H": ["INVTYPE_2HWEAPON"],
    "Staff": ["INVTYPE_2HWEAPON"],
    "Dagger": ["INVTYPE_WEAPON", "INVTYPE_WEAPONMAINHAND", "INVTYPE_WEAPONOFFHAND"],
    "Thrown": ["INVTYPE_RANGED"],
    "Crossbow": ["INVTYPE_RANGED"],
    "Wand": ["INVTYPE_RANGED"],
    "Fishingpole": ["INVTYPE_2HWEAPON"],
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
}

BUILD = "3.4.3.53788"
URL_PATTERN = "https://wago.tools/db2/%s/csv?build=%s"
SESSION = requests_cache.CachedSession("wago.tools")

def downloaddb(name, build=BUILD):
    url = URL_PATTERN % (name, build)
    with SESSION.get(url) as fd:
        return csv.DictReader(fd.text.splitlines())

SPELL_BLACKLIST = {
    47101, # https://www.wowhead.com/wotlk/spell=47101/test-riding-crop-enchant
    47103, # https://www.wowhead.com/wotlk/spell=47103/riding-crop
    47147, # https://www.wowhead.com/wotlk/spell=47147/test-on-use-enchant
    47242, # https://www.wowhead.com/wotlk/spell=47242/test-on-use-enchant-charges
    48401, # https://www.wowhead.com/wotlk/spell=48401/carrot-on-a-stick
    48555, # https://www.wowhead.com/wotlk/spell=48555/skybreaker-whip
    48556, # https://www.wowhead.com/wotlk/spell=48556/carrot-on-a-stick
    48557, # https://www.wowhead.com/wotlk/spell=48557/riding-crop
    50358, # https://www.wowhead.com/wotlk/spell=50358/test-skill-req-enchant
}
ITEM_BLACKLIST = {
    # 41605, # https://www.wowhead.com/wotlk/item=41605/zzdeprecated-sanctified-spellthread
    # 41606, # https://www.wowhead.com/wotlk/item=41606/zzdeprecated-masters-spellthread
}

SPELL_IDS = set(int(row["ID"]) for row in downloaddb("Spell") if int(row["ID"]) not in SPELL_BLACKLIST)
ITEM_IDS = set(int(row["ID"]) for row in downloaddb("Item") if int(row["ID"]) not in ITEM_BLACKLIST)

SPELL_ID_TO_INV_TYPES = collections.defaultdict(set)
for row in downloaddb("SpellEquippedItems"):
    spell_id = int(row["SpellID"])
    allowed_item_class = int(row["EquippedItemClass"])
    allowed_inv_types = int(row["EquippedItemInvTypes"])
    allowed_subclasses = int(row["EquippedItemSubclass"])

    if spell_id not in SPELL_IDS:
        continue

    subclasses, subclass_to_inventory_types = None, None
    if allowed_item_class == ITEM_CLASS_WEAPON:
        subclasses = WEAPON_SUBCLASSES
        subclass_to_inventory_types = WEAPON_SUBCLASS_TO_INVENTORY_TYPES
    if allowed_item_class == ITEM_CLASS_ARMOR:
        subclasses = ARMOR_SUBCLASSES
        subclass_to_inventory_types = ARMOR_SUBCLASS_TO_INVENTORY_TYPES

    if not subclasses:
        continue

    if allowed_subclasses == 0:
        for inv_type_id, inv_type in INVENTORY_TYPES.items():
            if (allowed_inv_types & (1 << inv_type_id)) != 0:
                SPELL_ID_TO_INV_TYPES[spell_id].add(inv_type)

    for subclass_id, subclass in subclasses.items():
        if (allowed_subclasses & (1 << subclass_id)) == 0:
            continue
        for inv_type in subclass_to_inventory_types[subclass]:
            SPELL_ID_TO_INV_TYPES[spell_id].add(inv_type)

    for inv_type_id, inv_type in INVENTORY_TYPES.items():
        if (allowed_inv_types & (1 << inv_type_id)) != 0:
            SPELL_ID_TO_INV_TYPES[spell_id].add(inv_type)

ENCHANT_ID_TO_SPELL_IDS = collections.defaultdict(set)
for row in downloaddb("SpellEffect"):
    effect = int(row["Effect"])
    enchant_id = int(row["EffectMiscValue_0"])
    spell_id = int(row["SpellID"])

    if spell_id not in SPELL_IDS:
        continue
    if effect != SPELL_EFFECT__EFFECT__ENCHANT_ITEM:
        continue
    ENCHANT_ID_TO_SPELL_IDS[enchant_id].add(spell_id)


SPELL_ID_TO_ITEM_IDS = collections.defaultdict(set)
for row in downloaddb("ItemEffect"):
    spell_id = int(row["SpellID"])
    item_id = int(row["ParentItemID"])
    trigger_type = int(row["TriggerType"])

    if spell_id not in SPELL_IDS:
        continue
    if item_id not in ITEM_IDS:
        continue
    if trigger_type != ITEM_EFFECT__TRIGGER_TYPE__ON_USE:
        continue
    SPELL_ID_TO_ITEM_IDS[spell_id].add(item_id)

entries = []
for row in sorted(downloaddb("SpellItemEnchantment"), key=lambda row: int(row["ID"])):
    enchant_id = int(row["ID"])
    for spell_id in ENCHANT_ID_TO_SPELL_IDS[enchant_id]:
        if spell_id not in SPELL_IDS:
            continue
        link = "spell:%d" % spell_id
        if spell_id in SPELL_ID_TO_ITEM_IDS:
            item_id = next(iter(SPELL_ID_TO_ITEM_IDS[spell_id]))
            link = "item:%d" % item_id
        types = set(inv_type for inv_type in SPELL_ID_TO_INV_TYPES[spell_id])
        if not types:
            raise ValueError(spell_id)
        print("Moldy.Enchants:add(%d, \"%s\", {\"%s\"})" % (enchant_id, link, "\", \"".join(sorted(types))))
