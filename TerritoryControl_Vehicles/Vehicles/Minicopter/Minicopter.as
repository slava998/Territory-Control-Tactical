#include "VehicleCommon.as"
#include "Hitters.as";
#include "HittersTC.as";
#include "VehicleFuel.as";
#include "Explosion.as";

const Vec2f upVelo = Vec2f(0.00f, -0.0175f);
const Vec2f downVelo = Vec2f(0.00f, 0.0085f);
const Vec2f leftVelo = Vec2f(-0.0233f, 0.00f);
const Vec2f rightVelo = Vec2f(0.0233f, 0.00f);

const Vec2f minClampVelocity = Vec2f(-0.50f, -0.70f);
const Vec2f maxClampVelocity = Vec2f( 0.50f, 0.00f);

const f32 thrust = 1050.00f;

const u8 cooldown_time = 15;//210;
const u8 recoil = 0;

const s16 init_gunoffset_angle = -3; // up by so many degrees

// 0 == up, 90 == sideways
const f32 high_angle = 85.0f; // upper depression limit
const f32 low_angle = 115.0f; // lower depression limit

void onInit(CBlob@ this)
{
	this.set_string("custom_explosion_sound", "bigbomb_explosion.ogg");
	this.set_bool("map_damage_raycast", true);
	this.Tag("map_damage_dirt");
	
	this.set_u32("duration", 0);

	this.Tag("vehicle");
	this.Tag("aerial");
	this.Tag("has mount");
	this.Tag("helicopter");
	this.set_u8("mode", 1);
	
	this.set_bool("lastTurn", false);
	this.set_bool("music", false);

	//this.addCommandID("shoot bullet");
	this.addCommandID("sync_vel");

	// spams in console if not added
	this.addCommandID("fire");
	this.addCommandID("fire blob");
	this.addCommandID("flip_over");
	this.addCommandID("vehicle getout");
	this.addCommandID("putin_mag");
	this.addCommandID("getin_mag");
	this.addCommandID("load_ammo");
	this.addCommandID("load_fuel");

	if (this !is null)
	{
		CShape@ shape = this.getShape();
		if (shape !is null)
		{
			shape.SetRotationsAllowed(false);
		}
	}
	
	this.set_f32("max_fuel", 3000);
	this.set_f32("fuel_consumption_modifier", 3.0f);

	AttachmentPoint@[] aps;
	if (this.getAttachmentPoints(@aps))
	{
		for (uint i = 0; i < aps.length; i++)
		{
			AttachmentPoint@ ap = aps[i];
			ap.offsetZ = 10.0f;
			ap.SetKeysToTake(key_action1 | key_action2 | key_action3);
		}
	}

	this.SetMapEdgeFlags(CBlob::map_collide_left | CBlob::map_collide_right);
	
	if (isServer())
	{
		CBlob@ mg = server_CreateBlob("gatlinggun");	
	
		if (mg !is null)
		{
			mg.server_setTeamNum(this.getTeamNum());
			this.server_AttachTo( mg, "VEHICLE" );
			mg.SetFacingLeft(this.isFacingLeft());
		}
	
	}
}

void onInit(CSprite@ this)
{	
	this.SetRelativeZ(-20.0f);
	//Add blade
	CSpriteLayer@ blade = this.addSpriteLayer("blade", "Minicopter_Blade.png", 92, 8);
	if (blade !is null)
	{
		Animation@ anim = blade.addAnimation("default", 1, true);
		int[] frames = {1, 2, 3, 2};
		anim.AddFrames(frames);
		
		blade.SetOffset(Vec2f(5, -16));
		blade.ScaleBy(Vec2f(0.7f, 1.0f));
		blade.SetRelativeZ(20.0f);
		blade.SetVisible(true);
	}
	
	this.SetEmitSound("minicopter_loop.ogg");
	this.SetEmitSoundSpeed(0.01f);
	this.SetEmitSoundPaused(false);
}

