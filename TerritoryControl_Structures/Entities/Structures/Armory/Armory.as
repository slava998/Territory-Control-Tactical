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
	AddIconToken("$str$", "StoreAll.png", Vec2f(16, 16), 0);

	//this.Tag("upkeep building");
	//this.set_u8("upkeep cap increase", 0);
	//this.set_u8("upkeep cost", 5);

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	this.Tag("remote_storage");
	this.Tag("builder always hit");
	this.Tag("change team on fort capture");

	this.getCurrentScript().tickFrequency = 300;

	// getMap().server_SetTile(this.getPosition(), CMap::tile_wood_back);

	this.inventoryButtonPos = Vec2f(-8, 0);
	this.addCommandID("sv_store");

	addTokens(this); //colored shop icons

	this.set_Vec2f("shop offset", Vec2f(0,0));
	this.set_Vec2f("shop menu size", Vec2f(6, 6));
	this.set_string("shop description", "Armory");
	this.set_u8("shop icon", 15);

	{
		ShopItem@ s = addShopItem(this, "Light Combat Helmet", "$icon_lighthelmet$", "lighthelmet", "A light combat helmet.\nCheap and flimsy. Gives some protection against all bullets.\n\nOccupies the Head slot");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 4);
		AddRequirement(s.requirements, "coin", "", "Coins", 50);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Combat Helmet", "$icon_militaryhelmet$", "militaryhelmet", "An universal combat helmet.\nNice and practical. Good against all bullets.\n\nOccupies the Head slot");
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 8);
		AddRequirement(s.requirements, "coin", "", "Coins", 300);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Composite Helmet", "$icon_compositehelmet$", "compositehelmet", "A combat helmet made of composite materials.\nGood against low caliber bullets, explosions, fire and swords,\nbut worse against high caliber and power rounds.\n\nOccupies the Head slot");
		AddRequirement(s.requirements, "blob", "mat_mithrilingot", "Mithril Ingot", 6);
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 6);
		AddRequirement(s.requirements, "coin", "", "Coins", 200);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Night Vision Device (NVD)", "$nvd$", "nvd", "Night vision googles fixed on a military helmet.\nRequires mithril.\n\nHold mithril and press [E]\nYou can also toggle it.");
		AddRequirement(s.requirements, "blob", "militaryhelmet", "Combat Helmet", 1);
		AddRequirement(s.requirements, "blob", "mat_mithril", "Mithril", 50);
		AddRequirement(s.requirements, "coin", "", "Coins", 250);
	
		s.spawnNothing = true;
	}
	/*{
		ShopItem@ s = addShopItem(this, "Katana", "$katana$", "katana", "Japanese melee weapon.\nPerfect for introducing enemies' organs to themselves.");
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel ingot", 10);
		AddRequirement(s.requirements, "coin", "", "Coins", 500);

		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;
		
		s.spawnNothing = true;
	}*/
	{
		ShopItem@ s = addShopItem(this, "Light Protective Vest", "$icon_lightvest$", "lightvest", "A light armor.\nCheap and flimsy. Gives some protection against all bullets.\n\nOccupies the Torso slot");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 6);
		AddRequirement(s.requirements, "coin", "", "Coins", 100);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Ballistic Vest", "$icon_bulletproofvest$", "bulletproofvest", "A resilient ballistic armor.\nNice and practical. Good against all bullets.\n\nOccupies the Torso slot");
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 12);
		AddRequirement(s.requirements, "coin", "", "Coins", 600);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Composite Vest", "$icon_compositevest$", "compositevest", "A combat vest made of composite materials.\nGood against low caliber bullets, explosions, fire and swords,\nbut worse against high caliber and power rounds.\n\nOccupies the Torso slot");
 		AddRequirement(s.requirements, "blob", "mat_mithrilingot", "Mithril Ingot", 8);
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 10);
		AddRequirement(s.requirements, "coin", "", "Coins", 350);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Parachute Pack", "$icon_parachute$", "parachutepack", "A piece of fabric to let you fall slowly.\nPress [E] while falling to activate.\n\nOccupies the Torso slot.");
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 80);
		AddRequirement(s.requirements, "coin", "", "Coins", 125);

		s.spawnNothing = true;
	}
	/*{
		ShopItem@ s = addShopItem(this, "Rendezook", "$icon_rendezook$", "rendezook", "A replica of a rocket launcher found behind the UPF shop in a trash can.\nDoes not seem to hurt anybody.");
		AddRequirement(s.requirements, "coin", "", "Coins", 350);

		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;
		
		s.spawnNothing = true;
	}*/
	{
		ShopItem@ s = addShopItem(this, "Bushy Helm", "$bush$", "bushyhelm", "Add bush camo to helm.");
		AddRequirement(s.requirements, "blob", "militaryhelmet", "Combat Helmet", 1);
	
		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Combat Boots", "$icon_combatboots$", "combatboots", "A pair of light military boots.\nSlightly protects against all bullets and increases your mobility.\nModerately decreases fall damage.\nIncreases stomp damage.\n\nOccupies the Boots slot");
		AddRequirement(s.requirements, "coin", "", "Coins", 50);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Composite Boots", "$icon_compositeboots$", "compositeboots", "A pair of resistant boots made of composite materials.\nSlightly protects you against all bullets and explosions.\nSlightly decreases fall damage.\n\nOccupies the Boots slot");
		AddRequirement(s.requirements, "blob", "mat_mithrilingot", "Mithril Ingot", 2);
		AddRequirement(s.requirements, "blob", "mat_copperingot", "Copper Ingot", 4);
		AddRequirement(s.requirements, "coin", "", "Coins", 125);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Jump Shoes", "$jumpshoes$", "jumpshoes", "Makes you better, faster, stronger.");
		AddRequirement(s.requirements, "blob", "combatboots", "Combat Boots", 1);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 5);
		AddRequirement(s.requirements, "blob", "mat_copperwire", "Copper Wire", 10);
		AddRequirement(s.requirements, "coin", "", "Coins", 1000);

		s.spawnNothing = true;
	}
	/*{
		ShopItem@ s = addShopItem(this, "Crossbow", "$crossbow$", "crossbow", "A hand-made ranged weapon.\nUses arrows to shoot.\nYou can set arrow type while holding different arrows near it.");
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 150);
		AddRequirement(s.requirements, "coin", "", "Coins", 150);

		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;
		
		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Smoke Grenade (1)", "$icon_smokegrenade$", "mat_smokegrenade-1", "A small hand grenade used to quickly fill a room with smoke. It helps you keep out of sight.");
		AddRequirement(s.requirements, "coin", "", "Coins", 50);
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 25);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Flash Grenade (1)", "$icon_flashgrenade$", "mat_flashgrenade-1", "A flash grenade used to temporarily blind your enemies.");
		AddRequirement(s.requirements, "coin", "", "Coins", 100);
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 10);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Glue Grenade (1)", "$icon_gluegrenade$", "mat_gluegrenade-1", "A glue grenade. Calm that stupid runner down!");
		AddRequirement(s.requirements, "coin", "", "Coins", 100);
		AddRequirement(s.requirements, "blob", "mat_coal", "Coal", 5);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Concrete Grenade (1)", "$icon_concretegrenade$", "mat_concretegrenade-1", "A sticky concrete grenade. Ñreates a concrete cube when it explodes.");
		AddRequirement(s.requirements, "coin", "", "Coins", 150);
		AddRequirement(s.requirements, "blob", "mat_concrete", "Concrete", 75);

		s.spawnNothing = true;
	}*/
	{
		ShopItem@ s = addShopItem(this, "Royal Guard Armor", "$icon_royalarmor$", "royalarmor", "A heavy armor that offers high damage resistance at cost of low mobility. Has a shield which is tough enough to block bullets.");
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 10);
		AddRequirement(s.requirements, "blob", "mat_steelingot", "Steel Ingot", 10);
		AddRequirement(s.requirements, "coin", "", "Coins", 1000);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Ancient Weaboo Scroll", "$ninjascroll$", "ninjascroll", "An ancient scroll with ninja codex and techniques.");
		AddRequirement(s.requirements, "coin", "", "Coins", 2500);
		AddRequirement(s.requirements, "blob", "mat_ganja", "Ganja", 15);
		AddRequirement(s.requirements, "blob", "mat_ironingot", "Iron Ingot", 5);
		AddRequirement(s.requirements, "blob", "katana", "Katana", 1);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Arrows (30)", "$mat_arrows$", "mat_arrows-30", "Arrows for crossbows.", true);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 50);
		AddRequirement(s.requirements, "coin", "", "Coins", 75);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Water Arrow (2)", "$mat_waterarrows$", "mat_waterarrows-2", descriptions[50], true);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 15);
		AddRequirement(s.requirements, "coin", "", "Coins", 50);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Fire Arrow (2)", "$mat_firearrows$", "mat_firearrows-2", descriptions[32], true);
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 10);
		AddRequirement(s.requirements, "coin", "", "Coins", 30);
	}
	{
		ShopItem@ s = addShopItem(this, "Bomb Arrow (1)", "$mat_bombarrows$", "mat_bombarrows-1", descriptions[51], true);
		AddRequirement(s.requirements, "coin", "", "Coins", 40);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Truncheon", "$icon_nightstick$", "nightstick", "A traditional tool used by seal clubbing clubs.");
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 100);
		AddRequirement(s.requirements, "coin", "", "Coins", 75);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Gregor Remote Detonator", "$icon_claymoreremote$", "claymoreremote-1", "A device used to remotely detonate Gregors.");
		AddRequirement(s.requirements, "coin", "", "Coins", 150);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Artillery Shell (4)", "$icon_tankshell$", "mat_tankshell-4", "A highly explosive shell used by the artillery.");
		AddRequirement(s.requirements, "coin", "", "Coins", 40);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Howitzer Shell (2)", "$icon_howitzershell$", "mat_howitzershell-2", "A large howitzer shell capable of annihilating a cottage.\nCan also be used as aearial bomb.");
		AddRequirement(s.requirements, "coin", "", "Coins", 100);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Gregor (1)", "$icon_claymore$", "claymore-1", "A remotely triggered explosive device covered in some sort of slime. Sticks to surfaces.");
		AddRequirement(s.requirements, "coin", "", "Coins", 70);

		s.spawnNothing = true;
	}
	{
		ShopItem@ s = addShopItem(this, "Grenade (2)", "$icon_grenade$", "mat_grenade-2", "A small, timed explosive device used by grenade launchers.");
		AddRequirement(s.requirements, "coin", "", "Coins", 100);

		s.spawnNothing = true;
	}
	/*{
		ShopItem@ s = addShopItem(this, "Red Hand Held Flare (1)", "$mat_flare$", "mat_flare", "A small but bright source of light. Press [Action 3] to activate");
		AddRequirement(s.requirements, "coin", "", "Coins", 80);
		AddRequirement(s.requirements, "blob", "mat_sulphur", "Sulphur", 10);

		s.spawnNothing = true;
	}*/
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

	AddIconToken("$icon_parachute$", "Parachutepack.png", Vec2f(16, 16), 0, teamnum);
	AddIconToken("$jumpshoes$", "JumpShoes.png", Vec2f(16, 16), 0, teamnum);
	AddIconToken("$icon_royalarmor$", "RoyalArmor.png", Vec2f(16, 8), 0, teamnum);
	AddIconToken("$icon_gluegrenade$", "GlueGrenade.png", Vec2f(16, 16), 0, teamnum);
	AddIconToken("$icon_concretegrenade$", "ConcreteGrenade.png", Vec2f(16, 16), 0, teamnum);
}

