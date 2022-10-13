// 
//  Tab.swift
//  ACME-Mobile-Browser
// 
//  Created by Echo Zhao on 8/17/22.
// 

import UIKit

// MARK: Tab - The model for the tab
class Tab {
  // The order of the tab
  var index: Int
  // The snapshot of the tab
  var contentSnapshot: UIImage?
  // The index in the tab history
  var historyIndex: Int
  // All history tabs
  var history: [String] = [String]()
  var pageTitle: String = ""
  
  required init(index: Int, homePage: String) {
    self.index = index
    // Add the homepage as the first loaded page
    self.history.append(homePage)
    // Set the history index to 0, the homepage
    self.historyIndex = 0
  }
  
  // Returns the current page url in string form
  func getCurrentPage() -> String {
    return history[historyIndex]
  }
  
  // Returns the current page in url form
  func getCurrentPageUrl() -> URL? {
    return URL(string: history[historyIndex])
  }
  
  // Adds a page to the history array
  func addPageToHistory(url: String) {
    self.history.append(url)
    self.historyIndex += 1
  }
  
  // Shifts the history pointer forward
  func moveForwardHistory() {
    if historyIndex < history.count {
      historyIndex += 1
    }
  }
  
  // Shifts the history pointer backward
  func moveBackHistory() {
    if historyIndex > 0 {
      historyIndex -= 1
    }
  }
  
  // Updates the page title of the site
  func updatePageTitle(_ pageTitle: String?) {
    self.pageTitle = pageTitle ?? history[historyIndex]
  }
}
