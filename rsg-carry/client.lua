local RSGCore = exports['rsg-core']:GetCoreObject()
local EntityInHands
local CarriedEntities = {}

RegisterNetEvent('carry:syncStart')
AddEventHandler('carry:syncStart', function(source, entityId)
    local Player = RSGCore.Functions.GetPlayer(source)
    local entityToAttach = NetworkGetEntityFromNetworkId(entityId)
    AttachEntityToEntity(entityToAttach, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.6, -0.3, 0.0, 0.0, 0.0, false, false, true, false, 0, true, false, false)
    CarriedEntities[serverId] = entityId
end)

RegisterNetEvent('carry:syncStop')
AddEventHandler('carry:syncStop', function(source, entityId)
    local Player = RSGCore.Functions.GetPlayer(source)
    local entityToDetach = NetworkGetEntityFromNetworkId(entityId)
    DetachEntity(entityToDetach, false, true)
    CarriedEntities[serverId] = nil
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 0xCEFD9220) then -- E key
            Drop()
        end
    end
end)

function Drop()
    if EntityInHands then
        StopCarrying(EntityInHands)
        EntityInHands = nil
    else
        -- Optional: Add a notification or message if no entity is being carried
        
    end
end



local TargetModels = {}

-- List of models and their distances
local ModelList = {
    {"p_crate02x", 3.0},
    {"p_chair_crate15x", 3.0},
    {"p_stoolfolding01x", 3.0},
    {"p_crate06x", 3.0},
    {"p_barrel05b", 3.0},
    {"p_tincan01x", 3.0},
	{"s_crateseat03x", 3.0},
	{"s_crateseat03x", 3.0},
	{"p_chair_crate02x", 3.0},
	{"mp001_p_cratetriple01x", 3.0},
    {"mp001_p_cratetwin01x", 3.0},
    {"mp001_p_group_crates01", 3.0},
    {"mp001_p_mp_artscrates01x", 3.0},
    {"mp001_p_mp_crate06x", 3.0},
    {"mp001_p_mp_cratebrand01x", 3.0},
    {"mp001_p_mp_cratetnt03x", 3.0},
    {"mp001_p_mp_crateweapon_01a", 3.0},
    {"mp004_mp_gfh_cratebooze01x", 3.0},
    {"mp004_mp_gfh_cratefuel01x", 3.0},
    {"mp004_mp_gfh_crategoods01x", 3.0},
    {"mp004_mp_gfh_cratetobacco01x", 3.0},
    {"mp004_mp_gfh_crateweapons01x", 3.0},
    {"mp004_p_cratetriple01x", 3.0},
    {"mp004_p_cratetwin01x", 3.0},
    {"mp005_mp_cratetrader01x", 3.0},
    {"mp005_mp_nondes_cratetrader01x", 3.0},
    {"mp005_p_mp_cratestack01x", 3.0},
    {"mp006_p_crate01x_nobrand", 3.0},
    {"mp006_p_mnshn_crate06x", 3.0},
    {"mp006_p_mnshn_crate12_01x", 3.0},
    {"mp006_p_moonshine_crate01x", 3.0},
    {"mp006_p_mp006_crate012x", 3.0},
    {"mp006_p_mp006_crate02x", 3.0},
    {"mp006_p_mp006_cratecanvase01x", 3.0},
    {"mp006_p_mp006_cratecover07x", 3.0},
    {"mp008_p_race_cratetriple01x", 3.0},
    {"mp008_p_race_cratetwin01x", 3.0},
    {"mp009_p_mp009_cratetable01x", 3.0},
    {"p_12moonshinecrate01", 3.0},
    {"p_bal_whiskeycrate01", 3.0},
    {"p_bat_cratestack01x", 3.0},
    {"p_bottlecrate01x", 3.0},
    {"p_bottlecrate02x", 3.0},
    {"p_bottlecrate02x_dirty", 3.0},
    {"p_bottlecrate03x", 3.0},
    {"p_bottlecrate05x", 3.0},
    {"p_bottlecrate_cul", 3.0},
    {"p_bottlecrate_hob", 3.0},
    {"p_bottlecrate_mil", 3.0},
    {"p_bottlecrate_sav", 3.0},
    {"p_bottlecrate_sur", 3.0},
    {"p_boxcar_barrelcrate01", 3.0},
    {"p_boxcar_cratecover05", 3.0},
    {"p_boxcar_cratecover09", 3.0},
    {"p_boxcar_crates01x", 3.0},
    {"p_boxcar_rob4_crates01x", 3.0},
    {"p_chair_crate02x", 3.0},
    {"p_crate012ax", 3.0},
    {"p_crate012x", 3.0},
    {"p_crate012x_sea", 3.0},
    {"p_crate01_h", 3.0},
    {"p_crate01x", 3.0},
    {"p_crate01x_var02", 3.0},
    {"p_crate02_h", 3.0},
    {"p_crate03b", 3.0},
    {"p_crate03c", 3.0},
    {"p_crate03d", 3.0},
    {"p_crate03x", 3.0},
    {"p_crate04x", 3.0},
    {"p_crate04x_b", 3.0},
    {"p_crate05x", 3.0},
    {"p_crate05x_group_01", 3.0},
    {"p_crate06bx", 3.0},
    {"p_crate08b", 3.0},
    {"p_crate08x", 3.0},
    {"p_crate14bx", 3.0},
    {"p_crate14cx", 3.0},
    {"p_crate14x", 3.0},
    {"p_crate15bx", 3.0},
    {"p_crate15x_a", 3.0},
    {"p_crate16x", 3.0},
    {"p_crate17x", 3.0},
    {"p_crate20x", 3.0},
    {"p_crate22x", 3.0},
    {"p_crate22x_a", 3.0},
    {"p_crate22x_s_group_01", 3.0},
    {"p_crate22x_small", 3.0},
    {"p_crate23x", 3.0},
    {"p_crate23x_group_01", 3.0},
    {"p_crate24x", 3.0},
    {"p_crate25x", 3.0},
    {"p_crate26bx", 3.0},
    {"p_crate26bx_a", 3.0},
    {"p_crate26bx_b", 3.0},
    {"p_crate26x", 3.0},
    {"p_crate26x_a", 3.0},
    {"p_crate26x_b", 3.0},
    {"p_crate26x_c", 3.0},
    {"p_crate27x", 3.0},
    {"p_crate_snow01x", 3.0},
    {"p_crateapple01b", 3.0},
    {"p_crateapple01x", 3.0},
    {"p_cratebottles01x", 3.0},
    {"p_cratebrand01x", 3.0},
    {"p_cratebrand02x", 3.0},
    {"p_cratebrand03x", 3.0},
    {"p_cratebrand03x_dmg", 3.0},
    {"p_crateburn02x", 3.0},
    {"p_cratecanvase01x", 3.0},
    {"p_cratecanvase02x", 3.0},
    {"p_cratechicken01x", 3.0},
    {"p_cratechicken02x", 3.0},
    {"p_cratechicken03x", 3.0},
	{"mp001_p_barreltriple01x", 3.0},
	{"mp001_p_barreltwin01x", 3.0},
	{"mp001_p_group_barrelshot01", 3.0},
	{"mp001_p_group_barrelshot02", 3.0},
	{"mp001_p_group_barrelshot03", 3.0},
	{"mp001_p_mp_jump_barrellong01", 3.0},
	{"mp001_p_mp_jump_barrelshort01", 3.0},
	{"mp001_p_mp_pickup_barrel_gun01a", 3.0},
	{"mp001_p_mp_pickup_barrel_gun02a", 3.0},
	{"mp001_p_mp_pickup_barrel_logo10x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo11x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo12x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo13x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo14x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo15x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo16x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo17x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo18x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo19x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo1x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo20x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo2x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo3x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo4x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo5x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo6x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo7x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo8x", 3.0},
	{"mp001_p_mp_pickup_barrel_logo9x", 3.0},
	{"mp004_p_barreltriple01x", 3.0},
	{"mp004_p_barreltwin01x", 3.0},
	{"mp005_s_posse_lardbarrels01x", 3.0},
	{"mp005_s_posse_lardbarrels02x", 3.0},
	{"mp006_p_mnshn_barrel02x", 3.0},
	{"mp006_p_mnshn_barrel03x", 3.0},
	{"mp006_p_mnshn_barrelgroup01x", 3.0},
	{"mp006_p_moonshine_barrel01x_dmg", 3.0},
	{"mp006_p_mp_moonshine_barrel01x", 3.0},
	{"mp006_p_mp_moonshine_barrel05x", 3.0},
	{"mp008_p_mnshn_barrelgroup01x", 3.0},
	{"mp008_p_race_barreltriple01x", 3.0},
	{"mp008_p_race_barreltwin01x", 3.0},
	{"p_ambburnbarrel01x", 3.0},
	{"p_barrel010x", 3.0},
	{"p_barrel01ax", 3.0},
	{"p_barrel01ax_sea", 3.0},
	{"p_barrel02_opencs01x", 3.0},
	{"p_barrel02x", 3.0},
	{"p_barrel02x_group_01", 3.0},
	{"p_barrel02x_group_02", 3.0},
	{"p_barrel02x_group_03", 3.0},
	{"p_barrel03x", 3.0},
	{"p_barrel04b", 3.0},
	{"p_barrel04x", 3.0},
	{"p_barrel05b", 3.0},
	{"p_barrel05x", 3.0},
	{"p_barrel06x", 3.0},
	{"p_barrel08x", 3.0},
	{"p_barrel09x", 3.0},
	{"p_barrel11x", 3.0},
	{"p_barrel12x", 3.0},
	{"p_barrel_cor01x", 3.0},
	{"p_barrel_cor01x_dmg", 3.0},
	{"p_barrel_cor02x", 3.0},
	{"p_barrel_ladle01x", 3.0},
	{"p_barrel_wash01x", 3.0},
	{"p_barrelapples01x", 3.0},
	{"p_barrelgroup01x", 3.0},
	{"p_barrelhalf01x", 3.0},
	{"p_barrelhalf02x", 3.0},
	{"p_barrelhalf03x", 3.0},
	{"p_barrelhalf04x", 3.0},
	{"p_barrelhalf05x", 3.0},
	{"p_barrelhalf06x", 3.0},
	{"p_barrelhalf07x", 3.0},
	{"p_barrelhalf08x", 3.0},
	{"p_barrelhalf09bx", 3.0},
	{"p_barrelhalf09bx_dmg", 3.0},
	{"p_barrelhalf09dx", 3.0},
	{"p_barrelhalfgroup01x", 3.0},
	{"p_barrelhoistnbx01x", 3.0},
	{"p_barrell1_h", 3.0},
	{"p_barrelladle1x_culture", 3.0},
	{"p_barrelladle1x_hobo", 3.0},
	{"p_barrelladle1x_military", 3.0},
	{"p_barrelladle1x_savage", 3.0},
	{"p_barrelladle1x_survivor", 3.0},
	{"p_barrellemons01x", 3.0},
	{"p_barrellt_h00", 3.0},
	{"p_barrellt_h01", 3.0},
	{"p_barrellt_h02", 3.0},
	{"p_barrellt_h03", 3.0},
	{"p_barrelmoonshine", 3.0},
	{"p_barreloranges01x", 3.0},
	{"p_barrelpears01x", 3.0},
	{"p_barrelpotatoes01x", 3.0},
	{"p_barrelrabbit01x", 3.0},
	{"p_barrelsalt01x", 3.0},
	{"p_barrelsaltlid01x", 3.0},
	{"p_barrelsaltlid01x_sea", 3.0},
	{"p_barrelshavingbase01x", 3.0},
	{"p_barreltobacco01x", 3.0},
	{"p_barrelwater01x", 3.0},
	{"p_biscuitbarrel01x", 3.0},
	{"p_boxcar_barrel_02a", 3.0},
	{"p_boxcar_barrel_09a", 3.0},
	{"p_boxcar_barrelcrate01", 3.0},
	{"p_cannonbarrel01x", 3.0},
	{"p_chair_barrel04b", 3.0},
	{"p_chickenbarrel01x", 3.0},
	{"p_chickenbarrel02x", 3.0},
	{"p_cs_barrel04x", 3.0},
	{"p_cs_barrel_ladle01x", 3.0},
	{"p_cs_chucksidebarrel03", 3.0},
	{"p_cs_nailbarrel01x", 3.0},
	{"p_firebarrel01x", 3.0},
	{"p_group_barrel01x_sd", 3.0},
	{"p_group_barrel05b", 3.0},
	{"p_group_barrel06x", 3.0},
	{"p_group_barrel09x", 3.0},
	{"p_group_barrelcor01", 3.0},
	{"p_group_barrelshot03", 3.0},
	{"p_grp_barrel01x_sal_sd", 3.0},
	{"p_grp_w_tra_barrelhalf01x", 3.0},
	{"p_gunbarrelset01x", 3.0},
	{"p_gunsmithbarrels01x", 3.0},
	{"p_haypilewheelbarrel01x", 3.0},
	{"p_pigbarrel01x", 3.0},
	{"p_shotgun_doublebarrel01", 3.0},
	{"p_static_barrel_01a", 3.0},
	{"p_static_barrel_01b", 3.0},
	{"p_static_barrel_02a", 3.0},
	{"p_static_barrel_02b", 3.0},
	{"p_static_barrel_03a", 3.0},
	{"p_static_barrel_03b", 3.0},
	{"p_static_barrel_04a", 3.0},
	{"p_static_barrel_04b", 3.0},
	{"p_static_barrel_05a", 3.0},
	{"p_static_barrel_05b", 3.0},
	{"p_static_barrel_06a", 3.0},
	{"p_static_barrel_07a", 3.0},
	{"p_static_barrel_08a", 3.0},
	{"p_static_barrel_09a", 3.0},
	{"p_static_barrel_cor01a", 3.0},
	{"p_static_barrel_cor01b", 3.0},
	{"p_static_barrel_cor02a", 3.0},
	{"p_static_barrel_cor02b", 3.0},
	{"p_static_barrel_cor03a", 3.0},
	{"p_static_barrel_cor03b", 3.0},
	{"p_static_barrel_cor04a", 3.0},
	{"p_static_barrel_cor04b", 3.0},
	{"p_static_barrel_cor05a", 3.0},
	{"p_static_barrel_cor05b", 3.0},
	{"p_static_barrel_cor06a", 3.0},
	{"p_static_barrelcrate01", 3.0},
	{"p_static_cratebarrel01", 3.0},
	{"p_static_w_tra_barrel01x", 3.0},
	{"p_sto_barrel01x", 3.0},
	{"p_sto_barrelsalt01x", 3.0},
	{"p_stovegasbarrel01x", 3.0},
	{"p_tmtsaucebarrel02x", 3.0},
	{"p_tmtsaucebarrels01x", 3.0},
	{"p_veh_cart03_barrels01x", 3.0},
	{"p_veh_chucksidebarrel01", 3.0},
	{"p_veh_chucksidebarrel02", 3.0},
	{"p_veh_chucksidebarrel03", 3.0},
	{"p_veh_sidebarrelsupport01x", 3.0},
	{"p_wheelbarrel01x", 3.0},
	{"p_whiskeybarrel01x", 3.0},
	{"p_winebarrel01x", 3.0},
	{"p_wood_barrel_001", 3.0},
	{"s_barrelartshop01x", 3.0},
	{"s_cvan_barrel", 3.0},
	{"s_gen_barrelhalf02x", 3.0},
	{"w_dis_sho_doublebarrel01", 3.0},
	{"p_crate02x", 3.0},
    {"p_chair_crate15x", 3.0},
    {"p_stoolfolding01x", 3.0},
    {"p_crate06x", 3.0},
    {"p_barrel05b", 3.0},
    {"p_tincan01x", 3.0},
    {"s_crateseat03x", 3.0},
    {"s_crateseat03x", 3.0},
    {"p_chair_crate02x", 3.0},
    {"mp001_p_cratetriple01x", 3.0},
    {"mp001_p_cratetwin01x", 3.0},
    {"mp001_p_group_crates01", 3.0},
    {"mp001_p_mp_artscrates01x", 3.0},
    {"mp001_p_mp_crate06x", 3.0},
    {"mp001_p_mp_cratebrand01x", 3.0},
    {"mp001_p_mp_cratetnt03x", 3.0},
    {"mp001_p_mp_crateweapon_01a", 3.0},
    {"mp004_mp_gfh_cratebooze01x", 3.0},
    {"mp004_mp_gfh_cratefuel01x", 3.0},
    {"mp004_mp_gfh_crategoods01x", 3.0},
    {"mp004_mp_gfh_cratetobacco01x", 3.0},
    {"mp004_mp_gfh_crateweapons01x", 3.0},
    {"mp004_p_cratetriple01x", 3.0},
    {"mp004_p_cratetwin01x", 3.0},
    {"mp005_mp_cratetrader01x", 3.0},
    {"mp005_mp_nondes_cratetrader01x", 3.0},
    {"mp005_p_mp_cratestack01x", 3.0},
    {"mp006_p_crate01x_nobrand", 3.0},
    {"mp006_p_mnshn_crate06x", 3.0},
    {"mp006_p_mnshn_crate12_01x", 3.0},
    {"mp006_p_moonshine_crate01x", 3.0},
    {"mp006_p_mp006_crate012x", 3.0},
    {"mp006_p_mp006_crate02x", 3.0},
    {"mp006_p_mp006_cratecanvase01x", 3.0},
    {"mp006_p_mp006_cratecover07x", 3.0},
    {"mp008_p_race_cratetriple01x", 3.0},
    {"mp008_p_race_cratetwin01x", 3.0},
    {"mp009_p_mp009_cratetable01x", 3.0},
    {"p_12moonshinecrate01", 3.0},
    {"p_bal_whiskeycrate01", 3.0},
    {"p_bat_cratestack01x", 3.0},
    {"p_bottlecrate01x", 3.0},
    {"p_bottlecrate02x", 3.0},
    {"p_bottlecrate02x_dirty", 3.0},
    {"p_bottlecrate03x", 3.0},
    {"p_bottlecrate05x", 3.0},
    {"p_bottlecrate_cul", 3.0},
    {"p_bottlecrate_hob", 3.0},
    {"p_bottlecrate_mil", 3.0},
    {"p_bottlecrate_sav", 3.0},
    {"p_bottlecrate_sur", 3.0},
    {"p_boxcar_barrelcrate01", 3.0},
    {"p_boxcar_cratecover05", 3.0},
    {"p_boxcar_cratecover09", 3.0},
    {"p_boxcar_crates01x", 3.0},
    {"p_boxcar_rob4_crates01x", 3.0},
    {"p_chair_crate02x", 3.0},
    {"p_crate012ax", 3.0},
    {"p_crate012x", 3.0},
    {"p_crate012x_sea", 3.0},
    {"p_crate01_h", 3.0},
    {"p_crate01x", 3.0},
    {"p_crate01x_var02", 3.0},
    {"p_crate02_h", 3.0},
    {"p_crate03b", 3.0},
    {"p_crate03c", 3.0},
    {"p_crate03d", 3.0},
    {"p_crate03x", 3.0},
    {"p_crate04x", 3.0},
    {"p_crate04x_b", 3.0},
    {"p_crate05x", 3.0},
    {"p_crate05x_group_01", 3.0},
    {"p_crate06bx", 3.0},
    {"p_crate08b", 3.0},
    {"p_crate08x", 3.0},
    {"p_crate14bx", 3.0},
    {"p_crate14cx", 3.0},
    {"p_crate14x", 3.0},
    {"p_crate15bx", 3.0},
    {"p_crate15x_a", 3.0},
    {"p_crate16x", 3.0},
    {"p_crate17x", 3.0},
    {"p_crate20x", 3.0},
    {"p_crate22x", 3.0},
    {"p_crate22x_a", 3.0},
    {"p_crate22x_s_group_01", 3.0},
    {"p_crate22x_small", 3.0},
    {"p_crate23x", 3.0},
    {"p_crate23x_group_01", 3.0},
    {"p_crate24x", 3.0},
    {"p_crate25x", 3.0},
    {"p_crate26bx", 3.0},
    {"p_crate26bx_a", 3.0},
    {"p_crate26bx_b", 3.0},
    {"p_crate26x", 3.0},
    {"p_crate26x_a", 3.0},
    {"p_crate26x_b", 3.0},
    {"p_crate26x_c", 3.0},
    {"p_crate27x", 3.0},
    {"p_crate_snow01x", 3.0},
    {"p_crateapple01x", 3.0},
    {"p_crateapple02x", 3.0},
    {"p_cratebanana01x", 3.0},
    {"p_cratebanana02x", 3.0},
    {"p_crategoods01x", 3.0},
    {"p_crategoods01x_empty", 3.0},
    {"p_crategoods01x_group_01", 3.0},
    {"p_crategoods02x", 3.0},
    {"p_crategoods02x_empty", 3.0},
    {"p_crategoods02x_group_01", 3.0},
    {"p_crategoods03x", 3.0},
    {"p_crategoods03x_group_01", 3.0},
	{"mp005_s_posse_col_chair01x", 3.0},
	{"mp005_s_posse_foldingchair_01x", 3.0},
	{"mp005_s_posse_trad_chair01x", 3.0},
	{"mp007_p_mp_chairdesk01x", 3.0},
	{"mp007_p_nat_chairfolding02x", 3.0},
	{"p_ambchair01x", 3.0},
	{"p_ambchair02x", 3.0},
	{"p_armchair01x", 3.0},
	{"p_barberchair01x", 3.0},
	{"p_barberchair02x", 3.0},
	{"p_barberchair03x", 3.0},
	{"p_birthingchair01x", 3.0},
	{"p_bistrochair01x", 3.0},
	{"p_chair02x", 3.0},
	{"p_chair02x_dmg", 3.0},
	{"p_chair04x", 3.0},
	{"p_chair05x", 3.0},
	{"p_chair05x_sea", 3.0},
	{"p_chair06x", 3.0},
	{"p_chair06x_dmg", 3.0},
	{"p_chair07x", 3.0},
	{"p_chair09x", 3.0},
	{"p_chair11x", 3.0},
	{"p_chair12bx", 3.0},
	{"p_chair12x", 3.0},
	{"p_chair13x", 3.0},
	{"p_chair14x", 3.0},
	{"p_chair15x", 3.0},
	{"p_chair16x", 3.0},
	{"p_chair17x", 3.0},
	{"p_chair18x", 3.0},
	{"p_chair19x", 3.0},
	{"p_chair20x", 3.0},
	{"p_chair21_leg01x", 3.0},
	{"p_chair21x", 3.0},
	{"p_chair21x_fussar", 3.0},
	{"p_chair22x", 3.0},
	{"p_chair23x", 3.0},
	{"p_chair24x", 3.0},
	{"p_chair25x", 3.0},
	{"p_chair26x", 3.0},
	{"p_chair27x", 3.0},
	{"p_chair30x", 3.0},
	{"p_chair31x", 3.0},
	{"p_chair34x", 3.0},
	{"p_chair37x", 3.0},
	{"p_chair38x", 3.0},
	{"p_chair_10x", 3.0},
	{"p_chair_barrel04b", 3.0},
	{"p_chair_crate02x", 3.0},
	{"p_chair_crate15x", 3.0},
	{"p_chair_cs05x", 3.0},
	{"p_chair_privatedining01x", 3.0},
	{"p_chairbroken01x", 3.0},
	{"p_chaircomfy01x", 3.0},
	{"p_chaircomfy02", 3.0},
	{"p_chaircomfy03x", 3.0},
	{"p_chaircomfy04x", 3.0},
	{"p_chaircomfy05x", 3.0},
	{"p_chaircomfy06x", 3.0},
	{"p_chaircomfy07x", 3.0},
	{"p_chaircomfy08x", 3.0},
	{"p_chaircomfy09x", 3.0},
	{"p_chaircomfy10x", 3.0},
	{"p_chaircomfy11x", 3.0},
	{"p_chaircomfy12x", 3.0},
	{"p_chaircomfy14x", 3.0},
	{"p_chaircomfy16x", 3.0},
	{"p_chaircomfy17x", 3.0},
	{"p_chaircomfy18x", 3.0},
	{"p_chaircomfy22x", 3.0},
	{"p_chaircomfy23x", 3.0},
	{"p_chaircomfycombo01x", 3.0},
	{"p_chairconvoround01x", 3.0},
	{"p_chairdeck01x", 3.0},
	{"p_chairdeckfolded01x", 3.0},
	{"p_chairdesk01x", 3.0},
	{"p_chairdesk02x", 3.0},
	{"p_chairdining01x", 3.0},
	{"p_chairdining02x", 3.0},
	{"p_chairdining03x", 3.0},
	{"p_chairdoctor01x", 3.0},
	{"p_chairdoctor02x", 3.0},
	{"p_chaireagle01x", 3.0},
	{"p_chairfolding02x", 3.0},
	{"p_chairhob01x", 3.0},
	{"p_chairhob02x", 3.0},
	{"p_chairironnbx01x", 3.0},
	{"p_chairmed01x", 3.0},
	{"p_chairmed02x", 3.0},
	{"p_chairnbx02x", 3.0},
	{"p_chairoffice02x", 3.0},
	{"p_chairpokerfancy01x", 3.0},
	{"p_chairporch01x", 3.0},
	{"p_chairrocking02x", 3.0},
	{"p_chairrocking03x", 3.0},
	{"p_chairrocking04x", 3.0},
	{"p_chairrocking05x", 3.0},
	{"p_chairrocking06x", 3.0},
	{"p_chairrustic01x", 3.0},
	{"p_chairrustic02x", 3.0},
	{"p_chairrustic03x", 3.0},
	{"p_chairrustic04x", 3.0},
	{"p_chairrustic05x", 3.0},
	{"p_chairrusticsav01x", 3.0},
	{"p_chairsalon01x", 3.0},
	{"p_chairtall01x", 3.0},
	{"p_chairvictorian01x", 3.0},
	{"p_chairwhite01x", 3.0},
	{"p_chairwicker01b_static", 3.0},
	{"p_chairwicker01x", 3.0},
	{"p_chairwicker02x", 3.0},
	{"p_chairwicker03x", 3.0},
	{"p_chestchair01x", 3.0},
	{"p_cs_electricchair01x", 3.0},
	{"p_diningchairs01x", 3.0},
	{"p_gen_chair06x", 3.0},
	{"p_gen_chair07x", 3.0},
	{"p_gen_chair08x", 3.0},
	{"p_gen_chairpokerfancy01x", 3.0},
	{"p_group_chair05x", 3.0},
	{"p_medwheelchair01x", 3.0},
	{"p_oldarmchair01x", 3.0},
	{"p_pianochair01x", 3.0},
	{"p_privatelounge_chair01x", 3.0},
	{"p_rockingchair01x", 3.0},
	{"p_rockingchair02x", 3.0},
	{"p_rockingchair03x", 3.0},
	{"p_sit_chairwicker01a", 3.0},
	{"p_sit_chairwicker01b", 3.0},
	{"p_sit_chairwicker01c", 3.0},
	{"p_sit_chairwicker01d", 3.0},
	{"p_sit_chairwicker01e", 3.0},
	{"p_theaterchair01b01x", 3.0},
	{"p_theaterchair02a01x", 3.0},
	{"p_theaterchair02b01x", 3.0},
	{"p_theaterchair02c01x", 3.0},
	{"p_toiletchair01x", 3.0},
	{"p_windsorchair01x", 3.0},
	{"p_windsorchair02x", 3.0},
	{"p_windsorchair03x", 3.0},
	{"p_woodenchair01x", 3.0},
	{"p_woodendeskchair01x", 3.0},
	{"s_bfchair04x", 3.0},
	{"s_chair04x", 3.0},
	{"s_electricchair01x", 3.0},
	{"p_haybale01x", 3.0},
	{"p_sandwhichboard02x", 3.0},
	

    -- Add more models and their corresponding distances here
}

