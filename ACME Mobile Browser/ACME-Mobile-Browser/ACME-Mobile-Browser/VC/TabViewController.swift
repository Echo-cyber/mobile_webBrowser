// 
//  TabViewController.swift
//  ACME-Mobile-Browser
// 
//  Created by Echo Zhao on 8/17/22.
// 

import UIKit

protocol TabViewControllerDelegate {
  func removeTab(index: Int)
}

// MARK: - TabViewController: This VC manages the open tabs
class TabViewController: UITableViewController {
  // Creates a new tab
  private lazy var newTabButton: UIBarButtonItem = {
    let button = UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .plain, target: delegate, action: #selector(delegate?.newTabPressed))
    return button
  }()
  
  weak var delegate: BrowserViewControllerDelegate? {
    didSet {
      navigationItem.rightBarButtonItem = newTabButton
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(TabTableViewCell.self, forCellReuseIdentifier: TabTableViewCell.cellIdentifier)
    tableView.separatorStyle = .none
    view.backgroundColor = .white
  }
}

// All tableView related delegate overridescurrentTabIndex
extension TabViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return delegate?.tabManager.tabs.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let tabAtIndex = delegate?.tabManager.tabs[indexPath.row] else { return UITableViewCell() }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: TabTableViewCell.cellIdentifier) as! TabTableViewCell
    cell.tabViewControllerDelegate = self
    cell.updateCell(cellIndex: indexPath.row, title: tabAtIndex.pageTitle, contentSnapshot: tabAtIndex.contentSnapshot)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 300
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Update the tabManagers selected tab
    delegate?.tabManager.currentTabIndex = indexPath.row
    delegate?.reloadPage()
    // Pop back to the browser VC
    navigationController?.popViewController(animated: true)
  }
}

extension TabViewController: TabViewControllerDelegate {
  // Removes user selected tab
  func removeTab(index: Int) {
    var switchToFirstTab = false
    if index == delegate?.tabManager.currentTab.index {
      switchToFirstTab = true
    }
    
    delegate?.tabManager.tabs.remove(at: index)
    
    if delegate?.tabManager.tabs.count == 0 {
      // If no tabs remaining, create a new one
      delegate?.tabManager.newTab()
      delegate?.reloadPage()
      navigationController?.popViewController(animated: true)
    } else if switchToFirstTab {
      // If the user removes the currently selected tab, make the first tab selected by default
      delegate?.tabManager.currentTabIndex = 0
      delegate?.reloadPage()
      navigationController?.popViewController(animated: true)
    }
    
    tableView.reloadData()
  }
}
