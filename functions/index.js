"use strict";
const functions = require('firebase-functions');
const request = require('request');
const secureCompare = require('secure-compare');
const admin = require('firebase-admin');
const https = require('https');
const querystring = require('querystring');
admin.initializeApp(functions.config().firebase);
// [END import]

//Global Variable
var allTopics = new Map();

exports.followUp = functions.https.onRequest((req, res) => {
  //check the API key
  const key = req.query.key;

  // Exit if the keys don't match
  if (!secureCompare(key, functions.config().cron.key)) {
    console.log('The key provided in the request does not match the key set in the environment. Check that', key,
        'matches the cron.key attribute in `firebase env:get`');
    res.status(403).send('Security key does not match. Make sure your "key" URL query parameter matches the ' +
        'cron.key environment variable.');
    return;
  }  

  //getContacts is a promise, thus non-blocking
  var articles;
  var articleSearchPromises = [];
  var promise = getAllTopics();
  promise
  .then(
  	function(topics){
  		articles = getArticles(topics);
  	})
  .then(
  	function(){
  		console.log(articles);
  		articles.forEach(function(topic)
  		{
  			articleSearchPromises.push(searchArticles(topic));
  		})
  	})
  .then(articleSearchPromises)
  .then(
  	function(){
  		console.log("map size: " + allTopics.size);
  });
  res.end();
});

/**
This function returns a promise
*/
function getAllTopics(){
    return admin.database().ref('/topics').once('value');
}

function getArticles(topics){
	var result = [];
	topics.forEach(function(topic) {
		//console.log("topic: " + topic.key);
		result.push(topic.key);
	})
	return result;
}
/*
    , function(topics) {

        topics.forEach(function(topic) {
            //console.log("topic: " + topic.key);
            /*var guardianData = searchArticles(topic.key);
            console.log("status: " + guardianData["status"]);
            console.log("total: " + guardianData["total"]);
            var users = [];
            topic.forEach(function(user) {
                users.push(user.key);
            })
            
            //console.log("users: " + users);
            //Find device of those users
            //getDevices(users);
            //deliver to those devices
            users = [];
        });

    });
}
*/
    
/**
* Make call to webhose to search articles
*/
function searchArticles(topic) {
	
	var key = '52de3693-c644-4ba0-a6be-9e8e78f74806';
    var query_path = '/search?api-key=' + key + '&q=' + querystring.escape(topic);
    var options = {
        host :  'content.guardianapis.com',
        port : 443,
        path : query_path,
        method : 'GET'
    }
    console.log('path: ' + query_path);

    //making the https get call
    var getReq = https.request(options, function(res) {
        //console.log("\nstatus code: ", res.statusCode);
        res.on('data', function(data) {
            var data = JSON.parse(data);
            var articleResult = new Map();
            articleResult.set("title", data.response.results[0].webTitle);
            articleResult.set("url", data.response.results[0].webUrl);
        	allTopics.set(topic, articleResult);
        	console.log("size: " + allTopics.size);
        });
    });
 
    //end the request
    getReq.end();
    getReq.on('error', function(err){
        console.log("Error: ", err);
    });
}

/**
* Get a list of devices with given users
*/
function getDevices(users) {
    //console.log("getting devices for: " + users);
    for (var i = 0; i < users.length; i++) {
        var ref = admin.database().ref("users/" + users[i] + "/devices/");
        ref.once("value", function(devices) {
            devices.forEach(function(device) {
                //console.log("device key: " + device.key + " | device value: " + device.val());
                sendMessageToUser(device.val(),'Share this article on Machine Learning with Yanjun');
            })
        });
    }

    //Add add unread notification to user DB
    addUnreadNotification(users);
}

/**
* Send Notification to a list of users
*/
function sendMessageToUser(deviceIds, message) {
    //console.log("sending notification to:" + deviceIds);
    request({
        url: 'https://fcm.googleapis.com/fcm/send',
        method: 'POST',
        headers: {
          'Content-Type' :' application/json',
          'Authorization': 'key=AAAAJh4i8mU:APA91bF1nMMWxv693VuJT7Yha-FLDQ8-7w9GEDxP_vsicVQ3u5KDXru-XBqiWtJnpGTjwUbfF6nA4SzLMhnIsaQl4PUZptDpt-ok2ZNmz7byo-xMj5hO5Tky_pN4b_BZFvMQQm4R8lHiUYyPosaVME-5pwLxHdrL7g'
        },
        body: JSON.stringify(
          { 
            "notification" : {
              "body" : message,
              "title" : "Follow-Up"
            },
            "to" : deviceIds,
            "priority" : "high"
          }
        )
        }, function(error, response, body) {
        if (error) { 
          console.error(error, response, body); 
        }
        else if (response.statusCode >= 400) { 
          console.error('HTTP Error: '+response.statusCode+' - '+response.statusMessage+'\n'+body); 
        }
        else {
          console.log('Done!')
        }
    });
}

/**
add notification to the unread list under user
*/
function addUnreadNotification(users)
{
  for (var i = 0; i < users.length; i++)
  {
     var ref = admin.database().ref("users/" + users[i] + "/unread/");
     ref.push().set({
            contact: "YJ's id",
            title: "Salesforce Use Machine Learning to summarize text",
            link: "https://www.theverge.com/2017/5/14/15637588/salesforce-algorithm-automatically-summarizes-text-machine-learning-ai",
            date: "2017/05/13"
          });
  }

}