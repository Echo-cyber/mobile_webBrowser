#  About The Project

This ACME Mobile Browser project is used for applying the new Grad software engineering position with the Neeva Mobile Browser team.

Features:
- Built on top of iOS’s built-in WKWebView component to render web pages.
- Support new URL in the URL entry field. URL entry field should be updated to reflect the URL of the currently loaded web page.
- Tab support: create new tab, close tab, select tab.
- Advaned tab support: view tab with thumbnails, smooth tab switch experience.
- If user enters a non-URL text in the address bar, search the text with google automatically

# How to Run
- Download & install the [latest version of Xcode from the App Store][1]
- Clone this project wutg `git clone https://github.com/echo_zhao/ACME-Mobile-Browser.git`
- Open `ACME-Mobile-Browser/ACME-Mobile-Browser.xcodeproj` and press Command-R to run the app


# Design
- This project builds the browser experience with only two ViewControllers:
  - BrowserViewController provides basic features to navigate between web pages with back and forward support.
  - TabViewController provides tab management support with advanced thumbnail feature, which makes user easier to select any open tab.
- The project structure follows the traditional MVC pattern with code split into:
  - VC: host all view controllers in the project
  - View: all views used by the view controllers 
  - Model: all models referenced in the project
  - Util: util classes to help manage code that does not fit into MVC directly.
  - Extention: add extra functionalities to classes.
- I am a big fan of coding up complex UI without relying on storyboard, but totally open to do mix. 

[1]: http://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12
