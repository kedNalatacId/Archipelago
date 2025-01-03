local socket = require("socket")
local json = require('json')
local math = require('math')
require("common")


local zones = {
    [6300]  = "ST0", -- 0x189c
    [34564] = "ARE", -- 0x8704
    [46804] = "CAT", -- 0xb6d4
    [3708]  = "CEN", -- 0x0e7C
    [56996] = "CHI", -- 0xdea4
    [24504] = "DAI", -- 0x5fb8
    [28608] = "DRE", -- 0x6fc0
    [61792] = "LIB", -- 0xf160
    [14264] = "NO0", -- 0x37B8
    [6688]  = "NO1", -- 0x1a20
    [34628] = "NO2", -- 0x8744
    [6268]  = "NO3", -- 0x187c
    [37100] = "NP3", -- 0x90ec
    [42528] = "NO4", -- 0xa620
    [38148] = "NZ0", -- 0x9504
    [50960] = "NZ1", -- 0xc710
    [54880] = "TOP", -- 0xd660
    [33304] = "WRP", -- 0x8218
    [27504] = "RARE", -- 0x6b70
    [16256] = "RCAT", -- 0x3f80
    [1180]  = "RCEN", -- 0x049c
    [44068] = "RCHI", -- 0xac24
    [18012] = "RDAI", -- 0x465c
    [11152] = "RLIB", -- 0x2b90
    [29524] = "RNO0", -- 0x7354
    [40140] = "RNO1", -- 0x9ccc
    [27936] = "RNO2", -- 0x6d20
    [16096] = "RNO3", -- 0x3ee0
    [41492] = "RNO4", -- 0xA214
    [52276] = "RNZ0", -- 0xcc34
    [52944] = "RNZ1", -- 0xced0
    [9508]  = "RTOP", -- 0x2524
    [41368] = "RWRP", -- 0xa198
    [49420] = "BO0", -- 0xc10c
    [21968] = "BO1", -- 0x55d0
    [30368] = "BO2", -- 0x76a0
    [26420] = "BO3", -- 0x6734
    [27116] = "BO4", -- 0x69ec
    [27620] = "BO5", -- 0x6be4
    [39812] = "BO6", -- 0x9b84
    [26232] = "BO7", -- 0x6678
    [41108] = "RBO0", -- 0xa094
    [20852] = "RBO1", -- 0x5174
    [6832]  = "RBO2", -- 0x1ab0
    [12744] = "RBO3", -- 0x31c8
    [36412] = "RBO4", -- 0x8e3c
    [22816] = "RBO5", -- 0x5920
    [21740] = "RBO6", -- 0x54ec
    [24324] = "RBO7", -- 0x5f04
    [40392] = "RBO8", -- 0x9dc8
}

