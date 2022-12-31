#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/gametypes_zm/_spawnlogic;
#include maps/mp/animscripts/traverse/shared;
#include maps/mp/animscripts/utility;
#include maps/mp/zombies/_load;
#include maps/mp/_createfx;
#include maps/mp/_music;
#include maps/mp/_busing;
#include maps/mp/_script_gen;
#include maps/mp/gametypes_zm/_globallogic_audio;
#include maps/mp/gametypes_zm/_tweakables;
#include maps/mp/_challenges;
#include maps/mp/gametypes_zm/_weapons;
#include maps/mp/_demo;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/gametypes_zm/_spawning;
#include maps/mp/gametypes_zm/_globallogic_utils;
#include maps/mp/gametypes_zm/_spectating;
#include maps/mp/gametypes_zm/_globallogic_spawn;
#include maps/mp/gametypes_zm/_globallogic_ui;
#include maps/mp/gametypes_zm/_hostmigration;
#include maps/mp/gametypes_zm/_globallogic_score;
#include maps/mp/gametypes_zm/_globallogic;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_ai_faller;
#include maps/mp/zombies/_zm_spawner;
#include maps/mp/zombies/_zm_pers_upgrades_functions;
#include maps/mp/zombies/_zm_pers_upgrades;
#include maps/mp/zombies/_zm_score;
#include maps/mp/animscripts/zm_run;
#include maps/mp/animscripts/zm_death;
#include maps/mp/zombies/_zm_blockers;
#include maps/mp/animscripts/zm_shared;
#include maps/mp/animscripts/zm_utility;
#include maps/mp/zombies/_zm_ai_basic;
#include maps/mp/zombies/_zm_laststand;
#include maps/mp/zombies/_zm_net;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/gametypes_zm/_zm_gametype;
#include maps/mp/_visionset_mgr;
#include maps/mp/zombies/_zm_equipment;
#include maps/mp/zombies/_zm_power;
#include maps/mp/zombies/_zm_server_throttle;
#include maps/mp/gametypes/_hud_util;
#include maps/mp/zombies/_zm_unitrigger;
#include maps/mp/zombies/_zm_zonemgr;
#include maps/mp/zombies/_zm_perks;
#include maps/mp/zombies/_zm_melee_weapon;
#include maps/mp/zombies/_zm_audio_announcer;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_ai_dogs;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/zombies/_zm_game_module;
#include maps/mp/zombies/_zm_buildables;
#include codescripts/character;
#include maps/mp/zombies/_zm_weap_riotshield;
#include maps/mp/zombies/_zm_ai_sloth;
#include maps/mp/zombies/_zm_ai_sloth_ffotd;
#include maps/mp/zombies/_zm_ai_sloth_utility;
#include maps/mp/zombies/_zm_ai_sloth_magicbox;
#include maps/mp/zombies/_zm_ai_sloth_crawler;
#include maps/mp/zombies/_zm_ai_sloth_buildables;

init()
{
		
	precacheshader("menu_mp_lobby_icon_film");
	precacheshader( "menu_mp_lobby_icon_customgamemode" );
	precacheshader( "waypoint_revive" );
	precacheshader( "killiconheadshot" );
	precacheshader( "menu_lobby_icon_twitter" );
	precacheshader( "menu_mp_weapons_1911" );
	precacheshader( "menu_mp_lobby_icon_screenshot" );
	precacheshader( "damage_feedback" ); 
	precacheshader( "zombies_rank_1" );
	precacheshader( "zombies_rank_3" );
	precacheshader( "zombies_rank_2" );
	precacheshader( "zombies_rank_4" );
	precacheshader( "zombies_rank_4_ded");
	precacheshader( "zombies_rank_5" );
	precacheshader( "zombies_rank_5_ded");
	precacheshader( "menu_mp_weapons_xm8" );
	precacheshader( "faction_cdc" ); 
	precacheshader( "menu_mp_weapons_hamr" ); 
	precacheshader( "zombies_rank_5" );
	precacheshader( "hud_grenadeicon" );
	precacheshader( "specialty_instakill_zombies" );
	precacheshader( "menu_mp_weapons_1911" );
	precacheshader( "hud_icon_colt" );
	precachemodel("p6_zm_buildable_sq_meteor");
	precachemodel( "collision_player_wall_512x512x10" );
	precachemodel( "collision_physics_512x512x10" );
	precachemodel( "t5_foliage_tree_burnt03" );
	precachemodel( "p_rus_door_roller" );
	precachemodel( "ch_tombstone1" );
	precachemodel( "collision_geo_256x256x10_standard" );
	precachemodel( "images/specialty_divetonuke_zombies");
	precachemodel( "zombie_vending_tombstone_on" );
	precachemodel( "zombie_vending_revive_on" );
	precachemodel( "zombie_vending_sleight_on" );
	precachemodel( "zombie_vending_doubletap2_on" );
	precachemodel( "p6_zm_vending_vultureaid_on" );
	precachemodel( "zombie_vending_marathon_on" );
	precachemodel( "zombie_pickup_perk_bottle" );
	precachemodel( "zm_collision_perks1" );
	level._effect["fx_zombie_cola_revive_on"] = loadfx( "misc/fx_zombie_cola_revive_on" );
	level._effect["fx_zombie_cola_dtap_on"] = loadfx( "misc/fx_zombie_cola_dtap_on" );
	level._effect["fx_zombie_cola_on"] = loadfx( "misc/fx_zombie_cola_on" );
	level.effect_WebFX = loadfx("misc/fx_zombie_powerup_solo_grab");
	if (  !(  getdvar("mapname") == "zm_buried" || getdvar("mapname") == "zm_tomb"  )  )
	{
		level._effect["fx_default_explosion"] = loadfx( "explosions/fx_default_explosion" );
	}
	
	level thread onPlayerConnect();
	level thread perk_machine_removal( "specialty_scavenger" );
	init_custom_map(); 

	level.get_player_weapon_limit = ::custom_get_player_weapon_limit;
	level.zombie_last_stand = ::LastStand;
	level.custom_vending_precaching = ::default_vending_precaching;
	level.original_damagecallback = level.callbackactordamage;
	level.callbackactordamage = ::actor_damage_override_wrapper;
	register_player_damage_callback( ::damage_callback );

	


   
	level.player_out_of_playable_area_monitor = 0;
	level.perk_purchase_limit = 50;
	
} 
	
	
onPlayerConnect()
{
	while ( 1 )
	{
		level waittill( "connected", player);
		player thread onPlayerSpawned();
		//player thread healthCounter();  // remove these two lines of code to remove 
		//player thread zombieCounter();  // the zombie and health counter. Then recompile with GSC Toolkit.
	}
}
onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon( "game_ended" );
	self waittill( "spawned_player" );
	self.perkarray = [];
	self.dying_wish_on_cooldown = 0;
	self.thunder_wall_on_cooldown = 0;
    self.perk_reminder = 0;
    self.perk_count = 0;
    self.num_perks = 0;
	self.score = 500000;
	self thread removeperkshader();
    self thread perkboughtcheck();
	self thread damagehitmarker();
	//self thread doGetposition();
	for(;;)
	{
		self waittill( "spawned_player" );
		if(self.score < 2500)
		{
			self.score = 2500;
		}
	}
}

