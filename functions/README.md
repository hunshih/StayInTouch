# Notification Data Structure
To build notifications, I use multiple layers of hashmaps. They are used to manage Topics, User, Name, Email...and may important fields. This may not be the optimal design, but I'm trying to strike the balance between good design and efficient data fetch from database.
<br />
These are the Maps:<br />
	 - allTopics<br />
	 	- This map holds information of news by topics<br />
	 	- key: Topics<br />
	 	- Value: Map that containts "Title", "URL", "Source"<br />
	 	- Example:<br />
| Key | Value |
| ------ | ------ |
| Machine Learning | www.google.com |
|  | "How Google uses machine learning to make better prediction" |
|  | "The Guardian" |

### Process
Here 