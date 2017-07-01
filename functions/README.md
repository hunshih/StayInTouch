# Notification Data Structure
To build notifications, I use multiple layers of hashmaps. They are used to manage Topics, User, Name, Email...and may important fields. This may not be the optimal design, but I'm trying to strike the balance between good design and efficient data fetch from database.
<br />
These are the Maps:
	 - allTopics
	 	- This map holds information of news by topics
	 	- key: Topics
	 	- Value: Map that containts "Title", "URL", "Source"

### Process
Here 