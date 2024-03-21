#!/usr/bin/python3

import collections
import csv
import itertools
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
     59778, # https://www.wowhead.com/wotlk/spell=59778/arcanum-of-dominance
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
    14847, # https://www.wowhead.com/wotlk/spell=14847/test-enchant-fire-weapon
    19927, # https://www.wowhead.com/wotlk/spell=19927/test-enchant-weapon-flame
    44119, # https://www.wowhead.com/wotlk/spell=44119/enchant-bracer-template
    47147, # https://www.wowhead.com/wotlk/spell=47147/test-on-use-enchant
    47242, # https://www.wowhead.com/wotlk/spell=47242/test-on-use-enchant-charges
    47715, # https://www.wowhead.com/wotlk/spell=47715/enchant-template
    48036, # https://www.wowhead.com/wotlk/spell=48036/enchant-chest-test
    50358, # https://www.wowhead.com/wotlk/spell=50358/test-skill-req-enchant
}

ITEM_BLACKLIST = {
    # Don't exist.
    28876, 28877, 28879, 28880, 28883, 28884, 28890, 28891, 28892, 28893, 28894,
    28895, 28896, 28897, 28898, 28899, 28900, 28901, 28902, 34110,

    41605, # https://www.wowhead.com/wotlk/item=41605/zzdeprecated-sanctified-spellthread
    41606, # https://www.wowhead.com/wotlk/item=41606/zzdeprecated-masters-spellthread
    44125, # https://www.wowhead.com/wotlk/item=44125/zzzoldlesser-inscription-of-template-ph
    44126, # https://www.wowhead.com/wotlk/item=44126/zzzoldgreater-inscription-of-template-ph
}

SPELL_NAMES = {int(row["ID"]): row["Name_lang"] for row in get_db("SpellName")}

# Add any spells that start with "QAEnchant " to the blacklist
for spell_id, spell_name in SPELL_NAMES.items():
    if spell_name.startswith("QAEnchant "):
        SPELL_BLACKLIST.add(spell_id)

ITEM_ID_TO_FACTION = {int(row["ID"]): int(row["MinFactionID"]) for row in get_db("ItemSparse")}
ITEM_ID_TO_BUY_PRICE = {int(row["ID"]): int(row["BuyPrice"]) for row in get_db("ItemSparse")}

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

    return output


class SpellEffect:

    EFFECT__ENCHANT_ITEM = 53

    def __init__(self, enchant_id, spell_id, effect):
        self.enchant_id = enchant_id
        self.spell_id = spell_id
        self.effect = effect

    def __lt__(self, other):
        return (self.enchant_id, self.spell_id) < (other.enchant_id, other.spell_id)

    def get_link(self):
        return "spell:%d" % self.spell_id

    @classmethod
    def from_row(cls, row):
        spell_effect = cls(int(row["EffectMiscValue_0"]), int(row["SpellID"]), int(row["Effect"]))

        # BUG! https://www.wowhead.com/wotlk/spell=27964/enchant-weapon-major-spirit
        # is marked as applying the "Lifestealing" enchant.
        if spell_effect.spell_id == 27964:
            assert spell_effect.enchant_id == 1898
            spell_effect.enchant_id = 1183 # or 2665?

        return spell_effect

    @staticmethod
    def get_all():
        return [
            spell_effect for spell_effect
            in (SpellEffect.from_row(row) for row in get_db("SpellEffect"))
            if spell_effect.spell_id not in SPELL_BLACKLIST
            and spell_effect.effect == SpellEffect.EFFECT__ENCHANT_ITEM
        ]


