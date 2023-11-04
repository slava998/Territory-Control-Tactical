// Storage.as

void onInit(CSprite@ this)
{
	// Building
	this.SetZ(-60); //-60 instead of -50 so sprite layers are behind ladders

	// Stone
	CSpriteLayer@ stone = this.addSpriteLayer("mat_stone", "StorageLayers.png", 24, 16);
	if (stone !is null)
	{
		{
			stone.addAnimation("default", 0, false);
			int[] frames = { 0, 5, 10 };
			stone.animation.AddFrames(frames);
		}
		stone.SetOffset(Vec2f(10.0f, -3.0f));
		stone.SetRelativeZ(1);
		stone.SetVisible(false);
	}

	// Wood
	CSpriteLayer@ wood = this.addSpriteLayer("mat_wood", "StorageLayers.png", 24, 16);
	if (wood !is null)
	{
		{
			wood.addAnimation("default", 0, false);
			int[] frames = { 1, 6, 11 };
			wood.animation.AddFrames(frames);
		}
		wood.SetOffset(Vec2f(-7.0f, -2.0f));
		wood.SetRelativeZ(1);
		wood.SetVisible(false);
	}

	// Gold
	CSpriteLayer@ gold = this.addSpriteLayer("mat_gold", "StorageLayers.png", 24, 16);
	if (gold !is null)
	{
		{
			gold.addAnimation("default", 0, false);
			int[] frames = { 2, 7, 12 };
			gold.animation.AddFrames(frames);
		}
		gold.SetOffset(Vec2f(-7.0f, -10.0f));
		gold.SetRelativeZ(1);
		gold.SetVisible(false);
	}

	// Bombs
	CSpriteLayer@ bombs = this.addSpriteLayer("mat_bombs", "StorageLayers.png", 24, 16);
	if (bombs !is null)
	{
		{
			bombs.addAnimation("default", 0, false);
			int[] frames = { 3, 8 };
			bombs.animation.AddFrames(frames);
		}
		bombs.SetOffset(Vec2f(-7.0f, 5.0f));
		bombs.SetRelativeZ(2);
		bombs.SetVisible(false);
	}

	// Rope
	CSpriteLayer@ rope = this.addSpriteLayer("rope", "StorageLayers.png", 24, 16);
	if (rope !is null)
	{
		{
			rope.addAnimation("default", 0, false);
			int[] frames = { 4 };
			rope.animation.AddFrames(frames);
		}
		rope.SetOffset(Vec2f(5.0f, -8.0f));
		rope.SetRelativeZ(2);
	}
}

void onInit(CBlob@ this)
{
	this.Tag("remote_storage");

	this.set_TileType("background tile", CMap::tile_castle_back);
	this.getShape().getConsts().mapCollisions = false;
	this.inventoryButtonPos = Vec2f(12, 0);
	//this.addCommandID("store inventory");
	this.getCurrentScript().tickFrequency = 60;

	//AddIconToken("$str$", "StoreAll.png", Vec2f(16, 16), 0);
	this.set_u16("capacity", 50);
	this.Tag("smart_storage");
	this.addCommandID("update_storagelayers");
}

/*void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	if (caller !is null)
	{
		if (this.getTeamNum() == caller.getTeamNum() && this.getDistanceTo(caller) <= 48)
		{
			CInventory @inv = caller.getInventory();
			if (inv !is null)
			{
				if (inv.getItemsCount() > 0)
				{
					CBitStream params;
					params.write_u16(caller.getNetworkID());
					caller.CreateGenericButton(28, Vec2f(-6, 0), this, this.getCommandID("sv_store"), "Store", params);
				}
			}
		}
	}
}*/

