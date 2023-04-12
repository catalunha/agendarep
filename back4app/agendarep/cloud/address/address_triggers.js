
Parse.Cloud.afterDelete("Address", async (req) => {
  let curObj = req.object;

  {
    //Unset Address de Clinic. SearchType4
    //console.log(`afterDelete Address: ${curObj.id}`);
  
    const query = new Parse.Query("Clinic");
    query.equalTo("address", curObj);
    
    const otherObjResults = await query.find();
    if (otherObjResults.length !== 0) {
      for (let i = 0; i < otherObjResults.length; i++) {
        const result = otherObjResults[i];
        //console.log(`afterDelete Address ${curObj.id}. Unset address in Clinic: ${result.id}`);
        result.unset('address');
        await result.save(null, { useMasterKey: true });
      }
    }
  }
  
});
