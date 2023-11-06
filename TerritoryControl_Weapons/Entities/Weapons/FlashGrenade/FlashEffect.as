 #include "Hitters.as";
#include "RunnerCommon.as";
#include "DeityCommon.as";

void onInit(CBlob@ this)
{
	this.getCurrentScript().tickFrequency = 1;
	
	if (this.hasTag("flashed")) this.getCurrentScript().runFlags |= Script::remove_after_this;
	this.Tag("flashed");
}

void onTick(CBlob@ this)
{
	u8 deity_id = this.get_u8("deity_id");
	CSprite@ sprite = this.getSprite();
	
	if (deity_id != Deity::leutnant || !this.hasTag("dead"))
	{		
		const int ticks = getGameTime() - this.get_u32("flash time");

		RunnerMoveVars@ moveVars;
		if (this.get("moveVars", @moveVars))
		{
			moveVars.walkFactor *= 0.80f;
			moveVars.jumpFactor *= 0.85f;
		}
		if (ticks % u32(300) == 0) 
		{
			//print("Nothing");
			this.RemoveScript("FlashEffect.as");
			sprite.RemoveScript("FlashEffect.as");
		}
	}
}

void onDie(CBlob@ this)
{
	this.RemoveScript("FlashEffect.as");
}

void onDie(CSprite@ this)
{
	this.RemoveScript("FlashEffect.as");
}

void onRender(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	u8 deity_id = blob.get_u8("deity_id");
	
	if (deity_id != Deity::leutnant || !blob.hasTag("dead"))
	{
		const int ticks = blob.get_u32("flash time");
		
		Driver@ driver = getDriver();
		Vec2f screenSize(driver.getScreenWidth(), driver.getScreenHeight());
		GUI::DrawRectangle(Vec2f(0, 0), screenSize, SColor(Maths::Clamp((ticks) / 3, 255, 255), 255, 255, 255));
	}
}