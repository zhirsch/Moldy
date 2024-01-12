local _, _, _, tocversion = GetBuildInfo()

local function IsClassic()
    return tocversion >= 10000 and tocversion < 20000
end

local function IsTBC()
    return tocversion >= 20000 and tocversion < 30000
end

local Scrolls = {}
if IsClassic() or IsTBC() then
    Scrolls = {
        ["item:38770"] = "spell:7454",
        ["item:38771"] = "spell:7457",
        ["item:38773"] = "spell:7748",
        ["item:38786"] = "spell:7867",
        ["item:38789"] = "spell:13419",
        ["item:38794"] = "spell:13503",
        ["item:38797"] = "spell:13536",
        ["item:38804"] = "spell:13626",
        ["item:38817"] = "spell:7782",
    }
end

local Enchants
Enchants = {
    new = function()
        local self = { map = {} }
        local cls  = { __index = Enchants.prototype }
        return setmetatable(self, cls)
    end,
}
Enchants.prototype = {
    add = function(self, enchantId, link, predicate)
        local enchants = GetOrCreateTableEntry(self.map, enchantId, {})
        table.insert(enchants, {
            link      = Scrolls[link] or link,
            predicate = predicate or function(...) return true end,
        })
    end,
    get = function(self, link, slot)
        local enchantId = string.match(link, "item:%d+:(%d+):")
        if not enchantId then return nil end
        local enchants = GetOrCreateTableEntry(self.map, tonumber(enchantId), {})
        local _, enchant = FindInTableIf(enchants, function(e) return e.predicate(link, slot) end)
        if not enchant then
            Moldy:Printf("Unknown enchant %s in slot %d on item %s", enchantId, slot, link)
            return "enchant:"..enchantId
        end
        return enchant.link
    end,
}


