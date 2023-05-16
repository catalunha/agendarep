
Parse.Cloud.afterDelete("Medical", async (req) => {
  let curObj = req.object;

  {
    //Apagar Medicals de Clinic. SearchType2
    const query = new Parse.Query("Clinic");
    query.equalTo("medical", curObj);
    const otherObjResults = await query.find();
    if (otherObjResults.length !== 0) {
      for (let i = 0; i < otherObjResults.length; i++) {
        const result = otherObjResults[i];
        await result.destroy({ useMasterKey: true });
      }
    }
  }
  {
    //Apagar Medicals de Schedule. SearchType2
    const query = new Parse.Query("Schedule");
    query.equalTo("medical", curObj);
    const otherObjResults = await query.find();
    if (otherObjResults.length !== 0) {
      for (let i = 0; i < otherObjResults.length; i++) {
        const result = otherObjResults[i];
        await result.destroy({ useMasterKey: true });
      }
    }
  }
  {
    //Apagar Medicals de CyclePlanning. SearchType2
    const query = new Parse.Query("CyclePlanning");
    query.equalTo("medical", curObj);
    const otherObjResults = await query.find();
    if (otherObjResults.length !== 0) {
      for (let i = 0; i < otherObjResults.length; i++) {
        const result = otherObjResults[i];
        await result.destroy({ useMasterKey: true });
      }
    }
  }
});