healthCounter ()
{
	self endon ("disconnect");
	level endon( "end_game" );
	common_scripts/utility::flag_wait( "initial_blackscreen_passed" );
	self.healthText = maps/mp/gametypes_zm/_hud_util::createFontString ("hudsmall", 1.5);
	self.healthText maps/mp/gametypes_zm/_hud_util::setPoint ("CENTER", "CENTER", 100, 180);
	self.healthText.label = &"Health: ^2";
	while ( 1 )
	{
		self.healthText setValue(self.health);
		wait 0.25;
	}
}

zombieCounter()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	common_scripts/utility::flag_wait( "initial_blackscreen_passed" );
    self.zombieText = maps/mp/gametypes_zm/_hud_util::createFontString( "hudsmall" , 1.5 );
    self.zombieText maps/mp/gametypes_zm/_hud_util::setPoint( "CENTER", "CENTER", -100, 180 );
    while( 1 )
    {
        self.zombieText setValue( ( maps/mp/zombies/_zm_utility::get_round_enemy_array().size + level.zombie_total ) );
        if( ( maps/mp/zombies/_zm_utility::get_round_enemy_array().size + level.zombie_total ) != 0 )
        {
        	self.zombieText.label = &"Zombies: ^1";
        }
        else
        {
        	self.zombieText.label = &"Zombies: ^6";
        }
        wait 0.25;
    }
}
//^^OPTIONAL FEATURES^^


doGetposition() //remove this 
{
	self endon ("disconnect"); 
	self endon ("death"); 
	print_pos = 1;
	if (print_pos==1)
	{
		for(;;)
		{
			self iPrintln("Angle: "+self.angles+"\nPosition: "+self.origin);
			wait 0.5;
		}
	}
}
damagehitmarker()
{
	self thread startwaiting();
	self.hitmarker = newdamageindicatorhudelem( self );
	self.hitmarker.horzalign = "center";
	self.hitmarker.vertalign = "middle";
	self.hitmarker.x = -12;
	self.hitmarker.y = -12;
	self.hitmarker.alpha = 0;
	self.hitmarker setshader( "damage_feedback", 24, 48 );

}
	
	
startwaiting()
{
	while( 1 )
	{
		foreach( zombie in getaiarray( level.zombie_team ) )
		{
			if( !(IsDefined( zombie.waitingfordamage )) )
			{
				zombie thread hitmark();
			}
		}
		wait 0.25;
	}
}


hitmark()
{
	self endon( "killed" );
	self.waitingfordamage = 1;
	while( 1 )
	{
		self waittill( "damage", amount, attacker, dir, point, mod );
		attacker.hitmarker.alpha = 0;
		if( isplayer( attacker ) )
		{
			if( isalive( self ) )
			{
				attacker.hitmarker.color = ( 1, 1, 1 );
				attacker.hitmarker.alpha = 1;
				attacker.hitmarker fadeovertime( 1 );
				attacker.hitmarker.alpha = 0;
			}
			else
			{
				attacker.hitmarker.color = ( 1, 0, 0 );
				attacker.hitmarker.alpha = 1;
				attacker.hitmarker fadeovertime( 1 );
				attacker.hitmarker.alpha = 0;
				self notify( "killed" );
			}
		}
	}
}	