local allItems = {
    { "Monster vial 1", 0x09798B }, { "Monster vial 2", 0x09798C }, { "Monster vial 3", 0x09798D }, { "Shield rod", 0x09798E }, { "Leather shield", 0x09798F }, { "Knight shield", 0x097990 },
    { "Iron shield", 0x097991 }, { "AxeLord shield", 0x097992 }, { "Herald shield", 0x097993 }, { "Dark shield", 0x097994 }, { "Goddess shield", 0x097995 }, { "Shaman shield", 0x097996 },
    { "Medusa shield", 0x097997 }, { "Skull shield", 0x097998 }, { "Fire shield", 0x097999 }, { "Alucard shield", 0x09799A }, { "Sword of dawn", 0x09799B }, { "Basilard", 0x09799C },
    { "Short sword", 0x09799D }, { "Combat knife", 0x09799E }, { "Nunchaku", 0x09799F }, { "Were bane", 0x0979A0 }, { "Rapier", 0x0979A1 }, { "Karma coin", 0x0979A2 }, { "Magic missile", 0x0979A3 },
    { "Red rust", 0x0979A4 }, { "Takemitsu", 0x0979A5 }, { "Shotel", 0x0979A6 }, { "Orange", 0x0979A7 }, { "Apple", 0x0979A8 }, { "Banana", 0x0979A9 }, { "Grapes", 0x0979AA }, { "Strawberry", 0x0979AB },
    { "Pineapple", 0x0979AC }, { "Peanuts", 0x0979AD }, { "Toadstool", 0x0979AE }, { "Shiitake", 0x0979AF }, { "Cheesecake", 0x0979B0 }, { "Shortcake", 0x0979B1 }, { "Tart", 0x0979B2 }, { "Parfait", 0x0979B3 },
    { "Pudding", 0x0979B4 }, { "Ice cream", 0x0979B5 }, { "Frankfurter", 0x0979B6 }, { "Hamburger", 0x0979B7 }, { "Pizza", 0x0979B8 }, { "Cheese", 0x0979B9 }, { "Ham and eggs", 0x0979BA },
    { "Omelette", 0x0979BB }, { "Morning set", 0x0979BC }, { "Lunch A", 0x0979BD }, { "Lunch B", 0x0979BE }, { "Curry rice", 0x0979BF }, { "Gyros plate", 0x0979C0 }, { "Spaghetti", 0x0979C1 },
    { "Grape juice", 0x0979C2 }, { "Barley tea", 0x0979C3 }, { "Green tea", 0x0979C4 }, { "Natou", 0x0979C5 }, { "Ramen", 0x0979C6 }, { "Miso soup", 0x0979C7 }, { "Sushi", 0x0979C8 }, { "Pork bun", 0x0979C9 },
    { "Red bean bun", 0x0979CA }, { "Chinese bun", 0x0979CB }, { "Dim sum set", 0x0979CC }, { "Pot roast", 0x0979CD }, { "Sirloin", 0x0979CE }, { "Turkey", 0x0979CF }, { "Meal ticket", 0x0979D0 },
    { "Neutron bomb", 0x0979D1 }, { "Power of Sire", 0x0979D2 }, { "Pentagram", 0x0979D3 }, { "Bat Pentagram", 0x0979D4 }, { "Shuriken", 0x0979D5 }, { "Cross shuriken", 0x0979D6 }, { "Buffalo star", 0x0979D7 },
    { "Flame star", 0x0979D8 }, { "TNT", 0x0979D9 }, { "Bwaka knife", 0x0979DA }, { "Boomerang", 0x0979DB }, { "Javelin", 0x0979DC }, { "Tyrfing", 0x0979DD }, { "Namakura", 0x0979DE },
    { "Knuckle duster", 0x0979DF }, { "Gladius", 0x0979E0 }, { "Scimitar", 0x0979E1 }, { "Cutlass", 0x0979E2 }, { "Saber", 0x0979E3 }, { "Falchion", 0x0979E4 }, { "Broadsword", 0x0979E5 },
    { "Bekatowa", 0x0979E6 }, { "Damascus sword", 0x0979E7 }, { "Hunter sword", 0x0979E8 }, { "Estoc", 0x0979E9 }, { "Bastard sword", 0x0979EA }, { "Jewel knuckles", 0x0979EB }, { "Claymore", 0x0979EC },
    { "Talwar", 0x0979ED }, { "Katana", 0x0979EE }, { "Flamberge", 0x0979EF }, { "Iron Fist", 0x0979F0 }, { "Zwei hander", 0x0979F1 }, { "Sword of hador", 0x0979F2 }, { "Luminus", 0x0979F3 },
    { "Harper", 0x0979F4 }, { "Obsidian sword", 0x0979F5 }, { "Gram", 0x0979F6 }, { "Jewel sword", 0x0979F7 }, { "Mormegil", 0x0979F8 }, { "Firebrand", 0x0979F9 }, { "Thunderbrand", 0x0979FA },
    { "Icebrand", 0x0979FB }, { "Stone sword", 0x0979FC }, { "Holy sword", 0x0979FD }, { "Terminus est", 0x0979FE }, { "Marsil", 0x0979FF }, { "Dark blade", 0x097A00 }, { "Heaven sword", 0x097A01 },
    { "Fist of Tulkas", 0x097A02 }, { "Gurthang", 0x097A03 }, { "Mourneblade", 0x097A04 }, { "Alucard sword", 0x097A05 }, { "Mablung sword", 0x097A06 }, { "Badelaire", 0x097A07 }, { "Sword familiar", 0x097A08 },
    { "Great sword", 0x097A09 }, { "Mace", 0x097A0A }, { "Morningstar", 0x097A0B }, { "Holy rod", 0x097A0C }, { "Star flail", 0x097A0D }, { "Moon rod", 0x097A0E }, { "Chakram", 0x097A0F },
    { "Fire boomerang", 0x097A10 }, { "Iron ball", 0x097A11 }, { "Holbein dagger", 0x097A12 }, { "Blue knuckles", 0x097A13 }, { "Dynamite", 0x097A14 }, { "Osafune katana", 0x097A15 }, { "Masamune", 0x097A16 },
    { "Muramasa", 0x097A17 }, { "Heart refresh", 0x097A18 }, { "Runesword", 0x097A19 }, { "Antivenom", 0x097A1A }, { "Uncurse", 0x097A1B }, { "Life apple", 0x097A1C }, { "Hammer", 0x097A1D },
    { "Str. potion", 0x097A1E }, { "Luck potion", 0x097A1F }, { "Smart potion", 0x097A20 }, { "Attack potion", 0x097A21 }, { "Shield potion", 0x097A22 }, { "Resist fire", 0x097A23 },
    { "Resist thunder", 0x097A24 }, { "Resist ice", 0x097A25 }, { "Resist stone", 0x097A26 }, { "Resist holy", 0x097A27 }, { "Resist dark", 0x097A28 }, { "Potion", 0x097A29 }, { "High potion", 0x097A2A },
    { "Elixir", 0x097A2B }, { "Manna prism", 0x097A2C }, { "Vorpal blade", 0x097A2D }, { "Crissaegrim", 0x097A2E }, { "Yasutsuna", 0x097A2F }, { "Library card", 0x097A30 },
    { "Alucart shield", 0x097A31 }, { "Alucart sword", 0x097A32 },
    -- As soon as a sparse array is started, must keep indexing each entry or else it breaks :(
    [170] = { "Cloth tunic", 0x097A34 }, [171] = { "Hide cuirass", 0x097A35 }, [172] = { "Bronze cuirass", 0x097A36 }, [173] = { "Iron cuirass", 0x097A37 }, [174] = { "Steel cuirass", 0x097A38 },
    [175] = { "Silver plate", 0x097A39 }, [176] = { "Gold plate", 0x097A3A }, [177] = { "Platinum mail", 0x097A3B }, [178] = { "Diamond plate", 0x097A3C }, [179] = { "Fire mail", 0x097A3D },
    [180] = { "Lightning mail", 0x097A3E }, [181] = { "Ice mail", 0x097A3F }, [182] = { "Mirror cuirass", 0x097A40 }, [183] = { "Spike breaker", 0x097A41 }, [184] = { "Alucard mail", 0x097A42 },
    [185] = { "Dark armor", 0x097A43 }, [186] = { "Healing mail", 0x097A44 }, [187] = { "Holy mail", 0x097A45 }, [188] = { "Walk armor", 0x097A46 }, [189] = { "Brilliant mail", 0x097A47 },
    [190] = { "Mojo mail", 0x097A48 }, [191] = { "Fury plate", 0x097A49 }, [192] = { "Dracula tunic", 0x097A4A }, [193] = { "God's garb", 0x097A4B }, [194] = { "Axe Lord armor", 0x097A4C },
    -- missingNo
    [196] = { "Sunglasses", 0x097A4E }, [197] = { "Ballroom mask", 0x097A4F }, [198] = { "Bandanna", 0x097A50 }, [199] = { "Felt hat", 0x097A51 }, [200] = { "Velvet hat", 0x097A52 },
    [201] = { "Goggles", 0x097A53 }, [202] = { "Leather hat", 0x097A54 }, [203] = { "Holy glasses", 0x097A55 }, [204] = { "Steel helm", 0x097A56 }, [205] = { "Stone mask", 0x097A57 },
    [206] = { "Circlet", 0x097A58 }, [207] = { "Gold circlet", 0x097A59 }, [208] = { "Ruby circlet", 0x097A5A }, [209] = { "Opal circlet", 0x097A5B }, [210] = { "Topaz circlet", 0x097A5C },
    [211] = { "Beryl circlet", 0x097A5D }, [212] = { "Cat-eye circl.", 0x097A5E }, [213] = { "Coral circlet", 0x097A5F }, [214] = { "Dragon helm", 0x097A60 }, [215] = { "Silver crown", 0x097A61 },
    [216] = { "Wizard hat", 0x097A62 },
    -- missingNo
    [218] = { "Cloth cape", 0x097A64 }, [219] = { "Reverse cloak", 0x097A65 }, [220] = { "Elven cloak", 0x097A66 }, [221] = { "Crystal cloak", 0x097A67 }, [222] = { "Royal cloak", 0x097A68 },
    [223] = { "Blood cloak", 0x097A69 }, [224] = { "Joseph's cloak", 0x097A6A }, [225] = { "Twilight cloak", 0x097A6B }, [227] = { "Moonstone", 0x097A6D }, [228] = { "Sunstone", 0x097A6E },
    [229] = { "Bloodstone", 0x097A6F }, [230] = { "Staurolite", 0x097A70 }, [231] = { "Ring of pales", 0x097A71 }, [232] = { "Zircon", 0x097A72 }, [233] = { "Aquamarine", 0x097A73 },
    [234] = { "Turquoise", 0x097A74 }, [235] = { "Onyx", 0x097A75 }, [236] = { "Garnet", 0x097A76 }, [237] = { "Opal", 0x097A77 }, [238] = { "Diamond", 0x097A78 }, [239] = { "Lapis lazuli", 0x097A79 },
    [240] = { "Ring of ares", 0x097A7A }, [241] = { "Gold ring", 0x097A7B }, [242] = { "Silver ring", 0x097A7C }, [243] = { "Ring of varda", 0x097A7D }, [244] = { "Ring of arcana", 0x097A7E },
    [245] = { "Mystic pendant", 0x097A7F }, [246] = { "Heart broach", 0x097A80 }, [247] = { "Necklace of j", 0x097A81 }, [248] = { "Gauntlet", 0x097A82 }, [249] = { "Ankh of life", 0x097A83 },
    [250] = { "Ring of feanor", 0x097A84 }, [251] = { "Medal", 0x097A85 }, [252] = { "Talisman", 0x097A86 }, [253] = { "Duplicator", 0x097A87 }, [254] = { "King's stone", 0x097A88 },
    [255] = { "Covenant stone", 0x097A89 }, [256] = { "Nauglamir", 0x097A8A }, [257] = { "Secret boots", 0x097A8B }, [258] = { "Alucart mail", 0x097a8c },
    -- break before relics
    [300] = { "Soul of bat", 0x097964 }, [301] = { "Fire of bat", 0x097965 }, [302] = { "Echo of bat", 0x097966 }, [303] = { "Force of echo", 0x097967 }, [304] = { "Soul of wolf", 0x097968 },
    [305] = { "Power of wolf", 0x097969 }, [306] = { "Skill of wolf", 0x09796A }, [307] = { "Form of mist", 0x09796B }, [308] = { "Power of mist", 0x09796C }, [309] = { "Gas cloud", 0x09796D },
    [310] = { "Cube of zoe", 0x09796E }, [311] = { "Spirit orb", 0x09796F }, [312] = { "Gravity boots", 0x097970 }, [313] = { "Leap stone", 0x097971 }, [314] = { "Holy symbol", 0x097972 },
    [315] = { "Faerie scroll", 0x097973 }, [316] = { "Jewel of open", 0x097974 }, [317] = { "Merman statue", 0x097975 }, [318] = { "Bat card", 0x097976 }, [319] = { "Ghost card", 0x097977 },
    [320] = { "Faerie card", 0x097978 }, [321] = { "Demon card", 0x097979 }, [322] = { "Sword card", 0x09797A }, [325] = { "Heart of vlad", 0x09797D }, [326] = { "Tooth of vlad", 0x09797E },
    [327] = { "Rib of vlad", 0x09797F }, [328] = { "Ring of vlad", 0x097980 }, [329] = { "Eye of vlad", 0x097981 },
    -- vessels
    [412] = { "Heart Vessel", 0x000001 }, [423] = { "Life Vessel", 0x000001 }
}

-- 1 game connect / 2 in-game / 4 on Richter
-- 8 just left STO / 10 Alucard / 20 just died
local last_status = 0

local cur_zone = "UNKNOWN"
local dracula_dead = false
local dracula_timer = 0
local just_died = false
local first_connect = true
local not_patched = true

local player_name = ""
local seed = ""

local STATE_OK = "Ok"
local STATE_TENTATIVELY_CONNECTED = "Tentatively Connected"
local STATE_INITIAL_CONNECTION_MADE = "Initial Connection Made"
local STATE_UNINITIALIZED = "Uninitialized"

local SCRIPT_VERSION = 1

local ItemsReceived = {}
local MsgReceived = {}
local need_to_organize = false
local have_read_last_received = false
local have_drawn = false
local skipped = false
local last_item_processed = 1
local last_processed_read = 1024
local num_item_processed = 0
local start_item_drawing = 0
local delay_timer = 0
local checked_locations = {}
local all_location_table = {}
local last_found_percent = 0
local bosses = {}

local prevstate = ""
local curstate =  STATE_UNINITIALIZED
local sotnSocket = nil
local frame = 0
local saved_in_room = false

function getCurrZone()
    local z = mainmemory.read_u16_le(0x180000)

    if zones[z] == cur_zone then
        return
    end

    if zones[z] then
        cur_zone = zones[z]
    else
        cur_zone = "UNKNOWN"
    end
end

function checkVictory(f)
    if just_died then
        dracula_timer = 0
        return
    end

    if dracula_timer == 0 then
        dracula_timer = f
    end

    -- Shaft/Dracula share hp. Give some time to Dracula HP is loaded on memory
    if dracula_timer > 0 and f - dracula_timer > 500 then
        local cur_hp = mainmemory.read_u16_le(0x076ed6)
        if cur_hp == 0 or cur_hp > 60000 then
            dracula_dead = true
        end
    end
end

function get_item_by_id(item_id)
    if item_id == nil then
        console.log("get item by id -- Error num_id is nil")
        return
    end

    local name    = allItems[item_id][1]
    local address = allItems[item_id][2]

    return name, address
end

-- synctactic sugar function
function get_itemname_by_id(item_id)
    local name, addy = get_item_by_id(item_id)
    if name == nil then
        return
    end

    return name
end

-- synctactic sugar function
function get_itemaddress_by_id(item_id)
    local name, addy = get_item_by_id(item_id)
    if addy == nil then
        return
    end

    return addy
end

function grant_item_byid(num_id)
    if num_id == nil then
        console.log("Grant item by id -- Error num_id is nil")
        return
    end
    local itemid = tonumber(num_id)

    local address = get_itemaddress_by_id(itemid)
    if address == nil or address == 0 then
        if itemid ~= nil then
            console.log("Item " .. num_id .. " not found!")
        else
            console.log("Item nil not found!")
        end
        return
    end

    if itemid >= 300 and itemid < 400 then
        relic_value = mainmemory.read_u8(address)
        if relic_value == 0 or relic_value == 2 or relic_value > 3 then
            if itemid >= 318 and itemid <= 322 then
                mainmemory.write_u8(address, 1)
            else
                mainmemory.write_u8(address, 3)
            end
        end
    elseif itemid > 400 then
        if itemid == 423 then
            max_hp = mainmemory.read_u32_le(0x097ba4)
            max_hp = max_hp + 5
            mainmemory.write_u32_le(0x097ba4, max_hp)
            mainmemory.write_u32_le(0x097ba0, max_hp)
        elseif itemid == 412 then
            max_heart = mainmemory.read_u32_le(0x097bac)
            max_heart = max_heart + 5
            mainmemory.write_u32_le(0x097bac, max_heart)
        end
    else
        local quipped = item_equipped(itemid)
        local itemqty = mainmemory.read_u8(address)
        if itemqty + quipped < 255 then
            itemqty = itemqty + 1
        end
        -- WIP - if we organize when have something equipped it does weird things
        if itemqty == 1 and quipped == 0 then
            organize_inventory(itemid)
            -- TODO
            -- need_to_organize = true
        end

        mainmemory.write_u8(address, itemqty)
    end
end

-- RightHandSlot = 0x097C00;
-- LeftHandSlot = 0x097C04;
-- HelmSlot = 0x097C08;
-- ArmorSlot = 0x097C0C;
-- CloakSlot = 0x097C10;
-- AccessorySlot1 = 0x097C14;
-- AccessorySlot2 = 0x097C18;
function item_equipped(itemid)
    local addend = 0

    for ma=0x097C00, 0x097C18, 0x000004 do
        if mainmemory.read_u8(ma) == itemid then
            addend = addend + 1
        end
    end

    return addend
end

function organize_inventory(item_id)
    max_index = 0
    start_address = 0
    item_offset = 0
    start_byte = 0x00

    if item_id > 0 and item_id <= 168 then --hand
        start_address = 0x097a8d
        qty_start_address = 0x09798a
        max_index = 168
    elseif (item_id > 168 and item_id <= 194) or item_id == 258 then --chest 258 Alucart mail
        start_address = 0x097b36
        qty_start_address = 0x097a33
        max_index = 27
        item_offset = 169
    elseif item_id > 195 and item_id <= 216 then --helm
        start_address = 0x097b50
        qty_start_address = 0x097a4d
        max_index = 21
        item_offset = 195
        start_byte = 0x1a
    elseif item_id > 217 and item_id <= 225 then --cloak
        start_address = 0x097b66
        qty_start_address = 0x097a63
        max_index = 8
        item_offset = 217
        start_byte = 0x30
    elseif item_id > 226 and item_id <= 257 then --trinket
        start_address = 0x097b6f
        qty_start_address = 0x097a6c
        max_index = 31
        item_offset = 226
        start_byte = 0x39
    end

    -- Find the first empty slot
    for i = 1, max_index, 1 do
        address = start_address + i
        old_byte = mainmemory.read_u8(address)
        qty_address = qty_start_address + old_byte - start_byte

        if mainmemory.read_u8(qty_address) == 0 then
            new_value = item_id - item_offset + start_byte
            for j = i, max_index, 1 do
                new_address = start_address + j
                if mainmemory.read_u8(new_address) == new_value then
                    mainmemory.write_u8(address, new_value)
                    mainmemory.write_u8(new_address, old_byte)
                    break
                end
            end
            break
        end
    end
end

function on_loadstate()
    all_location_table = checkAllLocations(0)
    first_connect = false
--  just_died = false
--  dracula_timer = 0
    console.log("Loaded state.")
end

function check_death()
    if cur_zone == "UNKNOWN" then
        return
    end

    hp = mainmemory.read_u32_le(0x097ba0)
    if not just_died and hp <= 0 then
        just_died = true
    end
end

function checkSavedRecently(room)
    -- Check to see if we're in a save room. this bitmap entry is true if we are.
-- local val = mainmemory.read_u16_le(0x03d8fc)
-- console.log("reading animation value: " .. val)
-- console.log("reading animation value (is it 0xcf4c?): " .. string.format('0x%X', val))
    if mainmemory.read_u16_le(0x03C708) & 0x20 == 0x20 then
        -- Read the memory location of entity slot 24 (zero-offset).
        -- Empirically, that slot is _always_ the save orb/coffin entity.
        -- Specifically, pull the AnimationSet (per SOTNAPI).
        -- If the animationset is 0xcf4c, then we're in the post-save coffin animation.
        -- If we're in a save room and there's a coffin, we just saved.
        if mainmemory.read_u16_le(0x03d8fc) == 0xcf4c then
            local room = mainmemory.read_u16_le(0x1375bc)
            if room ~= 0x321c then -- and we're not in nightmare.
                return true
            end
        end
    end

    return false
end

function processBlock(block)
    if block == nil then
        return
    end

    -- Check for player/seed before processing items (filename is based on both)
    if block["player"] ~= nil then
        if player_name == "" then
            player_name = tostring(block["player"])
        end
    end

    if block["seed_name"] ~= nil then
        if seed == "" then
            seed = tostring(block["seed_name"])
        end
    end

    -- NOT YET USED
    local msgBlock = block['messages']
    if msgBlock ~= nil and next(msgBlock) ~= nil then
        for i, v in pairs(msgBlock) do
            table.insert(MsgReceived, v)
--          console.log("Received message: " .. v)
        end
    end

    local itemsBlock = block["items"]
    local skip_x = 0
    if have_read_last_received == false then
        skip_x = read_last_received()
        last_item_processed = skip_x
    end
    if itemsBlock ~= nil and get_table_size(itemsBlock) > get_table_size(ItemsReceived) then
        local low_end = get_table_size(ItemsReceived)
        if skipped == false and have_read_last_received then
            low_end = skip_x
            skipped = true
        end
        for key = low_end, get_table_size(itemsBlock) do
            if ItemsReceived[key] == nil then
                grant_item_byid(itemsBlock[key])
            end
        end
        ItemsReceived = itemsBlock
    end

    -- NOT YET USED
    local checkedLocationsBlock = block["checked_locations"]
    if checkedLocationsBlock ~= nil then
    -- if checkedLocationsBlock ~= nil and next(checkedLocationsBlock) ~= nil then
        checked_locations = checkedLocationsBlock
    end
end

function send()
    local retTable = {}
    retTable["scriptVersion"] = SCRIPT_VERSION
    retTable["locations"] = all_location_table
    retTable["bosses"] = bosses

    msg = json.encode(retTable).."\n"
    local ret, error = sotnSocket:send(msg)
    if ret == nil then
console.log("error in send")
        print(error)
    elseif curstate == STATE_INITIAL_CONNECTION_MADE then
        curstate = STATE_TENTATIVELY_CONNECTED
    elseif curstate == STATE_TENTATIVELY_CONNECTED then
        print("Connected!")
        curstate = STATE_OK
    end
end

function receive()
    l, e = sotnSocket:receive()

    if e == 'closed' then
        if curstate == STATE_OK then
            print("Connection closed")
        end
        curstate = STATE_UNINITIALIZED
        return
    elseif e == 'timeout' then
        return
    elseif e ~= nil then
        print(e)
        curstate = STATE_UNINITIALIZED
        return
    end

    if l ~= nil then
        processBlock(json.decode(l))
    end
end

function checkARE(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03bf06)
    checks["ARE - Heart Vessel"] = bit.check(flag, 0)
    checks["ARE - Shield rod"] = bit.check(flag, 1)
    checks["ARE - Blood cloak"] = bit.check(flag, 3)
    checks["ARE - Knight shield(Chapel passage)"] = bit.check(flag, 4)
    checks["ARE - Library card"] = bit.check(flag, 5)
    checks["ARE - Green tea"] = bit.check(flag, 6)
    checks["ARE - Holy sword(Hidden attic)"] = bit.check(flag, 7)
    if mainmemory.read_u16_le(0x03ca38) ~= 0 then
        checks["ARE - Minotaurus/Werewolf kill"] = true
    else
        checks["ARE - Minotaurus/Werewolf kill"] = false
    end
    if cur_zone == "ARE" then
        if room == 0x2e90 then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 222)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 135)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Form of Mist"] = true
            end
        end
    end

    return checks