class SpellInventoryTypes:

    def __init__(self, spell_id, inventory_types):
        self.spell_id = spell_id
        self.inventory_types = inventory_types

    @classmethod
    def from_row(cls, row):
        spell_id = int(row["SpellID"])
        allowed_item_class = int(row["EquippedItemClass"])
        allowed_item_subclass_mask = int(row["EquippedItemSubclass"])
        allowed_item_inventory_type_mask = int(row["EquippedItemInvTypes"])

        inventory_types = get_inventory_types(allowed_item_class, allowed_item_subclass_mask, allowed_item_inventory_type_mask)
        return cls(spell_id, inventory_types)

    @staticmethod
    def get_all():
        return {
            spell_inventory_types.spell_id: spell_inventory_types for spell_inventory_types
            in (SpellInventoryTypes.from_row(row) for row in get_db("SpellEquippedItems"))
        }


class SpellItems:

    TRIGGER_TYPE__ON_USE = 0

    def __init__(self, spell_id, item_ids):
        self.spell_id = spell_id
        self.item_ids = item_ids

    def get_link(self):
        if not self.item_ids:
            return "spell:%d" % self.spell_id
        return "item:%d" % self._get_best_item_id()

    def _get_best_item_id(self):
        if len(self.item_ids) == 1:
            (item_id,) = self.item_ids
            return item_id

        factions = {
            ITEM_ID_TO_FACTION[item_id]: item_id for item_id in self.item_ids
            if ITEM_ID_TO_FACTION.get(item_id, 0) != 0
        }
        if factions:
            if len(factions) == 1:
                (item_id,) = factions.values()
                return item_id
            if len(factions) == 2:
                # Arbitrarily pick the Horde version of items.
                if 946 in factions and 947 in factions:
                    return factions[947]
                if 1037 in factions and 1052 in factions:
                    return factions[1052]

        prices = {
            item_id: ITEM_ID_TO_BUY_PRICE.get(item_id, 0) for item_id in self.item_ids
            if ITEM_ID_TO_BUY_PRICE.get(item_id, 0) == 0
        }
        if prices:
            if len(prices) == 1:
                (item_id,) = prices.keys()
                return item_id

        raise ValueError("%d: %s" % (self.spell_id, self.item_ids))

    @classmethod
    def from_row(cls, row):
        return cls(int(row["SpellID"]), int(row["ParentItemID"]), int(row["TriggerType"]))

    @staticmethod
    def get_all():
        mapping = collections.defaultdict(set)
        for row in get_db("ItemEffect"):
            spell_id = int(row["SpellID"])
            item_id = int(row["ParentItemID"])
            trigger_type = int(row["TriggerType"])

            if item_id in ITEM_BLACKLIST:
                continue
            if trigger_type != SpellItems.TRIGGER_TYPE__ON_USE:
                continue

            mapping[spell_id].add(item_id)

        return {spell_id: SpellItems(spell_id, item_ids) for spell_id, item_ids in mapping.items()}


def assert_no_duplicate_enchants(spell_effects, spell_inventory_types):
    enchants = set()
    for spell_effect in spell_effects:
        invtypes = spell_inventory_types[spell_effect.spell_id].inventory_types
        if not invtypes:
            raise ValueError(spell_effect.spell_id)
        for invtype in invtypes:
            enchant = (spell_effect.enchant_id, invtype)
            if enchant in enchants:
                raise ValueError(spell_effect.spell_id)
            enchants.add(enchant)


def get_link(spell_effect, spell_item):
    if not spell_item:
        return spell_effect.get_link()
    return spell_item.get_link()


def main(args):
    spell_effects = SpellEffect.get_all()
    spell_inventory_types = SpellInventoryTypes.get_all()
    spell_items = SpellItems.get_all()
    assert_no_duplicate_enchants(spell_effects, spell_inventory_types)

    for spell_effect in sorted(spell_effects):
        link = get_link(spell_effect, spell_items.get(spell_effect.spell_id))
        types = spell_inventory_types[spell_effect.spell_id].inventory_types
        print("-- {}".format(SPELL_NAMES[spell_effect.spell_id]))
        print("Moldy.Enchants:add({}, \"{}\", {{\"{}\"}})".format(spell_effect.enchant_id, link, "\", \"".join(sorted(types))))


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
