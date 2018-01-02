# iOS2dehandsApp

Hello, welcome to the github repository of my assignment for Native Apps: iOS.

## What is the application ?

The application is a place where you can post and look at different ads posted by different users.
The application is an easy version of the belgian website http://www.2dehands.be
My application uses a local MongoDB database and a local backend.
We used kitura for the backend as seen in the lessons.
As a user i can post an ad, look at all ads, look at your own ads, edit your ads and delete your ads.
You can also contact the user from who the ad is but this wil only work on devices and not in an simulator.
This application is very secure. the user his/her password is stored in the database as a hash and a salt.
Every request in the backend uses the correct headers such as an Authorization header so that unauthorized people can't access certain information.

## How to work with the application ?
To succesfully work with the application you have to run 3 different things on your mac.
You wil have to run the workspace from the frontend, the xcodeproj from the backend and your local MongoDB.
When running the application for the first time you will have to register a user in the application.
After registering you will automaticly log in and see the menu.
You can post ads and these are unique depending on the name and user.
So every user can have an ad with a certain name only once but globally there can be multiple ads with a certain name.
When contacting someone this will open the mail app on your iDevice and from there you can mail to the user who posted the ad.
If you want to log out of the app, just go to the menu and press logout.
