"use strict";
const functions = require('firebase-functions');
const webhoseio = require('webhoseio');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
// [END import]

exports.followUp = functions.https.onRequest((req, res) => {
  //getContacts is a promise, thus non-blocking
  getContacts();
  res.end();
});

/**
This function returns a promise
*/
function getContacts(){
	return admin.database().ref('/topics').once('value', function(topics) {
  		topics.forEach(function(topic) {
		    console.log("topic: " + topic.key);
		    var users = [];
		    topic.forEach(function(user) {
		    	users.push(user.key);
		    })
		    console.log("users: " + users);
    	});
	});
}