init_custom_map()
{
	if( getdvar( "mapname" ) == "zm_transit" && getdvar( "g_gametype" ) == "zstandard")
	{
		//Town
		perk_system( "script_model", ( 1229.23, -958, -55.875 ), "zombie_vending_sleight_on", ( 0, 0, 0 ), "custom", "mus_perks_sleight_sting", "Widow's Wine", 3000, "sleight_light", "WIDOWS_WINE","zombie_perk_bottle_sleight" );
		perk_system( "script_model", ( 780, 418, -40 ), "zombie_vending_tombstone_on", ( 0, 90, 0 ), "custom", "mus_perks_tombstone_sting", "Thunder Wall", 25000, "tombstone_light", "THUNDER_WALL","zombie_perk_bottle_tombstone" );
		perk_system( "script_model", ( 1553, 940, -61.875 ), "zombie_vending_doubletap2_on", ( 0, 0, 0 ), "custom", "mus_perks_doubletap_sting", "Ammo Regen", 15000, "doubletap_light", "Ammo_Regen","zombie_perk_bottle_jugg" );
		perk_system( "script_model", ( 1815.64, 514.282, -55.875 ), "zombie_vending_marathon_on", ( 0, 90, 0 ), "custom", "mus_perks_stamin_sting", "Burn Heart", 15000, "marathon_light", "Burn_Heart","zombie_perk_bottle_marathon" );
		perk_system( "script_model", ( 2335, -44, -55.875  ), "zombie_vending_revive_on", ( 0, -90, 0 ), "custom", "mus_perks_tombstone_sting", "Dying Wish", 15000, "revive_light", "Dying_Wish","zombie_perk_bottle_revive" );
		perk_system( "script_model", ( 2515, -693, -55.875 ), "zombie_vending_sleight_on", ( 0, 270, 0 ), "custom", "mus_perks_sleight_sting", "Electric Cherry", 3000, "revive_light", "ELECTRIC_CHERRY","zombie_perk_bottle_sleight" );
		perk_system( "script_model", ( 1997, -751, -40 ), "zombie_vending_tombstone_on", ( 0, 180, 0 ), "custom", "mus_perks_tombstone_sting", "Assasin's Creed", 18000, "tombstone_light", "Assasins_Creed","zombie_perk_bottle_tombstone" );
		perk_system( "script_model", ( 981, -163, -55.875 ), "zombie_vending_jugg_on", ( 0, 90, 0 ), "custom", "mus_perks_phd_sting", "PhD Flopper", 8000, "jugger_light", "PHD_FLOPPER","zombie_perk_bottle_jugg" );
		perk_system( "script_model", ( 545, -1350, 120.125  ), "zombie_vending_sleight_on", ( 0, 180, 0 ), "custom", "mus_perks_mulekick_sting", "Mule Kick", 4000, "sleight_light", "MULE","zombie_perk_bottle_sleight" );
		perk_system( "script_model", ( 843, -1480, -44 ), "zombie_vending_tombstone_on", ( 0, 90, 0 ), "custom", "mus_perks_tombstone_sting", "Nightfall", 18000, "tombstone_light", "Nightfall", "zombie_perk_bottle_tombstone" );
		//Farm 
		perk_system( "script_model", ( 8256, -6396, 92.6), "zombie_vending_sleight_on", ( 0, 120, 0 ), "custom", "mus_perks_sleight_sting", "Widow's Wine", 3000, "sleight_light", "WIDOWS_WINE","zombie_perk_bottle_sleight" );
		perk_system( "script_model", ( 7057, -5728, -48), "zombie_vending_marathon_on", ( 0, 90, 0 ), "custom", "mus_perks_tombstone_sting", "Thunder Wall", 25000, "tombstone_light", "THUNDER_WALL","zombie_perk_bottle_tombstone" );
		perk_system( "script_model", ( 8460, -4593, 48), "zombie_vending_doubletap2_on", ( 0, 0, 0 ), "custom", "mus_perks_doubletap_sting", "Ammo Regen", 15000, "doubletap_light", "Ammo_Regen","zombie_perk_bottle_jugg" );
		perk_system( "script_model", ( 7938, -4675, 48 ), "zombie_vending_marathon_on", ( 0, 45, 0 ), "custom", "mus_perks_stamin_sting", "Burn Heart", 15000, "marathon_light", "Burn_Heart","zombie_perk_bottle_marathon" );
		perk_system( "script_model", ( 7893, -6527, 117 ), "zombie_vending_revive_on", ( 0, 120, 0 ), "custom", "mus_perks_tombstone_sting", "Dying Wish", 15000, "revive_light", "Dying_Wish","zombie_perk_bottle_revive" );
		perk_system( "script_model", ( 7848, -4878, 47 ), "zombie_vending_sleight_on", ( 0, 270, 0 ), "custom", "mus_perks_sleight_sting", "Electric Cherry", 3000, "revive_light", "ELECTRIC_CHERRY","zombie_perk_bottle_sleight" );
		perk_system( "script_model", ( 8738, -6577, 109 ), "zombie_vending_tombstone_on", ( 0, 210, 0 ), "custom", "mus_perks_tombstone_sting", "Assasin's Creed", 18000, "tombstone_light", "Assasins_Creed","zombie_perk_bottle_tombstone" );
		perk_system( "script_model", ( 7767, -6329, 117  ), "zombie_vending_jugg_on", ( 0, 120, 0 ), "custom", "mus_perks_phd_sting", "PhD Flopper", 8000, "jugger_light", "PHD_FLOPPER","zombie_perk_bottle_jugg" );
		perk_system( "script_model", (  7921, -5408, 48 ), "zombie_vending_sleight_on", ( 0, 180, 0 ), "custom", "mus_perks_mulekick_sting", "Mule Kick", 4000, "sleight_light", "MULE","zombie_perk_bottle_sleight" );
		perk_system( "script_model", (  8820, -5785, 50 ), "zombie_vending_tombstone_on", ( 0, 270, 0 ), "custom", "mus_perks_tombstone_sting", "Nightfall", 18000, "tombstone_light", "Nightfall", "zombie_perk_bottle_tombstone" );

		
	}
	else if (getdvar ( "mapname" ) == "zm_buried")
	{
		perk_system( "script_model", (-732.102, 20.899, -28.9773), "zombie_vending_marathon_on", (0, 135, 0), "custom", "mus_perks_stamin_sting", "Thunder Wall", 25000, "marathon_light", "THUNDER_WALL","zombie_perk_bottle_marathon");
		perk_system( "script_model", (-37, -735, 8.125), "p6_zm_vending_vultureaid_on", (0, 180, 0), "custom", "mus_perks_vulture_sting", "Dying Wish", 15000, "jugger_light", "Dying_Wish","zombie_perk_bottle_vulture");
		perk_system( "script_model", (890.359, -850.248, -22.0684), "zombie_vending_sleight_on", (0, 270, 0), "custom", "mus_perks_speed_sting", "Electric Cherry", 3000, "revive_light", "ELECTRIC_CHERRY","zombie_perk_bottle_revive");
		perk_system( "script_model", (95.46, 560.359, 8.125), "zombie_vending_jugg", (0, 45, 0), "custom", "mus_perks_phd_sting", "PhD Flopper", 8000, "jugger_light", "PHD_FLOPPER","zombie_perk_bottle_jugg");
		perk_system( "script_model", (1163.82, 592.259, -17.6288), "zombie_vending_doubletap2_on", (0, 340, 0), "custom", "mus_perks_doubletap_sting", "Ammo Regen", 15000, "doubletap_light", "Ammo_Regen","zombie_perk_bottle_doubletap");
		perk_system( "script_model", (3983.92, 210.777, 4.125), "zombie_vending_doubletap2_on", (0,225,0), "custom", "mus_perks_doubletap_sting", "Assasin's Creed", 18000, "doubletap_light", "Assasins_Creed","zombie_perk_bottle_doubletap");
		perk_system( "script_model", (6370.25, 700, -135.875), "zombie_vending_sleight_on", (0, 150,0), "custom", "mus_perks_mulekick_sting", "Widow's Wine", 3000, "sleight_light", "WIDOWS_WINE","zombie_perk_bottle_sleight");
	}
	else if (getdvar( "mapname" ) == "zm_nuked") 
	{	
		
		perk_system( "script_model", ( 632, 418, -57 ), "zombie_vending_sleight_on", ( 0, 190, 0 ), "custom", "mus_perks_sleight_sting", "Widow's Wine", 3000, "sleight_light", "WIDOWS_WINE","zombie_perk_bottle_sleight" );
		perk_system( "script_model", ( 1919, 697, -64 ), "zombie_vending_doubletap2_on", ( 0, 330, 0 ), "custom", "mus_perks_tombstone_sting", "Thunder Wall", 25000, "doubletap_light", "THUNDER_WALL","zombie_perk_bottle_doubletap" );
		perk_system( "script_model", ( 701, 358, 80	 ), "zombie_vending_doubletap2_on", ( 0, 20, 0 ), "custom", "mus_perks_doubletap_sting", "Ammo Regen", 15000, "doubletap_light", "Ammo_Regen","zombie_perk_bottle_jugg" );
		perk_system( "script_model", ( -998, 211, -34 ), "zombie_vending_revive_on", ( 0, 250, 0 ), "custom", "mus_perks_tombstone_sting", "Dying Wish", 15000, "revive_light", "Dying_Wish","zombie_perk_bottle_revive" );
		perk_system( "script_model", ( 699, 560.7, -57 ), "zombie_vending_sleight_on", ( 0, 105, 0 ), "custom", "mus_perks_sleight_sting", "Electric Cherry", 3000, "revive_light", "ELECTRIC_CHERRY","zombie_perk_bottle_sleight" );
		perk_system( "script_model", ( -1830, 686, -48 ), "zombie_vending_doubletap2_on", ( 0, 340, 0 ), "custom", "mus_perks_tombstone_sting", "Assasin's Creed", 18000, "doubletap_light", "Assasins_Creed","zombie_perk_bottle_doubletap" );
		perk_system( "script_model", ( -934, 271, -55 ), "zombie_vending_jugg_on", ( 0, 75, 0 ), "custom", "mus_perks_jugg_sting", "PhD Flopper", 8000, "jugger_light", "PHD_FLOPPER","zombie_perk_bottle_jugg" );
		perk_system( "script_model", (  -897.749, -170, -60), "zombie_vending_sleight_on", ( 0, 110, 0 ), "custom", "mus_perks_mulekick_sting", "Mule Kick", 4000, "sleight_light", "MULE","zombie_perk_bottle_sleight" );
		perk_system( "script_model", ( -868, 352, 85 ), "zombie_vending_doubletap2_on", ( 0, 160, 0 ), "custom", "mus_perks_tombstone_sting", "Nightfall", 18000, "doubletap_light", "Nightfall", "zombie_perk_bottle_doubletap" );
	}
}



