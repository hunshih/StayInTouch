"use strict";
const functions = require('firebase-functions');
const webhoseio = require('webhoseio');
const webhoseClient = webhoseio.config({token: '29d2b0fb-fed2-4113-9d4e-f2021f774cd7'});

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
            searchArticles(topic.key);
            var users = [];
            topic.forEach(function(user) {
                users.push(user.key);
            })
            console.log("users: " + users);
        });
    });
}
    
/**
* Make call to webhose to search articles
*/
function searchArticles(topic) {
    var query = '\"' + topic + '\" language:(english) performance_score:>6 (site_type:news OR site_type:blogs)';
    webhoseClient.query('filterWebData', {q: query})
      .then(output => {
        console.log("posts length: " + output['posts'].length);
        if(output['posts'].length > 0)
        {
            console.log("from: " + output['posts'][0]['thread']['site'])
            console.log("url: " + output['posts'][0]['thread']['url']); // Print the text of the first post
            console.log("title: " + output['posts'][0]['title']); // Print the text of the first post   
        }
    });
}