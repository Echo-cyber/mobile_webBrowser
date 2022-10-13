//
//  HelperExtensions.swift
//  ACME-Mobile-Browser
//
//  Created by Echo Zhao on 8/17/22.
//

import UIKit

protocol UITableViewReuseCell {}

extension UITableViewReuseCell where Self: UIView {
  static var cellIdentifier: String {
    return String(describing: self)
  }
}

extension UITableViewCell: UITableViewReuseCell { }
