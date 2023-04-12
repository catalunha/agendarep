
Parse.Cloud.afterSave(Parse.User, async (req) => {
  let user = req.object;
  // //console.log(`afterSave User with ${user.email}. Create userProfile.`);

  if (user.get('userProfile') === undefined) {
    const userProfile = new Parse.Object("UserProfile");
    userProfile.set('email', user.get('email'));
    let userProfileResult = await userProfile.save(null, { useMasterKey: true });
    user.set('userProfile', userProfileResult);
    await user.save(null, { useMasterKey: true });
  }
});

Parse.Cloud.afterDelete(Parse.User, async (req) => {
  let user = req.object;
  //Apagar user de UserProfile
  //console.log(`afterDelete user ${user.id}`);
  let userProfileId = user.get('userProfile').id;
  //console.log(`deleting userProfile ${userProfileId}`);
  const userProfile = new Parse.Object("UserProfile");
  userProfile.id = userProfileId;
  await userProfile.destroy({ useMasterKey: true });

  {
    //Apagar UserProfile de Medical. SearchType2
    const query = new Parse.Query("Medical");
    query.equalTo("seller", userProfile);
    const otherObjResults = await query.find();
    if (otherObjResults.length !== 0) {
      for (let i = 0; i < otherObjResults.length; i++) {
        const result = otherObjResults[i];
        await result.destroy({ useMasterKey: true });
      }
    }
  }
  {
    //Apagar UserProfile de Secretary. SearchType2
    const query = new Parse.Query("Secretary");
    query.equalTo("seller", userProfile);
    const otherObjResults = await query.find();
    if (otherObjResults.length !== 0) {
      for (let i = 0; i < otherObjResults.length; i++) {
        const result = otherObjResults[i];
        await result.destroy({ useMasterKey: true });
      }
    }
  }
  {
    //Apagar UserProfile de Clinic. SearchType2
    const query = new Parse.Query("Clinic");
    query.equalTo("seller", userProfile);
    const otherObjResults = await query.find();
    if (otherObjResults.length !== 0) {
      for (let i = 0; i < otherObjResults.length; i++) {
        const result = otherObjResults[i];
        await result.destroy({ useMasterKey: true });
      }
    }
  }
  {
    //Apagar UserProfile de Schedule. SearchType2
    const query = new Parse.Query("Schedule");
    query.equalTo("seller", userProfile);
    const otherObjResults = await query.find();
    if (otherObjResults.length !== 0) {
      for (let i = 0; i < otherObjResults.length; i++) {
        const result = otherObjResults[i];
        await result.destroy({ useMasterKey: true });
      }
    }
  }
  {
    //Apagar UserProfile de Cycle. SearchType2
    const query = new Parse.Query("Cycle");
    query.equalTo("seller", userProfile);
    const otherObjResults = await query.find();
    if (otherObjResults.length !== 0) {
      for (let i = 0; i < otherObjResults.length; i++) {
        const result = otherObjResults[i];
        await result.destroy({ useMasterKey: true });
      }
    }
  }
  {
    //Apagar UserProfile de CyclePlanning. SearchType2
    const query = new Parse.Query("CyclePlanning");
    query.equalTo("seller", userProfile);
    const otherObjResults = await query.find();
    if (otherObjResults.length !== 0) {
      for (let i = 0; i < otherObjResults.length; i++) {
        const result = otherObjResults[i];
        await result.destroy({ useMasterKey: true });
      }
    }
  }
  {
    //Apagar UserProfile de Address. SearchType2
    const query = new Parse.Query("Address");
    query.equalTo("seller", userProfile);
    const otherObjResults = await query.find();
    if (otherObjResults.length !== 0) {
      for (let i = 0; i < otherObjResults.length; i++) {
        const result = otherObjResults[i];
        await result.destroy({ useMasterKey: true });
      }
    }
  }
  {
    //Apagar UserProfile de Region. SearchType2
    const query = new Parse.Query("Region");
    query.equalTo("seller", userProfile);
    const otherObjResults = await query.find();
    if (otherObjResults.length !== 0) {
      for (let i = 0; i < otherObjResults.length; i++) {
        const result = otherObjResults[i];
        await result.destroy({ useMasterKey: true });
      }
    }
  }
});
