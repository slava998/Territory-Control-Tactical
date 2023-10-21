#include "Hitters.as";
#include "Explosion.as";

string[] particles = 
{
	"LargeSmoke",
	"Explosion.png"
};

void onInit(CBlob@ this)
{
	this.getShape().SetRotationsAllowed(true);
	
	// this.set_string("custom_explosion_sound", "bigbomb_explosion.ogg");
	this.set_bool("map_damage_raycast", true);
	this.set_Vec2f("explosion_offset", Vec2f(0, 16));
	
	this.set_u8("stack size", 1);
	this.set_f32("bomb angle", 90);
	
	// this.Tag("map_damage_dirt");
	
	this.Tag("explosive");
	this.Tag("medium weight");
	
	this.maxQuantity = 1;
}

void onDie(CBlob@ this)
{
	if (isServer() && this.hasTag("DoExplode"))
	{
		u8 flashAlpha = 0;

		if (isClient())
		{
			f32 distance = this.get_f32("distance");
			flashAlpha = XORRandom(128) + 128;
			flashAlpha -= int(Maths::Min(flashAlpha, distance));
		}
		
		if (isServer())
		{
			for (int i = 0; i < 25; i++) 
			{
				CBlob @blob = server_CreateBlob("fuelgas", this.getTeamNum(), this.getPosition());
				blob.SetDamageOwnerPlayer(this.getDamageOwnerPlayer()); 
			}
			for (int i = 0; i < 18; i++) 
			{
				CBlob @blob = server_CreateBlob("firegas", this.getTeamNum(), this.getPosition());
				blob.setVelocity(Vec2f(10-XORRandom(20), -XORRandom(15)));
				blob.SetDamageOwnerPlayer(this.getDamageOwnerPlayer()); 
			} 
		}
		if (isClient())
		{
			this.getSprite().PlaySound("MithrilBomb_Explode.ogg", 1.00f, 1.00f);
			this.getSprite().PlaySound("ThermobaricExplosion.ogg", 1.00f, 1.00f);
			SetScreenFlash(flashAlpha, 255, 255, 255);
			ShakeScreen(512, 64, this.getPosition());
		}
	}
}

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	if (damage >= this.getHealth() && !this.hasTag("dead"))
	{
		this.Tag("DoExplode");
		this.set_f32("bomb angle", 90);
		this.server_Die();
	}
	
	return damage;
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal)
{
	if (blob !is null ? !blob.isCollidable() : !solid)
	{
		return;
	}

	f32 vellen = this.getOldVelocity().Length();
	if (vellen >= 8.0f) 
	{
		if (blob !is null)
		{
			if (blob.getName() != "triplane" && blob.getName() != "jetfighter"
			&& !blob.isInInventory() && !blob.isAttached())
				return;
		}
		
		Vec2f dir = Vec2f(-normal.x, normal.y);

		this.Tag("DoExplode");
		this.set_f32("bomb angle", dir.Angle());
		this.server_Die();
	}
}

bool canBePutInInventory(CBlob@ this, CBlob@ inventoryBlob)
{
	if (inventoryBlob !is null && (inventoryBlob.hasTag("flesh") || inventoryBlob.hasTag("player")) && this !is null)
	{
		CInventory@ inv = inventoryBlob.getInventory();
		if (inv !is null)
		{
			u8 counter = 1;
			u16 nukes = inv.getItemsCount();
			for (u16 i = 0; i < nukes; i++)
			{
				CBlob@ item = inv.getItem(i);
				if (item is null) continue;
				if (item.getName() == "mat_explonuke") counter++;
			}
			return counter <= 5;
		}
	}
	return true;
}