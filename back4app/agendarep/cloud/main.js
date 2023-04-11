require('./user/user_triggers.js');

// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", (request) => {
	return "Hello world!";
});

/*
Parse.Cloud.afterDelete("Table1", async (req) => {
  let curObj = req.object;
  console.log(`afterDelete Table1: ${curObj.id}`);
  let otherId = curObj.get('table2').id;
  console.log(`deleting Other: ${otherId}`);
  const otherObj = new Parse.Object("Table2");
  otherObj.id = otherId;
  await otherObj.destroy({ useMasterKey: true });
});
*/

/*
Parse.Cloud.afterDelete("Table1", async (req) => {
  let curObj = req.object;
  console.log(`afterDelete Table1: ${curObj.id}`);
  
  const query = new Parse.Query("Table2");
  query.equalTo("table1", curObj);
  
  const otherObjResults = await query.find();
  if (otherObjResults.length !== 0) {
    for (let i = 0; i < otherObjResults.length; i++) {
      const result = otherObjResults[i];
      await result.destroy({ useMasterKey: true });
    }
  }
});
*/
/*
Parse.Cloud.afterDelete("Table1", async (req) => {
  let curObj = req.object;
  console.log(`afterDelete Table1: ${curObj.id}`);
  
  const query = new Parse.Query("Table2");
  query.equalTo("table1Rel", curObj);

  const otherObjResults = await query.find();
  if (otherObjResults.length !== 0) {
    for (let i = 0; i < otherObjResults.length; i++) {
      const result = otherObjResults[i];
      console.log(`achei: ${result.id}`);
      const relation = result.relation("table1Rel");
      relation.remove(curObj);
      await result.save(null, { useMasterKey: true });
    }
  }
});
*/