-- Loop through the list and create the TargetModels table
for i = 1, #ModelList do
    table.insert(TargetModels, {
        model = ModelList[i][1],
        distance = ModelList[i][2]
    })
end



for _, targetData in ipairs(TargetModels) do
    exports['rsg-target']:AddTargetModel(targetData.model, {
        options = {
            {
                type = "client",
                event = "carry:toggle",
                icon = "fas fa-undo",
                label = "Pick up " ,
                args = targetData.model
            },
        },
        distance = targetData.distance
    })
end

RegisterNetEvent('carry:toggle')
RegisterNetEvent('carry:drop')

function GetNearbyEntities(entityType, coords)
    local itemset = CreateItemset(true)
    local size = Citizen.InvokeNative(0x59B57C4B06531E1E, coords, Config.MaxDistance, itemset, entityType, Citizen.ResultAsInteger())

    local entities = {}

    if size > 0 then
        for i = 0, size - 1 do
            table.insert(entities, GetIndexedItemInItemset(i, itemset))
        end
    end

    if IsItemsetValid(itemset) then
        DestroyItemset(itemset)
    end

    return entities
end

function GetClosestNetworkedEntity()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closestEntity
    local minDistance

    for _, targetData in ipairs(TargetModels) do
        local objects = GetNearbyEntities(3, playerCoords)
        
        for _, object in ipairs(objects) do
            if GetEntityModel(object) == GetHashKey(targetData.model) then
                local objectCoords = GetEntityCoords(object)
                local distance = #(playerCoords - objectCoords)

                if (not minDistance or distance < minDistance) and distance <= targetData.distance then
                    minDistance = distance
                    closestEntity = object
                end
            end
        end
    end

    return closestEntity