Moldy.Enchants = Enchants.new()
--[[
Moldy.Enchants.map = {
    [ 243] = { ["*"] = "spell:7766"  },
    [ 246] = { ["*"] = "spell:7776"  },
    [ 249] = { ["*"] = "spell:7786"  },
    [ 250] = { ["*"] = "spell:7788"  },
    [ 254] = { ["*"] = "spell:7857"  },
    [ 255] = { ["*"] = "spell:13380" },
    [ 255] = { ["*"] = "spell:13485" },
    [ 255] = { ["*"] = "spell:13687" },
    [ 255] = { ["*"] = "spell:7859"  },
    [ 256] = { ["*"] = "spell:7861"  },
    [ 368] = { ["*"] = "spell:34004" },
    [ 369] = { ["*"] = "spell:34001" },
    [ 684] = { ["*"] = "spell:33995" },
    [ 723] = { ["*"] = "spell:13622" },
    [ 723] = { ["*"] = "spell:7793"  },
    [ 724] = { ["*"] = "spell:13501" },
    [ 724] = { ["*"] = "spell:13631" },
    [ 724] = { ["*"] = "spell:13644" },
    [ 744] = { ["*"] = "spell:13421" },
    [ 783] = { ["*"] = "spell:7771"  },
    [ 804] = { ["*"] = "spell:13522" },
    [ 805] = { ["*"] = "spell:13943" },
    [ 843] = { ["*"] = "spell:13607" },
    [ 844] = { ["*"] = "spell:13612" },
    [ 845] = { ["*"] = "spell:13617" },
    [ 848] = { ["*"] = "spell:13464" },
    [ 848] = { ["*"] = "spell:13635" },
    [ 849] = { ["*"] = "spell:13637" },
    [ 849] = { ["*"] = "spell:13882" },
    [ 850] = { ["*"] = "spell:13640" },
    [ 851] = { ["*"] = "spell:13642" },
    [ 851] = { ["*"] = "spell:13659" },
    [ 851] = { ["*"] = "spell:20024" },
    [ 852] = { ["*"] = "spell:13648" },
    [ 852] = { ["*"] = "spell:13817" },
    [ 852] = { ["*"] = "spell:13836" },
    [ 853] = { ["*"] = "spell:13653" },
    [ 854] = { ["*"] = "spell:13655" },
    [ 856] = { ["*"] = "spell:13661" },
    [ 856] = { ["*"] = "spell:13887" },
    [ 857] = { ["*"] = "spell:13663" },
    [ 863] = { ["*"] = "spell:13689" },
    [ 865] = { ["*"] = "spell:13698" },
    [ 866] = { ["*"] = "spell:13700" },
    [ 884] = { ["*"] = "spell:13746" },
    [ 903] = { ["*"] = "spell:13794" },
    [ 904] = { ["*"] = "spell:13815" },
    [ 904] = { ["*"] = "spell:13935" },
    [ 905] = { ["*"] = "spell:13822" },
    [ 906] = { ["*"] = "spell:13841" },
    [ 907] = { ["*"] = "spell:13846" },
    [ 907] = { ["*"] = "spell:13905" },
    [ 908] = { ["*"] = "spell:13858" },
    [ 909] = { ["*"] = "spell:13868" },
    [ 910] = { ["*"] = "spell:25083" },
    [ 912] = { ["*"] = "spell:13915" },
    [ 913] = { ["*"] = "spell:13917" },
    [ 923] = { ["*"] = "spell:13931" },
    [ 924] = { ["*"] = "spell:7428"  },
    [ 925] = { ["*"] = "spell:13646" },
    [ 926] = { ["*"] = "spell:13933" },
    [ 927] = { ["*"] = "spell:13939" },
    [ 927] = { ["*"] = "spell:20013" },
    [ 928] = { ["*"] = "spell:13941" },
    [ 929] = { ["*"] = "spell:13945" },
    [ 929] = { ["*"] = "spell:20017" },
    [ 929] = { ["*"] = "spell:20020" },
    [ 930] = { ["*"] = "spell:13947" },
    [ 931] = { ["*"] = "spell:13948" },
    [ 943] = { ["*"] = "spell:13529" },
    [ 943] = { ["*"] = "spell:13693" },
    [ 963] = { ["*"] = "spell:13937" },
    [ 963] = { ["*"] = "spell:27967" },
    [1071] = { ["*"] = "spell:34009" },
    [1103] = { ["*"] = "spell:44633" },
    [1119] = { ["*"] = "spell:44555" },
    [1257] = { ["*"] = "spell:34005" },
    [1262] = { ["*"] = "spell:44596" },
    [1354] = { ["*"] = "spell:44556" },
    [1400] = { ["*"] = "spell:44494" },
    [1441] = { ["*"] = "spell:34006" },
    [1446] = { ["*"] = "spell:44590" },
    [1593] = { ["*"] = "spell:34002" },
    [1594] = { ["*"] = "spell:33996" },
    [1603] = { ["*"] = "item:44458"  },
    [1606] = { ["*"] = "spell:60621" },
    [1884] = { ["*"] = "spell:20009" },
    [1885] = { ["*"] = "spell:20010" },
    [1886] = { ["*"] = "spell:20011" },
    [1887] = { ["*"] = "spell:20012" },
    [1887] = { ["*"] = "spell:20023" },
    [1888] = { ["*"] = "spell:20014" },
    [1889] = { ["*"] = "spell:20015" },
    [1890] = { ["*"] = "spell:20016" },
    [1891] = { ["*"] = "spell:20025" },
    [1892] = { ["*"] = "spell:20026" },
    [1893] = { ["*"] = "spell:20028" },
    [1894] = { ["*"] = "spell:20029" },
    [1896] = { ["*"] = "spell:20030" },
    [1897] = { ["*"] = "spell:13695" },
    [1897] = { ["*"] = "spell:20031" },
    [1898] = { ["*"] = "spell:20032" },
    [1899] = { ["*"] = "spell:20033" },
    [1903] = { ["*"] = "spell:20035" },
    [1904] = { ["*"] = "spell:20036" },
    [1951] = { ["*"] = "item:38999"  },
    [2322] = { ["*"] = "spell:33999" },
    [2443] = { ["*"] = "spell:21931" },
    [2463] = { ["*"] = "spell:13657" },
    [2504] = { ["*"] = "spell:22749" },
    [2505] = { ["*"] = "spell:22750" },
    [2563] = { ["*"] = "spell:23799" },
    [2564] = { ["*"] = "spell:23800" },
    [2565] = { ["*"] = "spell:23801" },
    [2567] = { ["*"] = "spell:23803" },
    [2568] = { ["*"] = "spell:23804" },
    [2603] = { ["*"] = "spell:13620" },
    [2614] = { ["*"] = "spell:25073" },
    [2615] = { ["*"] = "spell:25074" },
    [2616] = { ["*"] = "spell:25078" },
    [2617] = { ["*"] = "spell:25079" },
    [2619] = { ["*"] = "spell:25081" },
    [2620] = { ["*"] = "spell:25082" },
    [2646] = { ["*"] = "spell:27837" },
    [2647] = { ["*"] = "spell:27899" },
    [2648] = { ["*"] = "spell:27906" },
    [2648] = { ["*"] = "spell:47051" },
    [2650] = { [INVSLOT_WRIST] = "item:38882" },
    [2650] = { [INVSLOT_WRIST] = "item:38900" },
    [2653] = { ["*"] = "spell:27944" },
    [2654] = { ["*"] = "spell:27945" },
    [2655] = { ["*"] = "spell:27946" },
    [2656] = { ["*"] = "spell:27948" },
    [2657] = { ["*"] = "spell:27951" },
    [2658] = { ["*"] = "spell:27954" },
    [2662] = { ["*"] = "item:38914"  },
    [2664] = { ["*"] = "spell:27962" },
    [2666] = { ["*"] = "item:38918"  },
    [2667] = { ["*"] = "spell:27971" },
    [2668] = { ["*"] = "spell:27972" },
    [2670] = { ["*"] = "spell:27977" },
    [2671] = { ["*"] = "spell:27981" },
    [2672] = { ["*"] = "spell:27982" },
    [2673] = { ["*"] = "item:38925"  },
    [2674] = { ["*"] = "spell:28003" },
    [2675] = { ["*"] = "spell:28004" },
    [2928] = { ["*"] = "spell:27924" },
    [2929] = { ["*"] = "spell:27920" },
    [2930] = { ["*"] = "spell:27926" },
    [2931] = { ["*"] = "spell:27927" },
    [2933] = { ["*"] = "spell:33992" },
    [2934] = { ["*"] = "spell:33993" },
    [2935] = { ["*"] = "spell:33994" },
    [2937] = { ["*"] = "spell:33997" },
    [2938] = { ["*"] = "spell:34003" },
    [2939] = { ["*"] = "spell:34007" },
    [2940] = { ["*"] = "spell:34008" },
    [2986] = { ["*"] = "item:28888"  },
    [2997] = { ["*"] = "item:28910"  },
    [3013] = { ["*"] = "item:29536"  },
    [3150] = { ["*"] = "spell:33991" },
    [3225] = { ["*"] = "spell:42974" },
    [3229] = { ["*"] = "spell:44383" },
    [3232] = { ["*"] = "item:39006"  },
    [3233] = { ["*"] = "spell:27958" },
    [3236] = { ["*"] = "spell:44492" },
    [3238] = { ["*"] = "spell:44506" },
    [3239] = { ["*"] = "spell:44524" },
    [3241] = { ["*"] = "spell:44576" },
    [3243] = { ["*"] = "spell:44582" },
    [3245] = { ["*"] = "spell:44588" },
    [3247] = { ["*"] = "spell:44595" },
    [3249] = { ["*"] = "spell:44612" },
    [3251] = { ["*"] = "spell:44621" },
    [3256] = { ["*"] = "spell:44631" },
    [3273] = { ["*"] = "spell:46578" },
    [3296] = { ["*"] = "spell:47899" },
    [3365] = { ["*"] = "spell:53323" },
    [3608] = { ["*"] = "item:41167"  },
    [3756] = { ["*"] = "item:43097"  },
    [3791] = { ["*"] = "spell:59636" },
    [3830] = { ["*"] = "item:38991"  },
    [3833] = { ["*"] = "spell:60707" },
    [3835] = { ["*"] = "spell:61117" },
    [3839] = { ["*"] = "spell:44645" },
    [3843] = { ["*"] = "item:44739"  },
    [3844] = { ["*"] = "spell:44510" },
    [3846] = { ["*"] = "spell:34010" },
    [3851] = { ["*"] = "spell:62257" },
    [3858] = { ["*"] = "spell:63746" },
    [3870] = { ["*"] = "spell:64579" },
    [3878] = { ["*"] = "spell:67839" },
    [3883] = { ["*"] = "spell:70164" },
}
]]

