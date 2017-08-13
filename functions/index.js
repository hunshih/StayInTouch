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

//record the topics subscribed by each user
var allUserSubscribe = new Map();

//All Users
var allUserNotification = new Map();

//Key: users
//Entry: unread notifications
var usersToUnread = new Map();

//Key: Contact ID
//Entry: Info of contact, aka name and email...etc
var contactIdInfo = new Map();

exports.followUp = functions.https.onRequest((req, res) => {

	//clear all global maps
	allTopics.clear();
	allUserSubscribe.clear();
	allUserNotification.clear();
	usersToUnread.clear();
	contactIdInfo.clear();

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
  var fillNotificationPromises = [];
  var promise = getAllTopics();
  promise
  .then(
  	function(topics){
  		articles = getArticles(topics);
  	})
  .then(
  	function(){
  		articles.forEach(function(topic)
  		{
  			articleSearchPromises.push(searchArticles(topic));
  		})
  	})
  .then(
  	function(){
  	return Promise.all(articleSearchPromises);
  })
  .then(
  	function(){
  		//printAllTopics();
  		//printAllUserSubscribe();
  		addUnreadNotification();
  	}
  ).then(
  	function(){
  		fillNotificationTable();
  	}
  ).then(
	function(){
		sendNotification();
	}
  );
  res.end();
});

/**
This function returns a promise
*/
function getAllTopics(){
    return admin.database().ref('/topics').once('value');
}

/**
* Make a copy of the topics list and modify the <user,topicList> map
*/
function getArticles(topics){
	var result = [];
	topics.forEach(function(topic) {
		result.push(topic.key);
		topic.forEach(function(user) {
				var userMap = new Map();
				if(allUserSubscribe.get(user.key) !== undefined)
				{
					userMap = allUserSubscribe.get(user.key);
				}
				var contacts = [];
				user.forEach(function(contact){
					var userInfo = new Map();
					userInfo.set("id", contact.key);
					userInfo.set("name",contact.val().name);
					userInfo.set("email", contact.val().email);
					contacts.push(userInfo);
					contactIdInfo.set(contact.key, userInfo);
				});
				userMap.set(topic.key, contacts);
				allUserSubscribe.set(user.key, userMap);
         })

	})
	return result;
}
    
/**
* Make call to webhose to search articles
*/
function searchArticles(topic) {

	return new Promise(
		function(resolve, reject){
			var key = '52de3693-c644-4ba0-a6be-9e8e78f74806';
		    var query_path = '/search?api-key=' + key + '&q=' + querystring.escape(topic);
		    var options = {
		        host :  'content.guardianapis.com',
		        port : 443,
		        path : query_path,
		        method : 'GET'
		    }

		    //making the https get call
		    var getReq = https.request(options, function(res) {
		        res.on('data', function(data) {
		            var data = JSON.parse(data);
		            var articleResult = new Map();
		            if(data.response.results.length > 0)
		            {
			            articleResult.set("title", data.response.results[0].webTitle);
			            articleResult.set("url", data.response.results[0].webUrl);
			            articleResult.set("source", "The Guardian");
			        	allTopics.set(topic, articleResult);
		        	}
		        	resolve(allTopics.size);
		        });
		    });
		 
		    //end the request
		    getReq.end();
		    getReq.on('error', function(err){
		        console.log("Error: ", err);
		    });
		}
	);
}

/**
* fill notification table
*/
function fillNotificationTable() {
	usersToUnread.forEach(function(notifications, user, mapObj){
		var notifCount = notifications.length;
		if( notifCount !== 0 )
		{
			var randomNum = getRandom(notifCount);
			allUserNotification.set(user, notifications[randomNum]);
		}
	});
}

function sendNotification(){
	allUserNotification.forEach(function(notification, user, mapObj){
		var ref = admin.database().ref("users/" + user + "/devices/");
        ref.once("value", function(devices) {
            devices.forEach(function(device) {
                sendMessageToUser(device.val(),notification);
            })
        });
	});
}

