//script by Xeno(PURPLExeno), sprites by Skemonde(TheCustomerMan) (Old)
//script by Slava, sprites by Peaceful Gay and Slava (New)

#include "Requirements.as";
#include "ShopCommon.as";
#include "Descriptions.as";
#include "CheckSpam.as";
#include "CTFShopCommon.as";
#include "MakeMat.as";

void onInit(CBlob@ this)
{
	this.set_TileType("background tile", CMap::tile_castle_back);

	this.getSprite().SetZ(-50); 
	this.getShape().getConsts().mapCollisions = false;

	this.Tag("builder always hit");
	this.Tag("change team on fort capture");

	addTokens(this); 

	this.set_Vec2f("shop offset", Vec2f(0, 0));
	this.set_Vec2f("shop menu size", Vec2f(9,5));
	this.set_string("shop description", "Advanced Weapon Shop");
	this.set_u8("shop icon", 21);

	this.SetLightRadius(32);
    this.SetLight(true);

	AddIconToken("$icon_sniperammo$", "AmmoIcon_Sniper.png", Vec2f(24,24), 255);
 	{
		ShopItem@ s = addShopItem(this, "Salt pebbles (20)", "$icon_banditammo$", "mat_banditammo-20", "Bullets for shit guns!");
		AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 40);

		s.spawnNothing = true;
	}
    {
		ShopItem@ s = addShopItem(this, "Low Caliber Ammunition (20)", "$icon_pistolammo$", "mat_pistolammo-20", "Bullets for pistols and SMGs.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 1);
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 15);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "High Caliber Ammunition (30)", "$icon_rifleammo$", "mat_rifleammo-30", "Bullets for rifles. Effective against armored targets.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 50);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Shotgun Shells (8)", "$icon_shotgunammo$", "mat_shotgunammo-8", "Shotgun Shells for... Shotguns.");
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 2);
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 50);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Machine Gun Ammunition (50)", "$icon_gatlingammo$", "mat_gatlingammo-50", "Ammunition used by the machine gun.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 1);
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 40);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "High Power Ammunition (10)", "$icon_sniperammo$", "mat_sniperammo-10", "Rounds that are mainly used by sniper rifles. Very effective against heavy armored targets.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 75);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Rockets (2)", "$mat_smallrocket$", "mat_smallrocket-2", "Small rocket for rocketlaunchers.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 1);
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 25);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Grenades (4)", "$grenade$", "mat_grenade-4", "Bouncy grenades for grenadelaunchers.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 4);
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 50);

		s.spawnNothing = true;
	}
	/*{
		ShopItem@ s = addShopItem(this, "Sticky Grenades (4)", "$stickygrenade$", "mat_stickygrenade-4", "Sticky grenades for grenadelaunchers.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 6);
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 50);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Soviet PPSH", "$ppsh$", "ppsh", "WW2 most-used russian weapon.\n\nСheap and weak. $icon_pistolammo$\n\nPress [RMB] to dash horizontally.\n\nAmmo Capacity = 72\n\nDamage = 1\n\nFire Rate = 15");
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 150);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 10);
		AddRequirement(s.requirements, "coin", "", "Coins", 750);
		
		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "AKM", "$bnak$", "bnak", "Popular russian weapon.\n\nPerfect value for money. $icon_rifleammo$\n\nAmmo Capacity = 20\n\nDamage = 1.5\n\nFire Rate = 10");
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 250);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 12);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 2);
		AddRequirement(s.requirements, "coin", "", "Coins", 1500);
		
		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "RP-46", "$rp46$", "rp46", "Powerful machinegun with slow fire rate and medium accuracy.\n\nGood for medium range combat and long shootouts. $icon_rifleammo$\n\nAmmo Capacity = 50\n\nDamage = 3.25\n\nFire Rate = 5");
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 100);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 16);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 2);
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 10);
		AddRequirement(s.requirements, "coin", "", "Coins", 2000);
		
		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "TKB-521", "$tkb521$", "tkb521", "A nice machinegun with a big magazine and high damage.\n\nDeals a lot of damage and is good for suppressive fire. $icon_rifleammo$\n\nAmmo Capacity = 100\n\nDamage = 1.5\n\nFire Rate = 15");
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 150);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 12);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 8);
		AddRequirement(s.requirements, "coin", "", "Coins", 2250);
		
		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Flame Grenades (4)", "$flamegrenade$", "mat_flamegrenade-4", "Flame grenades for grenadelaunchers.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 6);
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 50);
		AddRequirement(s.requirements, "blob", "mat_oil", "Oil", 50);
		

		s.spawnNothing = true;
	}
	{	
		ShopItem@ s = addShopItem(this, "Sniper Rifle Dragunova", "$svd$", "svd", "A strong semi-auto sniper rifle.\n\nDeals full damage only when shooting from a long distance.$icon_sniperammo$\n\nAmmo Capacity = 10\n\nDamage = 9\n\nFire Rate = 0.6");
		AddRequirement(s.requirements, "blob",  "mat_wood", "Wood", 200);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 8);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 8);
		AddRequirement(s.requirements, "coin", "", "Coins", 1500);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Nitro 700", "$nitro700_icon$", "nitro700", "Strong gun used to take down buffalos, not badgers.\n\nPerfect for aggressive attack. $icon_sniperammo$\n\nPress [RMB] to stab with bayonet wich is good against shields.\n\nAmmo Capacity = 2\n\nDamage = 6.8\n\nFire Rate = 1");
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 350);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 8);
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 8);
		AddRequirement(s.requirements, "coin", "", "Coins", 1500);
		
		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Gauss Rifle", "$icon_gaussrifle$", "gaussrifle", "A modified toy used to kill people.\n\nIdeal for breaking through walls and has strong knockback.\nAmmo Capacity = 1\n\nDamage = 7.56\n\nFire Rate = 0.75\n\nUses Steel Ingots.");
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 6);
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 8);
		AddRequirement(s.requirements, "blob", "mat_mithril", "Mithril", 40);
		AddRequirement(s.requirements, "blob", "mat_copperwire", "Copper Wire", 10);
		AddRequirement(s.requirements, "coin", "", "Coins", 1500);

		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Tesla Ray", "$icon_thunderbolt$", "thunderbolt", "Electromagnetic force, nature's force!\n\nPenetrates Armor. Sets the earth on fire.\n\nUses Batteries.");
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 8);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 8);
		AddRequirement(s.requirements, "blob", "mat_mithril", "Mithril", 50);
		AddRequirement(s.requirements, "blob", "mat_battery", "Voltron Battery Plus", 100);
		AddRequirement(s.requirements, "coin", "", "Coins", 500);

		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}*/
	{
		ShopItem@ s = addShopItem(this, "Bazooka", "$icon_bazooka$", "bazooka", "A long tube capable of shooting rockets. Make sure nobody is standing behind it.\n\nUses Small Rockets.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 5);
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 2);
		AddRequirement(s.requirements, "coin", "", "Coins", 500);

		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Grenade Launcher M79", "$icon_grenadelauncher$", "grenadelauncher", "A short-ranged weapon that launches grenades.\nPress [Action 2] to switch ammo type.\n\nUses Grenades.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 5);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 6);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 350);
		AddRequirement(s.requirements, "coin", "", "Coins", 750);

		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "L.O.L. Warhead Launcher", "$icon_mininukelauncher$", "mininukelauncher", "Are people bullying you again? Remember, there still is the nuclear option.\n\nUses L.O.L. or K.E.K. Warheads.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 20);
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 10);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 6);
		AddRequirement(s.requirements, "coin", "", "Coins", 3000);

		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	/*{
		ShopItem@ s = addShopItem(this, "Scorcher", "$icon_flamethrower$", "flamethrower", "A tool used for incinerating plants, buildings and people.\n\nUses Oil.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 12);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 12);
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 10);
		AddRequirement(s.requirements, "coin", "", "Coins", 4000);

		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Acid Grenades (2)", "$acidgrenade$", "mat_acidgrenade-2", "Acid grenades for grenadelaunchers.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 6);
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 50);
		AddRequirement(s.requirements, "blob", "mat_acid", "Acid", 50);
		

		s.spawnNothing = true;
	}*/
	{
		ShopItem@ s = addShopItem(this, "Fragmentation Grenade (1)", "$icon_fraggrenade$", "mat_fraggrenade-1", "A small hand grenade. Especially useful against infantry.");
		AddRequirement(s.requirements, "coin", "", "Coins", 200);
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 35);

		s.spawnNothing = true;
	}
	/*{
		ShopItem@ s = addShopItem(this, "Acidthrower", "$icon_acidthrower$", "acidthrower", "A tool used for dissolving plants, buildings and people.\n\nUses Acid.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 14);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 12);
		AddRequirement(s.requirements, "coin", "", "Coins", 2000);

		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Blazethrower", "$icon_blazethrower$", "blazethrower", "A Scorcher modification providing support for gaseous fuels.\n\nUses Fuel.");
		AddRequirement(s.requirements, "blob", "flamethrower", "Scorcher", 1);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 4);
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 18);
		AddRequirement(s.requirements, "blob", "bp_weapons", "Weapons Blueprint", 1);
		AddRequirement(s.requirements, "coin", "", "Coins", 500);

		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Rocket Propelled Chainsaw Launcher", "$icon_rpc$", "rpc", "A device that launches saw-rockets to cause serious damage to the environment.\n\nUses Rocket Propelled Chainsaws.");
		AddRequirement(s.requirements, "blob", "bazooka", "Bazooka", 1);
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 8);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 8);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 10);
		AddRequirement(s.requirements, "coin", "", "Coins", 4000);

		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}*/
	{
		ShopItem@ s = addShopItem(this, "Mine", "$icon_mine$", "mine", descriptions[20], false);
		AddRequirement(s.requirements, "coin", "", "Coins", 75);
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 15);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Fragmentation Mine", "$icon_fragmine$", "fragmine", "A fragmentation mine that fills the surroundings with shards of metal upon detonation.");
		AddRequirement(s.requirements, "coin", "", "Coins", 125);
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 30);

		s.spawnNothing = true;
	}
}    

