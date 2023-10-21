// A script by TFlippy

#include "Requirements.as";
#include "ShopCommon.as";
#include "Descriptions.as";
#include "CheckSpam.as";
#include "CTFShopCommon.as";
#include "MakeMat.as";

Random traderRandom(Time());

void onInit(CBlob@ this)
{
	this.set_TileType("background tile", CMap::tile_castle_back);

	//this.Tag("upkeep building");
	//this.set_u8("upkeep cap increase", 0);
	//this.set_u8("upkeep cost", 5);

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	this.Tag("builder always hit");
	this.Tag("change team on fort capture");

	this.getCurrentScript().tickFrequency = 150;

	// getMap().server_SetTile(this.getPosition(), CMap::tile_wood_back);

	addTokens(this); //colored shop icons

	this.set_Vec2f("shop offset", Vec2f(0,0));
	this.set_Vec2f("shop menu size", Vec2f(8, 6));
	this.set_string("shop description", "Mechanist's Workshop");
	this.set_u8("shop icon", 15);

	{
		ShopItem@ s = addShopItem(this, "Drill", "$icon_drill$", "drill", descriptions[43], false);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(s.requirements, "coin", "", "Coins", 25);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Wrench", "$wrench$", "wrench", "Repair damaged vehicles and structures.\nFaction leaders can use this to abandon captured structures.\nUse this to disable auto-extraction from certain structures.");
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 20);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 5);
		AddRequirement(s.requirements, "coin", "", "Coins", 100);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Copper Wire (2)", "$mat_copperwire$", "mat_copperwire-2", "A copper wire. Kids' favourite toy.");
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 1);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Copper Wire (20)", "$mat_copperwire$", "mat_copperwire-20", "A bundle of copper wires. Kids' favourite toy.");
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 10);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Copper Wire (100)", "$mat_copperwire$", "mat_copperwire-100", "A bundle of copper wires. Kids' favourite toy.");
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 50);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Accelerated Gyromat", "$icon_gyromat$", "gyromat", "A device capable of accelerating the work of various mechanisms and some vehicles.");
		AddRequirement(s.requirements, "blob", "mat_copperwire", "Copper Wire", 50);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 10);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 6);
		AddRequirement(s.requirements, "blob", "mat_mithrilingot", "Mithril Ingot", 4);
		AddRequirement(s.requirements, "coin", "", "Coins", 1500);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Building for Dummies", "$artisancertificate$", "artisancertificate", "Simplified Builder manuscript for those dumb peasants.", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 200);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Giga Drill Breaker", "$powerdrill$", "powerdrill", "A huge overpowered drill with a durable mithril head.");
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 250);
		AddRequirement(s.requirements, "blob", "mat_mithrilingot", "Mithril Ingot", 4);
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 4);
		AddRequirement(s.requirements, "blob", "mat_copperwire", "Copper Wire", 10);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Accelerated Gyromat Core Replacement", "$icon_gyromat$", "gyromat", "Replace this Accelerated Gyromat's core in hope to improve it.");
		AddRequirement(s.requirements, "blob", "gyromat", "Gyromat", 1);
		AddRequirement(s.requirements, "blob", "mat_copperwire", "Copper Wire", 10);
		AddRequirement(s.requirements, "coin", "", "Coins", 250);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Mithril-B-Gone", "$icon_radpill$", "radpill", "A piece of medicine that gives you a partial immunity to the adverse effects of Mithril.\nIt's a suppository!");
		AddRequirement(s.requirements, "blob", "mat_mithril", "Mithril", 25);
		AddRequirement(s.requirements, "coin", "", "Coins", 75);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Lighter", "$lighter$", "lighter", "A small device which can set things on fire");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 1);
		AddRequirement(s.requirements, "blob", "lantern", "Lantern", 1);
		AddRequirement(s.requirements, "coin", "", "Coins", 30);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Flashlight", "$icon_flashlight$", "flashlight", "Miraculous light in a tube! Illuminates the area it's pointing at.");
		AddRequirement(s.requirements, "blob", "mat_copperwire", "Copper Wire", 2);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(s.requirements, "coin", "", "Coins", 30);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Binoculars", "$icon_binoculars$", "binoculars", "Two telescopes glued together used for spying neighbours.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(s.requirements, "coin", "", "Coins", 150);
		// AddRequirement(s.requirements, "tech", "tech_metallurgy", "Metallurgy", 1);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Engineer's Tools", "$engineertools$", "engineertools", "Engineer's Tools for real engineers.", true);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 4);
		AddRequirement(s.requirements, "coin", "", "Coins", 750);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Zapthrottle Gas Extractor", "$icon_gasextractor$", "gasextractor", "A handheld air pump commonly used for cleaning, martial arts and gas cloud extraction.\nThrows a beam of water if carrier has a filled bucket in inventory. Can put out fire and cool meteors.\n\n[LMB]: Pull\n[RMB]: Push");
		AddRequirement(s.requirements, "blob", "mat_goldingot", "Gold Ingot", 2);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 1);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 80);
		AddRequirement(s.requirements, "coin", "", "Coins", 150);

		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Rocket Pack", "$icon_jetpack$", "jetpack", "A small rocket-propelled backpack.\nOccupies the Torso slot.\nPress [Shift] to jump!");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 5);
		AddRequirement(s.requirements, "blob", "mat_oil", "Oil", 50);
		AddRequirement(s.requirements, "coin", "", "Coins", 150);

		s.spawnNothing = true;
	}
	/*{
		ShopItem@ s = addShopItem(this, "Rocket Pack Version 2", "$icon_jetpackv2$", "jetpackv2", "A small rocket-propelled backpack.\nOccupies the Torso slot.\nPress [Shift] to Fly!\nUses oil.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 6);
		AddRequirement(s.requirements, "blob", "mat_fuel", "Fuel", 25);
		AddRequirement(s.requirements, "coin", "", "Coins", 300);

		s.spawnNothing = true;
	}*/
	{
		ShopItem@ s = addShopItem(this, "Backpack", "$icon_backpack$", "backpack", "A large leather backpack that can be equipped and used as an inventory.\nOccupies the Torso slot");
		AddRequirement(s.requirements, "coin", "", "Coins", 150);

		s.spawnNothing = true;
	}
	// {
	// 	ShopItem@ s = addShopItem(this, "Miner's Helmet", "$icon_minershelmet$", "minershelmet", "Turns you into an illuminati miner.\nOccupies the Head slot");
	// 	AddRequirement(s.requirements, "blob", "lantern", "Lantern", 1);
	// 	AddRequirement(s.requirements, "blob", "mat_goldingot", "Gold Ingot", 1);
	// 	AddRequirement(s.requirements, "coin", "", "Coins", 50);

	// 	s.spawnNothing = true;
	// }
	{
		ShopItem@ s = addShopItem(this, "Flippers", "$icon_flippers$", "flippers", "Cool flippers made of a fishy.\n");
		AddRequirement(s.requirements, "blob", "fishy", "Fishy", 1);
		AddRequirement(s.requirements, "coin", "", "Coins", 50);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Scuba Gear", "$icon_scubagear$", "scubagear", "Special equipment used for scuba diving.\nOccupies the Head slot");
		AddRequirement(s.requirements, "blob", "mat_goldingot", "Gold Ingot", 1);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(s.requirements, "coin", "", "Coins", 50);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Hazmat Suit", "$icon_hazmat$", "hazmatitem", "A hazardous materials suit giving the wearer protection against fire, toxic gases, radiation and drowning.");
		AddRequirement(s.requirements, "blob", "mat_mithril", "Mithril", 75);
		AddRequirement(s.requirements, "coin", "", "Coins", 500);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Dart Gun", "$icon_dartgun$", "dartgun", "Dart Gun that can be used to remotely deliver drugs.");
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 6);
		AddRequirement(s.requirements, "blob", "mat_methane", "Methane", 50);
		AddRequirement(s.requirements, "coin", "", "Coins", 500);

		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Bear Trap", "$icon_beartrap$", "beartrap", "An intricate device used for capturing of oversized badgers.");
		AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 100);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 6);
		AddRequirement(s.requirements, "coin", "", "Coins", 400);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Clown's Funny Klaxon", "$icon_klaxon$", "klaxon", "An infernal device housing thousands of lamenting souls.");
		AddRequirement(s.requirements, "blob", "mat_goldingot", "Gold Ingot", 2);
		AddRequirement(s.requirements, "coin", "", "Coins", 666);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Musical Contrabass", "$icon_contrabass$", "contrabass", "An advanced contrabass capable of emitting sounds of multiple instruments.");
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 150);
		AddRequirement(s.requirements, "blob", "mat_copperwire", "Copper Wire", 4);
		AddRequirement(s.requirements, "coin", "", "Coins", 200);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Gramophone", "$gramophone$", "gramophone", "A device used to play music from Gramophone Records purchased at the Merchant.", false);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 80);
		AddRequirement(s.requirements, "blob", "mat_goldingot", "Gold Ingot", 1);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Music Disc Replacement", "$musicdisc$", "musicdisc", "Change out the tunes to see if it fits your groove.");
		AddRequirement(s.requirements, "blob", "musicdisc", "Music Disc", 1);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Suspicious Engineer's Tools", "$susengineertools$", "susengineertools", "Become a neutral spy engineer with 99% credibility.", true);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 4);
		AddRequirement(s.requirements, "blob", "amogusplushie", "Amogus Plushie", 1);
		AddRequirement(s.requirements, "coin", "", "Coins", 1000);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Handheld Irradiator", "$icon_raygun$", "raygun", "A rather dangerous mithril-powered device used for cancer research.");
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 5);
		AddRequirement(s.requirements, "blob", "mat_mithrilingot", "Mithril Ingot", 3);
		AddRequirement(s.requirements, "coin", "", "Coins", 100);

		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Autonomous Activator", "$icon_automat$", "automat", "A magic-operated contraption that uses anything in its tiny hands. May be only carried around when not holding anything.");
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 4);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 8);
		AddRequirement(s.requirements, "coin", "", "Coins", 1000);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Catalyzer for Reactors", "$icon_catalyzer$", "catalyzer", "Increases reactor's irradiation just like if you put 75 of enriched mithril instead.\nSlightly destabilizes the reactor.");
		AddRequirement(s.requirements, "blob", "mat_mithrilenriched", "Enriched Mithril", 50);
		AddRequirement(s.requirements, "blob", "mat_mithrilingot", "Mithril Ingot", 5);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 5);
		AddRequirement(s.requirements, "coin", "", "Coins", 1000);

		s.customButton = true;
		s.buttonwidth = 1;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Refrigerant for Reactors", "$icon_refrigerant$", "refrigerant", "Decreases reactor's irradiation.\nModerately stabilizes and cools down the reactor.");
		AddRequirement(s.requirements, "blob", "mat_mithrilingot", "Mithril Ingot", 4);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 8);
		AddRequirement(s.requirements, "blob", "bubblegem", "Bubble gem", 1);
		AddRequirement(s.requirements, "coin", "", "Coins", 500);

		s.customButton = true;
		s.buttonwidth = 1;
		s.buttonheight = 1;

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Mustard Gas", "$icon_mustard$", "mat_mustard-50", "A bottle of a highly poisonous gas. Causes blisters, blindness and lung damage.");
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 50);
		AddRequirement(s.requirements, "coin", "", "Coins", 100);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "SpaceStar Ordering Transmitter", "$phone$", "phone", "A replica of SpaceStar Ordering Trasmitter capable of connecting to the UPF frequencies.\nAllows you to order supplies of UPF technologies and infantry support.");
		AddRequirement(s.requirements, "blob", "bp_weapons", "Weapons Blueprint", 1);
		AddRequirement(s.requirements, "blob", "bp_automation_advanced", "Advanced Automation Blueprint", 1);
		AddRequirement(s.requirements, "blob", "bp_energetics", "Energetics Blueprint", 1);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 16);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Copper Wire", 50);
		AddRequirement(s.requirements, "blob", "mat_copperwire", "Mithril Ingot", 4);
		AddRequirement(s.requirements, "blob", "mat_mithrilingot", "Mithril Ingot", 4);
		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Advanced Engineer", "$advancedengineertools$", "advancedengineertools", "An engineer with extra hp.");
		AddRequirement(s.requirements, "blob", "mat_plasteel", "Plasteel Sheet", 125);
		AddRequirement(s.requirements, "blob", "mat_mithrilingot", "Mithril Ingot", 12);
		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Gas Spreader XS-65", "$icon_gasweapon$", "gasthrower", "A device for spraying various gases.\nPut it on the ground and press E with gas in your hands to change the type of ammo.");
        AddRequirement(s.requirements, "blob", "gasextractor", "Zapthrottle Gas Extractor", 1);
		AddRequirement(s.requirements, "blob", "bp_weapons", "Weapons Blueprint", 1);
        AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 12);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 12);
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 8);
		AddRequirement(s.requirements, "coin", "", "Coins", 1000);
		s.customButton = true;
		s.buttonwidth = 2;	
		s.buttonheight = 1;
		
		s.spawnNothing = true;
	}
}