end

function StartCarrying(entity)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)
    local forwardOffset = 0.5 -- Adjust this value as needed for the forward offset
    local handBoneIndex = GetPedBoneIndex(playerPed, 28422) -- Get the index of the right hand bone

    NetworkRequestControlOfEntity(entity)
    FreezeEntityPosition(entity, true) -- Freeze the position of the entity
    AttachEntityToEntity(entity, playerPed, handBoneIndex, 0.0, 0.6, -0.3, 0.0, 0.0, playerHeading, false, false, true, false, 0, true, false, false)
	TriggerEvent('rNotify:NotifyLeft', "PRESS E TO ", "DROP", "generic_textures", "tick", 4000)


end





RegisterCommand("dropitem", function(source, args, rawCommand)
    Drop()
end, false)

function Drop()
    if EntityInHands then
        StopCarrying(EntityInHands)
        EntityInHands = nil
    end
end



function LoadAnimDict(dict)
    if DoesAnimDictExist(dict) then
        RequestAnimDict(dict)

        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end
    end
end

function PlayPickUpAnimation()
    LoadAnimDict(Config.PickUpAnimDict)
    TaskPlayAnim(PlayerPedId(), Config.PickUpAnimDict, Config.PickUpAnimName, 1.0, 1.0, -1, 0, 0, false, false, false, '', false)
    RemoveAnimDict(Config.PickUpAnimDict)