play_fx( fx )
{
	playfxontag( level._effect[ fx ], self, "tag_origin" );
}

default_vending_precaching()
{
	level._effect[ "sleight_light" ] = loadfx( "misc/fx_zombie_cola_on" );
	level._effect[ "tombstone_light" ] = loadfx( "misc/fx_zombie_cola_on" );
	level._effect[ "revive_light" ] = loadfx( "misc/fx_zombie_cola_revive_on" );
	level._effect[ "marathon_light" ] = loadfx( "maps/zombie/fx_zmb_cola_staminup_on" );
	level._effect[ "jugger_light" ] = loadfx( "misc/fx_zombie_cola_jugg_on" );
	level._effect[ "doubletap_light" ] = loadfx( "misc/fx_zombie_cola_dtap_on" );
	level._effect[ "deadshot_light" ] = loadfx( "misc/fx_zombie_cola_dtap_on" );
	level._effect[ "additionalprimaryweapon_light" ] = loadfx( "misc/fx_zombie_cola_arsenal_on" );
	level._effect[ "packapunch_fx" ] = loadfx( "maps/zombie/fx_zombie_packapunch" );
	level._effect[ "wall_taseknuck" ] = loadfx( "maps/zombie/fx_zmb_wall_buy_taseknuck" );
}

custom_get_player_weapon_limit( player )
{
    weapon_limit = 2;
    if ( player hascustomperk("MULE") )
    {
        weapon_limit = 3;
    } 
	else 
	{
        weapons = self getWeaponsListPrimaries();
        if(weapons.size > 2)
		{
            self takeWeapon(weapons[2]);
        }
    }
    return weapon_limit;
}

playchalkfx(effect, origin, angles)
{
    fx = SpawnFX(level._effect[ effect ], origin,AnglesToForward(angles),AnglesToUp(angles));
    TriggerFX(fx);
    level waittill("connected", player);
    fx Delete();
}

perk_system( script, pos, model, angles, type, sound, name, cost, fx, perk, bottle)
{
	col = spawn( script, pos);
	col setmodel( model );
	col.angles = angles;
	x = spawn( script, pos );
	x setmodel( "zm_collision_perks1" );
	x.angles = angles;
    col thread buy_system( perk, sound, name, cost, type, bottle );
    col thread play_fx( fx );
}

buy_system( perk, sound, name, cost, type, bottle)
{
    self endon( "game_ended" );
    while( 1 )
    {
        foreach( player in level.players )
        {
            if(!player.machine_is_in_use)
			{
                if( distance( self.origin, player.origin ) <= 70 )
                {
				    player thread SpawnHint( self.origin, 30, 30, "HINT_ACTIVATE", "Hold ^3&&1^7 for " + name + " [Cost: " + cost + "]" );
                    if(player usebuttonpressed() && !player hasperk(perk) && !player hascustomperk(perk) && player.score >= cost && !player maps/mp/zombies/_zm_laststand::player_is_in_laststand())
                    {
                        player.machine_is_in_use = 1;
                        player playsound( "zmb_cha_ching" );
                        player.score -= cost;
                        player playsound( sound );
			    	    player thread drawshader_and_shadermove( perk, 1, 1, bottle );
						wait 4;
                    	player.machine_is_in_use = 0;
					}
					else
                    {
                        if( player usebuttonpressed() && player.score < cost )
                        {
                            player maps/mp/zombies/_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
                        }
                    }
                }
            }
        }
        wait 0.1;
    }
}

hascustomperk(perk)
{
	for(i = 0; i < self.perkarray.size; i++)
	{
		if(self.perkarray[i].name == perk)
		{
			return 1;
		}
	}
	return 0;
}

removeperkshader()
{
    for(;;)
    {
        self waittill_any_return( "fake_death", "player_downed", "player_revived", "spawned_player", "disconnect", "death" );
        self.num_perks = 0;
        self.perk_reminder = 0;
        self.perk_count = 0;
		self.dying_wish_on_cooldown = 0;
		self.thunder_wall_on_cooldown = 0;
		self removeallcustomshader();
		self.perkarray = [];
        self notify( "stopcustomperk" );
        self.bleedout_time = 30;
	    self.ignore_lava_damage = 0;
    }
}

setPlayerDvar(player, dvar, value) 
{
    thedvar = player getXUID() + "_" + dvar;
    setDvar(thedvar, value);
}
removeallcustomshader()
{
	for(i = 0; i < self.perkarray.size; i++)
	{
		self.perkarray[i] destroy();
	}
}

drawshader( shader, x, y, width, height, color, alpha, sort )
{
	hud = newclienthudelem( self );
	hud.elemtype = "icon";
	hud.color = color;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.children = [];
    hud.hidewheninmenu = 1;
	hud setparent( level.uiparent );
	hud setshader( shader, width, height );
	hud.x = x;
	hud.y = y;
	return hud;
}

perkboughtcheck()
{
    self endon("death");
    self endon("disconnect");
    for(;;)
    {
        self.perk_reminder = self.num_perks;
        self waittill("perk_acquired");
		n = 1;
        if(!(self.num_perks > self.perk_reminder))
        {
			n = (self.num_perks - self.perk_reminder);
            self.num_perks = (self.perk_reminder + n);
        }
        self.perk_reminder = self.num_perks;
        self.perk_count += n;
        self drawshader_and_shadermove("none", 0, 0);
    }
}
set_anim_rate( n_speed )
{
	self setclientfield( "anim_rate", n_speed );
	n_rate = self getclientfield( "anim_rate" );
	self setentityanimrate( n_rate );
	if ( n_speed != 1 )
	{
		self.preserve_asd_substates = 1;
	}
	wait_network_frame();
	if ( !is_true( self.is_traversing ) )
	{
		self.needs_run_update = 1;
		self notify( "needs_run_update" );
	}
	wait_network_frame();
	if ( n_speed == 1 )
	{
		self.preserve_asd_substates = 0;
	}
}