void onChangeTeam(CBlob@ this, const int oldTeam)
{
	addTokens(this);
}

void addTokens(CBlob@ this)
{
	int teamnum = this.getTeamNum();
	if (teamnum > 6) teamnum = 7;

	AddIconToken("$rp46$", "RP-46.png", Vec2f(34, 12), 0, teamnum);
	AddIconToken("$tkb521$", "TKB-521.png", Vec2f(34, 14), 0, teamnum);
	AddIconToken("$nitro700_icon$", "Nitro700_icon.png", Vec2f(38, 12), 0, teamnum);
	AddIconToken("$icon_grenadelauncher$", "PumpActionGrenadeLauncher.png", Vec2f(22, 9), 0, teamnum);
	AddIconToken("$icon_thunderbolt$", "Thunderbolt.png", Vec2f(24, 10), 0, teamnum);
	AddIconToken("$icon_mine$", "Mine.png", Vec2f(16, 16), 1, teamnum);
	AddIconToken("$icon_fragmine$", "FragMine.png", Vec2f(16, 16), 1, teamnum);
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (this.getDistanceTo(caller) > 96.0f) return;
	this.set_bool("shop available", this.isOverlapping(caller));
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if(cmd == this.getCommandID("shop made item"))
	{
		this.getSprite().PlaySound("AdvancedConstruct");

		u16 caller, item;

		if(!params.saferead_netid(caller) || !params.saferead_netid(item))
			return;

		string name = params.read_string();
		CBlob@ callerBlob = getBlobByNetworkID(caller);

		if (callerBlob is null) return;

		if (isServer())
		{
			CPlayer@ ply = callerBlob.getPlayer();
			if (ply !is null)
			{
				tcpr("[PBI] " + ply.getUsername() + " has purchased " + name);
			}
		
			string[] spl = name.split("-");

			if (spl[0] == "coin")
			{
				CPlayer@ callerPlayer = callerBlob.getPlayer();
				if (callerPlayer is null) return;

				callerPlayer.server_setCoins(callerPlayer.getCoins() +  parseInt(spl[1]));
			}
			else if (name.findFirst("mat_") != -1)
			{
				CPlayer@ callerPlayer = callerBlob.getPlayer();
				if (callerPlayer is null) return;

				CBlob@ mat = server_CreateBlob(spl[0], callerBlob.getTeamNum(), this.getPosition());

				if (mat !is null)
				{
					mat.Tag("do not set materials");
					mat.server_SetQuantity(parseInt(spl[1]));
					if (!callerBlob.server_PutInInventory(mat))
					{
						mat.setPosition(callerBlob.getPosition());
					}
				}
			}
			else
			{
				CBlob@ blob = server_CreateBlob(spl[0], callerBlob.getTeamNum(), this.getPosition());

				if (blob is null) return;
				if (callerBlob.getPlayer() !is null && name == "nuke")
				{
					blob.SetDamageOwnerPlayer(callerBlob.getPlayer());
				}

				if (!blob.hasTag("vehicle"))
				{
					if (!blob.canBePutInInventory(callerBlob))
					{
						callerBlob.server_Pickup(blob);
					}
					else if (callerBlob.getInventory() !is null && !callerBlob.getInventory().isFull())
					{
						callerBlob.server_PutInInventory(blob);
					}
				}
			}
		}
	}
}