void updateLayer(CSprite@ sprite, string name, int index, bool visible, bool remove)
{
	if (sprite !is null)
	{
		CSpriteLayer@ layer = sprite.getSpriteLayer(name);
		if (layer !is null)
		{
			if (remove == true)
			{
				sprite.RemoveSpriteLayer(name);
				return;
			}
			else
			{
				layer.SetFrameIndex(index);
				layer.SetVisible(visible);
			}
		}
	}
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
	return false;
}

void onTick(CBlob@ this)
{
	if (this !is null)
	{
		
		Vehicle_ensureFallingCollision(this);
		
		if (this.getVelocity().x > 6.25f || this.getVelocity().x < -6.25f) this.setVelocity(Vec2f(this.getOldVelocity().x, this.getVelocity().y));

		if (this.getPosition().y < 70.0f && this.getVelocity().y < 0.5f)
		{
			//this.setVelocity(Vec2f(this.getVelocity().x, this.getVelocity().y*0.16f));
			this.AddForce(Vec2f(0, 220.0f));
		}
		
		CSprite@ sprite = this.getSprite();
		CShape@ shape = this.getShape();
		Vec2f currentVel = this.getVelocity();
		f32 angle = shape.getAngleDegrees();

		const bool flip = this.isFacingLeft();

		Vec2f newForce = Vec2f(0, 0);

		AttachmentPoint@[] aps;
		this.getAttachmentPoints(@aps);
		
		f32 fuel = GetFuel(this);
		
		CSpriteLayer@ blade = sprite.getSpriteLayer("blade");
		for(int a = 0; a < aps.length; a++)
		{
			AttachmentPoint@ ap = aps[a];
			if (ap !is null)
			{
				CBlob@ hooman = ap.getOccupied();
				if (hooman !is null)
				{
					if (ap.name == "DRIVER")
					{
						const bool pressed_w  = ap.isKeyPressed(key_up);
						const bool pressed_s  = ap.isKeyPressed(key_down);
						const bool pressed_a  = ap.isKeyPressed(key_left);
						const bool pressed_d  = ap.isKeyPressed(key_right);
						const bool pressed_c  = ap.isKeyPressed(key_pickup);
						const bool pressed_m1 = ap.isKeyPressed(key_action1);
						const bool pressed_m2 = ap.isKeyPressed(key_action2);

						if (hooman.isMyPlayer() && hooman.getControls() !is null)
						{
							if (hooman.getControls().isKeyJustPressed(KEY_LCONTROL))
							{
								this.add_u8("mode", 1);
								if (this.get_u8("mode") > 2) this.set_u8("mode", 0);
							}
						}

						const f32 mass = this.getMass();
						
						if(fuel > 0)
						{
							if (!this.hasTag("falling")
							&& hooman.getPlayer() !is null)
							{
								if (pressed_a) newForce += Vec2f(leftVelo.x*0.25f, leftVelo.y*0.25f);
								if (pressed_d) newForce += Vec2f(rightVelo.x*0.25f, rightVelo.y*0.25f);

								if (pressed_w) newForce += Vec2f(upVelo.x*0.75f, upVelo.y*0.75f);
								if (pressed_s) newForce += Vec2f(downVelo.x*0.5f, downVelo.y*0.5f);
							}
							if (!this.hasTag("falling"))
							{
								if (pressed_a) newForce += leftVelo;
								if (pressed_d) newForce += rightVelo;

								if (pressed_w) newForce += upVelo;
								if (pressed_s) newForce += downVelo;
							}
							else
							{
								newForce -= Vec2f(upVelo.x*0.45f, upVelo.y*0.45f);
							}
						}

						Vec2f mousePos = ap.getAimPos();
						CBlob@ pilot = ap.getBlob();
						
						if (!this.hasTag("falling"))
						{
							if (pilot !is null && pressed_m2 && (this.getVelocity().x < 5.00f || this.getVelocity().x > -5.00f))
							{
								if (mousePos.x < pilot.getPosition().x) this.SetFacingLeft(true);
								else if (mousePos.x > pilot.getPosition().x) this.SetFacingLeft(false);
							}
							else if (this.getVelocity().x < -0.50f)
								this.SetFacingLeft(true);
							else if (this.getVelocity().x > 0.50f)
								this.SetFacingLeft(false);
						}
					}
				}
			}
		}
		Vec2f targetForce;
		Vec2f currentForce = this.get_Vec2f("current_force");
		CBlob@ pilot = this.getAttachmentPoint(0).getOccupied();
		if (fuel > 0) targetForce = this.get_Vec2f("target_force") + newForce;
		else targetForce = Vec2f(0, 0);

		f32 targetForce_y = Maths::Clamp(targetForce.y, minClampVelocity.y, maxClampVelocity.y);

		Vec2f clampedTargetForce = Vec2f(Maths::Clamp(targetForce.x, Maths::Max(minClampVelocity.x, -Maths::Abs(targetForce_y)), Maths::Min(maxClampVelocity.x, Maths::Abs(targetForce_y))), targetForce_y);

		Vec2f resultForce;
		if(!this.get_bool("glide"))
		{
			resultForce = Vec2f(Lerp(currentForce.x, clampedTargetForce.x, lerp_speed_x), Lerp(currentForce.y, clampedTargetForce.y, lerp_speed_y));
			this.set_Vec2f("current_force", resultForce);
		}
		else
		{
			resultForce = Vec2f(Lerp(currentForce.x, clampedTargetForce.x, lerp_speed_x), -0.5890000005);
			this.set_Vec2f("current_force", resultForce);
		}

		if (this.hasTag("falling") && !this.hasTag("set_force"))
		{
			this.Tag("set_force");
			this.set_Vec2f("result_force", resultForce);
		}

		this.AddForce(resultForce * thrust);
		this.setAngleDegrees(resultForce.x * 75.00f);
		if (this.hasTag("falling"))
		{
			this.setAngleDegrees(this.get_Vec2f("result_force").x * 75.00f);
		}
		
		int anim_time_formula = Maths::Floor(1.00f + (1.00f - Maths::Abs(resultForce.getLength())) * 3) % 4;
		if (this.hasTag("falling")) anim_time_formula = Maths::Floor(1.00f + (1.00f - Maths::Abs(this.get_Vec2f("result_force").getLength())) * 3) % 4;
		blade.ResetTransform();
		blade.SetOffset(Vec2f(5, -16));
		blade.ScaleBy(Vec2f(0.7f, 1.0f));
		blade.animation.time = anim_time_formula;
		if (blade.animation.time == 0)
		{
			blade.SetOffset(Vec2f(5, -16));
			blade.ScaleBy(Vec2f(0.7f, 1.0f));
			blade.SetFrameIndex(0);
			blade.RotateBy(180, Vec2f(0.0f,2.0f));
		}
 
		if (sprite !is null && this.hasTag("falling"))
		{
			if (getGameTime() % 8 == 0)
			{
				sprite.SetFacingLeft(!sprite.isFacingLeft());
			}
		}
		f32 volume = (Maths::Log(4.5)*(resultForce.getLength()+0.2)+2)/4;
		sprite.SetEmitSoundVolume(Maths::Min(volume*1.5, 1.5f));

		sprite.SetEmitSoundSpeed(Maths::Min(0.005f + Maths::Abs(resultForce.getLength() * 3.75f), 1.25f) * volume + (this.getVelocity().Length() > 1.0f ? Maths::Max(resultForce.y + 0.25f, 0) : 0));
		if (this.hasTag("falling")) sprite.SetEmitSoundSpeed(Maths::Min(0.000075f + Maths::Abs(this.get_Vec2f("result_force").getLength() * 1.00f), 0.85f) * 1.55);

		this.set_Vec2f("target_force", clampedTargetForce);
	
		if (this.hasTag("falling"))
		{
			if (getGameTime()%8==0)
				this.getSprite().PlaySound("FallingAlarm.ogg", 1.0f, 1.3f);

			this.setAngleDegrees(this.getAngleDegrees() + (Maths::Sin(getGameTime() / 5.0f) * 8.5f));
		}
		
		if (this.getTickSinceCreated() % 5 == 0)
		{
			f32 taken = this.get_f32("fuel_consumption_modifier") * resultForce.getLength();
			TakeFuel(this, taken);
		}
	}

	if (isServer() && (getGameTime()+this.getNetworkID())%90==0)
	{
		CBitStream params;
		params.write_Vec2f(this.get_Vec2f("target_force"));
		this.SendCommand(this.getCommandID("sync_vel"), params);
	}
}