drawshader_and_shadermove(perk, custom, print, bottle)
{
    if(custom)
	{
        self allowProne(false);
        self allowSprint(true);
        self disableoffhandweapons();
        self disableweaponcycling();
        weapona = self getcurrentweapon();
        weaponb = bottle;
        self giveweapon( weaponb );
        self switchtoweapon( weaponb );
        self waittill( "weapon_change_complete" );
        self enableoffhandweapons();
        self enableweaponcycling();
        self takeweapon( weaponb );
        self switchtoweapon( weapona );
        self maps/mp/zombies/_zm_audio::playerexert( "burp" );
        self setblur( 4, 0.1 );
        wait 0.1;
        self setblur( 0, 0.1 );
        self allowProne(true);
    }
    x = -408 + (self.perk_count * 30);
	if (getdvar("mapname")=="zm_buried" || getdvar("mapname") == "zm_tomb")
	{
		y = 320;
	}
	else
	{
		y = 350;
	}
	
    for(i = 0; i < self.perkarray.size; i++)
	{
    	self.perkarray[i].x = self.perkarray[i].x + 30;
	}
        if(perk == "Downers_Delight")
        {
            self.perk1back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 0, 0, 0 ), 100, 0 );  
            self.perk1front = self drawshader( "waypoint_revive", x, y, 23, 23, ( 0, 1, 1 ), 100, 0 ); 
            self.perk1front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk1front;
			self.perk1back.name = perk;
			self.perkarray[self.perkarray.size] = self.perk1back;
			self.num_perks++;
			self thread DDown();
			if(print)
			{
				self iprintln("^9Downer's Delight");
				wait 0.2;
				self iprintln("This Perk will increase players bleedout time by 10 seconds and current weapons is used in laststand.");
			}
		}
        if(perk == "MULE")
        {   
            self.perk2back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk2front = self drawshader( "menu_mp_weapons_1911", x, y, 22, 22, ( 0, 1, 0 ), 100, 0 );
            self.perk2front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk2front;
			self.perk2back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk2back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9Mule Kick");
				wait 0.2;
				self iprintln("This Perk enables additional primary weapon slot for player. ");
			}
		}
        if(perk == "PHD_FLOPPER")
        {    
            self.perk3back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk3front = self drawshader( "hud_grenadeicon", x, y, 23, 23, (1, 0, 1 ), 100, 0 );
            self.perk3front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk3front;
			self.perk3back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk3back;
			self.num_perks++;
			self thread doPHDdive();
			if(print)
			{
				self iprintln("^9PhD Flopper");
				wait 0.2;
				self iprintln("This Perk removes explosion and fall damage also player creates explosion when dive to prone.");
			}
		}
        if(perk == "Victorious_Tortoise")
        {    
            self.perk4back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 0, 200, 0 ), 100, 0 );
            self.perk4front = self drawshader( "zombies_rank_2", x, y, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk4front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk4front;
			self.perk4back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk4back;
			self.num_perks++;
			self thread start_vt();
			if(print)
			{
				self iprintln("^9Victorious Tortoise");
				wait 0.2;
				self iprintln("This Perk allows shield block damage from all directions when in use.");
        	}
		}
        if(perk == "ELECTRIC_CHERRY")
        {    
            self.perk5back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 0, 0, 200 ), 100, 0 );
            self.perk5front = self drawshader( "zombies_rank_5", x, y, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk5front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk5front;
			self.perk5back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk5back;
			self.num_perks++;
			self thread start_ec();
			if(print)
			{
				self iprintln("^9Electric Cherry");
				wait 0.2;
				self iprintln("This Perk creates an electric shockwave around the player whenever they reload.");
        	}
		}	
        if(perk == "THUNDER_WALL")
        {    
            self.perk6back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk6front = self drawshader( "zombies_rank_5_ded", x, y, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk6front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk6front;
			self.perk6back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk6back;
			self.num_perks++;
			self thread thunder_wall_checker();
			if(print)
			{
				self iprintln("^9Thunder Wall");
				wait 0.2;
				self iprintln("This Perk launches nearby zombies into the air when the player is hit.");
        	}
		}
        if(perk == "Assasins_Creed")
        {    
            self.perk7back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk7front = self drawshader( "zombies_rank_4", x, y, 23, 23, ( 1, 1, 1 ), 100, 0 );
			self.perk7front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk7front;
			self.perk7back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk7back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9Assasin's Creed");
				wait 0.2;
				self iprintln("This perk gives melee attacks one shot kills and gives extra points.");
        	}
		}
		if(perk == "Ammo_Regen")
        {
            self.perk8back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk8front = self drawshader( "menu_mp_lobby_icon_customgamemode", x, y, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk8front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk8front;
			self.perk8back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk8back;
			self.num_perks++;
			self thread ammoregen();
            self thread grenadesregen();
			if(print)
			{
				self iprintln("^9Ammo Regen");
				wait 0.2;
				self iprintln("This Perk will slowly regenerate the players ammunation and grenades.");			
			}
		}
        if(perk == "Burn_Heart")
        {
            self.perk9back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk9front = self drawshader( "faction_cdc", x, y, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk9front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk9front;
			self.perk9back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk9back;
			self.num_perks++;
            self.ignore_lava_damage = 1;
			if(print)
			{
				self iprintln("^9Burn Heart");
				wait 0.2;
				self iprintln("This Perk removes lava damage.");
			}
		}
        if(perk == "Dying_Wish")
        {
            self.perk10back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 200, 0, 0 ), 100, 0 );
            self.perk10front = self drawshader( "zombies_rank_5", x, y, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk10front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk10front;
			self.perk10back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk10back;
			self.num_perks++;
            self thread dying_wish_checker();
			if(print)
			{
				self iprintln("^9Dying Wish");
				wait 0.2;
				self iprintln("This perk gives you a second chance if you die.");
				wait 0.1;
				self iprintln("( cooldown of 5 minutes )");
			}
		}
	
        if(perk == "WIDOWS_WINE")
        {
            self.perk11back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk11front = self drawshader( "zombies_rank_3", x, y, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk11front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk11front;
			self.perk11back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk11back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9Widow's Wine");
				wait 0.2;
				self iprintln("This Perk damages zombies around the player when they are hit and slows zombies down.");
        	}
		}

		if (perk == "Nightfall")
		{
			self.perk12back = self drawshader( "specialty_marathon_zombies", x, y, 24, 24, ( 0, 0, 0 ), 100, 0 );
            self.perk12front = self drawshader( "zombies_rank_4_ded", x, y, 23, 23, ( 1, 1, 1 ), 100, 0 );
            self.perk12front.name = perk;
			self.perkarray[self.perkarray.size] = self.perk12front;
			self.perk12back.name = perk;
            self.perkarray[self.perkarray.size] = self.perk12back;
			self.num_perks++;
			if(print)
			{
				self iprintln("^9Nightfall");
				wait 0.2;
				self iprintln("This Perk gives the DSR 50 and its upgraded variant a one shot kill at any round.");
        	}
		}
}

custom_get_player_weapon_limit( player )
{
    weapon_limit = 2;
    if ( player hascustomperk("MULE") )
    {
        weapon_limit = 3;
    } 
	else 
	{
        weapons = self getWeaponsListPrimaries();
        if(weapons.size > 2)
		{
            self takeWeapon(weapons[2]);
        }
    }
    return weapon_limit;
}

