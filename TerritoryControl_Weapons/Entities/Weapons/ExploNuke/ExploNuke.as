#include "Hitters.as";

const u32 fuel_timer_max = 30 * 0.50f;

void onInit(CBlob@ this)
{
		
	this.set_u32("fuel_timer", 0);
	this.set_f32("velocity", 9.0f);
	
	this.getShape().SetRotationsAllowed(true);
	
	this.set_u32("fuel_timer", getGameTime() + fuel_timer_max + XORRandom(15));
	
	this.Tag("projectile");
	this.Tag("explosive");
	
	CSprite@ sprite = this.getSprite();
	sprite.SetEmitSound("Shell_Whistle.ogg");
	sprite.SetEmitSoundSpeed(1.1f);
	sprite.SetEmitSoundVolume(1.0f);
	sprite.SetEmitSoundPaused(false);
}

void onTick(CBlob@ this)
{
	// f32 modifier = Maths::Max(0, this.getVelocity().y * 0.3f);
	// this.getSprite().SetEmitSoundVolume(Maths::Max(0, modifier));

	if (this.get_u32("fuel_timer") > getGameTime())
	{
		this.set_f32("velocity", Maths::Min(this.get_f32("velocity") + 0.15f, 10.0f));
		
		Vec2f dir = Vec2f(0, 1);
		dir.RotateBy(this.getAngleDegrees());
					
		this.setVelocity(dir * -this.get_f32("velocity") + Vec2f(0, this.getTickSinceCreated() > 5 ? XORRandom(50) / 100.0f : 0));
		
		this.setAngleDegrees(-this.getVelocity().Angle() + 90);
	}
	else
	{
		this.setAngleDegrees(-this.getVelocity().Angle() + 90);
		this.getSprite().SetEmitSoundPaused(true);
	}		
}

void onDie(CBlob@ this)
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

bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{
	return this.getTeamNum() != blob.getTeamNum() && blob.isCollidable();
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if (blob !is null) if (blob.hasTag("gas")) return; 
	if (this.getTickSinceCreated() > 5 && (solid ? true : (blob !is null && blob.isCollidable())))
	{
		if (isServer())
		{
			this.server_Die();
		}
	}
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
	return false;
}