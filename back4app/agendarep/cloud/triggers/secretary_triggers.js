
Parse.Cloud.afterDelete("Secretary", async (req) => {
  let curObj = req.object;

  {
    //Apagar Secretary de Clinic. SearchType3
  const query = new Parse.Query("Clinic");
  query.equalTo("secretaries", curObj);

  const otherObjResults = await query.find();
  if (otherObjResults.length !== 0) {
    for (let i = 0; i < otherObjResults.length; i++) {
      const result = otherObjResults[i];
      //console.log(`afterDelete Secretary ${curObj.id}. Delete Clinic: ${result.id}`);
      const relation = result.relation("secretaries");
      relation.remove(curObj);
      await result.save(null, { useMasterKey: true });
    }
  }
  }
  
});
