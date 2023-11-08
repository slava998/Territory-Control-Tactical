#include "GunCommon.as";
#include "Knocked.as";
#include "HittersTC.as";

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	if (this.isAttached()) return 0;
	return damage;
}

void onInit(CSprite@ this)
{
	CSpriteLayer@ stab = this.addSpriteLayer("stab", "BayonetStab.png", 16, 16);
	if (stab !is null)
	{
		Animation@ anim = stab.addAnimation("BayonetStab.png", 0, false);
		int[] frames = {0,1,2,3};
		if (anim !is null)
		{
			anim.AddFrames(frames);
			stab.SetAnimation(anim);
		}
		stab.SetOffset(Vec2f(-20, 0.0f));
		stab.SetRelativeZ(10.0f);
		stab.SetVisible(false);
	}
}

void onInit(CBlob@ this)
{
	GunSettings settings = GunSettings();

	//General
	settings.CLIP = 8; //Amount of ammunition in the gun at creation
	settings.TOTAL = 8; //Max amount of ammo that can be in a clip
	settings.FIRE_INTERVAL = 9; //Time in between shots
	settings.RELOAD_TIME = 10; //Time it takes to reload (in ticks)
	settings.AMMO_BLOB = "mat_rifleammo"; //Ammunition the gun takes

	//Bullet
	settings.B_PER_SHOT = 1; //Shots per bullet | CHANGE B_SPREAD, otherwise both bullets will come out together
	//settings.B_GRAV = Vec2f(0, 0.001); //Bullet gravity drop
	settings.B_SPEED = 90; //Bullet speed, STRONGLY AFFECTED/EFFECTS B_GRAV
	settings.B_TTL = 20; //TTL = 'Time To Live' which determines the time the bullet lasts before despawning
	settings.B_DAMAGE = 1.5f; //1 is 1 heart
	settings.B_TYPE = HittersTC::bullet_high_cal; //Type of bullet the gun shoots | hitter
	
	//Spread & Cursor
	//settings.B_SPREAD = 0; //the higher the value, the more 'uncontrollable' bullets get
	settings.INCREASE_SPREAD = false; //Should the spread increase as you shoot. Default is false
	//settings.SPREAD_FACTOR = 0.0; //How much spread will increase as you shoot. Formula of increasing is: B_SPREAD * Max:(SPREAD_FACTOR, (Number of shoots * SPREAD_FACTOR)). Does not affect cursor.
	//settings.MAX_SPREAD = 0; //Maximum spread the weapon can reach. Also determines how big cursor can become
	settings.CURSOR_SIZE = 10; //Size of crosshair that appear when you hold a gun
	settings.ENLARGE_CURSOR = false; //Should we enlarge cursor as you shoot. Default is true
	//settings.ENLARGE_FACTOR = 0; //Multiplier of how much cursor will enlarge as you shoot.

	//Recoil
	settings.G_RECOIL = -10; //0 is default, adds recoil aiming up
	//settings.G_RANDOMX = true; //Should we randomly move x
	//settings.G_RANDOMY = false; //Should we randomly move y, it ignores g_recoil
	settings.G_RECOILT = 7; //How long should recoil last, 10 is default, 30 = 1 second (like ticks)
	settings.G_BACK_T = 6; //Should we recoil the arm back time? (aim goes up, then back down with this, if > 0, how long should it last)

	//Sound
	settings.FIRE_SOUND = "LeverRifle_Fire.ogg"; //Sound when shooting
	settings.RELOAD_SOUND = "LeverRifle_load.ogg"; //Sound when reloading

	//Offset
	settings.MUZZLE_OFFSET = Vec2f(-17, -2); //Where the muzzle flash appears

	this.set("gun_settings", @settings);

	//Custom
	this.set_string("CustomCycle", "LeverRifle_Cycle");
	this.set_string("CustomReloadingEnding", "LeverRifle_Cycle");
	this.Tag("CustomShotgunReload");
	this.set_string("CustomSoundPickup", "LeverRifle_Pickup.ogg");
	this.Tag("CustomSemiAuto");
}

void onTick(CBlob@ this)
{
	if (this.isAttached())
	{
		AttachmentPoint@ point = this.getAttachments().getAttachmentPointByName("PICKUP");
		CBlob@ holder = point.getOccupied();
		
		if (holder is null) return;
		
		if (point.isKeyPressed(key_action2) && this.get_u8("actionInterval") == 0 && !isKnocked(holder))
		{
			this.set_f32("gun_recoil_current", -14); //Using the gun kickback variable for pushing forward
			this.set_u8("actionInterval", 18);
			if(isClient()) this.getSprite().PlaySound("SwordSlash");
			this.Tag("stabbing");

			HitInfo@[] hitInfos;
			if (getMap().getHitInfosFromArc(this.getPosition(), -(holder.getAimPos() - this.getPosition()).Angle(), 45, 28, this, @hitInfos))
			{
				for (uint i = 0; i < hitInfos.length; i++)
				{
					CBlob@ blob = hitInfos[i].blob;
					if (blob !is null && blob.hasTag("flesh"))
					{
						if (isServer())
						{
							holder.server_Hit(blob, blob.getPosition(), Vec2f(), 3.6f, HittersTC::bayonet, true);
						}
					}
				}
			}
		}
		if (this.hasTag("stabbing"))
		{
			CSprite@ sprite = this.getSprite();
			if (sprite is null) return;
				
			u8 interval = this.get_u8("actionInterval");
			CSpriteLayer@ stab = sprite.getSpriteLayer("stab");
			if (stab !is null)
			{
				if (interval == 17) 
				{
					stab.SetVisible(true); 
					stab.SetFrameIndex(0);
				}
				else if (interval == 16) stab.SetFrameIndex(1);
				else if (interval == 15) stab.SetFrameIndex(2);
				else if (interval == 14) stab.SetFrameIndex(3);
				else if (interval == 12) 
				{
					stab.SetVisible(false);
					this.Untag("stabbing");
				}
			}
		}
	}
}

void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint)
{
	CSprite@ sprite = this.getSprite();
	if (sprite !is null)
	{
		CSpriteLayer@ stab = sprite.getSpriteLayer("stab");
		if (stab !is null) stab.SetVisible(false);
		stab.SetVisible(false);
		this.Untag("stabbing");
	}
}