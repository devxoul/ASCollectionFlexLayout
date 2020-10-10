#if os(iOS) || os(tvOS)
import AsyncDisplayKit
import Nimble
import Quick

import ASCollectionFlexLayout

final class ASCollectionFlexLayoutDelegateSpec: QuickSpec {
  override func spec() {
    var dataSource: DataSourceObject!
    var layoutProvider: LayoutProviderObject!
    var collectionNode: ASCollectionNode!
    var window: UIWindow!

    beforeEach {
      dataSource = DataSourceObject()
      layoutProvider = LayoutProviderObject()
      collectionNode = ASCollectionNode(collectionViewLayout: ASCollectionFlexLayout(
        scrollableDirections: ASScrollDirectionVerticalDirections,
        layoutProvider: layoutProvider
      ))
      collectionNode.frame = CGRect(x: 0, y: 0, width: 100, height: 1000)
      collectionNode.dataSource = dataSource

      window = UIWindow(frame: collectionNode.frame)
      window.addSubnode(collectionNode)
      window.makeKeyAndVisible()
    }

    afterEach {
      window.isHidden = true
      window = nil
    }

    describe("Default layout") {
      it("aligns sections vertically with no line spacing") {
        collectionNode.sections = [
          Section(items: [Item(width: 50, height: 50)]),
          Section(items: [Item(width: 60, height: 60)]),
          Section(items: [Item(width: 70, height: 70)]),
        ]
        expect(collectionNode[0, 0]?.absoluteFrame.origin) == CGPoint(x: 0, y: 0)
        expect(collectionNode[1, 0]?.absoluteFrame.origin) == CGPoint(x: 0, y: 50)
        expect(collectionNode[2, 0]?.absoluteFrame.origin) == CGPoint(x: 0, y: 110)
      }

      it("aligns items horizontally in sections with no spacing") {
        collectionNode.sections = [
          Section(items: [
            Item(width: 10, height: 10),
            Item(width: 20, height: 20),
            Item(width: 30, height: 30),
          ]),
          Section(items: [
            Item(width: 20, height: 20),
            Item(width: 40, height: 40),
            Item(width: 60, height: 60),
          ]),
          Section(items: [
            Item(width: 10, height: 10),
            Item(width: 30, height: 30),
            Item(width: 50, height: 50),
            Item(width: 70, height: 70),
          ]),
        ]
        expect(collectionNode[0, 0]?.absoluteFrame.origin) == CGPoint(x: 0, y: 0)
        expect(collectionNode[0, 1]?.absoluteFrame.origin) == CGPoint(x: 10, y: 0)
        expect(collectionNode[0, 2]?.absoluteFrame.origin) == CGPoint(x: 30, y: 0)

        expect(collectionNode[1, 0]?.absoluteFrame.origin) == CGPoint(x: 0, y: 30)
        expect(collectionNode[1, 1]?.absoluteFrame.origin) == CGPoint(x: 20, y: 30)
        expect(collectionNode[1, 2]?.absoluteFrame.origin) == CGPoint(x: 0, y: 70) // wrap

        expect(collectionNode[2, 0]?.absoluteFrame.origin) == CGPoint(x: 0, y: 130)
        expect(collectionNode[2, 1]?.absoluteFrame.origin) == CGPoint(x: 10, y: 130)
        expect(collectionNode[2, 2]?.absoluteFrame.origin) == CGPoint(x: 40, y: 130)
        expect(collectionNode[2, 3]?.absoluteFrame.origin) == CGPoint(x: 0, y: 180) // wrap
      }

      it("can set item's width as 100%") {
        collectionNode.sections = [
          Section(items: [Item(width: 100%, height: 30)]),
        ]
        expect(collectionNode[0, 0]?.absoluteFrame) == CGRect(x: 0, y: 0, width: 100, height: 30)
      }
    }

    describe("Provider layout") {
      it("lays out sections using the provided layout") {
        layoutProvider.collectionLayoutSpecBlock = { constrainedSize, sectionElements in
          return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 100,
            justifyContent: .start,
            alignItems: .center,
            children: sectionElements
          )
        }

        collectionNode.sections = [
          Section(items: [Item(width: 50, height: 50)]),
          Section(items: [Item(width: 60, height: 60)]),
          Section(items: [Item(width: 70, height: 70)]),
        ]
        expect(collectionNode[0, 0]?.absoluteFrame.origin) == CGPoint(x: 25, y: 0)
        expect(collectionNode[1, 0]?.absoluteFrame.origin) == CGPoint(x: 20, y: 150)
        expect(collectionNode[2, 0]?.absoluteFrame.origin) == CGPoint(x: 15, y: 310)
      }

      it("lays out items using the provided section layout") {
        layoutProvider.sectionLayoutSpecBlock = { constrainedSize, section, itemElements in
          return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 0,
            justifyContent: .end,
            alignItems: .start,
            flexWrap: .wrap,
            alignContent: .start,
            lineSpacing: 30,
            children: itemElements
          )
        }

        collectionNode.sections = [
          Section(items: [
            Item(width: 10, height: 10),
            Item(width: 20, height: 20),
            Item(width: 30, height: 30),
          ]),
        ]
        expect(collectionNode[0, 0]?.absoluteFrame.origin) == CGPoint(x: 40, y: 0)
        expect(collectionNode[0, 1]?.absoluteFrame.origin) == CGPoint(x: 50, y: 0)
        expect(collectionNode[0, 2]?.absoluteFrame.origin) == CGPoint(x: 70, y: 0)
      }

