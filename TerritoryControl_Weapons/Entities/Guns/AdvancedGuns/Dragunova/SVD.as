#include "GunCommon.as";

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	if (this.isAttached()) return 0;
	return damage;
}

void onInit(CBlob@ this)
{
	GunSettings settings = GunSettings();

	//General
	settings.CLIP = 10; //Amount of ammunition in the gun at creation
	settings.TOTAL = 10; //Max amount of ammo that can be in a clip
	settings.FIRE_INTERVAL = 50; //Time in between shots
	settings.RELOAD_TIME = 60; //Time it takes to reload (in ticks)
	settings.AMMO_BLOB = "mat_sniperammo"; //Ammunition the gun takes

	//Bullet
	settings.B_PER_SHOT = 2; //Shots per bullet | CHANGE B_SPREAD, otherwise both bullets will come out together
	//settings.B_GRAV = Vec2f(0, 0.001); //Bullet gravity drop
	settings.B_SPEED = 120; //Bullet speed, STRONGLY AFFECTED/EFFECTS B_GRAV
	settings.B_TTL = 15; //TTL = 'Time To Live' which determines the time the bullet lasts before despawning
	settings.B_DAMAGE = 2.25f; //1 is 1 heart
	settings.B_TYPE = HittersTC::bullet_high_cal; //Type of bullet the gun shoots | hitter
	
	//Spread & Cursor
	//settings.B_SPREAD = 0; //the higher the value, the more 'uncontrollable' bullets get
	//settings.INCREASE_SPREAD = false; //Should the spread increase as you shoot. Default is false
	//settings.SPREAD_FACTOR = 0.0; //How much spread will increase as you shoot. Formula of increasing is: B_SPREAD * Max:(SPREAD_FACTOR, (Number of shoots * SPREAD_FACTOR)). Does not affect cursor.
	settings.MAX_SPREAD = 10; //Maximum spread the weapon can reach. Also determines how big cursor can become
	settings.CURSOR_SIZE = 10; //Size of crosshair that appear when you hold a gun
	settings.ENLARGE_CURSOR = true; //Should we enlarge cursor as you shoot. Default is true
	settings.ENLARGE_FACTOR = 3; //Multiplier of how much cursor will enlarge as you shoot.

	//Recoil
	settings.G_RECOIL = -15; //0 is default, adds recoil aiming up
	settings.G_RANDOMX = true; //Should we randomly move x
	settings.G_RANDOMY = false; //Should we randomly move y, it ignores g_recoil
	settings.G_RECOILT = 8; //How long should recoil last, 10 is default, 30 = 1 second (like ticks)
	settings.G_BACK_T = 2; //Should we recoil the arm back time? (aim goes up, then back down with this, if > 0, how long should it last)

	//Sound	
	settings.FIRE_SOUND = "DragunovaFire.ogg";//Sound when shooting
	settings.RELOAD_SOUND = "SVD_Reloading.ogg"; //Sound when reloading

	//Offset
	settings.MUZZLE_OFFSET = Vec2f(-25, -1); //Where the muzzle flash appears

	this.set("gun_settings", @settings);

	//Custom
	this.set_f32("scope_zoom", 0.20f);
	this.set_u8("CustomPenetration", 2);
	this.set_u8("CustomKnock", 10);
	this.Tag("medium weight");
	//this.Tag("place45");
	this.Tag("powerful");
	this.Tag("sniper");
	this.set_string("CustomSoundPickup", "SVD_Pickup.ogg");
	this.set_f32("CustomBulletLength", 40.0f);
}
