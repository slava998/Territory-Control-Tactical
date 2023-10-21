#define SERVER_ONLY

void onInit(CBlob@ this)
{
	this.getCurrentScript().removeIfTag = "dead";
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if (blob is null || blob.getShape().vellen > 1.0f)
	{
		return;
	}

	string blobName = blob.getName();
	CPlayer@ player = this.getPlayer();
	bool canPutInInventory = true;
	CRules@ rules = getRules();
	
	// if it's bot autopickup is always active
	if (player is null)
		canPutInInventory = true;
	else
		canPutInInventory = rules.get_bool(player.getUsername() + "autopickup");
	if (!canPutInInventory) return;
	
	if (blob.hasTag("archer pickup") && !blob.hasTag("no pickup"))
	{
		this.server_PutInInventory(blob);
	}

	// if (blobName == "mat_bombs" || (blobName == "satchel" && !blob.hasTag("exploding")) || blobName == "mat_waterbombs" || blobName == "mat_rifleammo" || blobName == "mat_pistolammo" || blobName == "mat_smallrocket" || blobName == "mat_shotgunammo")
	
	if (blob.hasTag("knight pickup") && !blob.hasTag("no pickup"))
	{
		this.server_PutInInventory(blob);
	}
}