void Vehicle_ensureFallingCollision(CBlob@ this)
{
	if (isServer() && this.hasTag("falling") && (this.isInWater() || this.isOnGround()))
	{
		this.server_Die();
	}
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if (isServer() && solid && this.hasTag("falling"))
		this.server_Die();
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (this.getDistanceTo(caller) > 96.0f) return;
	if (caller.getTeamNum() == this.getTeamNum())
	{
		{
			CBitStream params;
			CBlob@ carried = caller.getCarriedBlob();
			if (carried !is null && this.get_f32("fuel_count") < this.get_f32("max_fuel"))
			{
				string fuel_name = carried.getName();
				bool isValid = fuel_name == "mat_oil" || fuel_name == "mat_fuel";

				if (isValid)
				{
					params.write_netid(caller.getNetworkID());
					CButton@ button = caller.CreateGenericButton("$" + fuel_name + "$", Vec2f(12, 0), this, this.getCommandID("load_fuel"), "Load " + carried.getInventoryName() + "\n(" + this.get_f32("fuel_count") + " / " + this.get_f32("max_fuel") + ")", params);
				}
			}
		}
	}
}

void onCommand(CBlob@ this, u8 cmd, CBitStream@ params)
{
	if (isClient() && cmd == this.getCommandID("sync_vel"))
	{
		Vec2f vel;
		if (!params.saferead_Vec2f(vel)) return;
		this.set_Vec2f("target_force", vel);
	}
	else if (cmd == this.getCommandID("load_fuel"))
	{
		CBlob@ caller = getBlobByNetworkID(params.read_netid());
		CBlob@ carried = caller.getCarriedBlob();

		if (carried !is null)
		{
			string fuel_name = carried.getName();
			f32 fuel_modifier = 1.00f;
			bool isValid = false;

			fuel_modifier = GetFuelModifier(fuel_name, isValid, 1);

			if (isValid)
			{
				u16 remain = GiveFuel(this, carried.getQuantity(), fuel_modifier);

				if (remain == 0)
				{
					carried.Tag("dead");
					carried.server_Die();
				}
				else
				{
					carried.server_SetQuantity(remain);
				}
			}
		}
	}
}