ammoregen()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		if(!self GetCurrentWeapon() == "" && !is_grenade_launcher( self GetCurrentWeapon()) )
		{
			stockcount = self getweaponammostock( self GetCurrentWeapon() );
			self setWeaponAmmostock( self GetCurrentWeapon(), stockcount + 1 );
			wait 0.5;
		}
		wait 0.1;
	}
}
doPHDdive() //credit to extinct
{
	self endon("disconnect");
	level endon("end_game");
	
	for(;;)
	{
		if(isDefined(self.divetoprone) && self.divetoprone)
		{
			if(self isOnGround() && (self hascustomperk("PHD_FLOPPER")))
			{
				points=0;
				if(level.script == "zm_tomb" || level.script == "zm_buried")	
					explosionfx = level._effect["divetonuke_groundhit"];
				else
					explosionfx = loadfx("explosions/fx_default_explosion");
				self playSound("zmb_phdflop_explo");
				playfx(explosionfx, self.origin);
				zombies = getAiArray(level.zombie_team);
				foreach(zombie in zombies)
				{
					if(distance(zombie.origin, self.origin) < 300)
					{
						zombie doDamage(zombie.health * 2, zombie.origin, self);
						points+=50;
					}
				}
				wait .3;
			}
		}
		wait .05;
	}
}
grenadesregen()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		grenades = self get_player_lethal_grenade();
        grenade_count = self getweaponammoclip(grenades);
        if(grenade_count < 4)
		{
        	self setweaponammoclip(grenades, (grenade_count + 1));
		}
		tactical_grenades = self get_player_tactical_grenade();
        tactical_grenade_count = self getweaponammoclip(tactical_grenades);
        if(tactical_grenade_count < 3 )
		{
        	self setweaponammoclip(tactical_grenades, (tactical_grenade_count + 1));
		}
		wait 300;
	}
}

start_ec()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("stopcustomperk");
	for(;;)
	{
		self waittill( "reload_start" );
    	playfxontag( level._effect[ "poltergeist"], self, "J_SpineUpper" );
		self EnableInvulnerability();
		RadiusDamage(self.origin, 120, 200, 100, self);
		self DisableInvulnerability();
		self playsound( "zmb_turbine_explo" );
		wait 1;
	}
}

start_vt()
{
	level endon("end_game");
	self endon("disconnect");
	self endon("stopcustomperk");
	for(;;)
	{
		if(self getcurrentweapon() == "riotshield_zm" )
		{
			self enableInvulnerability();
			self.shielddamagetaken += 100;
			wait 0.9;
		}
		else
		{
			self disableInvulnerability();
		}
		wait 0.1;
	}
}



LastStand()
{
    if(self hascustomperk("Downers_Delight"))
	{
        self.customlaststandweapon = self getcurrentweapon();
		self switchtoweapon( self.customlaststandweapon );
		self setweaponammoclip( self.customlaststandweapon, 150 );
		self.bleedout_time = 40;
    } 
	else 
	{
        self maps/mp/zombies/_zm::last_stand_pistol_swap();
    }
}

DDown() 
{
	self endon( "disconnect" );
	level endon( "end_game" );
	self endon( "stopcustomperk" );
	for(;;)
	{
		self waittill("player_downed");
		self playsound( "zmb_phdflop_explo" );
		if(level.script == "zm_tomb" || level.script == "zm_buried")	
			explosionfx = level._effect["divetonuke_groundhit"];
		else
			explosionfx = loadfx("explosions/fx_default_explosion");
		playfx(explosionfx, self.origin, anglestoforward( ( 0, 45, 55  ) ) ); 
		RadiusDamage(self.origin, 150, 600, 400, self);
		wait 0.1;
	}
}

doGivePerk(perk)
{
    self endon("disconnect");
    self endon("death");
    level endon("game_ended");
    self endon("perk_abort_drinking");
    if (!(self hasperk(perk) || (self maps/mp/zombies/_zm_perks::has_perk_paused(perk))))
    {
        gun = self maps/mp/zombies/_zm_perks::perk_give_bottle_begin(perk);
        evt = self waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete");
        if (evt == "weapon_change_complete")
            self thread maps/mp/zombies/_zm_perks::wait_give_perk(perk, 1);
        self maps/mp/zombies/_zm_perks::perk_give_bottle_end(gun, perk);
        if (self maps/mp/zombies/_zm_laststand::player_is_in_laststand() || isDefined(self.intermission) && self.intermission)
            return;
        self notify("burp");
    }
}


SpawnHint( origin, width, height, cursorhint, string )
{
	hint = spawn( "trigger_radius", origin, 1, width, height );
	hint setcursorhint( cursorhint, hint );
	hint sethintstring( string );
	hint setvisibletoall();
	wait 0.2;
	hint delete();
}
object_touching_lava()
{
	if ( !isDefined( level.lava ) )
	{
		level.lava = getentarray( "lava_damage", "targetname" );
	}
	if ( !isDefined( level.lava ) || level.lava.size < 1 )
	{
		return 0;
	}
	if ( isDefined( self.lasttouching ) && self istouching( self.lasttouching ) )
	{
		return 1;
	}
	i = 0;
	while ( i < level.lava.size )
	{
		if ( distancesquared( self.origin, level.lava[ i ].origin ) < 2250000 )
		{
			if ( isDefined( level.lava[ i ].target ) )
			{
				if ( self istouching( level.lava[ i ].volume ) )
				{
					if ( isDefined( level.lava[ i ].script_float ) && level.lava[ i ].script_float <= 0.1 )
					{
						return 0;
					}
					self.lasttouching = level.lava[ i ].volume;
					return 1;
				}
			}
			else
			{
				if ( self istouching( level.lava[ i ] ) )
				{
					self.lasttouching = level.lava[ i ];
					return 1;
				}
			}
		}
		i++;
	}
	self.lasttouching = undefined;
	return 0;
}

ww_points( player )
{
    for(i = 0; i < 3; i++)
    {
		self maps/mp/zombies/_zm_utility::set_zombie_run_cycle("walk");
        player maps/mp/zombies/_zm_score::add_to_player_score( 10 );
        PlayFXOnTag(level.effect_WebFX,self,"j_spineupper");
        self doDamage(150, (0, 0, 0));
        if(getdvar( "mapname" ) == "zm_tomb" )
        {
            self set_anim_rate(0.1);
        }
        wait 1;
    }
    if(getdvar( "mapname" ) == "zm_tomb" )
    {
        self set_anim_rate( 1 );
        if(!isalive(self))
        {
            self delete();
        }
    }
}

ww_nade_explosion()
{
    wait 2;
	if(getdvar( "mapname" ) == "zm_transit")
    {
        if( self object_touching_lava())
        {
            self delete();
            return 0;
        }
    }
	foreach(zombie in getAiArray(level.zombie_team))
	{
        if( distance( zombie.origin, self.origin ) < 210 )
		{
            zombie thread ww_points( self );
        }
    }
    self delete();
}

