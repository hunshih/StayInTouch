"use strict";
const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
// [END import]

// [START addMessage]
// Take the text parameter passed to this HTTP endpoint and insert it into the
// Realtime Database under the path /messages/:pushId/original
// [START addMessageTrigger]
exports.addMessage = functions.https.onRequest((req, res) => {
// [END addMessageTrigger]
  // Grab the text parameter.
  const original = req.query.text;
  // Push it into the Realtime Database then send a response
  admin.database().ref('/messages').push({original: original}).then(snapshot => {
    // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
    //res.redirect(303, snapshot.ref);
    console.log("event triggered");
    res.end();
  });
});
// [END addMessage]

// [START makeUppercase]
// Listens for new messages added to /messages/:pushId/original and creates an
// uppercase version of the message to /messages/:pushId/uppercase
// [START makeUppercaseTrigger]
exports.makeUppercase = functions.database.ref('/messages/{pushId}/original')
    .onWrite(event => {
// [END makeUppercaseTrigger]
      // [START makeUppercaseBody]
      // Grab the current value of what was written to the Realtime Database.
      const original = event.data.val();
      console.log('Uppercasing', event.params.pushId, original);
      const uppercase = original.toUpperCase();
      // You must return a Promise when performing asynchronous tasks inside a Functions such as
      // writing to the Firebase Realtime Database.
      // Setting an "uppercase" sibling in the Realtime Database returns a Promise.
      return event.data.ref.parent.child('uppercase').set(uppercase);
      // [END makeUppercaseBody]
    });
// [END makeUppercase]
// [END all]

exports.followUp = functions.https.onRequest((req, res) => {
  //getContacts is a promise, thus non-blocking
  getContacts();
  res.end();
});

/**
This function returns a promise
*/
function getContacts(){
	return admin.database().ref('/last_contacted').once('value', function(snapshot) {
  		snapshot.forEach(function(childSnapshot) {
		    //var childKey = childSnapshot.key;
		    //var childData = childSnapshot.val();
    		var day = childSnapshot.val().day;
    		var month = childSnapshot.val().month;
    		var year = childSnapshot.val().year;
    		var timestamp = childSnapshot.val().timestamp;
    		console.log("id: " + childSnapshot.key);
    		console.log("day: " + day + ", month: " + month + ", year: " + year + ", timestamp: " + timestamp);
  		});
	});
}