end

function checkCAT(room)
    local checks = {}
    --local flag = mainmemory.read_u32_le(0x03befc)
    local flag = mainmemory.read_u24_le(0x03befc)
    checks["CAT - Cat-eye circl."] = bit.check(flag, 0)
    checks["CAT - Icebrand"] = bit.check(flag, 1)
    checks["CAT - Walk armor"] = bit.check(flag, 2)
    checks["CAT - Mormegil"] = bit.check(flag, 3)
    checks["CAT - Library card(Spike breaker)"] = bit.check(flag, 4)
    checks["CAT - Heart Vessel(Ballroom mask)"] = bit.check(flag, 6)
    checks["CAT - Ballroom mask"] = bit.check(flag, 7)
    checks["CAT - Bloodstone"] = bit.check(flag, 8)
    checks["CAT - Life Vessel(Crypt)"] = bit.check(flag, 9)
    checks["CAT - Heart Vessel(Crypt)"] = bit.check(flag, 10)
    checks["CAT - Cross shuriken 1(Spike breaker)"] = bit.check(flag, 11)
    checks["CAT - Cross shuriken 2(Spike breaker)"] = bit.check(flag, 12)
    checks["CAT - Karma coin 1(Spike breaker)"] = bit.check(flag, 13)
    checks["CAT - Karma coin 2(Spike breaker)"] = bit.check(flag, 14)
    checks["CAT - Pork bun"] = bit.check(flag, 15)
    checks["CAT - Spike breaker"] = bit.check(flag, 16)
    checks["CAT - Monster vial 3 1(Sarcophagus)"] = bit.check(flag, 17)
    checks["CAT - Monster vial 3 2(Sarcophagus)"] = bit.check(flag, 18)
    checks["CAT - Monster vial 3 3(Sarcophagus)"] = bit.check(flag, 19)
    checks["CAT - Monster vial 3 4(Sarcophagus)"] = bit.check(flag, 20)
    if mainmemory.read_u16_le(0x03ca34) ~= 0 then
        checks["CAT - Legion kill"] = true
    else
        checks["CAT - Legion kill"] = false
    end

    return checks
end

function checkCHI(room)
    local checks = {}
    -- local flag = mainmemory.read_u32_le(0x03bf02)
    local flag = mainmemory.read_u16_le(0x03bf02)
    checks["CHI - Power of sire(Demon)"] = bit.check(flag, 0)
    checks["CHI - Karma coin"] = bit.check(flag, 1)
    checks["CHI - Ring of ares"] = bit.check(flag, 4)
    checks["CHI - Combat knife"] = bit.check(flag, 5)
    checks["CHI - Shiitake 1"] = bit.check(flag, 6)
    checks["CHI - Shiitake 2"] = bit.check(flag, 7)
    checks["CHI - Barley tea(Demon)"] = bit.check(flag, 8)
    checks["CHI - Peanuts 1(Demon)"] = bit.check(flag, 9)
    checks["CHI - Peanuts 2(Demon)"] = bit.check(flag, 10)
    checks["CHI - Peanuts 3(Demon)"] = bit.check(flag, 11)
    checks["CHI - Peanuts 4(Demon)"] = bit.check(flag, 12)
    checks["CHI - Turkey(Demon)"] = bit.check(mainmemory.readbyte(0x03be3d), 0)
    if mainmemory.read_u16_le(0x03ca5c) ~= 0 then
        checks["CHI - Cerberos kill"] = true
    else
        checks["CHI - Cerberos kill"] = false
    end
    if cur_zone == "CHI" then
        if room == 0x19b8 then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 88)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 167)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Demon Card"] = true
            end
        end
    end

    return checks
end