bool isInventoryAccessible(CBlob@ this, CBlob@ forBlob)
{
	return this.getTeamNum() == forBlob.getTeamNum();
}

const f32 lerp_speed_x = 0.25f;
const f32 lerp_speed_y = 1.5f;

f32 constrainAngle(f32 x)
{
	x = (x + 180) % 360;
	if (x < 0) x += 360;
	return x - 180;
}

void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint)
{
	if (attached !is null)
	{
		if (attached.hasTag("flesh") || attached.hasTag("human") || attached.hasTag("hooman"))
		{ 
			if (isServer())
			{	
				attached.Tag("invincible");
				attached.Tag("invincibilityByVehicle");
			}
		}
	}
}

void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint)
{
	if (detached !is null)
	{
		detached.Untag("invincible");
		detached.Untag("invincibilityByVehicle");
	}
}

bool doesCollideWithBlob( CBlob@ this, CBlob@ blob )
{
	if (!blob.isCollidable() || blob.isAttached()){
		return false;
	} // no colliding against people inside vehicles
	if (blob.getRadius() > this.getRadius() ||
	        (blob.getTeamNum() != this.getTeamNum() && blob.hasTag("player") && this.getShape().vellen > 1.0f) ||
	        (blob.getShape().isStatic()) || blob.hasTag("projectile"))
	{
		return true;
	}
	return false;
}

void MakeParticle(CBlob@ this, const Vec2f vel, const string filename = "SmallSteam")
{
	if (!isClient()) return;

	Vec2f offset = Vec2f(8, 0).RotateBy(this.getAngleDegrees());
	ParticleAnimated(filename, this.getPosition() + offset, vel, float(XORRandom(360)), 1.0f, 2 + XORRandom(3), -0.1f, false);
}

