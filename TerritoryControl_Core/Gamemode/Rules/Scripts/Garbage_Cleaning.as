#define SERVER_ONLY

void onTick(CRules@ this)
{
    if (getGameTime() % 18000 == 0) //Once per 10 minutes
    {
		print("Doing cleaning...");
			
		CBlob@[] blobs;
		getBlobsByTag("RemoveOnCleaning", @blobs);
	
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			if(blob.getTickSinceCreated() > 5400 && blob.isOnGround() && !blob.isInInventory() && blob !is null) //Remove if blob exists for over 3 minutes, lies on ground and not in inventory
			{
				print("Removing Blob " + blob.getName());
				blob.server_Die();
			}
		}
	}
}