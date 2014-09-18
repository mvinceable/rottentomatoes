# RottenTomatoes Box Office Demo

This is an iOS iPhone application that displays the latest box office movies using the [RottenTomatoes API](http://www.rottentomatoes.com/). See the [RottenTomatoes Networking Tutorial](http://guides.thecodepath.com/android/RottenTomatoes-Networking-Tutorial) on our cliffnotes for a step-by-step tutorial.

Time spent: 12 hours spent in total

Completed user stories:
 
 * [x] Required: User can view a list of movies from Rotten Tomatoes. Poster images must be loading asynchronously.
 * [x] Required: User can view movie details by tapping on a cell
 * [x] Required: User sees loading state while waiting for movies API. You can use one of the 3rd party libraries at cocoacontrols.com (this submission uses [MBProgressHUD](https://www.cocoacontrols.com/controls/mbprogresshud))
 * [x] Required: User sees error message when there's a networking error (not using UIAlertView to display the error).
 * [x] Required: User can pull to refresh the movie list.
 * [x] Required: Must use Cocoapods. (used for AFNetworking and MBProgressHUD)
 * [x] Required: Asynchronous image downloading must be implemented using the UIImageView category in the AFNetworking library.
 * [x] Optional: Customize the navigation bar.

Notes:

The loading indicator will only display the first time that data is loaded since subsequent refreshes are invoked via the pull to refresh control, which has its own spinner.

Walkthrough of all user stories:

![Video Walkthrough](demo.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).