function checkDAI(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03beff)
    checks["DAI - Ankh of life(Stairs)"] = bit.check(flag, 0)
    checks["DAI - Morningstar"] = bit.check(flag, 1)
    checks["DAI - Silver ring"] = bit.check(flag, 2)
    checks["DAI - Aquamarine(Stairs)"] = bit.check(flag, 3)
    checks["DAI - Mystic pendant"] = bit.check(flag, 4)
    checks["DAI - Magic missile(Stairs)"] = bit.check(flag, 5)
    checks["DAI - Shuriken(Stairs)"] = bit.check(flag, 6)
    checks["DAI - TNT(Stairs)"] = bit.check(flag, 7)
    checks["DAI - Boomerang(Stairs)"] = bit.check(flag, 8)
    checks["DAI - Goggles"] = bit.check(flag, 9)
    checks["DAI - Silver plate"] = bit.check(flag, 10)
    checks["DAI - Str. potion(Bell)"] = bit.check(flag, 11)
    checks["DAI - Life Vessel(Bell)"] = bit.check(flag, 12)
    checks["DAI - Zircon"] = bit.check(flag, 13)
    checks["DAI - Cutlass"] = bit.check(flag, 14)
    checks["DAI - Potion"] = bit.check(flag, 15)
    if mainmemory.read_u16_le(0x03ca44) ~= 0 then
        checks["DAI - Hippogryph kill"] = true
    else
        checks["DAI - Hippogryph kill"] = false
    end

    return checks
end

function checkLIB(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03befa)
    checks["LIB - Stone mask"] = bit.check(flag, 1)
    checks["LIB - Holy rod"] = bit.check(flag, 2)
    checks["LIB - Bronze cuirass"] = bit.check(flag, 4)
    checks["LIB - Takemitsu"] = bit.check(flag, 5)
    checks["LIB - Onyx"] = bit.check(flag, 6)
    checks["LIB - Frankfurter"] = bit.check(flag, 7)
    checks["LIB - Potion"] = bit.check(flag, 8)
    checks["LIB - Antivenom"] = bit.check(flag, 9)
    checks["LIB - Topaz circlet"] = bit.check(flag, 10)
    if mainmemory.read_u16_le(0x03ca6c) ~= 0 then
        checks["LIB - Lesser Demon kill"] = true
    else
        checks["LIB - Lesser Demon kill"] = false
    end
    if cur_zone == "LIB" then
        if room == 0x2ec4 then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 1051)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 919)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= 5 then
                checks["Soul of Bat"] = true
            end
        end
        if room == 0x2f0c then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 1681)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 167)
            local o = 80 -- Increased offset
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Faerie Scroll"] = true
            end
        end
        if room == 0x2ee4 then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 230)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 135)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Jewel of Open"] = true
            end
        end
        if room == 0x2efc then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 48)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 167)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Faerie Card"] = true
            end
        end
    end

    return checks
end

function checkNO0(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03beec)
    checks["NO0 - Life Vessel(Left clock)"] = bit.check(flag, 0)
    checks["NO0 - Alucart shield"] = bit.check(flag, 1)
    checks["NO0 - Heart Vessel(Right clock)"] = bit.check(flag, 2)
    checks["NO0 - Life apple(Middle clock)"] = bit.check(flag, 3)
    checks["NO0 - Hammer(Middle clock)"] = bit.check(flag, 4)
    checks["NO0 - Potion(Middle clock)"] = bit.check(flag, 5)
    checks["NO0 - Alucart mail"] = bit.check(flag, 6)
    checks["NO0 - Alucart sword"] = bit.check(flag, 7)
    checks["NO0 - Life Vessel(Inside)"] = bit.check(flag, 8)
    checks["NO0 - Heart Vessel(Inside)"] = bit.check(flag, 9)
    checks["NO0 - Library card(Jewel)"] = bit.check(flag, 10)
    checks["NO0 - Attack potion(Jewel)"] = bit.check(flag, 11)
    checks["NO0 - Hammer(Spirit)"] = bit.check(flag, 12)
    checks["NO0 - Str. potion"] = bit.check(flag, 13)
    checks["NO0 - Holy glasses"] = bit.check(mainmemory.read_u8(0x03bec4), 0)
    if cur_zone == "NO0" then
        if room == 0x27f4 then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 130)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 1080)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Spirit Orb"] = true
            end
        end
        if room == 0x2884 then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 1170)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 167)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Gravity Boots"] = true
            end
        end
    end

    return checks
end

function checkNO1(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03beee)
    checks["NO1 - Jewel knuckles"] = bit.check(flag, 0)
    checks["NO1 - Mirror cuirass"] = bit.check(flag, 1)
    checks["NO1 - Heart Vessel"] = bit.check(flag, 2)
    checks["NO1 - Garnet"] = bit.check(flag, 3)
    checks["NO1 - Gladius"] = bit.check(flag, 4)
    checks["NO1 - Life Vessel"] = bit.check(flag, 5)
    checks["NO1 - Zircon"] = bit.check(flag, 6)
    checks["NO1 - Pot Roast"] = bit.check(mainmemory.readbyte(0x03bdfe), 0)
    if mainmemory.read_u16_le(0x03ca30) ~= 0 then
        checks["NO1 - Doppleganger 10 kill"] = true
    else
        checks["NO1 - Doppleganger 10 kill"] = false
    end
    if cur_zone == "NO1" then
        if room == 0x34f4 then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 360)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 807)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Soul of Wolf"] = true
            end
        end
    end

    return checks
end

function checkNO2(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03bef0)
    checks["NO2 - Heart Vessel"] = bit.check(flag, 1)
    checks["NO2 - Broadsword"] = bit.check(flag, 4)
    checks["NO2 - Onyx"] = bit.check(flag, 5)
    checks["NO2 - Cheese"] = bit.check(flag, 6)
    checks["NO2 - Manna prism"] = bit.check(flag, 7)
    checks["NO2 - Resist fire"] = bit.check(flag, 8)
    checks["NO2 - Luck potion"] = bit.check(flag, 9)
    checks["NO2 - Estoc"] = bit.check(flag, 10)
    checks["NO2 - Iron ball"] = bit.check(flag, 11)
    checks["NO2 - Garnet"] = bit.check(flag, 12)
    if mainmemory.read_u16_le(0x03ca2c) ~= 0 then
        checks["NO2 - Olrox kill"] = true
    else
        checks["NO2 - Olrox kill"] = false
    end
    if cur_zone == "NO2" then
        if room == 0x330c then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 130)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 135)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Echo of Bat"] = true
            end
        end
        if room == 0x3314 then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 367)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 135)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Sword Card"] = true
            end
        end
    end

    return checks
end

function checkNO3(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03bef2)

    checks["NO3 - Heart Vessel (Above Death)"] = bit.check(flag, 0)
    checks["NO3 - Life Vessel (Bellow shield potion)"] = bit.check(flag, 1)
    checks["NO3 - Life Apple (Hidden room)"] = bit.check(flag, 2)
    checks["NO3 - Shield Potion"] = bit.check(flag, 4)
    checks["NO3 - Holy mail"] = bit.check(flag, 5)
    checks["NO3 - Life Vessel (UC exit)"] = bit.check(flag, 6)
    checks["NO3 - Heart Vessel (Teleport exit)"] = bit.check(flag, 7)
    checks["NO3 - Life Vessel (Above entry)"] = bit.check(flag, 8)
    checks["NO3 - Jewel sword"] = bit.check(flag, 9)
    checks["NO3 - Pot Roast"] = bit.check(mainmemory.readbyte(0x03be1f), 0)
    checks["NO3 - Turkey"] = bit.check(mainmemory.readbyte(0x03be24), 0)
    if cur_zone == "NO3" or cur_zone == "NP3" then
        if room == 0x3d40 or room == 0x3af8 then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 270)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 103)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Cube of Zoe"] = true
            end
        end
        if room == 0x3cc8 or room == 0x3a80 then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 245)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 183)
            -- NP3 seens a bit offset
            local x2 = math.abs(mainmemory.read_u16_le(0x0973f0) - 270)
            local o = 10
            if (x >= 0 and x <= o and y >= 0 and y <= o) or (x2 >= 0 and x2 <= o and y >= 0 and y <= o) then
                checks["Power of Wolf"] = true
            end
        end
    end

    return checks
end

function checkNO4(room)
    local checks = {}
    local flag = mainmemory.read_u32_le(0x03bef4)
    -- local flag2 = mainmemory.read_u16_le(0x03bef8)
    local flag2 = mainmemory.read_u8(0x03bef8)
    checks["NO4 - Heart Vessel(0)"] = bit.check(flag, 0)
    checks["NO4 - Life Vessel(1)"] = bit.check(flag, 1)
    checks["NO4 - Crystal cloak"] = bit.check(flag, 2)
    checks["NO4 - Antivenom(Underwater)"] = bit.check(flag, 4)
    checks["NO4 - Life Vessel(Underwater)"] = bit.check(flag, 5)
    checks["NO4 - Life Vessel(Behind waterfall)"] = bit.check(flag, 6)
    checks["NO4 - Herald Shield"] = bit.check(flag, 7)
    checks["NO4 - Zircon"] = bit.check(flag, 9)
	checks["NO4 - Gold Ring"] = bit.check(flag, 10)
    checks["NO4 - Bandanna"] = bit.check(flag, 11)
    checks["NO4 - Shiitake(12)"] = bit.check(flag, 12)
    checks["NO4 - Claymore"] = bit.check(flag, 13)
    checks["NO4 - Meal ticket 1(Succubus)"] = bit.check(flag, 14)
    checks["NO4 - Meal ticket 2(Succubus)"] = bit.check(flag, 15)
    checks["NO4 - Meal ticket 3(Succubus)"] = bit.check(flag, 16)
    checks["NO4 - Meal ticket 4(Succubus)"] = bit.check(flag, 17)
    checks["NO4 - Moonstone"] = bit.check(flag, 18)
    checks["NO4 - Scimitar"] = bit.check(flag, 19)
    checks["NO4 - Resist ice"] = bit.check(flag, 20)
    checks["NO4 - Pot roast"] = bit.check(flag, 21)
    checks["NO4 - Onyx(Holy)"] = bit.check(flag, 22)
    checks["NO4 - Knuckle duster(Holy)"] = bit.check(flag, 23)
    checks["NO4 - Life Vessel(Holy)"] = bit.check(flag, 24)
    checks["NO4 - Elixir(Holy)"] = bit.check(flag, 25)
    checks["NO4 - Toadstool(26)"] = bit.check(flag, 26)
    checks["NO4 - Shiitake(27)"] = bit.check(flag, 27)
    checks["NO4 - Life Vessel(Bellow bridge)"] = bit.check(flag, 28)
    checks["NO4 - Heart Vessel(Bellow bridge)"] = bit.check(flag, 29)
    checks["NO4 - Pentagram"] = bit.check(flag, 30)
    checks["NO4 - Secret boots"] = bit.check(flag, 31)
    checks["NO4 - Shiitake(Waterfall)"] = bit.check(flag2, 0)
    checks["NO4 - Toadstool(Waterfall)"] = bit.check(flag2, 1)
    checks["NO4 - Shiitake(Near entrance passage)"] = bit.check(flag2, 3)
    checks["NO4 - Nunchaku"] = bit.check(flag2, 4)
    if mainmemory.read_u16_le(0x03ca4c) ~= 0 then
        checks["NO4 - Succubus kill"] = true
    else
        checks["NO4 - Succubus kill"] = false
    end
    if mainmemory.read_u16_le(0x03ca3c) ~= 0 then
        checks["NO4 - Scylla kill"] = true
    else
        checks["NO4 - Scylla kill"] = false
    end
    if cur_zone == "NO4" then
        if room == 0x315c then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 141)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 167)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Holy Symbol"] = true
            end
        end
        if room == 0x319c then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 92)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 167)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Merman Statue"] = true
            end
        end
    end

    return checks
