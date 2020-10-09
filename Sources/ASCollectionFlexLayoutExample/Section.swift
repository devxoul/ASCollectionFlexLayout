//
//  Section.swift
//  ASCollectionFlexLayoutExample
//
//  Created by Suyeol Jeon on 2020/10/10.
//

import AsyncDisplayKit

struct Section {
  var justifyContent: ASStackLayoutJustifyContent = .start
  var alignItems: ASStackLayoutAlignItems = .start
  var items: [Item]
}

struct Item {
  var color: UIColor? = nil
  var width: CGFloat = CGFloat((50..<150).randomElement()!)
  var height: CGFloat { width} //= CGFloat((100..<150).randomElement()!)
}

extension ASStackLayoutJustifyContent {
  static var allCases: [ASStackLayoutJustifyContent] {
    return [.start, .center, .end, .spaceBetween]
  }
}

extension ASStackLayoutAlignItems {
  static var allCases: [ASStackLayoutAlignItems] {
    return [.start, .center, .end, .stretch]
  }
}