ww_nades()
{
    level endon("end_game");
    self endon("disconnect");
    self endon("stopcustomperk");
    for(;;)
	{
        self waittill( "grenade_fire", grenade, weapname );
        if( weapname == "sticky_grenade_zm" )
		{
            ww_nade = spawnsm( grenade.origin, "zombie_bomb" );
            ww_nade hide();
            ww_nade linkto( grenade );
            ww_nade thread ww_nade_explosion();
        }
    }
}

spawnsm( origin, model, angles )
{
    ent = spawn( "script_model", origin );
    ent setmodel( model );
    if( IsDefined( angles ) )
    {
        ent.angles = angles;
    }
    return ent;
}



	
	
cool_down(time)
{
	self.cooldown = 1;
	wait time;
	self.cooldown = 0;
}

thunderwall( eattacker ) 
{
	thunder_wall_blast_pos = self.origin;
	ai_zombies = get_array_of_closest( thunder_wall_blast_pos, getaiarray( level.zombie_team ), undefined, undefined, 250  );
	if ( !isDefined( ai_zombies ) )
	{
		return;
	}
	if (ai_zombies.size > 4)
	{
		self notify("thunder_wall_activation");
		flung_zombies = 0;
		for ( i = 0; i < ai_zombies.size; i++ )
		{
			if(isDefined(ai_zombies[i].is_avogadro) && ai_zombies[i].is_avogadro || isDefined(ai_zombies[i].is_brutus) && ai_zombies[i].is_brutus || isDefined(ai_zombies[i].is_mechz) && ai_zombies[i].is_mechz )
			{
				//boss zombie check
			}
			else
			{
				n_random_x = RandomFloatRange( -3, 3 );
				n_random_y = RandomFloatRange( -3, 3 );
				ai_zombies[i] StartRagdoll();
				ai_zombies[i] LaunchRagdoll( (n_random_x, n_random_y, 150) );
				playfxontag( level._effect[ "jetgun_smoke_cloud"], ai_zombies[i], "J_SpineUpper" );
				ai_zombies[i] DoDamage( ai_zombies[i].health * 2, ai_zombies[i].origin, self, self, "none", "MOD_IMPACT" );
				flung_zombies++;
				if ( flung_zombies >= 50 )
				{
					break;
				}
			}
		}
	}
}