void onDie(CBlob@ this)
{
	DoExplosion(this);
	
	if (isServer())
	{
		CBlob@ wreck = server_CreateBlobNoInit("minicopterwreck");
		wreck.setPosition(this.getPosition());
		wreck.setVelocity(this.getVelocity());
		wreck.setAngleDegrees(this.getAngleDegrees());
		wreck.server_setTeamNum(this.getTeamNum());
		wreck.Init();
	}
}

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	if (this.hasTag("ignore damage")) return 0;
	if (damage >= this.getHealth())
	{
		this.Tag("ignore damage");
		this.Tag("falling");
		this.Tag("invincible");
		this.set_u32("falling_time", getGameTime());
		if (isServer())
		{
			this.server_SetTimeToDie(30);
			this.server_SetHealth(this.getInitialHealth());
		}
		return 0;
	}
	
	f32 dmg = damage;
	switch (customData)
	{
		case Hitters::sword:
		case Hitters::arrow:
		case Hitters::stab:
		case HittersTC::bayonet:
			dmg *= 0.25f;
			break;

		case Hitters::keg:
		case Hitters::explosion:
		case Hitters::bomb:
		case Hitters::bomb_arrow:
			dmg *= 8.0f;
			break;

		case Hitters::cata_stones:
			dmg *= 1.0f;
			break;
		case Hitters::crush:
			dmg *= 1.0f;
			break;

		case Hitters::flying: // boat ram
			dmg *= 0.5f;
			break;
			
		case HittersTC::bullet_high_cal:
		case HittersTC::bullet_low_cal:
			dmg *= 0.35f;
			break;
			
		case HittersTC::shotgun:
			dmg *= 0.30f;
			break;
	}

	return dmg;
}

string[] particles = 
{
	"LargeSmoke",
	"Explosion.png"
};

void DoExplosion(CBlob@ this)
{
	CRules@ rules = getRules();
	if (!shouldExplode(this, rules))
	{
		addToNextTick(this, rules, DoExplosion);
		return;
	}

	this.set_f32("map_damage_radius", 48.0f);
	this.set_f32("map_damage_ratio", 0.4f);
	f32 angle = this.get_f32("bomb angle");

	Explode(this, 100.0f, 50.0f);

	for (int i = 0; i < 4; i++) 
	{
		Vec2f dir = getRandomVelocity(angle, 1, 40);
		LinearExplosion(this, dir, 40.0f + XORRandom(64), 48.0f, 6, 0.5f, Hitters::explosion);
	}

	Vec2f pos = this.getPosition() + this.get_Vec2f("explosion_offset").RotateBy(this.getAngleDegrees());
	CMap@ map = getMap();

	if (isServer())
	{
		for (int i = 0; i < (5 + XORRandom(5)); i++)
		{
			CBlob@ blob = server_CreateBlob("flame", -1, this.getPosition());
			blob.setVelocity(Vec2f(XORRandom(10) - 5, -XORRandom(10)));
			blob.server_SetTimeToDie(10 + XORRandom(5));
		}
	}

	if (isClient())
	{
		for (int i = 0; i < 40; i++)
		{
			MakeParticle(this, Vec2f( XORRandom(64) - 32, XORRandom(80) - 60), getRandomVelocity(angle, XORRandom(400) * 0.01f, 70), particles[XORRandom(particles.length)]);
		}
	}

	this.getSprite().Gib();
}

