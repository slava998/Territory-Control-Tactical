#include "MakeCrate.as";
#include "Requirements.as";
#include "ShopCommon.as";
#include "Descriptions.as";
#include "CheckSpam.as";
#include "CTFShopCommon.as";
#include "MakeMat.as";
#include "MakeSeed.as";

void onInit(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	if (blob is null) return;
	// Building
	this.SetZ(-50);
	this.SetEmitSound("assembler_loop.ogg");
	this.SetEmitSoundVolume(0.4f);
	this.SetEmitSoundSpeed(0.5f);
	this.SetEmitSoundPaused(false);
	bool state = blob.get_bool("state");
	if (!state && blob.hasTag("togglesupport"))
	{
		this.SetEmitSoundPaused(true);
	}
	{
		this.RemoveSpriteLayer("gear3");
		CSpriteLayer@ gear = this.addSpriteLayer("gear3", "Cogs.png" , 16, 16, this.getBlob().getTeamNum(), this.getBlob().getSkinNum());
		if (gear !is null)
		{
			Animation@ anim = gear.addAnimation("default", 0, false);
			anim.AddFrame(3);
			gear.SetOffset(Vec2f(6.0f, -4.0f));
			gear.SetAnimation("default");
			gear.SetRelativeZ(-60);
			gear.RotateBy(-22, Vec2f(0.0f,0.0f));
		}
	}
}

void onTick(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	bool state = blob.get_bool("state");
	
	if (state || !blob.hasTag("togglesupport"))
	{
		if(this.getSpriteLayer("gear3") !is null)
		{
			this.getSpriteLayer("gear3").RotateBy(5.0f*(this.getBlob().exists("gyromat_acceleration") ? this.getBlob().get_f32("gyromat_acceleration") : 1), Vec2f(0.0f,0.0f));
		}
	}
}

class AssemblerItem
{
	string resultname;
	u32 resultcount;
	string title;
	CBitStream reqs;

	AssemblerItem(string resultname, u32 resultcount, string title)
	{
		this.resultname = resultname;
		this.resultcount = resultcount;
		this.title = title;
	}
}