void onCommand(CBlob@ this, u8 cmd, CBitStream@ params)
{
	if (cmd == this.getCommandID("update_storagelayers"))
	{
		CBlob@ blob = getBlobByNetworkID(params.read_u16());
		if (this.get_u16("smart_storage_quantity") > 0)
		{
			if (isServer()) 
			{
				string blobName = blob.getName();
				u32 cur_quantity = this.get_u32("Storage_"+blobName);
				if (cur_quantity > 0)
				{
					updateLayers(this, blobName, cur_quantity);
				}
			}
		}
	}
	//Moved this to SmartStorageCore.as
	
	/*else if (cmd == this.getCommandID("store inventory"))
	{
		CBlob@ caller = getBlobByNetworkID(params.read_u16());
		if (caller !is null && isServer())
		{
			CInventory @inv = caller.getInventory();
			if (caller.getName() == "builder")
			{
				CBlob@ carried = caller.getCarriedBlob();
				if (carried !is null)
				{
					// TODO: find a better way to check and clear blocks + blob blocks || fix the fundamental problem, blob blocks not double checking requirement prior to placement.
					if (carried.hasTag("temp blob"))
					{
						carried.server_Die();
					}
				}
			}
			
			if (inv !is null)
			{
				while (inv.getItemsCount() > 0)
				{
					CBlob@ item = inv.getItem(0);
					if (!this.server_PutInInventory(item))
					{
						if (canPickup(this, item))
						{
							smartStorageAdd(this, item);
						}
						else caller.server_PutInInventory(item);
						
						break;
					}
				}
			}
		}
	}*/
}

void updateLayers(CBlob@ this, string blobName, u32 cur_quantity)
{
	CSprite@ sprite = this.getSprite();
	if (blobName == "mat_stone")
	{
		CSpriteLayer@ stone = sprite.getSpriteLayer("mat_stone");
		if (cur_quantity > 0)
		{
			if (cur_quantity >= 200)
			{
				stone.SetFrameIndex(2);
			}
			else if (cur_quantity >= 100)
			{
				stone.SetFrameIndex(1);
			}
			else
			{
				stone.SetFrameIndex(0);
			}
			stone.SetVisible(true);
		}
		else
		{
			stone.SetVisible(false);
		}
	}
	else if (blobName == "mat_wood")
	{
		CSpriteLayer@ wood = sprite.getSpriteLayer("mat_wood");
		if (cur_quantity > 0)
		{
			if (cur_quantity >= 200)
			{
				wood.SetFrameIndex(2);
			}
			else if (cur_quantity >= 100)
			{
				wood.SetFrameIndex(1);
			}
			else
			{
				wood.SetFrameIndex(0);
			}
			wood.SetVisible(true);
		}
		else
		{
			wood.SetVisible(false);
		}
	}
	else if (blobName == "mat_goldingot")
	{
		CSpriteLayer@ gold = sprite.getSpriteLayer("mat_gold");
		if (cur_quantity > 0)
		{
			if (cur_quantity >= 200)
			{
				gold.SetFrameIndex(2);
			}
			else if (cur_quantity >= 100)
			{
				gold.SetFrameIndex(1);
			}
			else
			{
				gold.SetFrameIndex(0);
			}
			gold.SetVisible(true);
		}
		else
		{
			gold.SetVisible(false);
		}
	}
}

bool isInventoryAccessible(CBlob@ this, CBlob@ forBlob)
{
	return ((this.getTeamNum() > 100 ? true : forBlob.getTeamNum() == this.getTeamNum()) && forBlob.isOverlapping(this));
}

//Moved this to SmartStorageCore.as

/*void onCreateInventoryMenu(CBlob@ this, CBlob@ forBlob, CGridMenu@ gridmenu)
{
	if (forBlob is null) return;
	if (forBlob.getControls() is null) return;
	//CInventory@ inv = forBlob.getInventory();
	//CInventory@ tinv = this.getInventory();
	//if (inv is null || tinv is null) return;
	//if (inv.getItemsCount() == 0) return;
//
	//bool is_full = true;
	//Vec2f slots = tinv.getInventorySlots();
	//for (u16 i = 0; i < slots.x*slots.y; i++)
	//{
	//	if (tinv.getItem(i) is null) is_full = false;
	//}
	//if (is_full) return;
	Vec2f mscpos = forBlob.getControls().getMouseScreenPos(); 
	Vec2f MENU_POS = mscpos+Vec2f(-160,-72);
	CGridMenu@ sv = CreateGridMenu(MENU_POS, this, Vec2f(1, 1), "Store ");
	
	CBitStream params;
	params.write_u16(forBlob.getNetworkID());
	CGridButton@ store = sv.AddButton("$str$", "Store ", this.getCommandID("store inventory"), Vec2f(1, 1), params);
}*/