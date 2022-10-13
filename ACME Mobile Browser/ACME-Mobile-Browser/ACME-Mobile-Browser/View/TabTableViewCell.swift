// 
//  TabCollectionViewCell.swift
//  ACME-Mobile-Browser
// 
//  Created by Echo Zhao on 8/17/22.
// 

import UIKit

class TabTableViewCell: UITableViewCell {
  
  private lazy var deleteButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(systemName: "clear"), for: .normal)
    button.tintColor = .black
    button.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
    return button
  }()
  
  private lazy var contentSnapshotImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  var tabViewControllerDelegate: TabViewControllerDelegate?
  
  private var cellIndex: Int?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(contentSnapshotImageView)
    
    contentView.addSubview(deleteButton)
    
    contentView.isUserInteractionEnabled = true
    backgroundColor = .clear
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    
    let tabWidth = (contentSnapshotImageView.image?.size.width ?? 0.0) / 2
        
    deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    deleteButton.leadingAnchor.constraint(equalTo: contentSnapshotImageView.trailingAnchor, constant:10).isActive = true
    
    contentSnapshotImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    contentSnapshotImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    contentSnapshotImageView.widthAnchor.constraint(equalToConstant: tabWidth).isActive = true
    contentSnapshotImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    
    contentSnapshotImageView.layer.borderWidth = 1.0
    contentSnapshotImageView.layer.borderColor = UIColor.gray.cgColor
    contentSnapshotImageView.layer.cornerRadius = 8
    contentSnapshotImageView.layer.masksToBounds = true
  }
  
  func updateCell(cellIndex: Int, title: String, contentSnapshot: UIImage?) {
    self.cellIndex = cellIndex
    if let image = contentSnapshot {
      contentSnapshotImageView.image = image
    } else {
      contentSnapshotImageView.image = UIImage(systemName: "globe")
    }
  }
  
  @objc func deletePressed() {
    if let delegate = tabViewControllerDelegate, let index = cellIndex {
      delegate.removeTab(index: index)
    }
  }
}
