// 
//  BrowserTabManager.swift
//  ACME-Mobile-Browser
// 
//  Created by Echo Zhao on 8/17/22.
// 

import UIKit

// MARK: TabManager - manage all tabs with thumbnail
@objcMembers class TabManager: NSObject {
  var tabs = [Tab]()
  var currentTabIndex: Int
  var currentTab: Tab {
    get {
      return tabs[currentTabIndex]
    }
  }
  
  let defaultHomePage = "https://google.com/"
  
  override init(){
    let defaultTab = Tab(index: 0, homePage: defaultHomePage)
    currentTabIndex = 0
    
    tabs.append(defaultTab)
  }
  
  func newTab() {
    let index = tabs.count
    
    // New tab will be inserted to the front of the tab list
    let newTab = Tab(index: index, homePage: defaultHomePage)
    tabs.append(newTab)
    
    currentTabIndex = index
  }
}
