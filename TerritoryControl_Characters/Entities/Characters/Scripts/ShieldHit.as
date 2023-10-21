// Shield hit - make sure to set up the shield vars elsewhere
#include "ShieldCommon.as";
#include "ParticleSparks.as";
#include "KnockedCommon.as";
#include "KnightCommon.as";
#include "Hitters.as";
#include "HittersTC.as";

// if your health is lower than it was last time you got hit
f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	ShieldVars@ shieldVars = getShieldVars(this);

	// no shield when stunned
	if (isKnocked(this) && !isJustKnocked(this))
	{
		return damage;
	}

	if (blockAttack(this, velocity, 0.0f) && this.hasTag("shielded"))
	{			
		f32 dmg = damage;
		switch (customData)
		{
			case Hitters::arrow:
			dmg *= 0.25f;
			break;
				
			case Hitters::sword:
			case Hitters::stab:
			dmg *= 2.0f;
			break;
				
			case HittersTC::bayonet:
			dmg *= 5.0f;
			break;
					
			case Hitters::keg:
			case Hitters::bomb:
			case Hitters::explosion:
			case Hitters::bomb_arrow:
			dmg *= 4.0f;
			break;
					
			case HittersTC::shotgun:
			case HittersTC::bullet_low_cal:
			dmg *= 0.5f;
			break;
		}
		if (this.getName() == "royalguard")
		switch (customData)
		{
			case HittersTC::bayonet:
			dmg *= 2.0f;
			break;
			
			case HittersTC::bullet_high_cal:
			case HittersTC::bullet_low_cal:
			dmg *= 0.25f;
			break;
		}
	
		if (isExplosionHitter(customData)) // bomb jump
		{
			Vec2f vel = this.getVelocity();
			this.setVelocity(Vec2f(0.0f, Maths::Min(0.0f, vel.y)));

			Vec2f bombforce = Vec2f(0.0f, ((velocity.y > 0) ? 0.7f : -1.3f));

			bombforce.Normalize();
			bombforce *= 2.0f * Maths::Sqrt(damage) * this.getMass();
			bombforce.y -= 2;

			if (!this.isOnGround() && !this.isOnLadder())
			{
				if (this.isFacingLeft() && vel.x > 0)
				{
					bombforce.x += 50;
					bombforce.y -= 80;
				}
				else if (!this.isFacingLeft() && vel.x < 0)
				{
					bombforce.x -= 50;
					bombforce.y -= 80;
				}
			}
			else if (this.isFacingLeft() && vel.x > 0) bombforce.x += 5;
			else if (!this.isFacingLeft() && vel.x < 0) bombforce.x -= 5;

			this.AddForce(bombforce);
			this.Tag("dont stop til ground");
			return 0.0f;

		}
		else if (shieldVars.shieldHealth >= dmg)
		{	
			//print("was " + shieldVars.shieldHealth);
			shieldVars.shieldHealth = shieldVars.shieldHealth - dmg;
			
			if (isClient())
			{
				this.Tag("shieldDoesBlock");
				this.set_f32("shieldDamage", dmg);
				this.set_Vec2f("shieldDamageVel", velocity);
				this.set_Vec2f("ShieldWorldPoint", worldPoint);

				if (customData == HittersTC::bullet_low_cal || customData == HittersTC::bullet_high_cal || customData == HittersTC::shotgun)
				{
					this.getSprite().PlaySound("BulletDodge" + XORRandom(3), 1.25f, 0.8f);
				}
			}
			this.set("shield vars", shieldVars);
			//print("now " + shieldVars.shieldHealth);
			return 0.0f;
		}
		else
		{
			//print("was " + shieldVars.shieldHealth);
			f32 damg = damage - shieldVars.shieldHealth;
			
			shieldVars.shieldHealth = 0;
			knockShieldDown(this);
			this.Tag("force_knock");
			
			//print("now " + shieldVars.shieldHealth);
			this.set("shield vars", shieldVars);
			return damg;
		}
		this.set("shield vars", shieldVars);
	}
	else
	{
		if (isClient() && isJustKnocked(hitterBlob))
		{
			this.Tag("shieldNoBlock");
			this.set_f32("shieldDamage", damage);
			this.set_Vec2f("shieldDamageVel", velocity);
			this.set_Vec2f("ShieldWorldPoint", worldPoint);
		}
	}
	return damage; //no block, damage goes through
}

void onHealthChange( CBlob@ this, f32 oldHealth )
{
	if (isClient() && (this.hasTag("shieldNoBlock") || this.hasTag("shieldDoesBlock")))
	{
		if (this.getHealth() == oldHealth)
		{
			f32 damage = this.get_f32("shieldDamage");
			Vec2f velocity = this.get_Vec2f("shieldDamageVel");
			Vec2f worldPoint = this.get_Vec2f("ShieldWorldPoint");

			shieldHit(damage, velocity, worldPoint);
		}
		else if (this.hasTag("shieldDoesBlock"))
		{
			// drop shield
			knockShieldDown(this);
			KnightInfo@ knight;
			if (this.get("knightInfo", @knight))
			{
				knight.state = KnightStates::normal;
				this.set_s32("currentKnightState", 0);
			}
		}
		this.Untag("shieldNoBlock");
		this.Untag("shieldDoesBlock");
	}
}

void shieldHit(f32 damage, Vec2f velocity, Vec2f worldPoint)
{
	Sound::Play("ShieldHit", worldPoint);
	const f32 vellen = velocity.Length();
	sparks(worldPoint, -velocity.Angle(), Maths::Max(vellen * 0.05f, damage));
}
