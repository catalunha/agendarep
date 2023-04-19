require('./user/user_triggers.js');
require('./medical/medical_triggers.js');
require('./secretary/secretary_triggers.js');
require('./clinic/clinic_triggers.js');
require('./address/address_triggers.js');
require('./cycle/cycle_triggers.js');

// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", (request) => {
	return "Hello world!";
});

/*
//SearchType1: currentObject tem uma coluna com Pointer para otherObj. Remove otherObj
Parse.Cloud.afterDelete("Table1", async (req) => {
  let curObj = req.object;
  console.log(`afterDelete Table1: ${curObj.id}`);
  let otherId = curObj.get('table2').id;
  console.log(`deleting Table2: ${otherId}`);
  const otherObj = new Parse.Object("Table2");
  otherObj.id = otherId;
  await otherObj.destroy({ useMasterKey: true });
});
*/

/*
//SearchType2: currentObj é referenciado em otherObj via otherFieldPointer. Remove otherObj
Parse.Cloud.afterDelete("Table1", async (req) => {
  let curObj = req.object;
  console.log(`afterDelete Table1: ${curObj.id}`);
  
  const query = new Parse.Query("Table2");
  query.equalTo("table1", curObj);
  
  const otherObjResults = await query.find();
  if (otherObjResults.length !== 0) {
    for (let i = 0; i < otherObjResults.length; i++) {
      const result = otherObjResults[i];
      console.log(`afterDelete Clinic ${curObj.id}. Delete Schedule: ${result.id}`);
      await result.destroy({ useMasterKey: true });
    }
  }
});
*/
/*
//SearchType3: currentObj é referenciado em otherObj via otherFieldRelation. Remove otherObj
Parse.Cloud.afterDelete("Table1", async (req) => {
  let curObj = req.object;
  console.log(`afterDelete Table1: ${curObj.id}`);
  
  const query = new Parse.Query("Table2");
  query.equalTo("table1Rel", curObj);

  const otherObjResults = await query.find();
  if (otherObjResults.length !== 0) {
    for (let i = 0; i < otherObjResults.length; i++) {
      const result = otherObjResults[i];
      console.log(`afterDelete Table1 ${curObj.id}. Delete Table2: ${result.id}`);
      const relation = result.relation("table1Rel");
      relation.remove(curObj);
      await result.save(null, { useMasterKey: true });
    }
  }
});
*/
/*
//SearchType4: currentObj é referenciado em otherObj via otherFieldPointer. Unset otherFieldPointer
Parse.Cloud.afterDelete("Table1", async (req) => {
  let curObj = req.object;
  console.log(`afterDelete Table1: ${curObj.id}`);
  
  const query = new Parse.Query("Table2");
  query.equalTo("table1", curObj);
  
  const otherObjResults = await query.find();
  if (otherObjResults.length !== 0) {
    for (let i = 0; i < otherObjResults.length; i++) {
      const result = otherObjResults[i];
      console.log(`afterDelete Address ${curObj.id}. Unset address in Clinic: ${result.id}`);
      result.unset('table1');
      await result.save(null, { useMasterKey: true });
    }
  }
});
*/
/*

//SearchType5: currentObj referencia a otherObj via currentFieldRelation. Remove otherObj
Parse.Cloud.afterDelete("Table2", async (req) => {
  let curObj = req.object;
	console.log(`Table1> ${curObj.id}`);
	const table1Rel = curObj.relation("table1Rel");
	console.log('Table2>2');

  const query = await table1Rel.query();
	console.log('Table2>3');
	const otherObjResults = await query.find();
	console.log('Table2>3a');

  if (otherObjResults.length !== 0) {
		console.log('Table2>4');
    for (let i = 0; i < otherObjResults.length; i++) {
			console.log(`Table5> ${i} - ${curObj.id}`);

      const result = otherObjResults[i];
      await result.destroy({ useMasterKey: true });
    }
  }
});


*/