void onInit(CBlob@ this)
{
	AssemblerItem[] items;
	{
		AssemblerItem i("mat_tankshell", 4, "Artillery Shell (4)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 1);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 10);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_howitzershell", 4, "Howitzer Shells (4)");
		AddRequirement(i.reqs, "blob", "mat_copperingot", "Copper Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 15);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_smallbomb", 4, "Small Bombs (4)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 20);
		items.push_back(i);
	}
		{
		AssemblerItem i("mat_shrapnelbomb", 8, "Anti-personel Shrapnel Bomb (8)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 15);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_grenade", 4, "Grenade (4)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 1);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 10);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_smallrocket", 4, "Small Rocket (4)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 40);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 20);
		items.push_back(i);
	}
	{
		AssemblerItem i("firework", 2, "Firework (2)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 40);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 20);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_tankshell", 8, "Artillery Shell (8)");
		AddRequirement(i.reqs, "blob", "mat_goldingot", "Gold Ingot", 1);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_howitzershell", 2, "Howitzer Shells (2)");
		AddRequirement(i.reqs, "blob", "mat_goldingot", "Gold Ingot", 1);
		items.push_back(i);
	}	
	{
		AssemblerItem i("mat_smallbomb", 4, "Small Bombs (4)");
		AddRequirement(i.reqs, "blob", "mat_goldingot", "Gold Ingot", 1);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_shrapnelbomb", 8, "Anti-personel Shrapnel Bomb (8)");
		AddRequirement(i.reqs, "blob", "mat_goldingot", "Gold Ingot", 1);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_grenade", 2, "Grenade (2)");
		AddRequirement(i.reqs, "blob", "mat_goldingot", "Gold Ingot", 1);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_smallrocket", 2, "Small Rocket (2)");
		AddRequirement(i.reqs, "blob", "mat_goldingot", "Gold Ingot", 1);
		items.push_back(i);
	}
	{
		AssemblerItem i("firework", 2, "Firework (2)");
		AddRequirement(i.reqs, "blob", "mat_goldingot", "Gold Ingot", 1);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_bigbomb", 1, "Big Bomb");
		AddRequirement(i.reqs, "blob", "mat_goldingot", "Gold Ingot", 15);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 500);
		AddRequirement(i.reqs, "blob", "mat_coal", "Coal", 100);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_incendiarybomb", 4, "Incendiary Bombs (4)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_oil", "Oil", 20);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_bunkerbuster", 1, "Bunker Buster (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 125);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_stunbomb", 2, "Shockwave Bomb (2)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_methane", "Methane", 20);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_clusterbomb", 1, "Cluster Bomb (1)");
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_methane", "Methane", 25);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 25);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_dirtybomb", 1, "Dirty Bomb (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_mithril", "Mithril", 200);
		items.push_back(i);
	}
	{
		AssemblerItem i("mine", 2, "Mine (2)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 1);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 20);
		items.push_back(i);
	}
	{
		AssemblerItem i("fragmine", 1, "Fragmentation Mine (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 20);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_sammissile", 1, "SAM Missile (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_methane", "Methane", 15);
		items.push_back(i);
	}
	{
		AssemblerItem i("guidedrocket", 1, "Guided Missile");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_methane", "Methane", 80);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_bombs", 1, "Bomb (1)");
		AddRequirement(i.reqs, "blob", "mat_stone", "Stone", 30);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 5);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_bombarrows", 1, "Bomb Arrow (1)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 20);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 5);
		items.push_back(i);
	}
	{
		AssemblerItem i("firejob", 1, "Firejob");
		AddRequirement(i.reqs, "blob", "mat_fuel", "Fuel", 15);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 50);
		AddRequirement(i.reqs, "blob", "mat_coal", "Coal", 25);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_sawrocket", 1, "Rocket Propelled Chainsaw");
		AddRequirement(i.reqs, "blob", "mat_fuel", "Fuel", 20);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 8);
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 30);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_mininuke", 1, "L.O.L. Warhead (1)");
		AddRequirement(i.reqs, "blob", "mat_mithrilenriched", "Enriched Mithril", 30);
		AddRequirement(i.reqs, "blob", "mat_mithrilingot", "Mithril Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 8);
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 4);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_explonuke", 1, "K.E.K Warhead (1)");
		AddRequirement(i.reqs, "blob", "mat_fuel", "Fuel", 120);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 150);
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 8);
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 4);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_dynamite", 2, "Dynamite (2)");
		AddRequirement(i.reqs, "blob", "mat_wood", "Wood", 100);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 50);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_fraggrenade", 1, "Fragmentation Grenade (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 35);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_flashgrenade", 1, "Flash Grenade (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 10);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_gluegrenade", 1, "Glue Grenade (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_coal", "Coal", 5);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_concretegrenade", 1, "Concrete Grenade (1)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 2);
		AddRequirement(i.reqs, "blob", "mat_concrete", "Concrete", 75);
		items.push_back(i);
	}
	{
		AssemblerItem i("mat_highcalshell", 4, "High Caliber Shell (4)");
		AddRequirement(i.reqs, "blob", "mat_ironingot", "Iron Ingot", 8);
		AddRequirement(i.reqs, "blob", "mat_steelingot", "Steel Ingot", 4);
		AddRequirement(i.reqs, "blob", "mat_sulphur", "Sulphur", 30);
		items.push_back(i);
	}
	this.set("items", items);

	this.set_TileType("background tile", CMap::tile_castle_back);
	this.getShape().getConsts().mapCollisions = false;
	this.getCurrentScript().tickFrequency = 90;

	this.Tag("builder always hit");
	this.Tag("change team on fort capture");
	this.Tag("hassound");
	
	this.addCommandID("set");

	this.set_u8("crafting", 0);
	
	this.Tag("ignore extractor");
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (this.getDistanceTo(caller) > 96.0f) return;
	if (!caller.isOverlapping(this)) return;
	{
		CBitStream params;
		params.write_u16(caller.getNetworkID());
	
		CButton@ button = caller.CreateGenericButton(21, Vec2f(0, -16), this, AssemblerMenu, "Set Item");
	}
}