void drawFuelCount(CBlob@ this)
{
	// draw ammo count
	Vec2f pos2d1 = this.getInterpolatedScreenPos() - Vec2f(0, 10);

	Vec2f pos2d = this.getInterpolatedScreenPos() - Vec2f(0, 60);
	Vec2f dim = Vec2f(20, 8);
	const f32 y = this.getHeight() * 2.4f;
	f32 charge_percent = 1.0f;

	Vec2f ul = Vec2f(pos2d.x - dim.x, pos2d.y + y);
	Vec2f lr = Vec2f(pos2d.x - dim.x + charge_percent * 2.0f * dim.x, pos2d.y + y + dim.y);

	if (this.isFacingLeft())
	{
		ul -= Vec2f(8, 0);
		lr -= Vec2f(8, 0);

		f32 max_dist = ul.x - lr.x;
		ul.x += max_dist + dim.x * 2.0f;
		lr.x += max_dist + dim.x * 2.0f;
	}

	f32 dist = lr.x - ul.x;
	Vec2f upperleft((ul.x + (dist / 2.0f) - 10) + 4.0f, pos2d1.y + this.getHeight() + 30);
	Vec2f lowerright((ul.x + (dist / 2.0f) + 10), upperleft.y + 20);

	//GUI::DrawRectangle(upperleft - Vec2f(0,20), lowerright , SColor(255,0,0,255));

	int fuel = this.get_f32("fuel_count");
	string reqsText = "Fuel: " + fuel + " / " + this.get_f32("max_fuel");

	u8 numDigits = reqsText.size() - 1;

	upperleft -= Vec2f((float(numDigits) * 4.0f), 0);
	lowerright += Vec2f((float(numDigits) * 4.0f), 18);

	// GUI::DrawRectangle(upperleft, lowerright);
	GUI::SetFont("menu");
	GUI::DrawTextCentered(reqsText, this.getInterpolatedScreenPos() + Vec2f(0, 40), color_white);
}

void MakeParticle(CBlob@ this, const Vec2f pos, const Vec2f vel, const string filename = "SmallSteam")
{
	if (!isClient()) return;

	ParticleAnimated(filename, this.getPosition() + pos, vel, float(XORRandom(360)), 1 + XORRandom(200) * 0.01f, 2 + XORRandom(5), XORRandom(100) * -0.00005f, true);
}

void onRender(CSprite@ this)
{
	if (this is null) return; //can happen with bad reload

	// draw only for local player
	CBlob@ blob = this.getBlob();
	CBlob@ localBlob = getLocalPlayerBlob();

	if (blob is null)
	{
		return;
	}

	if (localBlob is null)
	{
		return;
	}

	AttachmentPoint@ gunner = blob.getAttachments().getAttachmentWithBlob(localBlob);
	if (gunner !is null)
	{
		if(gunner.name == "DRIVER")
		{
			drawFuelCount(blob);
		}
		else
		{
			renderAmmo(blob,false);
		}
	}

	Vec2f mouseWorld = getControls().getMouseWorldPos();
	bool mouseOnBlob = (mouseWorld - blob.getPosition()).getLength() < this.getBlob().getRadius();
	f32 fuel = blob.get_f32("fuel_count");
	if (fuel <= 0 && mouseOnBlob)
	{
		Vec2f pos = blob.getInterpolatedScreenPos();

		GUI::SetFont("menu");
		GUI::DrawTextCentered("Requires fuel!", Vec2f(pos.x, pos.y + 85 + Maths::Sin(getGameTime() / 5.0f) * 5.0f), SColor(255, 255, 55, 55));
		GUI::DrawTextCentered("(Oil or Fuel)", Vec2f(pos.x, pos.y + 105 + Maths::Sin(getGameTime() / 5.0f) * 5.0f), SColor(255, 255, 55, 55));
	}

	AttachmentPoint@ pilot = blob.getAttachments().getAttachmentPointByName("DRIVER");
	if (pilot !is null && pilot.getOccupied() !is null)
	{
		CBlob@ driver_blob = pilot.getOccupied();
		if (driver_blob.isMyPlayer())
		{
			u8 mode = blob.get_u8("mode");
			if (mode == 0) return; // disabled

			f32 screenWidth = getScreenWidth();
			f32 screenHeight = getScreenHeight();

			//Vec2f oldpos2d = getDriver().getScreenPosFromWorldPos(driver_blob.getOldPosition());
			//Vec2f pos2d = oldpos2d;

			Vec2f oldpos = driver_blob.getOldPosition();
			Vec2f pos = driver_blob.getPosition();
			Vec2f pos2d = getDriver().getScreenPosFromWorldPos(Vec2f_lerp(oldpos, pos, getInterpolationFactor())) - Vec2f(0 , 0);

			Vec2f force = blob.get_Vec2f("target_force")*64+Vec2f(0, 36);	
			Vec2f offset = pos2d;

			if (mode == 1) // leftside square
			{
				offset = Vec2f(50, screenHeight*0.5f); // fixed pos
				Vec2f pane_size = Vec2f(40.0f, 40.0f);
				GUI::DrawPane(offset-pane_size, offset+pane_size, SColor(100, 0, 0, 0));
				GUI::DrawTextCentered("CTRL", offset+Vec2f(-28, screenHeight*0.05f), SColor(100, 0, 0, 0));
			}

			SColor color;
			if (force.y < 0) color = SColor(255, 55, 255, 55); // up
			else color = color = SColor(255, 215, 155, 15);

			if (mode == 2) // outlines
			{
				force = force*1.75f;
				GUI::DrawLine2D(offset+Vec2f(2,1), offset+Vec2f(force.x, force.y > 0 ? force.y : force.y * 4.0f)+Vec2f(2,-1), SColor(255, 255, 255, 255));
				GUI::DrawLine2D(offset+Vec2f(-2,1), offset+Vec2f(force.x, force.y > 0 ? force.y : force.y * 4.0f)+Vec2f(-2,-1), SColor(255, 255, 255, 255));
			}

			GUI::DrawLine2D(offset, offset+Vec2f(force.x, force.y > 0 ? force.y : force.y * 4.0f), color);
			GUI::DrawLine2D(offset+Vec2f(1,0), offset+Vec2f(force.x, force.y > 0 ? force.y : force.y * 4.0f)+Vec2f(1,0), color);
			GUI::DrawLine2D(offset+Vec2f(-1,0), offset+Vec2f(force.x, force.y > 0 ? force.y : force.y * 4.0f)+Vec2f(-1,0), color);
		}
	}
}