void onChangeTeam(CBlob@ this, const int oldTeam)
{
	// reset shop colors
	addTokens(this);
}

void addTokens(CBlob@ this)
{
	int teamnum = this.getTeamNum();
	if (teamnum > 6) teamnum = 7;

	AddIconToken("$icon_saw$", "VehicleIcons.png", Vec2f(32, 32), 3, teamnum);
	AddIconToken("$icon_hazmat$", "HazmatItem.png", Vec2f(16, 10), 0, teamnum);
	AddIconToken("$icon_jetpack$", "Jetpack.png", Vec2f(16, 16), 0, teamnum);
	AddIconToken("$icon_scubagear$", "ScubaGear.png", Vec2f(16, 16), 0, teamnum);
	AddIconToken("$icon_automat$", "Automat.png", Vec2f(16, 16), 0, teamnum);
	AddIconToken("$icon_flippers$", "Flippers.png", Vec2f(16, 16), 0, teamnum);
	AddIconToken("$icon_backpack$", "Backpack.png", Vec2f(16, 16), 0, teamnum);
	AddIconToken("$icon_jetpackv2$", "JetpackV2.png", Vec2f(16, 16), 0, teamnum);
	AddIconToken("$icon_catalyzer$", "Catalyzer.png", Vec2f(9, 11), 0, teamnum);
	AddIconToken("$icon_drill$", "Drill.png", Vec2f(32, 16), 0, teamnum);
	AddIconToken("$icon_refrigerant$", "RefrigerantIcon", Vec2f(8, 14), 0, teamnum);
	AddIconToken("$icon_gasweapon$", "GasThrower.png", Vec2f(24, 13), 0, teamnum);
	AddIconToken("phone$", "Phone.png", Vec2f(8, 16), 0, teamnum);
}