local function Or(...)
    local predicates = {...}
    return function(...)
        for _, predicate in ipairs(predicates) do
            if predicate(...) then
                return true
            end
        end
        return false
    end
end

local function Slot(allowed)
    return function(link, slot) return allowed == slot end
end

local function IsTwoHandedWeapon(link, slot)
    return false
end

Moldy.Enchants:add(  16, "item:2313")
Moldy.Enchants:add(  17, "item:4265")
Moldy.Enchants:add(  24, "item:38769")
Moldy.Enchants:add(  41, "item:38679",  Slot(INVSLOT_WRIST))
Moldy.Enchants:add(  41, "item:38766",  Slot(INVSLOT_CHEST))
Moldy.Enchants:add(  44, "item:38767")
Moldy.Enchants:add(  63, "item:38798")
Moldy.Enchants:add(  65, "item:38770")
Moldy.Enchants:add(  66, "item:38771",  Slot(INVSLOT_WRIST))
Moldy.Enchants:add(  66, "item:38785",  Slot(INVSLOT_FEET))
Moldy.Enchants:add(  66, "item:38787",  Slot(INVSLOT_OFFHAND))
Moldy.Enchants:add( 241, "item:38772",  IsTwoHandedWeapon)
Moldy.Enchants:add( 241, "item:38794")
Moldy.Enchants:add( 242, "item:38773")
Moldy.Enchants:add( 247, "item:38777",  Slot(INVSLOT_WRIST))
Moldy.Enchants:add( 247, "item:38786",  Slot(INVSLOT_FEET))
Moldy.Enchants:add( 247, "item:38789",  Slot(INVSLOT_BACK))
Moldy.Enchants:add( 248, "item:38817")
Moldy.Enchants:add( 803, "item:38838")
Moldy.Enchants:add( 823, "item:38797")
Moldy.Enchants:add( 846, "item:19971",  Slot(INVSLOT_MAINHAND))
Moldy.Enchants:add( 846, "item:50816",  Slot(INVSLOT_HAND))
Moldy.Enchants:add( 847, "item:38804")
Moldy.Enchants:add( 911, "item:38837")
Moldy.Enchants:add( 983, "item:38959",  Slot(INVSLOT_BACK))
Moldy.Enchants:add( 983, "item:38976",  Slot(INVSLOT_FEET))
Moldy.Enchants:add(1075, "item:38966")
Moldy.Enchants:add(1099, "item:44457")
Moldy.Enchants:add(1128, "item:44455")
Moldy.Enchants:add(1144, "item:38928")
Moldy.Enchants:add(1147, "item:38961",  Slot(INVSLOT_FEET))
Moldy.Enchants:add(1147, "item:38980",  Slot(INVSLOT_WRIST))
Moldy.Enchants:add(1597, "item:44469")
Moldy.Enchants:add(1600, "item:38971")
Moldy.Enchants:add(1883, "item:38852")
Moldy.Enchants:add(1888, "item:38858",  Slot(INVSLOT_BACK))
Moldy.Enchants:add(1888, "item:38907",  Slot(INVSLOT_OFFHAND))
Moldy.Enchants:add(1891, "item:38865",  Slot(INVSLOT_CHEST))
Moldy.Enchants:add(1891, "item:38898",  Slot(INVSLOT_WRIST))
Moldy.Enchants:add(1900, "item:38873")
Moldy.Enchants:add(1951, "item:38978")
Moldy.Enchants:add(1952, "item:38954")
Moldy.Enchants:add(1953, "item:39002")
Moldy.Enchants:add(2326, "item:38997")
Moldy.Enchants:add(2332, "item:44470")
Moldy.Enchants:add(2381, "item:38962")
Moldy.Enchants:add(2564, "item:38880",  Or(Slot(INVSLOT_MAINHAND), Slot(INVSLOT_OFFHAND)))
Moldy.Enchants:add(2564, "item:38890",  Slot(INVSLOT_HAND))
Moldy.Enchants:add(2613, "item:38885")
Moldy.Enchants:add(2621, "item:38894")
Moldy.Enchants:add(2622, "item:38895")
Moldy.Enchants:add(2649, "item:38902",  Slot(INVSLOT_WRIST))
Moldy.Enchants:add(2649, "item:38909",  Slot(INVSLOT_FEET))
Moldy.Enchants:add(2650, "item:38903")
Moldy.Enchants:add(2659, "item:38911")
Moldy.Enchants:add(2661, "item:38913",  Slot(INVSLOT_CHEST))
Moldy.Enchants:add(2661, "item:38987",  Slot(INVSLOT_WRIST))
Moldy.Enchants:add(2669, "item:38921")
Moldy.Enchants:add(2679, "item:38901")
Moldy.Enchants:add(2723, "item:23765")
Moldy.Enchants:add(2746, "item:24276")
Moldy.Enchants:add(2748, "item:24274")
Moldy.Enchants:add(2978, "item:28889")
Moldy.Enchants:add(2995, "item:28909")
Moldy.Enchants:add(2999, "item:29186")
Moldy.Enchants:add(3002, "item:29191")
Moldy.Enchants:add(3003, "item:29192")
Moldy.Enchants:add(3011, "item:29534")
Moldy.Enchants:add(3222, "item:38947",  Or(Slot(INVSLOT_MAINHAND), Slot(INVSLOT_OFFHAND)))
Moldy.Enchants:add(3222, "item:38967",  Slot(INVSLOT_HAND))
Moldy.Enchants:add(3230, "item:38950")
Moldy.Enchants:add(3231, "item:38951")
Moldy.Enchants:add(3231, "item:38984")
Moldy.Enchants:add(3234, "item:38953")
Moldy.Enchants:add(3244, "item:38974")
Moldy.Enchants:add(3246, "item:38979")
Moldy.Enchants:add(3252, "item:38989")
Moldy.Enchants:add(3253, "item:38990")
Moldy.Enchants:add(3294, "item:39001")
Moldy.Enchants:add(3297, "item:39005")
Moldy.Enchants:add(3326, "item:38372")
Moldy.Enchants:add(3330, "item:38376")
Moldy.Enchants:add(3368, "spell:53344")
Moldy.Enchants:add(3370, "spell:53343")
Moldy.Enchants:add(3594, "spell:54446")
Moldy.Enchants:add(3599, "spell:54736")
Moldy.Enchants:add(3601, "spell:54793")
Moldy.Enchants:add(3604, "spell:54999")
Moldy.Enchants:add(3605, "item:41111")
Moldy.Enchants:add(3606, "item:41118")
Moldy.Enchants:add(3719, "item:41602")
Moldy.Enchants:add(3721, "item:41604")
Moldy.Enchants:add(3722, "spell:55642")
Moldy.Enchants:add(3730, "spell:55777")
Moldy.Enchants:add(3758, "spell:57691")
Moldy.Enchants:add(3788, "item:44497")
Moldy.Enchants:add(3789, "item:44493")
Moldy.Enchants:add(3790, "item:43987")
Moldy.Enchants:add(3797, "item:44075")
Moldy.Enchants:add(3808, "item:50335")
Moldy.Enchants:add(3809, "item:50336")
Moldy.Enchants:add(3810, "item:50338")
Moldy.Enchants:add(3811, "item:50337")
Moldy.Enchants:add(3812, "item:44884")
Moldy.Enchants:add(3817, "item:50367")
Moldy.Enchants:add(3818, "item:50369")
Moldy.Enchants:add(3819, "item:50370")
Moldy.Enchants:add(3820, "item:50368")
Moldy.Enchants:add(3822, "item:38373")
Moldy.Enchants:add(3823, "item:38374")
Moldy.Enchants:add(3824, "item:44449")
Moldy.Enchants:add(3825, "item:44456")
Moldy.Enchants:add(3826, "item:38986")
Moldy.Enchants:add(3827, "item:44463")
Moldy.Enchants:add(3828, "item:38992")
Moldy.Enchants:add(3829, "item:38964")
Moldy.Enchants:add(3831, "item:39003")
Moldy.Enchants:add(3832, "item:44465")
Moldy.Enchants:add(3834, "item:44467")
Moldy.Enchants:add(3838, "spell:61120")
Moldy.Enchants:add(3840, "spell:44636")
Moldy.Enchants:add(3845, "item:44815")
Moldy.Enchants:add(3847, "spell:62158")
Moldy.Enchants:add(3849, "item:44936")
Moldy.Enchants:add(3850, "item:44947")
Moldy.Enchants:add(3852, "item:44957")
Moldy.Enchants:add(3854, "item:45056")
Moldy.Enchants:add(3855, "item:45060")
Moldy.Enchants:add(3859, "spell:63765")
Moldy.Enchants:add(3860, "spell:63770")
Moldy.Enchants:add(3869, "item:46026")
Moldy.Enchants:add(3872, "spell:56039")
Moldy.Enchants:add(3873, "spell:56034")