end

function checkNZ0(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03bf0b)
    checks["NZ0 - Hide cuirass"] = bit.check(flag, 0)
    checks["NZ0 - Heart Vessel"] = bit.check(flag, 1)
    checks["NZ0 - Cloth cape"] = bit.check(flag, 2)
    checks["NZ0 - Life Vessel"] = bit.check(flag, 3)
    checks["NZ0 - Sunglasses"] = bit.check(flag, 6)
    checks["NZ0 - Resist thunder"] = bit.check(flag, 7)
    checks["NZ0 - Leather shield"] = bit.check(flag, 8)
    checks["NZ0 - Basilard"] = bit.check(flag, 9)
    checks["NZ0 - Potion"] = bit.check(flag, 10)
    if mainmemory.read_u16_le(0x03ca40) ~= 0 then
        checks["NZ0 - Slogra and Gaibon kill"] = true
    else
        checks["NZ0 - Slogra and Gaibon kill"] = false
    end
    if cur_zone == "NZ0" then
        if room == 0x2770 then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 120)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 167)
            local o = 25
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Skill of Wolf"] = true
            end
        end
        if room == 0x2730 then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 114)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 167)
            local o = 25
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Bat Card"] = true
            end
        end
    end

    return checks
end

function checkNZ1(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03bf0d)
    checks["NZ1 - Magic missile"] = bit.check(flag, 0)
    checks["NZ1 - Pentagram"] = bit.check(flag, 1)
    checks["NZ1 - Star flail"] = bit.check(flag, 3)
    checks["NZ1 - Gold plate"] = bit.check(flag, 4)
    checks["NZ1 - Steel helm"] = bit.check(flag, 5)
    checks["NZ1 - Healing mail"] = bit.check(flag, 6)
    checks["NZ1 - Bekatowa"] = bit.check(flag, 7)
    checks["NZ1 - Shaman shield"] = bit.check(flag, 8)
    checks["NZ1 - Ice mail"] = bit.check(flag, 9)
    checks["NZ1 - Life Vessel(Gear train)"] = bit.check(flag, 10)
    checks["NZ1 - Heart Vessel(Gear train)"] = bit.check(flag, 11)
    checks["NZ1 - Bwaka knife"] = bit.check(mainmemory.readbyte(0x03be8f), 2)
    checks["NZ1 - Pot roast"] = bit.check(mainmemory.readbyte(0x03be8f), 0)
    checks["NZ1 - Shuriken"] = bit.check(mainmemory.readbyte(0x03be8f), 1)
    checks["NZ1 - TNT"] = bit.check(mainmemory.readbyte(0x03be8f), 3)
    if mainmemory.read_u16_le(0x03ca50) ~= 0 then
        checks["NZ1 - Karasuman kill"] = true
    else
        checks["NZ1 - Karasuman kill"] = false
    end
    if cur_zone == "NZ1" then
        if room == 0x23a0 then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 198)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 183)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Fire of Bat"] = true
            end
        end
    end

    return checks
end

function checkTOP(room)
    local checks = {}
    local flag = mainmemory.read_u32_le(0x03bf08)
    checks["TOP - Turquoise"] = bit.check(flag, 0)
    checks["TOP - Turkey(Behind wall)"] = bit.check(flag, 1)
    checks["TOP - Fire mail(Behind wall)"] = bit.check(flag, 2)
    checks["TOP - Tyrfing"] = bit.check(flag, 3)
    checks["TOP - Sirloin(Above Richter)"] = bit.check(flag, 4)
    checks["TOP - Turkey(Above Richter)"] = bit.check(flag, 5)
    checks["TOP - Pot roast(Above Richter)"] = bit.check(flag, 6)
    checks["TOP - Frankfurter(Above Richter)"] = bit.check(flag, 7)
    checks["TOP - Resist stone(Above Richter)"] = bit.check(flag, 8)
    checks["TOP - Resist dark(Above Richter)"] = bit.check(flag, 9)
    checks["TOP - Resist holy(Above Richter)"] = bit.check(flag, 10)
    checks["TOP - Platinum mail(Above Richter)"] = bit.check(flag, 11)
    checks["TOP - Falchion"] = bit.check(flag, 12)
    checks["TOP - Life Vessel 1(Viewing room)"] = bit.check(flag, 13)
    checks["TOP - Life Vessel 2(Viewing room)"] = bit.check(flag, 14)
    checks["TOP - Heart Vessel 1(Viewing room)"] = bit.check(flag, 15)
    checks["TOP - Heart Vessel 2(Viewing room)"] = bit.check(flag, 16)
    checks["TOP - Heart Vessel(Before Richter)"] = bit.check(flag, 18)
    if cur_zone == "TOP" then
        if room == 0x1b8c then
            local xl = math.abs(mainmemory.read_u16_le(0x0973f0) - 424)
            local yl = math.abs(mainmemory.read_u16_le(0x0973f4) - 1815)
            local xm = math.abs(mainmemory.read_u16_le(0x0973f0) - 417)
            local ym = math.abs(mainmemory.read_u16_le(0x0973f4) - 1207)
            local o = 10
            if xl >= 0 and xl <= o and yl >= 0 and yl <= o then
                checks["Leap Stone"] = true
            end
            if xm >= 0 and xm <= o and ym >= 0 and ym <= o then
                checks["Power of Mist"] = true
            end
        end
        if room == 0x1b94 then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 350)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 663)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Ghost Card"] = true
            end
        end
    end

    return checks
end

function checkRARE(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03bf3b)
    checks["RARE - Fury plate(Hidden floor)"] = bit.check(flag, 0)
    checks["RARE - Zircon"] = bit.check(flag, 1)
    checks["RARE - Buffalo star"] = bit.check(flag, 2)
    checks["RARE - Gram"] = bit.check(flag, 3)
    checks["RARE - Aquamarine"] = bit.check(flag, 4)
    checks["RARE - Heart Vessel(5)"] = bit.check(flag, 5)
    checks["RARE - Life Vessel"] = bit.check(flag, 6)
    checks["RARE - Heart Vessel(7)"] = bit.check(flag, 7)
    if mainmemory.read_u16_le(0x03ca54) ~= 0 then
        checks["RARE - Fake Trevor/Grant/Sypha kill"] = true
    else
        checks["RARE - Fake Trevor/Grant/Sypha kill"] = false
    end

    return checks
end

function checkRCAT(room)
    local checks = {}
    local flag = mainmemory.read_u32_le(0x03bf2b)
    checks["RCAT - Magic missile"] = bit.check(flag, 0)
    checks["RCAT - Buffalo star"] = bit.check(flag, 1)
    checks["RCAT - Resist thunder"] = bit.check(flag, 2)
    checks["RCAT - Resist fire"] = bit.check(flag, 3)
    checks["RCAT - Karma coin(4)(Spike breaker)"] = bit.check(flag, 4)
    checks["RCAT - Karma coin(5)(Spike breaker)"] = bit.check(flag, 5)
    checks["RCAT - Red bean bun"] = bit.check(flag, 6)
    checks["RCAT - Elixir"] = bit.check(flag, 7)
    checks["RCAT - Library card"] = bit.check(flag, 8)
    checks["RCAT - Life Vessel(9)"] = bit.check(flag, 9)
    checks["RCAT - Heart Vessel(10)"] = bit.check(flag, 10)
    checks["RCAT - Shield potion"] = bit.check(flag, 11)
    checks["RCAT - Attack potion"] = bit.check(flag, 12)
    checks["RCAT - Necklace of j"] = bit.check(flag, 13)
    checks["RCAT - Diamond"] = bit.check(flag, 14)
    checks["RCAT - Heart Vessel(After Galamoth)"] = bit.check(flag, 15)
    checks["RCAT - Life Vessel(After Galamoth)"] = bit.check(flag, 16)
    checks["RCAT - Ruby circlet"] = bit.check(flag, 17)
    if mainmemory.read_u16_le(0x03ca7c) ~= 0 then
        checks["RCAT - Galamoth kill"] = true
    else
        checks["RCAT - Galamoth kill"] = false
    end
    if cur_zone == "RCAT" or cur_zone == "RBO8" then
        if room == 0x2429 or room == 0x2490 then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 38)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 173)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Gas Cloud"] = true
            end
        end
    end

    return checks
end

function checkRCEN(room)
    local checks = {}
    bosses["Dracula"] = dracula_dead

    return checks
end

function checkRCHI(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03bf33)
    checks["RCHI - Power of Sire(Demon)"] = bit.check(flag, 0)
    checks["RCHI - Life apple(Demon)"] = bit.check(flag, 1)
    checks["RCHI - Alucard sword"] = bit.check(flag, 2)
    checks["RCHI - Green tea(Demon)"] = bit.check(flag, 3)
    checks["RCHI - Power of Sire"] = bit.check(flag, 4)
    checks["RCHI - Shiitake 1(6)"] = bit.check(flag, 6)
    checks["RCHI - Shiitake 2(7)"] = bit.check(flag, 7)
    if mainmemory.read_u16_le(0x03ca58) ~= 0 then
        checks["RCHI - Death kill"] = true
        checks["Eye of Vlad"] = true
    else
        checks["RCHI - Death kill"] = false
        checks["Eye of Vlad"] = false
    end

    return checks
