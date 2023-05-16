
Parse.Cloud.afterDelete("Clinic", async (req) => {
  let curObj = req.object;

  {
    //Apagar Clinic de Schedule. SearchType3
    //console.log(`afterDelete Clinic: ${curObj.id}`);
  
    const query = new Parse.Query("Schedule");
    query.equalTo("clinic", curObj);
    
    const otherObjResults = await query.find();
    if (otherObjResults.length !== 0) {
      for (let i = 0; i < otherObjResults.length; i++) {
        const result = otherObjResults[i];
        //console.log(`afterDelete Clinic ${curObj.id}. Delete Schedule: ${result.id}`);
        await result.destroy({ useMasterKey: true });
      }
    }
  }
  {
    //Apagar Clinic de CyclePlanning. SearchType3
    //console.log(`afterDelete Clinic: ${curObj.id}`);
  
    const query = new Parse.Query("CyclePlanning");
    query.equalTo("clinic", curObj);
    
    const otherObjResults = await query.find();
    if (otherObjResults.length !== 0) {
      for (let i = 0; i < otherObjResults.length; i++) {
        const result = otherObjResults[i];
        //console.log(`afterDelete Clinic ${curObj.id}. Delete CyclePlanning: ${result.id}`);
        await result.destroy({ useMasterKey: true });
      }
    }
  }
});
