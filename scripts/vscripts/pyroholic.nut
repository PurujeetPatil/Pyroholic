Msg("Removing unwanted weapons.\n");
DirectorOptions <-
{
  	weaponsToRemove =
 	{
	//	<Weapon script name>	= 0
          weapon_pipe_bomb         = 0
          weapon_vomitjar          = 0
          weapon_pistol            = 0
          weapon_pistol_magnum     = 0
          weapon_rifle             = 0
          weapon_rifle_ak47        = 0
          weapon_rifle_desert      = 0
          weapon_rifle_m60         = 0
          weapon_rifle_sg552       = 0
          weapon_shotgun_chrome    = 0
          weapon_pumpshotgun       = 0
          weapon_autoshotgun       = 0
          weapon_shotgun_spas      = 0
          weapon_smg               = 0
          weapon_smg_mp5           = 0
          weapon_smg_silenced      = 0
          weapon_sniper_awp        = 0
          weapon_sniper_military   = 0
          weapon_sniper_scout      = 0
          weapon_hunting_rifle     = 0
          weapon_upgradepack_explosive = 0
          weapon_upgradepack_incendiary = 0
          upgrade_item             = 0//Lasers
          weapon_grenade_launcher  = 0
          weapon_chainsaw          = 0
          ammo = 0
		  weapon_melee 			= 0 //ALL melee weapons
		//Individual melee weapons need to be deleted via modelname.
		//If you're building your own map, edit the missionfile to not allow certain melee weapons instead.
     }

 	function AllowWeaponSpawn( classname )
 	{
 		if ( classname in weaponsToRemove )
 		{
 			return false;
 		}
 		return true;
 	}

     DefaultItems =
 	[
 		"weapon_molotov",
		//Using two "weapon_pistol" makes you spawn holding two pistols.
 	]

 	function GetDefaultItem(idx)
 	{
 		if ( idx < DefaultItems.len() )
 		{
 			return DefaultItems[idx];
 		}
 		return 0;
 	}
 	// This applies for survivor bots only
 	function ShouldAvoidItem(classname)
 	{
 		if ( ( classname != "weapon_melee" ) && ( classname in weaponsToRemove ) )
 		{
 			return true;
 		}
 		return false;
 	}
}

function OnGameEvent_round_start_post_nav(params)
{
	//Remove weapon_*_spawn entities, with * being an entity name in "weaponsToRemove"
	EntFire( "weapon_spawn", "Kill" );
 	foreach( wep, val in DirectorOptions.weaponsToRemove )
 		EntFire( wep + "_spawn", "Kill" );
}

function laugh()
{

	player <- null;
	while(player = Entities.FindByClassname(player, "player"))   // Iterate through the script handles of the players.
	{
    	// printl(" ** Name:" + player.GetPlayerName() )
		// DoEntFire("!self", "speakresponseconcept", "PlayerLaugh", 0, null, player); // Make each player laugh.
	}

}

function OnGameplayStart()
{
     // gameplay start code goes here!
    //  ScriptedMode_AddSlowPoll(laugh)
}

function KillEntity( str )
{
	local ent = null;
	ent = Entities.FindByClassname(ent, str)
	ent.Kill()
}


function Update()
{
    printl(" ** Time:" + Time() )
	local str = "weapon_molotov"
	player <- null;
	while(player = Entities.FindByClassname(player, "player"))   // Iterate through the script handles of the players.
	{
		local table = {};
		printl("\n -------------------\n Player: " + player.GetPlayerName());
		GetInvTable(player, table);
		if(table.len() != 0)
		{
			if(!table.rawin("slot2"))
			{
				player.GiveItem(str);
				player.SwitchToItem(str)
			}

			foreach( slot, item in table )
			{
				printl(" Slot:" + slot + " Item:" + item);
				if(slot == "slot0" || slot == "slot1" && !player.IsIncapacitated())
				{
					KillEntity(item.GetClassname())
				}
			}

		}
		else
		{
			player.GiveItem(str);
			player.SwitchToItem(str)
		}
		printl("\n -------------------\n");
	}
}
