-- TODO: Disambiguate enchants that have the same text (and therefore appear multiple times in this table).
local map = {
    [24]   = { [INVSLOT_CHEST]    = "item:38769" },
    [41]   = { [INVSLOT_CHEST]    = "item:38766",
               [INVSLOT_WRIST]    = "item:38679" },
    [44]   = { [INVSLOT_CHEST]    = "item:38767" },
    [63]   = { [INVSLOT_CHEST]    = "item:38798" },
    [65]   = { [INVSLOT_BACK]     = "item:38770" },
    [66]   = { [INVSLOT_FEET]     = "item:38785",
               [INVSLOT_WRIST]    = "item:38771",
               [INVSLOT_OFFHAND]  = "item:38787" },
    [241]  = { [INVSLOT_MAINHAND] = "item:38794",
               [INVSLOT_OFFHAND]  = "item:38794" },  -- also: https://www.wowhead.com/wotlk/item=38772/scroll-of-enchant-2h-weapon-minor-impact
    [242]  = { [INVSLOT_CHEST]    = "item:38773" },
    -- [243]  = { ["*"] = "spell:7766" },
    -- [246]  = { ["*"] = "spell:7776" },
    [247]  = { [INVSLOT_BACK]     = "item:38789",
               [INVSLOT_WRIST]    = "item:38777",
               [INVSLOT_FEET]     = "item:38786" },
    -- [248]  = { ["*"] = "spell:7782" },
    -- [249]  = { ["*"] = "spell:7786" },
    -- [250]  = { ["*"] = "spell:7788" },
    -- [254]  = { ["*"] = "spell:7857" },
    -- [255]  = { ["*"] = "spell:13380" },
    -- [255]  = { ["*"] = "spell:13485" },
    -- [255]  = { ["*"] = "spell:13687" },
    -- [255]  = { ["*"] = "spell:7859" },
    -- [256]  = { ["*"] = "spell:7861" },
    -- [368]  = { ["*"] = "spell:34004" },
    -- [369]  = { ["*"] = "spell:34001" },
    -- [684]  = { ["*"] = "spell:33995" },
    -- [723]  = { ["*"] = "spell:13622" },
    -- [723]  = { ["*"] = "spell:7793" },
    -- [724]  = { ["*"] = "spell:13501" },
    -- [724]  = { ["*"] = "spell:13631" },
    -- [724]  = { ["*"] = "spell:13644" },
    -- [744]  = { ["*"] = "spell:13421" },
    -- [783]  = { ["*"] = "spell:7771" },
    [803]  = { [INVSLOT_MAINHAND] = "item:38838",
               [INVSLOT_OFFHAND]  = "item:38838" },
    -- [804]  = { ["*"] = "spell:13522" },
    -- [805]  = { ["*"] = "spell:13943" },
    -- [823]  = { ["*"] = "spell:13536" },
    -- [843]  = { ["*"] = "spell:13607" },
    -- [844]  = { ["*"] = "spell:13612" },
    -- [845]  = { ["*"] = "spell:13617" },
    [846]  = { [INVSLOT_HAND]     = "item:50816",
               [INVSLOT_MAINHAND] = "item:19971" },
    -- [847]  = { ["*"] = "spell:13626" },
    -- [848]  = { ["*"] = "spell:13464" },
    -- [848]  = { ["*"] = "spell:13635" },
    -- [849]  = { ["*"] = "spell:13637" },
    -- [849]  = { ["*"] = "spell:13882" },
    -- [850]  = { ["*"] = "spell:13640" },
    -- [851]  = { ["*"] = "spell:13642" },
    -- [851]  = { ["*"] = "spell:13659" },
    -- [851]  = { ["*"] = "spell:20024" },
    -- [852]  = { ["*"] = "spell:13648" },
    -- [852]  = { ["*"] = "spell:13817" },
    -- [852]  = { ["*"] = "spell:13836" },
    -- [853]  = { ["*"] = "spell:13653" },
    -- [854]  = { ["*"] = "spell:13655" },
    -- [856]  = { ["*"] = "spell:13661" },
    -- [856]  = { ["*"] = "spell:13887" },
    -- [857]  = { ["*"] = "spell:13663" },
    -- [863]  = { ["*"] = "spell:13689" },
    -- [865]  = { ["*"] = "spell:13698" },
    -- [866]  = { ["*"] = "spell:13700" },
    -- [884]  = { ["*"] = "spell:13746" },
    -- [903]  = { ["*"] = "spell:13794" },
    -- [904]  = { ["*"] = "spell:13815" },
    -- [904]  = { ["*"] = "spell:13935" },
    -- [905]  = { ["*"] = "spell:13822" },
    -- [906]  = { ["*"] = "spell:13841" },
    -- [907]  = { ["*"] = "spell:13846" },
    -- [907]  = { ["*"] = "spell:13905" },
    -- [908]  = { ["*"] = "spell:13858" },
    -- [909]  = { ["*"] = "spell:13868" },
    -- [910]  = { ["*"] = "spell:25083" },
    [911]  = { [INVSLOT_FEET]     = "item:38837" },
    -- [912]  = { ["*"] = "spell:13915" },
    -- [913]  = { ["*"] = "spell:13917" },
    -- [923]  = { ["*"] = "spell:13931" },
    -- [924]  = { ["*"] = "spell:7428" },
    -- [925]  = { ["*"] = "spell:13646" },
    -- [926]  = { ["*"] = "spell:13933" },
    -- [927]  = { ["*"] = "spell:13939" },
    -- [927]  = { ["*"] = "spell:20013" },
    -- [928]  = { ["*"] = "spell:13941" },
    -- [929]  = { ["*"] = "spell:13945" },
    -- [929]  = { ["*"] = "spell:20017" },
    -- [929]  = { ["*"] = "spell:20020" },
    -- [930]  = { ["*"] = "spell:13947" },
    -- [931]  = { ["*"] = "spell:13948" },
    -- [943]  = { ["*"] = "spell:13529" },
    -- [943]  = { ["*"] = "spell:13693" },
    -- [963]  = { ["*"] = "spell:13937" },
    -- [963]  = { ["*"] = "spell:27967" },
    [983]  = { [INVSLOT_FEET]     = "item:38976",
               [INVSLOT_BACK]     = "item:38959" },
    -- [1071] = { ["*"] = "spell:34009" },
    [1075] = { [INVSLOT_FEET]     = "item:38966" },
    [1099] = { [INVSLOT_BACK]     = "item:44457" },
    -- [1103] = { ["*"] = "spell:44633" },
    -- [1119] = { ["*"] = "spell:44555" },
    [1128] = { [INVSLOT_OFFHAND]  = "item:44455" },
    [1144] = { [INVSLOT_CHEST]    = "item:38928" },
    [1147] = { [INVSLOT_FEET]     = "item:38961",
               [INVSLOT_WRIST]    = "item:38980" },
    -- [1257] = { ["*"] = "spell:34005" },
    -- [1262] = { ["*"] = "spell:44596" },
    -- [1354] = { ["*"] = "spell:44556" },
    -- [1400] = { ["*"] = "spell:44494" },
    -- [1441] = { ["*"] = "spell:34006" },
    -- [1446] = { ["*"] = "spell:44590" },
    -- [1593] = { ["*"] = "spell:34002" },
    -- [1594] = { ["*"] = "spell:33996" },
    [1597] = { [INVSLOT_FEET]     = "item:44469" },
    [1600] = { [INVSLOT_WRIST]    = "item:38971" },
    -- [1603] = { ["*"] = "item:44458" },
    -- [1606] = { ["*"] = "spell:60621" },
    [1883] = { [INVSLOT_WRIST]    = "item:38852" },
    -- [1884] = { ["*"] = "spell:20009" },
    -- [1885] = { ["*"] = "spell:20010" },
    -- [1886] = { ["*"] = "spell:20011" },
    -- [1887] = { ["*"] = "spell:20012" },
    -- [1887] = { ["*"] = "spell:20023" },
    -- [1888] = { ["*"] = "spell:20014" },
    [1888] = { [INVSLOT_BACK]     = "item:38858",
               [INVSLOT_OFFHAND]  = "item:38907" },
    -- [1889] = { ["*"] = "spell:20015" },
    -- [1890] = { ["*"] = "spell:20016" },
    -- [1891] = { ["*"] = "spell:20025" },
    [1891] = { [INVSLOT_CHEST]    = "item:38865",
               [INVSLOT_WRIST]    = "item:38898" },
    -- [1892] = { ["*"] = "spell:20026" },
    -- [1893] = { ["*"] = "spell:20028" },
    -- [1894] = { ["*"] = "spell:20029" },
    -- [1896] = { ["*"] = "spell:20030" },
    -- [1897] = { ["*"] = "spell:13695" },
    -- [1897] = { ["*"] = "spell:20031" },
    -- [1898] = { ["*"] = "spell:20032" },
    -- [1899] = { ["*"] = "spell:20033" },
    [1900] = { [INVSLOT_MAINHAND] = "item:38873",
               [INVSLOT_OFFHAND]  = "item:38873" },
    -- [1903] = { ["*"] = "spell:20035" },
    -- [1904] = { ["*"] = "spell:20036" },
    [1951] = { [INVSLOT_BACK]     = "item:38978" },
    -- [1951] = { ["*"] = "item:38999" },
    [1952] = { [INVSLOT_OFFHAND]  = "item:38954" },
    [1953] = { [INVSLOT_CHEST]    = "item:39002" },
    -- [2322] = { ["*"] = "spell:33999" },
    [2326] = { [INVSLOT_WRIST]    = "item:38997" },
    [2332] = { [INVSLOT_WRIST]    = "item:44470" },
    [2381] = { [INVSLOT_CHEST]    = "item:38962" },
    -- [2443] = { ["*"] = "spell:21931" },
    -- [2463] = { ["*"] = "spell:13657" },
    -- [2504] = { ["*"] = "spell:22749" },
    -- [2505] = { ["*"] = "spell:22750" },
    -- [2563] = { ["*"] = "spell:23799" },
    -- [2564] = { ["*"] = "spell:23800" },
    [2564] = { [INVSLOT_HAND]     = "item:38890",
               [INVSLOT_MAINHAND] = "item:38880",
               [INVSLOT_OFFHAND]  = "item:38880" },
    -- [2565] = { ["*"] = "spell:23801" },
    -- [2567] = { ["*"] = "spell:23803" },
    -- [2568] = { ["*"] = "spell:23804" },
    -- [2603] = { ["*"] = "spell:13620" },
    [2613] = { [INVSLOT_HAND]     = "item:38885" },
    -- [2614] = { ["*"] = "spell:25073" },
    -- [2615] = { ["*"] = "spell:25074" },
    -- [2616] = { ["*"] = "spell:25078" },
    -- [2617] = { ["*"] = "spell:25079" },
    -- [2619] = { ["*"] = "spell:25081" },
    -- [2620] = { ["*"] = "spell:25082" },
    [2621] = { [INVSLOT_BACK]     = "item:38894" },
    [2622] = { [INVSLOT_BACK]     = "item:38895" },
    -- [2646] = { ["*"] = "spell:27837" },
    -- [2647] = { ["*"] = "spell:27899" },
    -- [2648] = { ["*"] = "spell:27906" },
    -- [2648] = { ["*"] = "spell:47051" },
    [2649] = { [INVSLOT_WRIST]    = "item:38902",
               [INVSLOT_FEET]     = "item:38909" },
    -- [2650] = { [INVSLOT_WRIST]    = "item:38882" },
    -- [2650] = { [INVSLOT_WRIST]    = "item:38900" },
    [2650] = { [INVSLOT_WRIST]    = "item:38903" },
    -- [2653] = { ["*"] = "spell:27944" },
    -- [2654] = { ["*"] = "spell:27945" },
    -- [2655] = { ["*"] = "spell:27946" },
    -- [2656] = { ["*"] = "spell:27948" },
    -- [2657] = { ["*"] = "spell:27951" },
    -- [2658] = { ["*"] = "spell:27954" },
    [2659] = { [INVSLOT_CHEST]    = "item:38911" },
    [2661] = { [INVSLOT_CHEST]    = "item:38913",
               [INVSLOT_WRIST]    = "item:38987" },
    -- [2662] = { ["*"] = "item:38914" },
    -- [2664] = { ["*"] = "spell:27962" },
    -- [2666] = { ["*"] = "item:38918" },
    -- [2667] = { ["*"] = "spell:27971" },
    -- [2668] = { ["*"] = "spell:27972" },
    [2669] = { [INVSLOT_MAINHAND] = "item:38921",
               [INVSLOT_OFFHAND]  = "item:38921" },
    -- [2670] = { ["*"] = "spell:27977" },
    -- [2671] = { ["*"] = "spell:27981" },
    -- [2672] = { ["*"] = "spell:27982" },
    -- [2673] = { ["*"] = "item:38925" },
    -- [2674] = { ["*"] = "spell:28003" },
    -- [2675] = { ["*"] = "spell:28004" },
    [2679] = { [INVSLOT_WRIST]    = "item:38901" },
    [2723] = { [INVSLOT_RANGED]   = "item:23765" },
    [2746] = { [INVSLOT_LEGS]     = "item:24276" },
    [2748] = { [INVSLOT_LEGS]     = "item:24274" },
    -- [2928] = { ["*"] = "spell:27924" },
    -- [2929] = { ["*"] = "spell:27920" },
    -- [2930] = { ["*"] = "spell:27926" },
    -- [2931] = { ["*"] = "spell:27927" },
    -- [2933] = { ["*"] = "spell:33992" },
    -- [2934] = { ["*"] = "spell:33993" },
    -- [2935] = { ["*"] = "spell:33994" },
    -- [2937] = { ["*"] = "spell:33997" },
    -- [2938] = { ["*"] = "spell:34003" },
    -- [2939] = { ["*"] = "spell:34007" },
    -- [2940] = { ["*"] = "spell:34008" },
    [2978] = { [INVSLOT_SHOULDER] = "item:28889" },
    -- [2986] = { ["*"] = "item:28888" },
    [2995] = { [INVSLOT_SHOULDER] = "item:28909" },
    -- [2997] = { ["*"] = "item:28910" },
    [2999] = { [INVSLOT_HEAD]     = "item:29186" },
    [3002] = { [INVSLOT_HEAD]     = "item:29191" },
    [3003] = { [INVSLOT_HEAD]     = "item:29192" },
    [3011] = { [INVSLOT_LEGS]     = "item:29534" },
    -- [3013] = { ["*"] = "item:29536" },
    -- [3150] = { ["*"] = "spell:33991" },
    [3222] = { [INVSLOT_HAND]     = "item:38967",
               [INVSLOT_MAINHAND] = "item:38947",
               [INVSLOT_OFFHAND]  = "item:38947" },    
    -- [3225] = { ["*"] = "spell:42974" },
    -- [3229] = { ["*"] = "spell:44383" },
    -- [3230] = { ["*"] = "spell:44483" },
    [3231] = { [INVSLOT_HAND]     = "spell:44484",
               [INVSLOT_WRIST]    = "spell:44598" },
    -- [3232] = { ["*"] = "item:39006" },
    -- [3233] = { ["*"] = "spell:27958" },
    [3234] = { [INVSLOT_HAND]     = "item:38953" },
    -- [3236] = { ["*"] = "spell:44492" },
    -- [3238] = { ["*"] = "spell:44506" },
    -- [3239] = { ["*"] = "spell:44524" },
    -- [3241] = { ["*"] = "spell:44576" },
    -- [3243] = { ["*"] = "spell:44582" },
    [3244] = { [INVSLOT_FEET]     = "item:38974" },
    -- [3245] = { ["*"] = "spell:44588" },
    [3246] = { [INVSLOT_HAND]     = "item:38979" },
    -- [3247] = { ["*"] = "spell:44595" },
    -- [3249] = { ["*"] = "spell:44612" },
    -- [3251] = { ["*"] = "spell:44621" },
    [3252] = { [INVSLOT_CHEST]    = "item:38989" },
    [3253] = { [INVSLOT_HAND]     = "item:38990" },
    -- [3256] = { ["*"] = "spell:44631" },
    -- [3273] = { ["*"] = "spell:46578" },
    [3294] = { [INVSLOT_BACK]     = "item:39001" },
    -- [3296] = { ["*"] = "spell:47899" },
    [3297] = { [INVSLOT_CHEST]    = "item:39005" },
    [3326] = { [INVSLOT_LEGS]     = "item:38372" },
    [3330] = { [INVSLOT_HEAD]     = "item:38376",
               [INVSLOT_CHEST]    = "item:38376",
               [INVSLOT_SHOULDER] = "item:38376",
               [INVSLOT_LEGS]     = "item:38376",
               [INVSLOT_HAND]     = "item:38376",
               [INVSLOT_FEET]     = "item:38376" },
    -- [3365] = { ["*"] = "spell:53323" },
    [3368] = { [INVSLOT_MAINHAND] = "spell:53344",
               [INVSLOT_OFFHAND]  = "spell:53344" },
    [3370] = { [INVSLOT_MAINHAND] = "spell:53343",
               [INVSLOT_OFFHAND]  = "spell:53343" },
    [3594] = { [INVSLOT_MAINHAND] = "spell:54446",
               [INVSLOT_OFFHAND]  = "spell:54446" },
    [3599] = { [INVSLOT_WAIST]    = "spell:54736" },
    [3601] = { [INVSLOT_WAIST]    = "spell:54793" },
    [3604] = { [INVSLOT_HAND]     = "spell:54999" },
    [3605] = { [INVSLOT_BACK]     = "item:41111" },
    [3606] = { [INVSLOT_FEET]     = "item:41118" },
    -- [3608] = { ["*"] = "item:41167" },
    [3719] = { [INVSLOT_LEGS]     = "item:41602" },
    [3721] = { [INVSLOT_LEGS]     = "item:41604" },
    [3722] = { [INVSLOT_BACK]     = "spell:55642" },
    [3730] = { [INVSLOT_CHEST]    = "spell:55777" },
    -- [3756] = { ["*"] = "item:43097" },
    [3758] = { [INVSLOT_WRIST]    = "spell:57691" },
    [3788] = { [INVSLOT_MAINHAND] = "item:44497",
               [INVSLOT_OFFHAND]  = "item:44497" },
    [3789] = { [INVSLOT_MAINHAND] = "item:44493",
               [INVSLOT_OFFHAND]  = "item:44493" },
    [3790] = { [INVSLOT_MAINHAND] = "item:43987",
               [INVSLOT_OFFHAND]  = "item:43987" },
    -- [3791] = { ["*"] = "spell:59636" },
    [3797] = { [INVSLOT_HEAD]     = "item:44075" },
    [3809] = { [INVSLOT_SHOULDER] = "item:50336" },
    [3808] = { [INVSLOT_SHOULDER] = "item:50335" },
    [3810] = { [INVSLOT_SHOULDER] = "item:50338" },
    [3811] = { [INVSLOT_SHOULDER] = "item:50337" },
    [3817] = { [INVSLOT_HEAD]     = "item:50367" },
    [3818] = { [INVSLOT_HEAD]     = "item:50369" },
    [3819] = { [INVSLOT_HEAD]     = "item:50370" },
    [3820] = { [INVSLOT_HEAD]     = "item:50368" },
    [3822] = { [INVSLOT_LEGS]     = "item:38373" },
    [3823] = { [INVSLOT_LEGS]     = "item:38374" },
    [3824] = { [INVSLOT_FEET]     = "item:44449" },
    [3825] = { [INVSLOT_BACK]     = "item:44456" },
    [3826] = { [INVSLOT_FEET]     = "item:38986" },
    [3827] = { [INVSLOT_MAINHAND] = "item:44463",
               [INVSLOT_OFFHAND]  = "item:44463" },
    [3828] = { [INVSLOT_MAINHAND] = "item:38992",
               [INVSLOT_OFFHAND]  = "item:38992" },
    [3829] = { [INVSLOT_HAND]     = "item:38964" },
    -- [3830] = { ["*"] = "item:38991" },
    [3831] = { [INVSLOT_BACK]     = "item:39003" },
    [3832] = { [INVSLOT_CHEST]    = "item:44465" },
    -- [3833] = { ["*"] = "spell:60707" },
    [3834] = { [INVSLOT_MAINHAND] = "item:44467",
               [INVSLOT_OFFHAND]  = "item:44467" },
    -- [3835] = { ["*"] = "spell:61117" },
    [3838] = { [INVSLOT_SHOULDER] = "spell:61120" },
    -- [3839] = { ["*"] = "spell:44645" },
    [3840] = { [INVSLOT_FINGER1]  = "spell:44636",
               [INVSLOT_FINGER2]  = "spell:44636" },
    -- [3843] = { ["*"] = "item:44739" },
    -- [3844] = { ["*"] = "spell:44510" },
    [3845] = { [INVSLOT_WRIST]    = "item:44815" },
    -- [3846] = { ["*"] = "spell:34010" },
    [3847] = { [INVSLOT_MAINHAND] = "spell:62158",
               [INVSLOT_OFFHAND]  = "spell:62158" },
    [3849] = { [INVSLOT_OFFHAND]  = "item:44936" },
    [3850] = { [INVSLOT_WRIST]    = "item:44947" },
    -- [3851] = { ["*"] = "spell:62257" },
    [3852] = { [INVSLOT_SHOULDER] = "item:44957" },
    [3854] = { [INVSLOT_MAINHAND] = "item:45056" },
    [3855] = { [INVSLOT_MAINHAND] = "item:45060",
               [INVSLOT_OFFHAND]  = "item:45060" },
    -- [3858] = { ["*"] = "spell:63746" },
    [3859] = { [INVSLOT_BACK]     = "spell:63765" },
    [3860] = { [INVSLOT_HAND]     = "spell:63770" },
    [3869] = { [INVSLOT_MAINHAND] = "item:46026",
               [INVSLOT_OFFHAND]  = "item:46026" },
    -- [3870] = { ["*"] = "spell:64579" },
    [3872] = { [INVSLOT_LEGS]     = "spell:56039" },
    [3873] = { [INVSLOT_LEGS]     = "spell:56034" },
    -- [3878] = { ["*"] = "spell:67839" },
    -- [3883] = { ["*"] = "spell:70164" },
}

function Moldy.GetItemEnchantId(itemLink)
    local enchantId = string.match(itemLink, "item:%d+:(%d+):")
    return enchantId and tonumber(enchantId)
end

function Moldy.GetEnchantSourceLink(enchantId, slot)
    local value = map[enchantId]
    if not value or not value[slot] then
        Moldy:Printf("Unknown enchant %d in slot %d", enchantId, slot)
        return nil
    end
    return value[slot]
end