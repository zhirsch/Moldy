#!/usr/bin/python3

import collections
import csv
import itertools
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
}

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

BUILD = "3.4.3.53788"
URL_PATTERN = "https://wago.tools/db2/%s/csv?build=%s"
SESSION = requests_cache.CachedSession("db-wago.tools")

def get_db(name, build=BUILD):
    url = URL_PATTERN % (name, build)
    with SESSION.get(url) as fd:
        return csv.DictReader(fd.text.splitlines())

SPELL_BLACKLIST = {
    # Can't tell the difference between
    # https://www.wowhead.com/wotlk/spell=7745/enchant-2h-weapon-minor-impact
    # https://www.wowhead.com/wotlk/spell=13503/enchant-weapon-lesser-striking
     7745,

    # Can't tell the difference between
    # https://www.wowhead.com/wotlk/spell=13529/enchant-2h-weapon-lesser-impact
    # https://www.wowhead.com/wotlk/spell=13693/enchant-weapon-striking
    13529,

    # Can't tell the difference between
    # https://www.wowhead.com/wotlk/spell=13937/enchant-2h-weapon-greater-impact
    # https://www.wowhead.com/wotlk/spell=27967/enchant-weapon-major-striking
    13937,

    # Can't tell the difference between
    # https://www.wowhead.com/wotlk/spell=13695/enchant-2h-weapon-impact
    # https://www.wowhead.com/wotlk/spell=20031/enchant-weapon-superior-striking
    13695,

    # Can't tell the difference between
    # https://www.wowhead.com/wotlk/spell=23802/enchant-bracer-healing-power
    # https://www.wowhead.com/wotlk/spell=27911/enchant-bracer-superior-healing
    # https://www.wowhead.com/wotlk/spell=27917/enchant-bracer-spellpower
    23802,
    27911,

    # Unused?  Seems like this is the actual enchant:
    # https://www.wowhead.com/wotlk/spell=30260/stabilitzed-eternium-scope
    30255, # https://www.wowhead.com/wotlk/spell=30255/stabilized-eternium-scope
    30258, # https://www.wowhead.com/wotlk/spell=30258/stabilized-eternium-scope

    # Duplicates?
     50903, # https://www.wowhead.com/wotlk/spell=50903/jormungar-leg-reinforcements
     50904, # https://www.wowhead.com/wotlk/spell=50904/nerubian-leg-reinforcements
    359639, # https://www.wowhead.com/wotlk/spell=359639/enchant-bracer-assault
    359640, # https://www.wowhead.com/wotlk/spell=359640/enchant-cloak-stealth
    359641, # https://www.wowhead.com/wotlk/spell=359641/enchant-gloves-superior-agility
    359642, # https://www.wowhead.com/wotlk/spell=359642/enchant-weapon-mighty-spirit
    359685, # https://www.wowhead.com/wotlk/spell=359685/enchant-shield-resistance
    359847, # https://www.wowhead.com/wotlk/spell=359847/enchant-cloak-subtlety
    359858, # https://www.wowhead.com/wotlk/spell=359858/enchant-gloves-threat
    359895, # https://www.wowhead.com/wotlk/spell=359895/enchant-shield-frost-resistance
    359949, # https://www.wowhead.com/wotlk/spell=359949/enchant-cloak-greater-nature-resistance
    359950, # https://www.wowhead.com/wotlk/spell=359950/enchant-cloak-greater-fire-resistance

    # Mounts
    47101, # https://www.wowhead.com/wotlk/spell=47101/test-riding-crop-enchant
    47103, # https://www.wowhead.com/wotlk/spell=47103/riding-crop
    48401, # https://www.wowhead.com/wotlk/spell=48401/carrot-on-a-stick
    48555, # https://www.wowhead.com/wotlk/spell=48555/skybreaker-whip
    48556, # https://www.wowhead.com/wotlk/spell=48556/carrot-on-a-stick
    48557, # https://www.wowhead.com/wotlk/spell=48557/riding-crop

    # Testing
    19927, # https://www.wowhead.com/wotlk/spell=19927/test-enchant-weapon-flame
    44119, # https://www.wowhead.com/wotlk/spell=44119/enchant-bracer-template
    47147, # https://www.wowhead.com/wotlk/spell=47147/test-on-use-enchant
    47242, # https://www.wowhead.com/wotlk/spell=47242/test-on-use-enchant-charges
    47715, # https://www.wowhead.com/wotlk/spell=47715/enchant-template
    48036, # https://www.wowhead.com/wotlk/spell=48036/enchant-chest-test
    50358, # https://www.wowhead.com/wotlk/spell=50358/test-skill-req-enchant
}
ITEM_BLACKLIST = {
    44125, # https://www.wowhead.com/wotlk/item=44125/zzzoldlesser-inscription-of-template-ph
    44126, # https://www.wowhead.com/wotlk/item=44126/zzzoldgreater-inscription-of-template-ph
}

SPELL_NAMES = {int(row["ID"]): row["Name_lang"] for row in get_db("SpellName")}

# Add any spells that start with "QAEnchant " to the blacklist
for spell_id, spell_name in SPELL_NAMES.items():
    if spell_name.startswith("QAEnchant "):
        SPELL_BLACKLIST.add(spell_id)

