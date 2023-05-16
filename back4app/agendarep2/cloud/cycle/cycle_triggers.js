
Parse.Cloud.afterDelete("Cycle", async (req) => {
  let curObj = req.object;

  {
    //Delete Cycle de CyclePlanning. SearchType2
    console.log(`afterDelete Cycle: ${curObj.id}`);
  
    const query = new Parse.Query("CyclePlanning");
    query.equalTo("cycle", curObj);
    
    const otherObjResults = await query.find();
    if (otherObjResults.length !== 0) {
      for (let i = 0; i < otherObjResults.length; i++) {
        const result = otherObjResults[i];
        console.log(`afterDelete Cycle ${curObj.id}. Delete CyclePlanning: ${result.id}`);
        await result.destroy({ useMasterKey: true });
      }
    }
  }
  
});
