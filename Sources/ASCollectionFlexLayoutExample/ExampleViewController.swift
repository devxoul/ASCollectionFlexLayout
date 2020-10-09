//
//  ExampleViewController.swift
//  ASCollectionFlexLayoutExample
//
//  Created by Suyeol Jeon on 2020/10/10.
//

import AsyncDisplayKit
import ASCollectionFlexLayout

final class ExampleViewController: ASDKViewController<ASCollectionNode> {
  private var sections: [Section] = [
    Section(items: [
      Item(color: .systemRed),
      Item(color: .systemOrange),
      Item(color: .systemYellow),
      Item(color: .systemGreen),
      Item(color: .systemBlue),
      Item(color: .systemIndigo),
      Item(color: .systemPurple),
    ]),
  ] {
    didSet {
      self.node.reloadData()
    }
  }

  private lazy var refreshButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))

  override init() {
    let layout = ASCollectionFlexLayout()
    let collectionNode = ASCollectionNode(collectionViewLayout: layout)
    collectionNode.backgroundColor = .systemBackground
    collectionNode.alwaysBounceVertical = true

    super.init(node: collectionNode)

    layout.layoutProvider = self
    collectionNode.dataSource = self

    self.configureNavigationBar()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configureNavigationBar() {
    self.navigationItem.title = "ASCollectionFlexLayout"
    self.navigationItem.rightBarButtonItem = self.refreshButtonItem
  }

  @objc private func refresh() {
    var section = self.sections[0]
    section.justifyContent = ASStackLayoutJustifyContent.allCases.randomElement()!
    section.alignItems = ASStackLayoutAlignItems.allCases.randomElement()!
    self.sections = [section]
  }
}

extension ExampleViewController: ASCollectionFlexLayoutProvider {
  func layoutSpecThatFits(_ constrainedSize: ASSizeRange, sectionElements: [ASLayoutElement]) -> ASLayoutSpec? {
    return ASStackLayoutSpec(
      direction: .vertical,
      spacing: 50,
      justifyContent: .start,
      alignItems: .stretch,
      children: sectionElements
    )
  }

  func layoutSpecThatFits(_ constrainedSize: ASSizeRange, forSectionAt section: Int, itemElements: [ASLayoutElement]) -> ASLayoutSpec? {
    let section = self.sections[section]
    return ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 0,
      justifyContent: section.justifyContent,
      alignItems: section.alignItems,
      flexWrap: .wrap,
      alignContent: .start,
      lineSpacing: CGFloat((0..<50).randomElement()!),
      children: itemElements
    )
  }
}

extension ExampleViewController: ASCollectionDataSource {
  func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
    return self.sections.count
  }

  func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
    return self.sections[section].items.count
  }

  func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
    let item = self.sections[indexPath.section].items[indexPath.item]
    return {
      let node = ASCellNode()
      node.backgroundColor = item.color
      node.style.preferredSize.width = item.width
      node.style.preferredSize.height = item.height
      return node
    }
  }
}