end

function StartCarryingClosestEntity()
    local entity = GetClosestNetworkedEntity()

    if entity then
        PlayPickUpAnimation()

        Citizen.Wait(750)

        StartCarrying(entity)

        return entity
    end
end

function PlayPutDownAnimation()
    LoadAnimDict(Config.PutDownAnimDict)
    TaskPlayAnim(PlayerPedId(), Config.PutDownAnimDict, Config.PutDownAnimName, 1.0, 1.0, -1, 0, 0, false, false, false, '', false)
    RemoveAnimDict(Config.PutDownAnimDict)
end

function PlacePedOnGroundProperly(ped)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local found, groundz, normal = GetGroundZAndNormalFor_3dCoord(x, y, z)
    if found then
        SetEntityCoordsNoOffset(ped, x, y, groundz + normal.z, true)
    end
end

function PlaceOnGroundProperly(entity)
    local entityType = GetEntityType(entity)

    if entityType == 1 then
        PlacePedOnGroundProperly(entity)
    elseif entityType == 2 then
        SetVehicleOnGroundProperly(entity)
    elseif entityType == 3 then
        PlaceObjectOnGroundProperly(entity)
    end
end

function StopCarrying(entity)
    local heading = GetEntityHeading(entity)

    ClearPedTasks(PlayerPedId())

    PlayPutDownAnimation()

    Citizen.Wait(500)

    NetworkRequestControlOfEntity(entity)
    FreezeEntityPosition(entity, false)
    DetachEntity(entity, false, true)
    PlaceOnGroundProperly(entity)
    SetEntityHeading(entity, heading)
