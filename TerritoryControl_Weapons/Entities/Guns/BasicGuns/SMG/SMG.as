#include "GunCommon.as";
#include "Knocked.as";

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	if (this.isAttached()) return 0;
	return damage;
}

void onInit(CBlob@ this)
{
	GunSettings settings = GunSettings();

	//General
	settings.CLIP = 50; //Amount of ammunition in the gun at creation
	settings.TOTAL = 50; //Max amount of ammo that can be in a clip
	settings.FIRE_INTERVAL = 2; //Time in between shots
	settings.RELOAD_TIME = 45; //Time it takes to reload (in ticks)
	settings.AMMO_BLOB = "mat_pistolammo"; //Ammunition the gun takes

	//Bullet
	//settings.B_PER_SHOT = 1; //Shots per bullet | CHANGE B_SPREAD, otherwise both bullets will come out together
	//settings.B_GRAV = Vec2f(0, 0.001); //Bullet gravity drop
	settings.B_SPEED = 45; //Bullet speed, STRONGLY AFFECTED/EFFECTS B_GRAV
	settings.B_TTL = 20; //TTL = 'Time To Live' which determines the time the bullet lasts before despawning
	settings.B_DAMAGE = 0.4f; //1 is 1 heart
	settings.B_TYPE = HittersTC::bullet_low_cal; //Type of bullet the gun shoots | hitter
	
	//Spread & Cursor
	settings.B_SPREAD = 3; //the higher the value, the more 'uncontrollable' bullets get
	settings.INCREASE_SPREAD = true; //Should the spread increase as you shoot. Default is false
	settings.SPREAD_FACTOR = 0.041; //How much spread will increase as you shoot. Formula of increasing is: B_SPREAD * Max:(SPREAD_FACTOR, (Number of shoots * SPREAD_FACTOR)). Does not affect cursor.
	settings.MAX_SPREAD = 10; //Maximum spread the weapon can reach. Also determines how big cursor can become
	settings.CURSOR_SIZE = 15; //Size of crosshair that appear when you hold a gun
	settings.ENLARGE_CURSOR = true; //Should we enlarge cursor as you shoot. Default is true
	settings.ENLARGE_FACTOR = 1; //Multiplier of how much cursor will enlarge as you shoot.
	
	//Recoil
	settings.G_RECOIL = -11; //0 is default, adds recoil aiming up
	settings.G_RANDOMX = false; //Should we randomly move x
	settings.G_RANDOMY = false; //Should we randomly move y, it ignores g_recoil
	settings.G_RECOILT = 4; //How long should recoil last, 10 is default, 30 = 1 second (like ticks)
	settings.G_BACK_T = 0; //Should we recoil the arm back time? (aim goes up, then back down with this, if > 0, how long should it last)

	//Sound
	settings.FIRE_SOUND = "SMGFire.ogg"; //Sound when shooting
	//settings.RELOAD_SOUND = "SMGReload.ogg"; //Sound when reloading

	//Offset
	settings.MUZZLE_OFFSET = Vec2f(-16, -2); //Where the muzzle flash appears

	this.set("gun_settings", @settings);
	
	//Custom
	this.set_string("CustomSoundPickup", "SMG_Pickup.ogg");
	this.set_f32("CustomBulletLength", 6.5f);
	this.set_f32("CustomBulletWidth", 1.3f);
	this.set_string("CustomBullet", "item_bullet_alt.png");
}