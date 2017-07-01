# Notification Data Structure
To build notifications, I use multiple layers of hashmaps. They are used to manage Topics, User, Name, Email...and may important fields. This may not be the optimal design, but I'm trying to strike the balance between good design and efficient data fetch from database.
<br />
These are the Maps:<br />
	 - allTopics<br />
	 	- This map holds information of news by topics<br />
	 	- key: Topics. "Machine Learning", "NBA" for example<br />
	 	- Value: Map that containts "Title", "URL", "Source"<br />
	 	<br />
	 - allUserSubscribe<br />
	 	- This map holds all the information about how users subscribe to each topic<br />
	 	- key: Users<br />
	 	- value: userMap<br />
	 	<br />
	 - userMap <br />
	 - key: Topics
	 - value: Array of maps that tracks "UserID", "Name", "Email"



### Process
There are a few components of notification:
(1) The notificaton actually being sent out.
(2) The "notification" that appears in users app.

Since it's possible that a user has multiple topics, he will have multiple (2). But we don't want to spam the user with 100 (1) on their phone. We figured that notification is really there to remind people to use the app, and not to get the exact content.

What we did is we randomly select one notification (2) among the many notification to actually send to the user. Thus (1) is actually a subset of (2).

This is accomplished with the following steps:
1. Clear up all the maps (since this Node server could be running since last start/crash)
2. get all the topics, and fill up userSubscribe 
3. Fill up an array of Promise that search on the Guardian
4. Add all the new notifications (2) to the database under the user
5. Send out one of the randomly selected notifications to user

### Handling Notification
Once the user received the notification, he will then tap open the app. The app then try to load up all the unread notification on the client side, when view loads.

### Note
I design this pattern based on my own experience of client/server design. Maybe there are better design pattern to achieve what I'm doing, but I didn't spend that much time researching on it. If possible I would like to make data fetching more efficient, data structure less repeated.