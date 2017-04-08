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
		    //var childData = topic.val();
		    console.log("topic: " + topic.key);
		    topic.forEach(function(user) {
		    	var user_id = user.key;
		    	var last_updated_date = user.val();
		    	var day = last_updated_date.day;
	    		var month = last_updated_date.month;
	    		var year = last_updated_date.year;
	    		var timestamp = last_updated_date.timestamp;
	    		console.log("day: " + day + ", month: " + month + ", year: " + year + ", timestamp: " + timestamp);
		    })
    	});
	});
}