end

function checkRDAI(room)
    local checks = {}
    local flag = mainmemory.read_u32_le(0x03bf2f)
    checks["RDAI - Fire boomerang"] = bit.check(flag, 2)
    checks["RDAI - Diamond"] = bit.check(flag, 3)
    checks["RDAI - Zircon"] = bit.check(flag, 4)
    checks["RDAI - Heart Vessel(5)"] = bit.check(flag, 5)
    checks["RDAI - Shuriken"] = bit.check(flag, 6)
    checks["RDAI - TNT"] = bit.check(flag, 7)
    checks["RDAI - Boomerang"] = bit.check(flag, 8)
    checks["RDAI - Javelin"] = bit.check(flag, 9)
    checks["RDAI - Manna prism"] = bit.check(flag, 10)
    checks["RDAI - Smart potion"] = bit.check(flag, 11)
    checks["RDAI - Life Vessel"] = bit.check(flag, 12)
    checks["RDAI - Talwar"] = bit.check(flag, 13)
    checks["RDAI - Bwaka knife"] = bit.check(flag, 14)
    checks["RDAI - Magic missile"] = bit.check(flag, 15)
    checks["RDAI - Twilight cloak"] = bit.check(flag, 16)
    checks["RDAI - Heart Vessel(17)"] = bit.check(flag, 17)
    if mainmemory.read_u16_le(0x03ca64) ~= 0 then
        checks["RDAI - Medusa kill"] = true
        checks["Heart of Vlad"] = true
    else
        checks["RDAI - Medusa kill"] = false
        checks["Heart of Vlad"] = false
    end

    return checks
end

function checkRLIB(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03bf27)
    checks["RLIB - Turquoise"] = bit.check(flag, 0)
    checks["RLIB - Opal"] = bit.check(flag, 1)
    checks["RLIB - Library card"] = bit.check(flag, 2)
    checks["RLIB - Resist fire"] = bit.check(flag, 3)
    checks["RLIB - Resist ice"] = bit.check(flag, 4)
    checks["RLIB - Resist stone"] = bit.check(flag, 5)
    checks["RLIB - Neutron bomb"] = bit.check(flag, 6)
    checks["RLIB - Badelaire"] = bit.check(flag, 7)
    checks["RLIB - Staurolite"] = bit.check(flag, 8)

    return checks
end

function checkRNO0(room, f)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03bf13)
    checks["RNO0 - Library card"] = bit.check(flag, 0)
    checks["RNO0 - Potion"] = bit.check(flag, 1)
    checks["RNO0 - Antivenom"] = bit.check(flag, 2)
    checks["RNO0 - Life Vessel(Middle clock)"] = bit.check(flag, 3)
    checks["RNO0 - Heart Vessel(Middle clock)"] = bit.check(flag, 4)
    checks["RNO0 - Resist dark(Left clock)"] = bit.check(flag, 5)
    checks["RNO0 - Resist holy(Left clock)"] = bit.check(flag, 6)
    checks["RNO0 - Resist thunder(Left clock)"] = bit.check(flag, 7)
    checks["RNO0 - Resist fire(Left clock)"] = bit.check(flag, 8)
    checks["RNO0 - Meal ticket"] = bit.check(flag, 9)
    checks["RNO0 - Iron ball"] = bit.check(flag, 10)
    checks["RNO0 - Heart Refresh(Inside clock)"] = bit.check(flag, 11)

    if cur_zone == "RNO0" then
        if delay_timer == 0 then
            delay_timer = f
        elseif delay_timer ~= 0 then
            if delay_timer == f then
                gui.drawText(0, client.bufferheight() - 20, bosses_dead .. " - " .. mainmemory.read_u8(0x180f8b))
                gui.drawText(0, client.bufferheight() - 30, memory.read_u32_le(0x801c132c, "System Bus"))
            end

            if f - delay_timer >= 900 then
                gui.clearGraphics()

                local bosses_dead      = checkBosses()
                local boss_goal        = mainmemory.read_u8(0x180f8b)
                local exploration_goal = mainmemory.read_u16_le(0x180f89)
                local rooms_seen       = mainmemory.read_u16_le(0x3c760)
                if bosses_dead >= boss_goal and rooms_seen >= exploration_goal then
                    -- Give some time to zone load before patching
                    memory.write_u32_le(0x801c132c, 0x14400118, "System Bus")
                end
            end
        end
    end

    return checks
end

function checkRNO1(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03bf17)
    checks["RNO1 - Heart Vessel"] = bit.check(flag, 0)
    checks["RNO1 - Shotel"] = bit.check(flag, 1)
    checks["RNO1 - Hammer"] = bit.check(flag, 2)
    checks["RNO1 - Life Vessel"] = bit.check(flag, 3)
    checks["RNO1 - Luck potion"] = bit.check(flag, 4)
    checks["RNO1 - Shield potion"] = bit.check(flag, 5)
    checks["RNO1 - High potion"] = bit.check(flag, 6)
    checks["RNO1 - Garnet"] = bit.check(flag, 7)
    checks["RNO1 - Dim Sum set"] = bit.check(mainmemory.readbyte(0x03be04), 0)
    if mainmemory.read_u16_le(0x03ca68) ~= 0 then
        checks["RNO1 - Creature kill"] = true
        checks["Tooth of Vlad"] = true
    else
        checks["RNO1 - Creature kill"] = false
        checks["Tooth of Vlad"] = false
    end

    return checks
end

function checkRNO2(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03bf1b)
    checks["RNO2 - Opal"] = bit.check(flag, 0)
    checks["RNO2 - Sword of hador"] = bit.check(flag, 1)
    checks["RNO2 - High potion"] = bit.check(flag, 2)
    checks["RNO2 - Shield potion"] = bit.check(flag, 3)
    checks["RNO2 - Luck potion"] = bit.check(flag, 4)
    checks["RNO2 - Manna prism"] = bit.check(flag, 5)
    checks["RNO2 - Aquamarine"] = bit.check(flag, 6)
    checks["RNO2 - Alucard mail"] = bit.check(flag, 7)
    checks["RNO2 - Life Vessel"] = bit.check(flag, 8)
    checks["RNO2 - Heart Refresh"] = bit.check(flag, 9)
    checks["RNO2 - Shuriken"] = bit.check(flag, 10)
    checks["RNO2 - Heart Vessel"] = bit.check(flag, 11)
    if mainmemory.read_u16_le(0x03ca74) ~= 0 then
        checks["RNO2 - Akmodan II kill"] = true
        checks["Rib of Vlad"] = true
    else
        checks["RNO2 - Akmodan II kill"] = false
        checks["Rib of Vlad"] = false
    end

    return checks
end

function checkRNO3(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03bf1f)
    checks["RNO3 - Hammer"] = bit.check(flag, 0)
    checks["RNO3 - Antivenom"] = bit.check(flag, 1)
    checks["RNO3 - High potion"] = bit.check(flag, 2)
    checks["RNO3 - Heart Vessel"] = bit.check(flag, 3)
    checks["RNO3 - Zircon"] = bit.check(flag, 4)
    checks["RNO3 - Opal"] = bit.check(flag, 5)
    checks["RNO3 - Beryl circlet"] = bit.check(flag, 6)
    checks["RNO3 - Fire boomerang"] = bit.check(flag, 7)
    checks["RNO3 - Life Vessel"] = bit.check(flag, 8)
    checks["RNO3 - Talisman"] = bit.check(flag, 9)
    checks["RNO3 - Pot roast"] = bit.check(mainmemory.readbyte(0x03be27), 0)

    return checks
end

function checkRNO4(room)
    local checks = {}
    local flag = mainmemory.read_u32_le(0x03bf23)
    checks["RNO4 - Alucard shield"] = bit.check(flag, 0)
    checks["RNO4 - Shiitake 1(Near entrance passage)"] = bit.check(flag, 1)
    checks["RNO4 - Toadstool(Waterfall)"] = bit.check(flag, 2)
    checks["RNO4 - Shiitake 2(Waterfall)"] = bit.check(flag, 3)
    checks["RNO4 - Garnet"] = bit.check(flag, 4)
    checks["RNO4 - Bat Pentagram"] = bit.check(flag, 5)
    checks["RNO4 - Life Vessel(Underwater)"] = bit.check(flag, 6)
    checks["RNO4 - Heart Vessel(Air pocket)"] = bit.check(flag, 7)
    checks["RNO4 - Potion(Underwater)"] = bit.check(flag, 8)
    checks["RNO4 - Shiitake 3(Near air pocket)"] = bit.check(flag, 9)
    checks["RNO4 - Shiitake 4(Near air pocket)"] = bit.check(flag, 10)
    checks["RNO4 - Opal"] = bit.check(flag, 11)
    checks["RNO4 - Life Vessel"] = bit.check(flag, 12)
    checks["RNO4 - Diamond"] = bit.check(flag, 13)
    checks["RNO4 - Zircon(Vase)"] = bit.check(flag, 14)
    checks["RNO4 - Heart Vessel(Succubus side)"] = bit.check(flag, 15)
    checks["RNO4 - Meal ticket 1(Succubus side)"] = bit.check(flag, 16)
    checks["RNO4 - Meal ticket 2(Succubus side)"] = bit.check(flag, 17)
    checks["RNO4 - Meal ticket 3(Succubus side)"] = bit.check(flag, 18)
    checks["RNO4 - Meal ticket 4(Succubus side)"] = bit.check(flag, 19)
    checks["RNO4 - Meal ticket 5(Succubus side)"] = bit.check(flag, 20)
    checks["RNO4 - Zircon(Doppleganger)"] = bit.check(flag, 21)
    checks["RNO4 - Pot roast(Doppleganger)"] = bit.check(flag, 22)
    checks["RNO4 - Dark Blade"] = bit.check(flag, 23)
    checks["RNO4 - Manna prism"] = bit.check(flag, 24)
    checks["RNO4 - Elixir"] = bit.check(flag, 25)
    checks["RNO4 - Osafune katana"] = bit.check(flag, 26)
    if mainmemory.read_u16_le(0x03ca70) ~= 0 then
        checks["RNO4 - Doppleganger40 kill"] = true
    else
        checks["RNO4 - Doppleganger40 kill"] = false
    end
    if cur_zone == "RNO4" then
        if room == 0x2c6c then
            local x = math.abs(mainmemory.read_u16_le(0x0973f0) - 110)
            local y = math.abs(mainmemory.read_u16_le(0x0973f4) - 167)
            local o = 10
            if x >= 0 and x <= o and y >= 0 and y <= o then
                checks["Force of Echo"] = true
            end
        end
    end

    return checks
