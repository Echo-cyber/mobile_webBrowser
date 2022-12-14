//
//  ViewController.swift
//  ACME-Mobile-Browser
//
//  Created by Echo Zhao on 8/17/22.
//


import UIKit
import WebKit

@objc protocol BrowserViewControllerDelegate: WKNavigationDelegate, UITextFieldDelegate {
    @objc func reloadPage()
    @objc func forwardPressed()
    @objc func backPressed()
    @objc func tabPressed()
    @objc func newTabPressed()
    func updateWebViewContent(url: String)
    var tabManager: TabManager { get }
}

class BrowserViewController: UIViewController {
  // This view contains all of the UI elements of the BrowserViewController
  private lazy var browserView: BrowserView = {
    let view = BrowserView()
    view.delegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // An array of domain extensions used to deduce if a user is searching for specific url or wants to search by keyword
  // Ideally this would be have a more robust deduction of whether a user is looking to use a search engine vs.
  // Manually adding a site by URL
  private lazy var domainExtensions: [String] = {
    if let path = Bundle.main.path(forResource: "DomainExtensions", ofType: "txt") {
      do {
        let data = try String(contentsOfFile: path, encoding: .utf8)
        return data.components(separatedBy: .newlines).map { $0.lowercased() }
      } catch {
        print(error)
      }
    }
    return [ ".com", ".net", ".org", ".co" ]
  }()
  
  var tabManager: TabManager
  
  init(_ tabManager: TabManager) {
    self.tabManager = tabManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Load the default url
    if let url = URL(string: tabManager.defaultHomePage) {
      browserView.urlTextField.text = url.absoluteString
      browserView.webView.load(URLRequest(url: url))
    }
    
    // Add the browser view
    view.addSubview(browserView)
  }
  
  // When this view controller is presented, hide the nav bar to maximize screen real estate
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  // When this view controller disappears, enable the navigation bar
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    // Check if the back button should be enabled or not (when on new tab, shouldn't be able to go back)
    if tabManager.currentTab.history.count == 1 || tabManager.currentTab.historyIndex == 0 {
      browserView.backButton.isEnabled = false
    } else {
      browserView.backButton.isEnabled = true
    }
    // Check if the forward button should be enabled or not (when on most recent page, shouldn't be able to go forward)
    if tabManager.currentTab.history.count - 1 == tabManager.currentTab.historyIndex {
      browserView.forwardButton.isEnabled = false
    } else {
      browserView.forwardButton.isEnabled = true
    }
    
    browserView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    browserView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    browserView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    browserView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
  }
  
  // Updates webView's content and updates the user input textfield
  func updateWebViewContent(url: String) {
    if let url = URL(string: url) {
      browserView.webView.load(URLRequest(url: url))
    } else {
      browserView.webView.load(URLRequest(url: URL(string: tabManager.defaultHomePage)!))
    }
    browserView.urlTextField.text = url
  }
}

// MARK: - BrowserViewControllerDelegate methods, used to handle button presses
extension BrowserViewController: BrowserViewControllerDelegate {
  // Reloads the current page
  @objc func reloadPage() {
    updateWebViewContent(url: tabManager.currentTab.getCurrentPage())
  }
  // Moves forward in the history stack
  @objc func forwardPressed() {
    tabManager.currentTab.moveForwardHistory()
    updateWebViewContent(url: tabManager.currentTab.getCurrentPage())
  }
  // Moves backward in the history stack
  @objc func backPressed() {
    tabManager.currentTab.moveBackHistory()
    updateWebViewContent(url: tabManager.currentTab.getCurrentPage())
  }
  // Tab manager `VC` is opened
  @objc func tabPressed() {
    let vc = TabViewController()
    vc.delegate = self
    navigationController?.pushViewController(vc, animated: true)
  }
  // New tab is added
  @objc func newTabPressed() {
    tabManager.newTab()
    reloadPage()
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - WKNavigationDelegate methods
extension BrowserViewController: WKNavigationDelegate {
  // Check if the user navigated to a new page from within the webView content (not search bar)
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    let currentPage = tabManager.currentTab.getCurrentPage()
    
    if let url = webView.url?.absoluteString, url != currentPage {
      print("User navigated from \(url) to \(currentPage)")
      tabManager.currentTab.history.append(url)
      tabManager.currentTab.historyIndex += 1
      browserView.urlTextField.text = url
    }
  }
  
  // Each time a page is done loading, add a snapshot of the content to the tab manager
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    if #available(iOS 11.0, *) {
      webView.takeSnapshot(with: nil, completionHandler: { (image, error) in
        if let snapshotImage = image {
          self.tabManager.currentTab.contentSnapshot = snapshotImage
        }
      })
    }
    // Update with the current website title
    tabManager.currentTab.updatePageTitle(webView.title)
  }
}

// MARK: - UITextFieldDelegate methods
extension BrowserViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let url = textField.text {
      var formattedURL = url.lowercased()
            
      // If there is no user input, direct to the home page
      if formattedURL == "" {
        formattedURL = tabManager.defaultHomePage
        // If the url does not appear to be a valid web address
      } else if !formattedURL.contains("https://") && !formattedURL.contains("www.") {
        // Check if it was meant to be a valid address (if user did not add https:// or www.) check if it contains a domain extension
        if let pathExtension = URL(string: formattedURL)?.pathExtension, pathExtension != "", domainExtensions.contains(pathExtension) {
          formattedURL = "https://\(formattedURL)"
          // Presumed the user wanted to search a keyword
        } else {
          formattedURL = "http://www.google.com/search?q=\(formattedURL.replacingOccurrences(of: " ", with: "+"))"
        }
      }
      // Make sure all urls end in a '/'
      if !formattedURL.hasSuffix("/") {
        formattedURL = "\(formattedURL)/"
      }
      
      // Add new search to history
      tabManager.currentTab.addPageToHistory(url: formattedURL)
      // Update web view
      updateWebViewContent(url: formattedURL)
      // Hide keyboard
      browserView.urlTextField.resignFirstResponder()
    }
    return true
  }
}
