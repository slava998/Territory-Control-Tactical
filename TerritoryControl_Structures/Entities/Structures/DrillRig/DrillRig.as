// A script by TFlippy & Pirate-Rob

#include "Requirements.as";
#include "ShopCommon.as";
#include "Descriptions.as";
#include "CheckSpam.as";
#include "CTFShopCommon.as";
#include "MakeMat.as";
#include "BuilderHittable.as";
#include "Hitters.as";

u8 counter = 4;

const string[] resources = 
{
	"mat_iron",
	"mat_copper",
	"mat_stone",
	"mat_gold",
	"mat_mithril"
};

const u8[] resourceYields = 
{
	18,
	18,
	36,
	18,
	9
};

void onInit(CBlob@ this)
{
	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	this.Tag("builder always hit");
	this.Tag("extractable");
	
	this.getCurrentScript().tickFrequency = 90;
	
	this.set_bool("isActive", false);
	this.addCommandID("sv_toggle");
	this.addCommandID("cl_toggle");

	this.set_bool("HasStorage", false);
	

	this.set_Vec2f("wire_offset", Vec2f(0, 8));
	
	// SetState(this, this.get_bool("isActive"));
}

void onInit(CSprite@ this)
{
	this.SetEmitSound("Drill.ogg");
	this.SetEmitSoundVolume(0.1f);
	this.SetEmitSoundSpeed(0.7f);
	
	this.SetEmitSoundPaused(!this.getBlob().get_bool("isActive"));
}

void onTick(CBlob@ this)
{
	if (isServer())
	{
		if (!this.get_bool("isActive")) return;
	
		CMap@ map = getMap();
		
		f32 depth = XORRandom(96);
		Vec2f pos = Vec2f(this.getPosition().x + (XORRandom(64) - 32) * (1 - depth / 96), Maths::Min(this.getPosition().y + 16 + depth, (map.tilemapheight * map.tilesize) - 8));

		this.server_HitMap(pos, Vec2f(0, 0), 1.3f, Hitters::drill);
		
		if(counter == 4) //Check for storage every 4th hit
		{
			CBlob@ storage = FindStorage(this.getTeamNum());
			if (storage !is null)
			{
				this.set_bool("HasStorage", true);
				//print("Found storage!");
			}
			else
			{
				this.set_bool("HasStorage", false);
				//print("Not found storage!");
			}
			
			counter = 0;
		}
		else counter++;
	}
	
	if (isClient())
	{
		this.getSprite().SetEmitSoundSpeed(0.7f + ((this.get_f32("gyromat_acceleration") - 1.00f) * 0.10f));
	}
}

void onHitMap(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, u8 customData)
{
	if (isServer())
	{
		TileType tile = getMap().getTile(worldPoint).type;
		
		if (tile == CMap::tile_bedrock)
		{
			if(!this.get_bool("HasStorage")) //Production with stone pile code in StonePile.as
			{
				u8 index = XORRandom(resources.length - 1);
				MakeMat(this, worldPoint, resources[index], XORRandom(resourceYields[index] * (f32(XORRandom(100)) / 40.00f)));
			}
			
			//print("ore: " + resources[XORRandom(index)] + " yield: " + XORRandom(resourceYields[index]));
			
			if(!this.hasTag("digging_bedrock")) this.Tag("digging_bedrock");
		}
		else if(this.hasTag("digging_bedrock")) this.Untag("digging_bedrock");
	}
}

CBlob@ FindStorage(u8 team)
{
	//print("Checking for storage...");
	if (team >= 100) return null;

	CBlob@[] blobs;
	getBlobsByName("stonepile", @blobs);

	CBlob@[] validBlobs;

	for (u32 i = 0; i < blobs.length; i++)
	{
		if (blobs[i].getTeamNum() == team && !blobs[i].getInventory().isFull())
		{
			validBlobs.push_back(blobs[i]);
		}
	}

	if (validBlobs.length == 0) return null;

	return validBlobs[XORRandom(validBlobs.length)];
}

void onDie(CBlob@ this)
{
	if (isServer())
	{
		server_CreateBlob("drill", this.getTeamNum(), this.getPosition());
	}
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (isServer())
	{
		if (cmd == this.getCommandID("sv_toggle"))
		{
			bool active = params.read_bool();
			
			this.set_bool("isActive", active);

			// print("sv: " + active);
			
			CBitStream stream;
			stream.write_bool(active);
			this.SendCommand(this.getCommandID("cl_toggle"), stream);
		}
	}
	
	if (isClient())
	{
		if (cmd == this.getCommandID("cl_toggle"))
		{		
			bool active = params.read_bool();
		
			// print("cl: " + active);
		
			this.set_bool("isActive", active);
		
			CSprite@ sprite = this.getSprite();
		
			sprite.PlaySound("LeverToggle.ogg");
			sprite.SetEmitSoundPaused(!active);
			sprite.SetAnimation(active ? "active" : "inactive");
		}
	}
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (this.getDistanceTo(caller) > 96.0f) return;
	if (!this.isOverlapping(caller)) return;
	
	CBitStream params;
	params.write_bool(!this.get_bool("isActive"));
	
	CButton@ buttonEject = caller.CreateGenericButton(11, Vec2f(0, -8), this, this.getCommandID("sv_toggle"), (this.get_bool("isActive") ? "Turn Off" : "Turn On"), params);
}

bool isInventoryAccessible(CBlob@ this, CBlob@ forBlob)
{
	return (forBlob.isOverlapping(this));
}