void onTick(CBlob@ this)
{
	CBlob@[] blobs;
	// if (this.getMap().getBlobsInRadius(this.getPosition(), this.getRadius() * 128.0f, @blobs))
	if (getMap().getBlobsInBox(this.getPosition() + Vec2f(96, 64), this.getPosition() + Vec2f(-96, 0), @blobs))
	{
		for (uint i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];

			// print(blob.getName() + "; " + blob.hasTag("vehicle"));

			if (blob.hasTag("vehicle"))
			{
				if (blob.getHealth() < blob.getInitialHealth()) blob.server_Heal(4);
			}
		}
	}
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (this.getDistanceTo(caller) > 96.0f) return;

	this.set_Vec2f("shop offset", Vec2f(0,0));

	this.set_bool("shop available", this.isOverlapping(caller));
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if(cmd == this.getCommandID("shop made item"))
	{
		this.getSprite().PlaySound("ConstructShort");

		u16 caller, item;

		if(!params.saferead_netid(caller) || !params.saferead_netid(item))
			return;

		string name = params.read_string();
		CBlob@ callerBlob = getBlobByNetworkID(caller);

		if (callerBlob is null) return;

		if (isServer())
		{
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

				MakeMat(callerBlob, this.getPosition(), spl[0], parseInt(spl[1]));

				// CBlob@ mat = server_CreateBlob(spl[0]);

				// if (mat !is null)
				// {
					// mat.Tag("do not set materials");
					// mat.server_SetQuantity(parseInt(spl[1]));
					// if (!callerBlob.server_PutInInventory(mat))
					// {
						// mat.setPosition(callerBlob.getPosition());
					// }
				// }
			}
			else
			{
				CBlob@ blob = server_CreateBlob(spl[0], callerBlob.getTeamNum(), this.getPosition());

				if (blob is null) return;

				if (callerBlob.getPlayer() !is null ) blob.SetDamageOwnerPlayer(callerBlob.getPlayer());
				
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
