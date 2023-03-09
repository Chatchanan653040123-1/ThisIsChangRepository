function getFirestore(){
  var email = "firebase-writer-account-2@kkupark-711e6.iam.gserviceaccount.com";
  var key = "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCltmd7wsfRQzq8\nhGDLQb9WsDOriz7YEaiG4TkJQDrrfTLRSDZvMQl+2gnjaNY/xY9UuWa4iiNXq5TI\nxK8WPay2MquIc1FJqWEu7A9vIt6AoKBdWm1UZt2ReSSaDJV+I4IY/DyYM2kuqUhg\nzpj4Z1BwaKGmi/33yUY3IQHZxD5TJDXvOGfmhviXd56jBwVajCl6vFSPo2gtOaNT\nsyXb8GouRaQrQTOG3BO8etoyP5E0I+5JpoXgA87CtskGwyumDBlxU+5kJVEU3wIc\nAqpBplX1mPcWRfWqfTQoceIPEK7SNYuy4h/8dKttRfB5DC1Wo16k3K/02iJhsff5\nVO+ZBecrAgMBAAECggEAK9jo5uFyN9ffKdSpO/8Inup+sYxls4xwmEft7Jm3PWpi\nUOgXpzJFffA5n5e04SjoNRXdrUS391GqS7lnTq5BDfC4XKGOx7vuwBisOM70KvrV\nk/4CYcvaIsz4N17PC5JfsTbE3cz0rukSArOH3GqR6Tx2UXhHWhJC5wFv2OxJRXwp\nXKfISRkwXUFLsrD7jsHqgMqktJwDkGLlN2yy7CIq+k98gc1MMa9hYN7kPbLUNDf4\nAx/1F3Va/acI55xtlo7AamZ8BJyN6UsAgBE28g2WsFCurzodYhbbQ/MCnTAuoaRr\nEE7rFMy2njq09HuAukBEcArI6/Yje75ckA0bqotZAQKBgQDPovh7J6mitpMXOyhU\nXQF2OM7vcA3nmnfdkMH9DJWn6GeBAMFPNMjpBSEOL9VK0wUn5HTeB9L+SiUw3dRu\nM7GExZSlFL00j0Owm8XxdZ/BEpiBXLZzWleMf5S5QnmHWf7gmdH4e/j1rJxiWuQy\nvqLDbkqoWs7XWOo7VvWYuHkNqwKBgQDMT5G2BaFGIohdt1AM6+xDWIbgH1oYNbcx\nigw+bM/p/gaLqrs1XjsZWgCRypipJ+mFw0bwtQErIOwU3Zu9vf4ub9s9oafwB4UP\nK8x7GYWiGcujkHqcXcE4EjxqLiU342egNQJYbf0ViKmgUUIEZlsAvxe03ExYg66X\naVHG0CYMgQKBgHbqoWD3QEI+SlO9v8VBVvr8YhfjlzMT1p6Ar3lb4cI+ajkJ06yn\nUIGUPHBBmOi3nnZQc1ZOKNsWX+JyyZ0r4flmp1E8ZXharKvTKzS05v/OxKUiEiRS\nk12WG/lWRv/r3PuJXSXw6o7Zgt8ZqyQc5l8DJaLyDxBqjgvaK+KBlGLtAoGBAI2v\nAFVCQjzo5bhXz2OmmAl78syp8Uiot4nbOfJwcx7J0rA4jerMlh9Wkt6HqKZlz0O7\n0A5M96p5Aj7WD5Ldls+NMnTjDhsem9+ReBRF9q4bRWUAZIbbXYsM2min55eCU/J9\n0EqSu9ebFkbfEvEKKkGyQzZhL3CSoRjPKK6+2iQBAoGASJgioULNEPvaexFpBMmx\nmngZ676DdhW7QKIJFdy76fGkE+BmnZv2mQ/gAqxjbfU4Mg7cYwaYAx5/LoAy6Uj7\nuXVSIlHIKJUZW7AgMSAVfUApzeRYjOtH4L9OjQu9R33lPc++Y8jrWIBmRIUncIle\n1vdoOaFeqHfA8BfjhyGL3BY=\n-----END PRIVATE KEY-----\n";
  var projectId = "kkupark-711e6";
  return FirestoreApp.getFirestore(email,key,projectId);
}
function myFunction() {
  car();
  moto();
}
function car(){
  const firestore = getFirestore();
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var sheetname = "KKUPARKCAR";
  var sheet = ss.getSheetByName(sheetname);
  var lastRow = sheet.getLastRow();
  var lastCol = sheet.getMaxColumns();
  var dataSR = 2;
  var sheetRange = sheet.getRange(2,1,lastRow-dataSR+1,lastCol);
  var sheetData = sheetRange.getValues();
  var parkPlaces = [];

  for (var i=0; i<sheetData.length; i++) {
    if (sheetData[i][0] !== '') {
      var placeParking = {
        Latitude: sheetData[i][0],
        Longitude: sheetData[i][1],
        placeID: sheetData[i][2],
        status : sheetData[i][3]
      };
      parkPlaces.push(placeParking);
      Logger.log(placeParking);
    }
  }

  if (parkPlaces.length > 0) {
    var data = {
      placeParking: parkPlaces
    };
    firestore.createDocument("parkPlace/car", data);
  }
}
function moto(){
  const firestore = getFirestore();
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var sheetname = "KKUPARKMOTO";
  var sheet = ss.getSheetByName(sheetname);
  var lastRow = sheet.getLastRow();
  var lastCol = sheet.getMaxColumns();
  var dataSR = 2;
  var sheetRange = sheet.getRange(2,1,lastRow-dataSR+1,lastCol);
  var sheetData = sheetRange.getValues();
  var parkPlaces = [];

  for (var i=0; i<sheetData.length; i++) {
    if (sheetData[i][0] !== '') {
      var placeParking = {
        Latitude: sheetData[i][0],
        Longitude: sheetData[i][1],
        placeID: sheetData[i][2],
        status : sheetData[i][3]
      };
      parkPlaces.push(placeParking);
      Logger.log(placeParking);
    }
  }

  if (parkPlaces.length > 0) {
    var data = {
      placeParking: parkPlaces
    };
    firestore.createDocument("parkPlace/motorcycle", data);
  }
}