bool canPickup(CBlob@ blob)
{
	return blob.hasTag("weapon") || blob.hasTag("ammo") || blob.hasTag("armor") || blob.hasTag("armory_storable");
}

void onTick(CBlob@ this)
{
	if (this.getInventory().isFull()) return;

	CBlob@[] blobs;
	if (getMap().getBlobsInBox(this.getPosition() + Vec2f(128, 96), this.getPosition() + Vec2f(-128, -96), @blobs))
	{
		for (uint i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];

			if ((canPickup(blob)) && !blob.isAttached())
			{
				if (isClient() && this.getInventory().canPutItem(blob)) blob.getSprite().PlaySound("/PutInInventory.ogg");
				if (isServer()) this.server_PutInInventory(blob);
			}
		}
	}
}

bool isInventoryAccessible(CBlob@ this, CBlob@ forBlob)
{
	if (forBlob is null || this is null) return false;
	CBlob@ carried = forBlob.getCarriedBlob();
	return forBlob.isOverlapping(this) && (carried is null ? true : canPickup(carried));
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (this.getDistanceTo(caller) > 96.0f) return;
	if (isInventoryAccessible(this, caller))
	{
		this.set_Vec2f("shop offset", Vec2f(8, 0));
		this.set_bool("shop available", this.isOverlapping(caller));

		/*
		CBitStream params;
		params.write_u16(caller.getNetworkID());

		CInventory @inv = caller.getInventory();
		if (inv is null) return;
		
		CBlob@ carried = caller.getCarriedBlob();
		if(carried is null && this.isOverlapping(caller))
		{
			if (inv.getItemsCount() > 0)
			{
				for (int i = 0; i < inv.getItemsCount(); i++)
				{
					CBlob @item = inv.getItem(i);
					if (canPickup(item))
					{
						params.write_u16(caller.getNetworkID());
						CButton@ buttonOwner = caller.CreateGenericButton(28, Vec2f(0, -10), this, this.getCommandID("sv_store"), "Store", params);
						break;
					}
				}
			}
		}
		*/
	}
	else
	{
		this.set_Vec2f("shop offset", Vec2f(0, 0));
		this.set_bool("shop available", this.isOverlapping(caller));
	}
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("shop made item"))
	{
		this.getSprite().PlaySound("ConstructShort");

		u16 caller, item;

		if (!params.saferead_netid(caller) || !params.saferead_netid(item))
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
			else if (name.findFirst("mat_") != -1 && spl.length > 1)
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
				string blobName = spl[0];
				bool mask = false;
				if (blobName == "bushyhelm")
				{
					blobName = "militaryhelmet";
					mask = true;
				}

				CBlob@ blob = server_CreateBlob(blobName, callerBlob.getTeamNum(), this.getPosition());
				if (mask) blob.Tag("bushy");

				if (blob is null && callerBlob is null) return;

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
	if (cmd == this.getCommandID("sv_store"))
	{
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (isServer())
		{
			if (caller !is null)
			{
				CInventory @inv = caller.getInventory();
				if (caller.getName() == "builder")
				{
					CBlob@ carried = caller.getCarriedBlob();
					if (carried !is null)
					{
						if (carried.hasTag("temp blob"))
						{
							carried.server_Die();
						}
					}
				}
				if (inv !is null)
				{
					for (int i = 0; i < inv.getItemsCount(); i++)
					{
						CBlob @item = inv.getItem(i);
						if (canPickup(item))
						{
							caller.server_PutOutInventory(item);
							this.server_PutInInventory(item);
							i--;
						}
					}
				}
			}
		}

		if (caller !is null && caller.isMyPlayer())
		{
			caller.ClearButtons();
			caller.ClearGridMenus();
		}
	}
}

void onCreateInventoryMenu(CBlob@ this, CBlob@ forBlob, CGridMenu@ gridmenu)
{
	if (forBlob is null) return;
	if (forBlob.getControls() is null) return;
	Vec2f mscpos = forBlob.getControls().getMouseScreenPos(); 

	Vec2f MENU_POS = mscpos+Vec2f(-200,-96);
	CGridMenu@ sv = CreateGridMenu(MENU_POS, this, Vec2f(1, 1), "Store ");
	
	CBitStream params;
	params.write_u16(forBlob.getNetworkID());
	CGridButton@ store = sv.AddButton("$str$", "Store ", this.getCommandID("sv_store"), Vec2f(1, 1), params);
}