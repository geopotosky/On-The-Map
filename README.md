# On-The-Map

=================
On-The-Map README
=================


“On The Map” is student locator app (Udacity iOS Development – Project 3). It uses geo-location and maps to show where a student is posting from (simulated) and what they are posting at that location. The user must log into Udacity directly or via Facebook before using the app.


-----------
Login Scene
-----------

Files:
------
LoginViewController.swift
OTMClient.swift
OTMConstants.swift
NetworkConnectCheck.swift
UsernameFieldDelegate.swift
PasswordFieldDelegate.swift

The login scene simulates the Udacity login screen. The user must login to either Udacity directly or via Facebook credentials.

How to use the Login scene:

•	Tap the email text box to enter the Udacity username (normally this is your email address).
•	Tap the password text box to enter the Udacity password.
•	Tap the “Login” button to begin the login authentication process. Login authentication is done via a Udacity API.
•	Tap the “Sign up” button to sign up at Udacity.
•	Tap the Facebook login button to login into Udacity via Facebook credentials. After tapping the button, tap the “ok” button to confirm authorization. 
•	If you are already logged into Udacity via Facebook from a previous session, you must logout of the session. An alert will pop up. Tap “OK” and tap the Facebook log out button.


-------------
Student Views
-------------

Files:
------
MapViewController.swift
TableViewController.swift
VCMapView.swift

The main Student Mapping scenes display the top 100 Udacity student posts from Udacity student access dictionary. There are 2 views: Map view and Table view. Both behave the same way and have similar options.

Student Map View:

How to use the Student Map View:

Files:
------
MapViewController.swift

The student map view displays the location of 100 students (reverse order) via map pins.

•	Tap any pin to see the student name and URL location via a map popup bubble.
•	Tap the map popup to leave the app and go the student URL via the web browser.
•	Tap “X” to exit the student information and go back to the login scene.
•	Tap the pin icon to add the student location and URL.


Student List View:

How to use the Student List View:

Files:
------
TableViewController.swift

The student list view displays the name and location of 100 students (reverse order) via a table list.

•	Tap any pin/table entry to see the student name and URL location via a map popup bubble.

•	Tap the pin icon/table entry to leave the app and go the student URL via the web browser.
•	Tap “X” to exit the student information and go back to the login scene.
•	Tap the pin icon to add the student location and URL.


-----------------
My Location Scene
-----------------

Files:
------
MyLocationViewController.swift
LocationFieldDelegate.swift
URLFieldDelegate.swift

The My Location scene provides a way to add your location (actual or anyway in the world) and a URL web link associated with you and/or your location.

How to use the My Location scene:

•	Tap the “Enter Your Location” text field to enter a location. The user can enter any text and the geo location function will attempt to find the coordinates for that word/phrase. For example, you can enter New York, NY or New York City or Disneyland or Eiffel Tower.
•	Tap the “Find on the Map” button to search for the location.
•	Next, the scene will be updated to show a zoomed in pinned location.
•	Tap the “Enter Your URL” text field to enter a web address. The URL must start with either “http://” or “https://” or the user will receive an error popup message.
•	Tap the “Submit” button. This entry will be added to the Udacity student location lookup dictionary via API and the view will change to the map view. The map view will now include the new student location.


----------------
Other App Files:
----------------

Delegate Files:
---------------

AppDelegate.swift: Default delegate file
Note: other delegate files listed above


Object Files:
-------------

StudentLocation.swift
Students.swift


Button Attributes:
------------------

CustomButton1.swift
CustomButton2.swift

Images:
-------
pin.pdf
udacity.pdf
OnTheMapGlobe.png