SPELL_IDS = set(int(row["ID"]) for row in get_db("Spell") if int(row["ID"]) not in SPELL_BLACKLIST)
ITEM_IDS = set(int(row["ID"]) for row in get_db("Item") if int(row["ID"]) not in ITEM_BLACKLIST)

SPELL_ID_TO_INV_TYPES = collections.defaultdict(set)
for row in get_db("SpellEquippedItems"):
    spell_id = int(row["SpellID"])
    allowed_item_class = int(row["EquippedItemClass"])
    allowed_inv_types = int(row["EquippedItemInvTypes"])
    allowed_subclasses = int(row["EquippedItemSubclass"])

    if spell_id not in SPELL_IDS:
        continue
    if allowed_item_class != ITEM_CLASS_WEAPON and allowed_item_class != ITEM_CLASS_ARMOR:
        continue

    if allowed_item_class == ITEM_CLASS_WEAPON:
        SPELL_ID_TO_INV_TYPES[spell_id].update(get_weapon_inventory_types_from_subclass_mask(allowed_subclasses))
    if allowed_item_class == ITEM_CLASS_ARMOR:
        SPELL_ID_TO_INV_TYPES[spell_id].update(get_armor_inventory_types_from_subclass_mask(allowed_subclasses))

    for inv_type_id, inv_type in INVENTORY_TYPES.items():
        if (allowed_inv_types & (1 << inv_type_id)) != 0:
            SPELL_ID_TO_INV_TYPES[spell_id].add(inv_type)

ENCHANT_ID_TO_SPELL_IDS = collections.defaultdict(set)
for row in get_db("SpellEffect"):
    effect = int(row["Effect"])
    enchant_id = int(row["EffectMiscValue_0"])
    spell_id = int(row["SpellID"])

    if spell_id not in SPELL_IDS:
        continue
    if effect != SPELL_EFFECT__EFFECT__ENCHANT_ITEM:
        continue

    # BUG! https://www.wowhead.com/wotlk/spell=27964/enchant-weapon-major-spirit
    # is marked as applying the "Lifestealing" enchant.
    if spell_id == 27964:
        assert enchant_id == 1898
        ENCHANT_ID_TO_SPELL_IDS[1183].add(spell_id)
        ENCHANT_ID_TO_SPELL_IDS[2665].add(spell_id)
        continue

    ENCHANT_ID_TO_SPELL_IDS[enchant_id].add(spell_id)


SPELL_ID_TO_ITEM_IDS = collections.defaultdict(set)
for row in get_db("ItemEffect"):
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

enchants = set()
for row in get_db("SpellItemEnchantment"):
    enchant_id = int(row["ID"])
    for spell_id in ENCHANT_ID_TO_SPELL_IDS[enchant_id]:
        invtypes = set(inv_type for inv_type in SPELL_ID_TO_INV_TYPES[spell_id])
        if not invtypes:
            raise ValueError(spell_id)
        for invtype in invtypes:
            enchant = (enchant_id, invtype)
            if enchant in enchants:
                raise ValueError(spell_id)
            enchants.add(enchant)

ITEM_ID_TO_BUY_PRICE = {}
for row in get_db("ItemSparse"):
    item_id = int(row["ID"])
    buy_price = int(row["BuyPrice"])

    ITEM_ID_TO_BUY_PRICE[item_id] = buy_price

ITEM_ID_TO_FACTION = {}
for row in get_db("ItemSparse"):
    item_id = int(row["ID"])
    faction = int(row["MinFactionID"])

    ITEM_ID_TO_FACTION[item_id] = faction


def get_item_for_spell(spell_id):
    candidates = SPELL_ID_TO_ITEM_IDS.get(spell_id)
    if not candidates:
        return None
    if len(candidates) == 1:
        (item_id,) = SPELL_ID_TO_ITEM_IDS[spell_id]
        return item_id

    candidates = [x for x in candidates if ITEM_ID_TO_FACTION[x] != 0]
    if not candidates:
        return None
    if len(candidates) == 1:
        (item_id,) = candidates
        return item_id

    candidates = [x for x in candidates if ITEM_ID_TO_BUY_PRICE[x] == 0]
    if not candidates:
        return None
    if len(candidates) == 1:
        (item_id,) = candidates
        return item_id

    raise ValueError(candidates)


entries = []
for row in sorted(get_db("SpellItemEnchantment"), key=lambda row: int(row["ID"])):
    enchant_id = int(row["ID"])
    for spell_id in ENCHANT_ID_TO_SPELL_IDS[enchant_id]:
        if spell_id not in SPELL_IDS:
            continue
        item_id = get_item_for_spell(spell_id)
        if item_id:
            link = "item:%d" % item_id
        else:
            link = "spell:%d" % spell_id
        types = set(inv_type for inv_type in SPELL_ID_TO_INV_TYPES[spell_id])
        if not types:
            raise ValueError(spell_id)
        print("-- {}".format(SPELL_NAMES[spell_id]))
        print("Moldy.Enchants:add({}, \"{}\", {{\"{}\"}})".format(enchant_id, link, "\", \"".join(sorted(types))))