end

function checkRNZ0(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03bf43)
    checks["RNZ0 - Heart Vessel"] = bit.check(flag, 1)
    checks["RNZ0 - Life Vessel"] = bit.check(flag, 2)
    checks["RNZ0 - Goddess shield"] = bit.check(flag, 3)
    checks["RNZ0 - Manna prism"] = bit.check(flag, 4)
    checks["RNZ0 - Katana"] = bit.check(flag, 5)
    checks["RNZ0 - High potion"] = bit.check(flag, 6)
    checks["RNZ0 - Turquoise"] = bit.check(flag, 7)
    checks["RNZ0 - Ring of Arcana"] = bit.check(flag, 8)
    checks["RNZ0 - Resist dark"] = bit.check(flag, 9)
    if mainmemory.read_u16_le(0x03ca48) ~= 0 then
        checks["RNZ0 - Beezelbub kill"] = true
    else
        checks["RNZ0 - Beezelbub kill"] = false
    end

    return checks
end

function checkRNZ1(room)
    local checks = {}
    local flag = mainmemory.read_u16_le(0x03bf47)
    checks["RNZ1 - Magic missile"] = bit.check(flag, 0)
    checks["RNZ1 - Karma coin"] = bit.check(flag, 1)
    checks["RNZ1 - Str. potion"] = bit.check(flag, 2)
    checks["RNZ1 - Luminus"] = bit.check(flag, 3)
    checks["RNZ1 - Smart potion"] = bit.check(flag, 4)
    checks["RNZ1 - Dragon helm"] = bit.check(flag, 5)
    checks["RNZ1 - Diamond(Hidden room)"] = bit.check(flag, 6)
    checks["RNZ1 - Life apple(Hidden room)"] = bit.check(flag, 7)
    checks["RNZ1 - Sunstone(Hidden room)"] = bit.check(flag, 8)
    checks["RNZ1 - Life Vessel"] = bit.check(flag, 9)
    checks["RNZ1 - Heart Vessel"] = bit.check(flag, 10)
    checks["RNZ1 - Moon rod"] = bit.check(flag, 11)
    checks["RNZ1 - Bwaka knife"] = bit.check(mainmemory.readbyte(0x03be97), 2)
    checks["RNZ1 - Turkey"] = bit.check(mainmemory.readbyte(0x03be97), 0)
    checks["RNZ1 - Shuriken"] = bit.check(mainmemory.readbyte(0x03be97), 1)
    checks["RNZ1 - TNT"] = bit.check(mainmemory.readbyte(0x03be97), 3)
    if mainmemory.read_u16_le(0x03ca78) ~= 0 then
        checks["RNZ1 - Darkwing bat kill"] = true
        checks["Ring of Vlad"] = true
    else
        checks["RNZ1 - Darkwing bat kill"] = false
        checks["Ring of Vlad"] = false
    end

    return checks
end

function checkRTOP(room)
    local checks = {}
    local flag = mainmemory.read_u32_le(0x03bf3f)
    checks["RTOP - Sword of dawn"] = bit.check(flag, 0)
    checks["RTOP - Iron ball(Above Richter)"] = bit.check(flag, 1)
    checks["RTOP - Zircon"] = bit.check(flag, 2)
    checks["RTOP - Bastard sword"] = bit.check(flag, 4)
    checks["RTOP - Life Vessel 1"] = bit.check(flag, 5)
    checks["RTOP - Heart Vessel 1"] = bit.check(flag, 6)
    checks["RTOP - Life Vessel 2"] = bit.check(flag, 7)
    checks["RTOP - Heart Vessel 2"] = bit.check(flag, 8)
    checks["RTOP - Life Vessel 3"] = bit.check(flag, 9)
    checks["RTOP - Heart Vessel 4"] = bit.check(flag, 10)
    checks["RTOP - Royal cloak"] = bit.check(flag, 11)
    checks["RTOP - Resist fire(Viewing room)"] = bit.check(flag, 17)
    checks["RTOP - Resist ice(Viewing room)"] = bit.check(flag, 18)
    checks["RTOP - Resist thunder(Viewing room)"] = bit.check(flag, 19)
    checks["RTOP - Resist stone(Viewing room)"] = bit.check(flag, 20)
    checks["RTOP - High potion(Viewing room)"] = bit.check(flag, 21)
    checks["RTOP - Garnet"] = bit.check(flag, 22)
    checks["RTOP - Lightning mail"] = bit.check(flag, 23)
    checks["RTOP - Library card"] = bit.check(flag, 24)

    return checks
end

function checkAllLocations(f)
    local location_checks = {}
    if mainmemory.read_u16_le(0x180000) == 0xeed8 or mainmemory.read_u16_le(0x180000) == 0x0000 then
        return location_checks
    end

    local room = mainmemory.read_u16_le(0x1375bc)

    -- Normal Castle
    for k,v in pairs(checkARE(room)) do location_checks[k] = v end
    for k,v in pairs(checkCAT(room)) do location_checks[k] = v end
    for k,v in pairs(checkCHI(room)) do location_checks[k] = v end
    for k,v in pairs(checkDAI(room)) do location_checks[k] = v end
    for k,v in pairs(checkLIB(room)) do location_checks[k] = v end
    for k,v in pairs(checkNO0(room)) do location_checks[k] = v end
    for k,v in pairs(checkNO1(room)) do location_checks[k] = v end
    for k,v in pairs(checkNO2(room)) do location_checks[k] = v end
    for k,v in pairs(checkNO3(room)) do location_checks[k] = v end
    for k,v in pairs(checkNO4(room)) do location_checks[k] = v end
    for k,v in pairs(checkNZ0(room)) do location_checks[k] = v end
    for k,v in pairs(checkNZ1(room)) do location_checks[k] = v end
    for k,v in pairs(checkTOP(room)) do location_checks[k] = v end

    -- Reverse Castle
    for k,v in pairs(checkRARE(room)) do location_checks[k] = v end
    for k,v in pairs(checkRCAT(room)) do location_checks[k] = v end
    for k,v in pairs(checkRCEN(room)) do location_checks[k] = v end
    for k,v in pairs(checkRCHI(room)) do location_checks[k] = v end
    for k,v in pairs(checkRDAI(room)) do location_checks[k] = v end
    for k,v in pairs(checkRLIB(room)) do location_checks[k] = v end
    for k,v in pairs(checkRNO0(room, f)) do location_checks[k] = v end
    for k,v in pairs(checkRNO1(room)) do location_checks[k] = v end
    for k,v in pairs(checkRNO2(room)) do location_checks[k] = v end
    for k,v in pairs(checkRNO3(room)) do location_checks[k] = v end
    for k,v in pairs(checkRNO4(room)) do location_checks[k] = v end
    for k,v in pairs(checkRNZ0(room)) do location_checks[k] = v end
    for k,v in pairs(checkRNZ1(room)) do location_checks[k] = v end
    for k,v in pairs(checkRTOP(room)) do location_checks[k] = v end

    return location_checks
end

function checkOneLocation(f)
    local current_table = {}
    if mainmemory.read_u16_le(0x180000) == 0xeed8 or mainmemory.read_u16_le(0x180000) == 0x0000 then
        return
    end

    if last_zone == "RNO0" and cur_zone ~= "RNO0" then
        gui.clearGraphics()
    end

    local room = mainmemory.read_u16_le(0x1375bc)

    -- Normal Castle
    if cur_zone == "ARE" or cur_zone == "BO2" then current_table = checkARE(room) end
    if cur_zone == "CAT" or cur_zone == "BO1" then current_table = checkCAT(room) end
    if cur_zone == "CHI" or cur_zone == "BO7" then current_table = checkCHI(room) end
    if cur_zone == "DAI" or cur_zone == "BO5" then current_table = checkDAI(room) end
    if cur_zone == "LIB" then current_table = checkLIB(room) end
    if cur_zone == "NO0" or cur_zone == "CEN" then current_table = checkNO0(room) end
    if cur_zone == "NO1" or cur_zone == "BO4" then current_table = checkNO1(room) end
    if cur_zone == "NO2" or cur_zone == "BO0" then current_table = checkNO2(room) end
    if cur_zone == "NO3" then current_table = checkNO3(room) end
    if cur_zone == "NP3" then current_table = checkNO3(room) end
    if cur_zone == "NO4" or cur_zone == "BO3" then current_table = checkNO4(room) end
    if cur_zone == "BO3" then current_table = checkNO4(room) end
    if cur_zone == "NZ0" then current_table = checkNZ0(room) end
    if cur_zone == "NZ1" then current_table = checkNZ1(room) end
    if cur_zone == "TOP" then current_table = checkTOP(room) end

    -- Reverse Castle
    if cur_zone == "RARE" or cur_zone == "RBO0" then current_table = checkRARE(room) end
    if cur_zone == "RCAT" or cur_zone == "RBO8" then current_table = checkRCAT(room) end
    if cur_zone == "RCEN" or cur_zone == "RBO6" then current_table = checkRCEN(room) end
    if cur_zone == "RCHI" or cur_zone == "RBO2" then current_table = checkRCHI(room) end
    if cur_zone == "RDAI" or cur_zone == "RBO3" then current_table = checkRDAI(room) end
    if cur_zone == "RLIB" then current_table = checkRLIB(room) end
    if cur_zone == "RNO0" then current_table = checkRNO0(room, f) end
    if cur_zone == "RNO1" or cur_zone == "RBO4" then current_table = checkRNO1(room) end
    if cur_zone == "RNO2" or cur_zone == "RBO7" then current_table = checkRNO2(room) end
    if cur_zone == "RNO3" then current_table = checkRNO3(room) end
    if cur_zone == "RNO4" or cur_zone == "RBO5" then current_table = checkRNO4(room) end
    if cur_zone == "RNZ0" or cur_zone == "RBO1" then current_table = checkRNZ0(room) end
    if cur_zone == "RNZ1" then current_table = checkRNZ1(room) end
    if cur_zone == "RTOP" then current_table = checkRTOP(room) end

    local rooms = mainmemory.read_u16_le(0x3c760)
    -- by rounding to three decimal places this seems to work correctly
    local found_percent = round(rooms / 1869, 3) * 100
    if found_percent > last_found_percent then
        for i = 5, found_percent, 5 do
            if i >= last_found_percent then
