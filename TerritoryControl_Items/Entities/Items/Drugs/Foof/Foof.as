void onInit(CBlob@ this)
{
	this.getShape().SetRotationsAllowed(true);
	this.addCommandID("consume");
	this.Tag("hopperable");
	this.Tag("dartguninjectable");
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (this.getDistanceTo(caller) > 96.0f) return;
	if (getGameTime() <= this.get_u32("button_delay")) return;
	this.set_u32("button_delay", getGameTime()+5);
	
	CBitStream params;
	params.write_u16(caller.getNetworkID());
	caller.CreateGenericButton(22, Vec2f(0, 0), this, this.getCommandID("consume"), "Eat!", params);
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("consume"))
	{
		if (getGameTime() < this.get_u32("consume_delay")) return;
		this.set_u32("consume_delay", getGameTime()+2);
		// this.getSprite().PlaySound("Huuu.ogg", 1.0f, 1.5f);
		this.getSprite().PlaySound("Eat.ogg", 1.00f, 1.00f);

		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller !is null)
		{		
			if (!caller.hasScript("Foofed.as")) caller.AddScript("Foofed.as");
			// if (!caller.exists("foof_original_radius")) 
			// {
				// CShape@ shape = caller.getShape();
				// if (shape !is null)
				// {
					// ShapeConsts@ consts = shape.getConsts();
					// if (consts !is null)
					// {
						// caller.set_f32("foof_original_radius", consts.radius);
					// }
				// }
			// }
			
			caller.add_f32("foofed", 1);

			if (isServer())
			{
				this.server_Die();
			}
		}
	}
}