void AssemblerMenu(CBlob@ this, CBlob@ caller)
{
	if(caller.isMyPlayer())
	{
		CGridMenu@ menu = CreateGridMenu(getDriver().getScreenCenterPos() + Vec2f(0.0f, 0.0f), this, Vec2f(7, 6), "Set Assembly");
		if (menu !is null)
		{
			AssemblerItem[] items = getItems(this);
			for(uint i = 0; i < items.length; i += 1)
			{
				AssemblerItem item = items[i];

				CBitStream pack;
				pack.write_u8(i);

				int teamnum = this.getTeamNum();
				if (teamnum > 6) teamnum = 7;
				AddIconToken("$assembler_icon" + i + "$", "BombAssemblerIcons.png", Vec2f(16, 16), i, teamnum);

				string text = "Set to Assemble: " + item.title;
				if(this.get_u8("crafting") == i)
				{
					text = "Already Assembling: " + item.title;
				}

				CGridButton @butt = menu.AddButton("$assembler_icon" + i + "$", text, this.getCommandID("set"), pack);
				butt.hoverText = item.title + "\n" + getButtonRequirementsText(item.reqs, false);
				if(this.get_u8("crafting") == i)
				{
					butt.SetEnabled(false);
				}
			}
		}
	}
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("set"))
	{
		u8 setting = params.read_u8();
		this.set_u8("crafting", setting);
	}
}



void onTick(CBlob@ this)
{
	if (!this.get_bool("state") && this.hasTag("togglesupport")) return; // set this to stop structure
	int crafting = this.get_u8("crafting");

	AssemblerItem[]@ items = getItems(this);
	if (items.length == 0) return;

	AssemblerItem item = items[crafting];
	CInventory@ inv = this.getInventory();


	CBitStream missing;
	if (hasRequirements(inv, item.reqs, missing))
	{
		if (isServer())
		{
			CBlob @mat = server_CreateBlob(item.resultname, this.getTeamNum(), this.getPosition());
			mat.server_SetQuantity(item.resultcount);

			server_TakeRequirements(inv, item.reqs);
		}

		if(isClient())
		{
			this.getSprite().PlaySound("ProduceSound.ogg");
			this.getSprite().PlaySound("BombMake.ogg");
		}
	}
}



void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if (blob is null) return;

	int crafting = this.get_u8("crafting");

	bool isMat = false;

	AssemblerItem[]@ items = getItems(this);
	if (items.length == 0) return;

	AssemblerItem item = items[crafting];
	CBitStream bs = item.reqs;
	bs.ResetBitIndex();
	string text, requiredType, name, friendlyName;
	u16 quantity = 0;

	while (!bs.isBufferEnd())
	{
		ReadRequirement(bs, requiredType, name, friendlyName, quantity);

		if(blob.getName() == name)
		{
			isMat = true;
			break;
		}
	}

	if (isMat && !blob.isAttached() && blob.hasTag("material"))
	{
		if (isServer()) this.server_PutInInventory(blob);
		if (isClient()) this.getSprite().PlaySound("bridge_open.ogg");
	}
}

bool isInventoryAccessible(CBlob@ this, CBlob@ forBlob)
{
	return (this.getTeamNum() >= 100 ? true : (forBlob.getTeamNum() == this.getTeamNum())) && forBlob.isOverlapping(this);
}

AssemblerItem[] getItems(CBlob@ this)
{
	AssemblerItem[] items;
	this.get("items", items);
	return items;
}


/*void onAddToInventory( CBlob@ this, CBlob@ blob )
{
	if(blob.getName() != "gyromat") return;

	this.getCurrentScript().tickFrequency = Maths::Max(1, 60 / (this.exists("gyromat_acceleration") ? this.get_f32("gyromat_acceleration") : 1));
}

void onRemoveFromInventory(CBlob@ this, CBlob@ blob)
{
	if(blob.getName() != "gyromat") return;
	
	this.getCurrentScript().tickFrequency = Maths::Max(1, 60 / (this.exists("gyromat_acceleration") ? this.get_f32("gyromat_acceleration") : 1));
}*/