actor_damage_override_wrapper( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex ) 
{
	damage_override = self actor_damage_override_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
	if ( ( self.health - damage_override ) > 0 || !is_true( self.dont_die_on_me ) )
	{
		self finishactordamage( inflictor, attacker, damage_override, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
	}
}



actor_damage_override_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
	if(isdefined(level.sloth) && self == level.sloth || isDefined(self.is_avogadro) && self.is_avogadro || isDefined(self.is_brutus) && self.is_brutus || isDefined(self.is_mechz) && self.is_mechz )
    {
		return [[level.original_damagecallback]]( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
    }
	if ( isdefined(attacker) && isplayer( attacker ) )
	
	{
		if ( meansofdeath == "MOD_MELEE" && attacker hascustomperk("Assasins_Creed") )
		{
			ai_zombies = getaiarray(level.zombie_team);
			attacker maps/mp/zombies/_zm_score::add_to_player_score(250);
			attacker.health+=20;
			return ((ai_zombies[0].health)*2);
		}
		if((weapon=="dsr50_zm" || weapon=="dsr50_upgraded_zm") && attacker hascustomperk("Nightfall") )
		{
			ai_zombies = getaiarray(level.zombie_team);
			attacker maps/mp/zombies/_zm_score::add_to_player_score(250);
			attacker.health+=20;
			return ((ai_zombies[0].health)*2);
		}
	}
	
	return [[level.original_damagecallback]]( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex );
}






damage_callback( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex )
{
    
	if( isDefined( eattacker.is_zombie ) && eattacker.is_zombie && self hascustomperk("THUNDER_WALL") && !self.thunder_wall_on_cooldown)
	{	
		self thread thunderwall(eAttacker);
	}
	if( isDefined( eattacker.is_zombie ) && eattacker.is_zombie && self hascustomperk("WIDOWS_WINE") )
	{
		zombies = getaiarray(level.zombie_team);
        foreach(zombie in zombies)
    	{
	   		if(distance(self.origin, zombie.origin) < 150)
        	{
				zombie thread ww_points( self );
			}
		}
    }
	
    if (self hascustomperk("PHD_FLOPPER"))
	{
		if( smeansofdeath == "MOD_PROJECTILE" || smeansofdeath == "MOD_FALLING" || smeansofdeath == "MOD_PROJECTILE_SPLASH" || smeansofdeath == "MOD_EXPLOSIVE" || smeansofdeath == "MOD_GRENADE" || smeansofdeath == "MOD_GRENADE_SPLASH")
		{
			return 0;
		}
		
	}
	
    
    if(idamage > self.health && !self.dying_wish_on_cooldown && self hascustomperk("Dying_Wish") )
	{
		self notify("dying_wish_charge");
	    self thread dying_wish_effect();
        return 0;
	}
	return idamage;
}


thunder_wall_checker()
{
	level endon("end_game");
    self endon("disconnect");
    self endon( "stopcustomperk" );
	for(;;)
	{
		self.thunder_wall_on_cooldown = 0;
		self.perk6back.alpha = 1;
        self.perk6front.alpha = 1;
		self waittill("thunder_wall_activation");
		self.perk6back.alpha = 0.3;
        self.perk6front.alpha = 0.4;
		self.thunder_wall_on_cooldown = 1;
		thunder_wall_cooldown=10;
		wait thunder_wall_cooldown;
	}
}
	
dying_wish_checker()
{
    level endon("end_game");
    self endon("disconnect");
    self endon( "stopcustomperk" );
    self.dying_wish_uses = 0;
    for(;;)
	{
        self.dying_wish_on_cooldown = 0;
        self.perk10back.alpha = 1;
        self.perk10front.alpha = 1;
        self waittill("dying_wish_charge");
        self.perk10back.alpha = 0.3;
        self.perk10front.alpha = 0.4;
        self.dying_wish_uses++;
        self.dying_wish_on_cooldown = 1;
        delay = 300;
        wait delay;
    }
}


dying_wish_effect()
{
    self iprintln("Dying Wish saved you!");
    self enableInvulnerability();
    self.ignoreme = 1;
    self useServerVisionSet(1);
    self setvisionsetforplayer( "zombie_death", 0 );
    wait 9;
	self.health = 1;
    self disableInvulnerability();
    self.ignoreme = 0;
    self useServerVisionSet(0);
    self setvisionsetforplayer("remote_mortar_enhanced", 0);
}


player_burning_audio()
{
	fire_ent = spawn( "script_model", self.origin );
	wait_network_frame();
	fire_ent linkto( self );
	fire_ent playloopsound( "evt_plr_fire_loop" );
	self waittill_any( "stop_flame_damage", "stop_flame_sounds", "death", "disconnect" );
	fire_ent delete();
}

Perkaholic()
{
	self.num_perks = 0;
	if(!self hasperk("specialty_armorvest"))
	{
    	self give_perk( "specialty_armorvest" );
		wait 0.1;
	}
	else
	{
		self.num_perks++;
	}
	if(!self hasperk("specialty_fastreload"))
	{
		self give_perk( "specialty_fastreload" );
		wait 0.1;
	}
	else
	{
		self.num_perks++;
	}
	if(!self hasperk("specialty_rof"))
	{
    	self give_perk( "specialty_rof" );
		wait 0.1;
	}
	else
	{
		self.num_perks++;
	}
	if( getdvar( "mapname" ) == "zm_transit")
	{
		if(!self hasperk("specialty_quickrevive"))
		{
			self give_perk( "specialty_quickrevive" );
			wait 0.1;
		}
		else
		{
			self.num_perks++;
		}
		/*if(!self hasperk("specialty_scavenger"))
    	{
			self give_perk( "specialty_scavenger" );
			wait 0.1;
		}
		else
		{
			self.num_perks++;
		}*/
		if(!self hasperk("specialty_longersprint"))
		{
			self give_perk( "specialty_longersprint" );
			wait 0.1;
		}
		else
		{
			self.num_perks++;
		}
	}
	if( getdvar( "mapname" ) == "zm_prison" )
	{
		if(!self hasperk("specialty_grenadepulldeath"))
		{
        	self give_perk("specialty_grenadepulldeath");
		}
		if(!self hasperk("specialty_deadshot"))
        {
			self give_perk("specialty_deadshot");
		}
	}
	if( getdvar( "mapname" ) == "zm_nuked" )
	{
		if(!self hasperk("specialty_quickrevive"))
		{
			self give_perk("specialty_quickrevive");
		}
	}
	if( getdvar( "mapname" ) == "zm_tomb")
	{
		if(!self hasperk("specialty_deadshot"))
		{
			self give_perk( "specialty_deadshot" );
		}
		if(!self hasperk("specialty_grenadepulldeath"))
		{
    		self give_perk( "specialty_grenadepulldeath" );
		}
		if(!self hasperk("specialty_flakjacket"))
    	{
			self give_perk( "specialty_flakjacket" );
		}
		if(!self hasperk("specialty_quickrevive"))
        {
			self give_perk( "specialty_quickrevive" );
		}
		if(!self hasperk("specialty_additionalprimaryweapon"))
		{
			self give_perk( "specialty_additionalprimaryweapon" );
		}
		if(!self hasperk("specialty_longersprint"))
		{
			self give_perk( "specialty_longersprint" );
		}
	}
	if( getdvar( "mapname" ) == "zm_buried")
	{
		if(!self hasperk("specialty_nomotionsensor"))
    	{
			self give_perk("specialty_nomotionsensor");
		}
		if(!self hasperk("specialty_additionalprimaryweapon"))
		{
			self give_perk( "specialty_additionalprimaryweapon" );
		}
		if(!self hasperk("specialty_quickrevive"))
    	{
			self give_perk( "specialty_quickrevive" );
		}
		if(!self hasperk("specialty_longersprint"))
		{
			self give_perk( "specialty_longersprint" );
		}
	}
	if( getdvar( "mapname" ) == "zm_highrise" )
	{
		if(!self hasperk("specialty_quickrevive"))
		{
			self give_perk("specialty_quickrevive");
		}
		if(!self hasperk("specialty_finalstand"))
    	{
			self give_perk( "specialty_finalstand" );
		}
		if(!self hasperk("specialty_additionalprimaryweapon"))
	    {
			self give_perk("specialty_additionalprimaryweapon");
		}
	}
    self.perk_reminder = self.num_perks;
    self.perk_count = self.num_perks;
	wait 0.2;
	if(level.town)
	{
		if(!self hascustomperk("Downers_Delight"))
		{
			self drawshader_and_shadermove( "Downers_Delight", 0, 0 );
			wait 0.15;
		}
    	if(!self hascustomperk("MULE"))
		{
			self drawshader_and_shadermove( "MULE", 0, 0 );
			wait 0.15;
    	}
    	if(!self hascustomperk("PHD_FLOPPER"))
		{
			self drawshader_and_shadermove( "PHD_FLOPPER", 0, 0 );
			wait 0.15;
    	}
    	if(!self hascustomperk("Victorious_Tortoise"))
		{
			self drawshader_and_shadermove( "Victorious_Tortoise", 0, 0 );
			wait 0.15;
    	}
    	if(!self hascustomperk("ELECTRIC_CHERRY"))
		{
			self drawshader_and_shadermove( "ELECTRIC_CHERRY", 0, 0 );
			wait 0.15;
    	}
    	if(!self hascustomperk("WIDOWS_WINE"))
		{
			self drawshader_and_shadermove( "WIDOWS_WINE", 0, 0 );
			wait 0.15;
    	}
    	if(!self hascustomperk("Assasins_Creed"))
		{
			self drawshader_and_shadermove( "Assasins_Creed", 0, 0 );
			wait 0.15;
    	}
    	if(!self hascustomperk("Ammo_Regen"))
		{
			self drawshader_and_shadermove( "Ammo_Regen", 0, 0 );
			wait 0.15;
    	}
		if(!self hascustomperk("Burn_Heart"))
		{
			self drawshader_and_shadermove( "Burn_Heart", 0, 0 );
			wait 0.15;
    	}
		if(!self hascustomperk("Dying_Wish"))
		{
			self drawshader_and_shadermove( "Dying_Wish", 0, 0 );
			wait 0.15;
    	}
		if(!self hascustomperk("deadshot"))
		{
			self drawshader_and_shadermove( "deadshot", 0, 0 );
			wait 0.15;
    	}
	}
	if(level.diner)
	{
		if(!self hascustomperk("Downers_Delight"))
		{
			self thread drawshader_and_shadermove( "Downers_Delight", 0, 0 );
    	}
    	if(!self hascustomperk("MULE"))
		{
			self thread drawshader_and_shadermove( "MULE", 0, 0 );
    	}
    	if(!self hascustomperk("PHD_FLOPPER"))
		{
			self thread drawshader_and_shadermove( "PHD_FLOPPER", 0, 0 );
    	}
    	if(!self hascustomperk("Victorious_Tortoise"))
		{
			self thread drawshader_and_shadermove( "Victorious_Tortoise", 0, 0 );
    	}
    	if(!self hascustomperk("ELECTRIC_CHERRY"))
		{
			self thread drawshader_and_shadermove( "ELECTRIC_CHERRY", 0, 0 );
    	}
    	if(!self hascustomperk("WIDOWS_WINE"))
		{
			self thread drawshader_and_shadermove( "WIDOWS_WINE", 0, 0 );
    	}
    	if(!self hascustomperk("Assasins_Creed"))
		{
			self thread drawshader_and_shadermove( "Assasins_Creed", 0, 0 );
    	}	
	}
}