console.log("adding exploration token to current table: " .. (2 * 1))
                current_table["Exploration " .. (2 * i)] = true
                current_table["Exploration " .. (2 * i) .. " item"] = true
            end
        end
        last_found_percent = found_percent
    end

    -- Check if the main table needs update
    if next(current_table) ~= nil then
        for k, v in pairs(current_table) do
            if all_location_table[k] ~= current_table[k] then
                all_location_table[k] = v
            end
        end
    end
end

function checkBosses()
    local bosses_dead = 0
    if mainmemory.read_u16_le(0x03ca78) ~= 0 then
        bosses["Darkwing bat"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Darkwing bat"] = false
    end
    if mainmemory.read_u16_le(0x03ca48) ~= 0 then
        bosses["Beezelbub"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Beezelbub"] = false
    end
    if mainmemory.read_u16_le(0x03ca70) ~= 0 then
        bosses["Doppleganger40"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Doppleganger40"] = false
    end
    if mainmemory.read_u16_le(0x03ca74) ~= 0 then
        bosses["Akmodan II"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Akmodan II"] = false
    end
    if mainmemory.read_u16_le(0x03ca68) ~= 0 then
        bosses["Creature"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Creature"] = false
    end
    if mainmemory.read_u16_le(0x03ca64) ~= 0 then
        bosses["Medusa"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Medusa"] = false
    end
    if mainmemory.read_u16_le(0x03ca58) ~= 0 then
        bosses["Death"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Death"] = false
    end
    if mainmemory.read_u16_le(0x03ca7c) ~= 0 then
        bosses["Galamoth"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Galamoth"] = false
    end
    if mainmemory.read_u16_le(0x03ca54) ~= 0 then
        bosses["Fake Trevor/Grant/Sypha"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Fake Trevor/Grant/Sypha"] = false
    end
    if mainmemory.read_u16_le(0x03ca50) ~= 0 then
        bosses["Karasuman"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Karasuman"] = false
    end
    if mainmemory.read_u16_le(0x03ca40) ~= 0 then
        bosses["Slogra and Gaibon"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Slogra and Gaibon"] = false
    end
    if mainmemory.read_u16_le(0x03ca3c) ~= 0 then
        bosses["Scylla"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Scylla"] = false
    end
    if mainmemory.read_u16_le(0x03ca4c) ~= 0 then
        bosses["Succubus"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Succubus"] = false
    end
    if mainmemory.read_u16_le(0x03ca2c) ~= 0 then
        bosses["Olrox"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Olrox"] = false
    end
    if mainmemory.read_u16_le(0x03ca30) ~= 0 then
        bosses["Doppleganger 10"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Doppleganger 10"] = false
    end
    if mainmemory.read_u16_le(0x03ca6c) ~= 0 then
        bosses["Lesser Demon"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Lesser Demon"] = false
    end
    if mainmemory.read_u16_le(0x03ca44) ~= 0 then
        bosses["Hippogryph"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Hippogryph"] = false
    end
    if mainmemory.read_u16_le(0x03ca5c) ~= 0 then
        bosses["Cerberos"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Cerberos"] = false
    end
    if mainmemory.read_u16_le(0x03ca34) ~= 0 then
        bosses["Legion"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Legion"] = false
    end
    if mainmemory.read_u16_le(0x03ca38) ~= 0 then
        bosses["Minotaurus/Werewolf"] = true
        bosses_dead = bosses_dead + 1
    else
        bosses["Minotaurus/Werewolf"] = false
    end

    return bosses_dead
end

function process_items(f)
    if have_read_last_received == false then
        return
    end

    local table_size = get_table_size(ItemsReceived)
    if start_item_drawing == 0 and table_size >= last_item_processed then
        if have_drawn == false then
            start_item_drawing = f
            gui.drawText(0, 0, get_itemname_by_id(ItemsReceived[last_item_processed]), "red")
            num_item_processed = 1
            if last_item_processed + 1 <= table_size then
                gui.drawText(0, 10, get_itemname_by_id(ItemsReceived[last_item_processed + 1]), "blue")
                num_item_processed = num_item_processed + 1
            end
            if last_item_processed + 2 <= table_size then
                gui.drawText(0, 20, get_itemname_by_id(ItemsReceived[last_item_processed + 2]), "red")
                num_item_processed = num_item_processed + 1
            end
            if last_item_processed + 3 <= table_size then
                gui.drawText(0, 30, get_itemname_by_id(ItemsReceived[last_item_processed + 3]), "blue")
                num_item_processed = num_item_processed + 1
            end
            have_drawn = true
        end
    end

    if start_item_drawing ~= 0 and f - start_item_drawing >= 900 then
        gui.clearGraphics()
        start_item_drawing = 0
        last_item_processed = last_item_processed + num_item_processed
        num_item_processed = 0
        have_drawn = false
    end
end

-- Lua uses 1-based arrays; have to return 1 on failure
function read_last_received()
    if seed == "" or player_name == "" then
        return 1
    end
    local filename = seed .. "_" .. player_name .. ".txt"
-- console.log("read last received -- filename: " .. filename)

    if have_read_last_received then
-- console.log("we have already read last received")
        return 1
    end

    local f, e = io.open(filename, "r")
    -- File doesn't exist
    if e ~= nil then
        have_read_last_received = true
        return 1
    end

    -- file exists
    if f ~= nil then
        line = f:read()
        f:close()
        have_read_last_received = true
        return tonumber(line)
    else
        return 1
    end
end

function write_last_received(last_rec)
    if seed == "" or player_name == "" then
        return
    end
    local filename = seed .. "_" .. player_name .. ".txt"

    local f, e = io.open(filename, "w")
    if e ~= nil then
        console.log("read last received -- Failed to open '" .. filename .. "': " .. e)
        return
    end
    f:write(last_rec .. "\n")
    f:close()

    -- If we're overwriting it, then don't read what we just wrote
    have_read_last_received = true
end

function main()
    if not checkBizHawkVersion() then
        return
    end
    local port = 17242
    print("Using port: "..tostring(port))
    server, error = socket.bind('localhost', port)
    if error ~= nil then
        print(error)
    end

    event.onloadstate(on_loadstate)

    while true do
        frame = frame + 1
        if not (curstate == prevstate) then
            print("Current state: "..curstate)
            prevstate = curstate
        end

        if (curstate == STATE_OK) or (curstate == STATE_INITIAL_CONNECTION_MADE) or (curstate == STATE_TENTATIVELY_CONNECTED) then
            if (frame % 5 == 0) then
                send()
                receive()
                getCurrZone()

                -- printing for testing reasons
                --gui.drawText(200, 0, mainmemory.read_u16_le(0x0973f0))
                --gui.drawText(200, 10, mainmemory.read_u16_le(0x0973f4))
                --gui.drawText(200, 20, mainmemory.read_u16_le(0x1375bc))
                --last_processed_read = read_last_processed()
                --gui.drawText(200, 30, bosses_dead)
                --gui.drawText(300, 0, last_status)
                --gui.drawText(300, 10, last_item_processed .. " - " .. last_processed_read)

                if first_connect then
                    console.log("Just connected!")
                    first_connect = false
                    last_status = 1
                end

                if last_status == 1 then
                    if cur_zone ~= "UNKNOWN" then last_status = 2 end
                end

                if last_status == 2 or last_status == 10 then
                    if not_patched then
                        --**-- Simple Clear Game Script - by Eigh7o --**--
                        mainmemory.write_u16_le(0x3BDE0, 0x02)
                        not_patched = false
                    end
                end

                if last_status == 2 then
                    -- We are connected. At Richter?
                    if cur_zone == "ST0" then
                        last_status = 4
                    end
                    -- At Alucard?
                    if cur_zone ~= "ST0" and cur_zone ~= "UNKNOWN" then
                        -- We just connected and already on Alucard. Loaded game?.
                        last_status = 10
--                      last_processed_read = read_last_processed()
--                      if last_processed_read == 0 and last_processed_read < 1024 then
--                          last_item_processed = 1
--                      else
--                          last_item_processed = last_processed_read
--                      end
                    end
                end

                if last_status == 4 then
                    -- We are at Richter. Game takes a bit to actually start, after defeating Dracula
                    if cur_zone ~= "ST0" then
                        last_status = 8
                    end
                end

                if last_status == 8 then
                    -- Just changed to NO3
                    if delay_timer == 0 then delay_timer = frame end
                    -- Assume 60fps, give 15 seconds to load and Alucard enter the castle
                    if frame - delay_timer >= 900 then
                        last_status = 10
                        delay_timer = 0
                    end
                end

                if last_status == 10 then
                    check_death()
                    if cur_zone == "RBO6" then
                        checkVictory(frame)
                    end

                    if just_died == true then
-- WIP
console.log("just died is true, checking for reset window")
                        if mainmemory.read_u16_le(0x180000) == 0xeed8 then
console.log("just died is true, resetting")
                            getCurrZone()
                            if mainmemory.read_u16_le(0x180000) ~= 0xeed8 and cur_zone ~= "UNKNOWN" then
                                just_died = false
                                not_patched = true
                                have_read_last_received = false
                            end
                        end
                    elseif mainmemory.readbyte(0x09794c) == 2 then
                        if next(ItemsReceived) ~= nil then
                            process_items(frame)
                        end

                        local savedRecently = checkSavedRecently(room)
                        if savedRecently then
                            if saved_in_room == false then
-- WIP
console.log("have saved recently, writing out item index")
                                write_last_received(get_table_size(ItemsReceived))
                                saved_in_room = true
                            end
                        else
                            saved_in_room = false
                        end
                    end

                    checkOneLocation(frame)
                end
            end
        elseif (curstate == STATE_UNINITIALIZED) then
            if  (frame % 60 == 0) then

                print("Waiting for client.")

                emu.frameadvance()
                server:settimeout(2)
                print("Attempting to connect")
                last_status = 0
                local client, timeout = server:accept()
                if timeout == nil then
                    print("Initial connection made")
                    curstate = STATE_INITIAL_CONNECTION_MADE
                    sotnSocket = client
                    sotnSocket:settimeout(0)
                    last_status = 1
                end
            end
        end
        emu.frameadvance()
    end
end

main()