/**
* Send Notification to a user with content in "notification"
*/
function sendMessageToUser(deviceIds, notification) {
	var message = "Hey! We think " 
				  + notification.get("name")
				  + " will be interested in this article from "
				  + notification.get("source")
				  + " about "
				  + notification.get("tag")
				  + ", reach out now!";
	console.log("message: ", message);

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
              "title" : notification.get("title"),
              "sound": "default"
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
function addUnreadNotification()
{
	var todayDate = today();
	allUserSubscribe.forEach(function(item, key, mapObj){
		var ref = admin.database().ref("users/" + key + "/unread/");
		var contactToTopicListTable = pivotContactTable(item);
		var contactWithSelectedTopicList = [];
		contactWithSelectedTopicList = pickOneTopicForContact(contactToTopicListTable);
		usersToUnread.set(key,contactWithSelectedTopicList);
		for(var index in contactWithSelectedTopicList)
		{
			ref.push().set({
			            title: contactWithSelectedTopicList[index].get("title"),
			            link: contactWithSelectedTopicList[index].get("url"),
			            date: todayDate,
			            contactID: contactWithSelectedTopicList[index].get("id"),
			            contactName: contactWithSelectedTopicList[index].get("name"),
			            email: contactWithSelectedTopicList[index].get("email"),
			            tag: contactWithSelectedTopicList[index].get("tag"),
			            source: contactWithSelectedTopicList[index].get("source")
		        	});
		}
	});
}

/**
* get today's date in the form of mm/dd/yyyy
*/
function today()
{
	var today = new Date();
	var dd = today.getDate();
	var mm = today.getMonth()+1; //January is 0!
	var yyyy = today.getFullYear();

	if(dd<10) {
	    dd='0'+dd
	} 

	if(mm<10) {
	    mm='0'+mm
	} 

	today = mm+'/'+dd+'/'+yyyy;
	return today;
}

/**
* Print allUserSubscribe
*/
function printAllUserSubscribe(){
	allUserSubscribe.forEach(function(contactMap, user, mapObj){
		console.log("user: ", user);
		contactMap.forEach(function(contacts, topic, contactMapObj){
			console.log("topic: ", topic);
			console.log("contacts: ", contacts);
		});
	});
}

/**
* Print allTopics
*/
function printAllTopics(){
	allTopics.forEach(function(articleDetails, topic, mapObj){
		console.log("topic: ", topic);
		console.log("title: ", articleDetails.get("title"));
		console.log("url: ", articleDetails.get("url"));
	});
}

/**
* Print allNotification map
*/
function printAllNotification(){
	allUserNotification.forEach(function(notification, user, mapObj){
		console.log("user: ", user);
		console.log("title: ", notification.get("title"));
		console.log("name: ", notification.get("name"));		
	});
}

/**
* Get a random number between 0 and X (NOT inclusive)
*/
function getRandom(max){
	return Math.floor(Math.random() * max);
}

/**
* Get a random pair of topic and contactID
* [topic, name]
* [Big Data, henry]
*/
function getRandomTopicAndContact(user){
	var subscription = allUserSubscribe.get(user);
	var mapIter = subscription[Symbol.iterator]();
	var topicIndex = Math.max(getRandom(subscription.size), 0);
	var randomResult;
	for(var i = 0; i <= topicIndex; i++)
	{
		randomResult = mapIter.next().value;
	}
	var randomTopic = randomResult[0];
	var contactIndex = Math.max(getRandom(randomResult[1].length), 0);
	//randomresult is: |topic|[[id1,name1], [id2, name2]], thus 1/index/1 to get name
	var randomContact = randomResult[1][contactIndex].get("name");
	var result = [randomTopic, randomContact];
	return result;
}

/**
*Extract fields from given map to create a map key off user
*@param Map with key being topics, entry being a list of contact object (id, name, email)
*@return A Map with key being contact object, and entry being list of topics
*Reason to pivot: We only want to send user one article per contacts of his, instead of say
*				  5 articles for each contact. That's too much to catch up. The next step
*				  after this function call is to select topics for each contact by random
*/
function pivotContactTable(topicContactMap)
{
	var result = new Map();
	topicContactMap.forEach(function(contacts, topic, mapObj){
		for(var index in contacts)
		{
			var targetKey = contacts[index].get("id");
			var entry = result.get(targetKey);
			if(entry === undefined)
			{
				entry = [];
			}
			entry.push(topic);
			result.set(targetKey, entry);
		}
	});
	return result;
}

/** 
* Turn contactMap into an array of maps containing contact info and article details
* @param contactMap Map with key as contact object, which is a map with "id", "name", "email" fields
*							entry is a list of topics
* This function randomly select a topic from the topic list for user, as long as there are content
* available for such topic. Selected topic would be then added to the resulting contact info.
* If all topics from a user has no article avaiable, the contact will simply not be added to result list
*/ 
function pickOneTopicForContact(contactMap)
{
	var result = [];
	contactMap.forEach(function(topics, contact, mapObj){
		var contactInfo = new Map();
		//select a random topic in the list
		//copy contact info and link to contactInfo
		var triedIndex = new Set();
		for(var x = 0; x < topics.length; x++)
		{
			triedIndex.add(x);
		}
		var articleFound = false;
		while(triedIndex.size > 0)
		{
			var randomIndex = getRandom(triedIndex.size);
			var articleResult;
			var val;
			var count = 0;
			for (var it = triedIndex.values(), val= null; val=it.next().value; ) {
				if(count == randomIndex)
				{
					articleResult = allTopics.get(topics[val]);
					break;
				}
			    count++;
			}
			if(articleResult !== undefined)
			{
				articleFound = true;
				var contactDetails = contactIdInfo.get(contact);
				contactInfo.set("id", contactDetails.get("id"));
				contactInfo.set("name", contactDetails.get("name"));
				contactInfo.set("email", contactDetails.get("email"));
				contactInfo.set("title", articleResult.get("title"));
	            contactInfo.set("url", articleResult.get("url"));
	            contactInfo.set("source", articleResult.get("source"));
	            contactInfo.set("tag",topics[val]);
				break;
			}
			else
			{
				triedIndex.delete(val);
			}
		}
		if(articleFound)
		{
			result.push(contactInfo);
		}
	});
	return result;
}