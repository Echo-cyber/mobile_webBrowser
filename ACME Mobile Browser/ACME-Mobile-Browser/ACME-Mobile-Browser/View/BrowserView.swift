// 
//  BrowserView.swift
//  ACME-Mobile-Browser
// 
//  Created by Echo Zhao on 8/17/22.
// 

import WebKit
import UIKit

class BrowserView: UIView {
  
  lazy var webView: WKWebView = {
    let webView = WKWebView()
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.allowsBackForwardNavigationGestures = true
    return webView
  }()
  
  // The url entry field
  lazy var urlTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.backgroundColor = UIColor(red: 245, green: 245, blue: 245, alpha: 90)
    textField.rightViewMode = .always
    textField.returnKeyType = .search
    
    // Add a 10pts of padding to left side of textfield
    textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 1.0))
      textField.leftViewMode = .always
    
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .none
    textField.spellCheckingType = .no
    
    return textField
  }()
  
  // The bottom bar with supported actions
  lazy var bottomBarStack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.distribution = .fillEqually
    return stack
  }()
  
  // Go forward
  lazy var forwardButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
    button.addTarget(delegate, action: #selector(delegate?.forwardPressed), for: .touchUpInside)
    return button
  }()
  
  // Go backward
  lazy var backButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
    button.addTarget(delegate, action: #selector(delegate?.backPressed), for: .touchUpInside)
    return button
  }()
  
  // Open tab management page
  lazy var tabButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(systemName: "square.on.square"), for: .normal)
    button.addTarget(delegate, action: #selector(delegate?.tabPressed), for: .touchUpInside)
    return button
  }()
  
  weak var delegate: BrowserViewControllerDelegate? {
    didSet {
      webView.navigationDelegate = delegate
      urlTextField.delegate = delegate
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    self.addSubview(urlTextField)
    self.addSubview(webView)
    self.addSubview(bottomBarStack)
    
    bottomBarStack.addArrangedSubview(backButton)
    bottomBarStack.addArrangedSubview(forwardButton)
    bottomBarStack.addArrangedSubview(tabButton)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    urlTextField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    urlTextField.bottomAnchor.constraint(equalTo: webView.topAnchor).isActive = true
    urlTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
    urlTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
    urlTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    urlTextField.layer.cornerRadius = 5
    urlTextField.layer.borderWidth = 1
    urlTextField.layer.borderColor = UIColor.black.cgColor
    
    webView.bottomAnchor.constraint(equalTo: bottomBarStack.topAnchor).isActive = true
    webView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
    webView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
    
    bottomBarStack.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    bottomBarStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
    bottomBarStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
    bottomBarStack.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }
}