const f32 fuel_factor = 100.00f;

void renderAmmo(CBlob@ blob, bool rocket)
{
	Vec2f pos2d1 = blob.getInterpolatedScreenPos() - Vec2f(0, 10);

	Vec2f pos2d = blob.getInterpolatedScreenPos() - Vec2f(0, 60);
	Vec2f dim = Vec2f(20, 8);
	const f32 y = blob.getHeight() * 2.4f;
	f32 charge_percent = 1.0f;

	Vec2f ul = Vec2f(pos2d.x - dim.x, pos2d.y + y);
	Vec2f lr = Vec2f(pos2d.x - dim.x + charge_percent * 2.0f * dim.x, pos2d.y + y + dim.y);

	if (blob.isFacingLeft())
	{
		ul -= Vec2f(8, 0);
		lr -= Vec2f(8, 0);

		f32 max_dist = ul.x - lr.x;
		ul.x += max_dist + dim.x * 2.0f;
		lr.x += max_dist + dim.x * 2.0f;
	}

	f32 dist = lr.x - ul.x;
	Vec2f upperleft((ul.x + (dist / 2.0f)) - 5.0f + 4.0f, pos2d1.y + blob.getHeight() + 30);
	Vec2f lowerright((ul.x + (dist / 2.0f))  + 5.0f + 4.0f, upperleft.y + 20);

	//GUI::DrawRectangle(upperleft - Vec2f(0,20), lowerright , SColor(255,0,0,255));

	u16 ammo = rocket ? blob.get_u16("rocketCount") : blob.get_u16("ammoCount");

	string reqsText = "" + ammo;

	u8 numDigits = reqsText.size();

	upperleft -= Vec2f((float(numDigits) * 4.0f), 0);
	lowerright += Vec2f((float(numDigits) * 4.0f), 0);

	GUI::DrawRectangle(upperleft, lowerright);
	GUI::SetFont("menu");
	GUI::DrawText(reqsText, upperleft + Vec2f(2, 1), color_white);
}

bool Vehicle_canFire(CBlob@ this, VehicleInfo@ v, bool isActionPressed, bool wasActionPressed, u8 &out chargeValue) {return false;}

void Vehicle_onFire(CBlob@ this, VehicleInfo@ v, CBlob@ bullet, const u8 _charge) {}