      it("lays out items using the provided layouts") {
        layoutProvider.collectionLayoutSpecBlock = { constrainedSize, sectionElements in
          return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 100,
            justifyContent: .start,
            alignItems: .start,
            children: sectionElements
          )
        }
        layoutProvider.sectionLayoutSpecBlock = { constrainedSize, section, itemElements in
          let alignItems: ASStackLayoutAlignItems = {
            switch section {
            case 0: return .start
            case 1: return .center
            default: return .end
            }
          }()
          return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 20,
            justifyContent: .start,
            alignItems: alignItems,
            flexWrap: .wrap,
            alignContent: .start,
            lineSpacing: 30,
            children: itemElements
          )
        }

        collectionNode.sections = [
          Section(items: [
            Item(width: 10, height: 10),
            Item(width: 20, height: 20),
            Item(width: 30, height: 30),
          ]),
          Section(items: [
            Item(width: 20, height: 20),
            Item(width: 40, height: 40),
            Item(width: 60, height: 60),
          ]),
          Section(items: [
            Item(width: 10, height: 10),
            Item(width: 30, height: 30),
            Item(width: 50, height: 50),
            Item(width: 70, height: 70),
          ]),
        ]
        expect(collectionNode[0, 0]?.absoluteFrame.origin) == CGPoint(x: 0, y: 0)
        expect(collectionNode[0, 1]?.absoluteFrame.origin) == CGPoint(x: 30, y: 0)
        expect(collectionNode[0, 2]?.absoluteFrame.origin) == CGPoint(x: 70, y: 0)

        expect(collectionNode[1, 0]?.absoluteFrame.origin) == CGPoint(x: 0, y: 140)
        expect(collectionNode[1, 1]?.absoluteFrame.origin) == CGPoint(x: 40, y: 130)
        expect(collectionNode[1, 2]?.absoluteFrame.origin) == CGPoint(x: 0, y: 200) // wrap

        expect(collectionNode[2, 0]?.absoluteFrame.origin) == CGPoint(x: 0, y: 380)
        expect(collectionNode[2, 1]?.absoluteFrame.origin) == CGPoint(x: 30, y: 360)
        expect(collectionNode[2, 2]?.absoluteFrame.origin) == CGPoint(x: 0, y: 420) // wrap
        expect(collectionNode[2, 3]?.absoluteFrame.origin) == CGPoint(x: 0, y: 500) // wrap
      }
    }
  }
}


// MARK: - ASCollectionNode Utils

private extension ASCollectionNode {
  var sections: [Section] {
    get {
      return self.dataSourceObject.sections
    }
    set {
      self.dataSourceObject.sections = newValue
      self.reloadData()
      self.waitUntilAllUpdatesAreProcessed()
      self.layoutIfNeeded()
    }
  }

  private var dataSourceObject: DataSourceObject {
    return self.dataSource as! DataSourceObject
  }

  subscript(_ section: Int, _ item: Int) -> ASCellNode? {
    return self.nodeForItem(at: IndexPath(item: item, section: section))
  }
}


// MARK: - ASCellNode Utils

private extension ASCellNode {
  var absoluteFrame: CGRect {
    return self.convert(self.frame, to: self.supernode?.supernode)
  }
}


// MARK: - Section Model

private struct Section {
  let items: [Item]
}

struct Item {
  var width: ASDimension? = nil
  var height: ASDimension? = nil
}


// MARK: - Data Source

private final class DataSourceObject: NSObject, ASCollectionDataSource {
  var sections: [Section] = []

  func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
    return self.sections.count
  }

  func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
    return self.sections[section].items.count
  }

  func collectionView(_ collectionView: ASCollectionView, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
    let item = self.sections[indexPath.section].items[indexPath.item]
    return {
      let node = ASCellNode()
      if let width = item.width {
        node.style.width = width
      }
      if let height = item.height {
        node.style.height = height
      }
      return node
    }
  }
}


// MARK: - Layout Provider

private final class LayoutProviderObject: NSObject, ASCollectionFlexLayoutProvider {
  var collectionLayoutSpecBlock: ((_ constrainedSize: ASSizeRange, _ sectionElements: [ASLayoutElement]) -> ASLayoutSpec?)?
  var sectionLayoutSpecBlock: ((_ constrainedSize: ASSizeRange, _ section: Int, _ itemElements: [ASLayoutElement]) -> ASLayoutSpec?)?

  func flexLayout(_ layout: ASCollectionFlexLayout, layoutSpecThatFits constrainedSize: ASSizeRange, sectionElements: [ASLayoutElement]) -> ASLayoutSpec? {
    return self.collectionLayoutSpecBlock?(constrainedSize, sectionElements)
  }

  func flexLayout(_ layout: ASCollectionFlexLayout, layoutSpecThatFits constrainedSize: ASSizeRange, forSectionAt section: Int, itemElements: [ASLayoutElement]) -> ASLayoutSpec? {
    return self.sectionLayoutSpecBlock?(constrainedSize, section, itemElements)
  }
}


// MARK: - ASDimension Utils

private extension ASDimension {
  static var auto: ASDimension {
    return ASDimensionAuto
  }

  static func points(_ value: CGFloat) -> ASDimension {
    return ASDimension(unit: .points, value: value)
  }

  static func fraction(_ value: CGFloat) -> ASDimension {
    return ASDimension(unit: .fraction, value: value)
  }
}

postfix operator %
private postfix func % (value: CGFloat) -> ASDimension {
  return ASDimension(unit: .fraction, value: value / 100)
}

extension ASDimension: ExpressibleByIntegerLiteral {
  public typealias IntegerLiteralType = Int

  public init(integerLiteral value: Int) {
    self = ASDimension(unit: .points, value: CGFloat(value))
  }
}

extension ASDimension: ExpressibleByFloatLiteral {
  public typealias FloatLiteralType = Double

  public init(floatLiteral value: FloatLiteralType) {
    self = ASDimension(unit: .points, value: CGFloat(value))
  }
}
#endif
