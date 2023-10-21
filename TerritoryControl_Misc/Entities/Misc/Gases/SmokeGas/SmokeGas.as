void onInit(CBlob@ this)
{
	this.Tag("smoke");
	this.Tag("gas");

	this.getShape().SetGravityScale(0.00f);

	this.getSprite().SetZ(10.0f);

	this.SetMapEdgeFlags(CBlob::map_collide_sides);
	this.getCurrentScript().tickFrequency = 10;

	this.getSprite().RotateBy(90 * XORRandom(4), Vec2f());
	
	this.server_SetTimeToDie(20);
}

void onTick(CBlob@ this)
{
	if (isServer() && this.getPosition().y < 0) this.server_Die();

	MakeParticle(this);
}

void MakeParticle(CBlob@ this, const string filename = "GrenadeSmoke")
{
	if (!isClient() && !this.isOnScreen()) return;

	//ParticleAnimated(filename, this.getPosition() + Vec2f(XORRandom(200) / 10.0f - 10.0f, XORRandom(200) / 10.0f - 10.0f), Vec2f(), float(XORRandom(360)), 2.0f + (XORRandom(50) / 100.0f), 3, 0.0f, false);
	ParticleAnimated(filename, this.getPosition(), Vec2f(0.0f, 0.0f), 0, 8.00f, 15, 0, false);
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{
   return blob.hasTag("smoke");
}