end

function ToggleCarry()
    if EntityInHands then
        Stop()
    else
        Start()
    end
end

function Start()
    local entity = StartCarryingClosestEntity()
    if entity then
        EntityInHands = entity
    end
end

function Stop()
    if EntityInHands then
        StopCarrying(EntityInHands)
        EntityInHands = nil
    end
end

function Drop()
    if EntityInHands then
        StopCarrying(EntityInHands)
        EntityInHands = nil
    end
end

function PlayPickUpAnimation()
    LoadAnimDict(Config.PickUpAnimDict)
    TaskPlayAnim(PlayerPedId(), Config.PickUpAnimDict, Config.PickUpAnimName, 1.0, 1.0, -1, 0, 0, false, false, false, '', false)
    RemoveAnimDict(Config.PickUpAnimDict)
end

function PlayPutDownAnimation()
    LoadAnimDict(Config.PutDownAnimDict)
    TaskPlayAnim(PlayerPedId(), Config.PutDownAnimDict, Config.PutDownAnimName, 1.0, 1.0, -1, 0, 0, false, false, false, '', false)
    RemoveAnimDict(Config.PutDownAnimDict)
end


AddEventHandler('carry:toggle', ToggleCarry)
AddEventHandler('carry:drop', Drop)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if EntityInHands then
            DisableControlAction(0, 0x07CE1E61, true)
            DisableControlAction(0, 0xB2F377E8, true)
            DisableControlAction(0, 0x018C47CF, true)
            DisableControlAction(0, 0x2277FAE9, true)

            if not IsEntityAttachedToEntity(EntityInHands, PlayerPedId()) or GetEntityHealth(EntityInHands) == 0 then
                Stop()
            elseif not IsEntityPlayingAnim(PlayerPedId(), Config.CarryAnimDict, Config.CarryAnimName, 25) then
                
            end
        end
    end
end)


