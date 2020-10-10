#if os(iOS) || os(tvOS)
import AsyncDisplayKit

@objcMembers public class ASCollectionFlexLayoutDelegate: NSObject, ASCollectionLayoutDelegate {
  private var _scrollableDirections: ASScrollDirection
  public weak var layout: ASCollectionFlexLayout?
  public weak var layoutProvider: ASCollectionFlexLayoutProvider?

  private typealias Section = Int
  private typealias Item = Int
  private typealias IndexMap = [Section: [Item]]

  public init(
    scrollableDirections: ASScrollDirection = ASScrollDirectionVerticalDirections,
    layoutProvider: ASCollectionFlexLayoutProvider? = nil
  ) {
    self._scrollableDirections = scrollableDirections
    self.layoutProvider = layoutProvider
  }

  public func scrollableDirections() -> ASScrollDirection {
    return self._scrollableDirections
  }

  public func additionalInfoForLayout(withElements elements: ASElementMap) -> Any? {
    return AdditionalInfo(layout: self.layout, layoutProvider: self.layoutProvider)
  }

  public static func calculateLayout(with context: ASCollectionLayoutContext) -> ASCollectionLayoutState {
    guard let elementMap = context.elements else { return ASCollectionLayoutState(context: context) }

    let indexPaths = elementMap.itemIndexPaths
    guard !indexPaths.isEmpty else { return ASCollectionLayoutState(context: context) }

    let indexMap = self.indexMap(with: indexPaths)
    let orderedIndexMap = indexMap.lazy.sorted(by: { $0.key < $1.key })

    let itemLayoutSpecs: [ASLayoutElement] = orderedIndexMap.map { section, items in
      let indexPaths = items.lazy.map { IndexPath(item: $0, section: section) }
      let elements = indexPaths.compactMap { elementMap.elementForItem(at: $0) }
      let children = Array(elements.map(\.node))
      return self.itemLayoutSpec(with: context, section: section, children: children)
    }

    let sectionLayoutSpec = self.sectionLayoutSpec(with: context, children: itemLayoutSpecs)
    let layout = sectionLayoutSpec.layoutThatFits(context.constrainedSize())

    return ASCollectionLayoutState(context: context, layout: layout, getElementBlock: { sublayout in
      let cellNode = sublayout.layoutElement as? ASCellNode
      let collectionElement = cellNode?.value(forKey: "collectionElement") as? ASCollectionElement
      return collectionElement
    })
  }

  private static func indexMap(with indexPaths: [IndexPath]) -> IndexMap {
    var indexMap: IndexMap = [:]
    for indexPath in indexPaths {
      var items = indexMap[indexPath.section] ?? []
      items.append(indexPath.item)
      indexMap[indexPath.section] = items
    }
    return indexMap
  }

  private static func sectionLayoutSpec(with context: ASCollectionLayoutContext, children: [ASLayoutElement]) -> ASLayoutSpec {
    let constrainedSize = context.constrainedSize()
    let layoutSpec: ASLayoutSpec = {
      if let layout = context.layout,
        let layoutProvider = context.layoutProvider,
        let layoutSpec = layoutProvider.flexLayout?(layout, layoutSpecThatFits: constrainedSize, sectionElements: children) {
        return layoutSpec
      }
      let defaultLayoutSpec = ASCollectionFlexLayout.defaultLayoutSpecThatFits(constrainedSize, sectionElements: children)
      return defaultLayoutSpec
    }()

    (layoutSpec as? ASStackLayoutSpec)?.isConcurrent = true
    layoutSpec.style.preferredLayoutSize.width = ASDimensionMake(.fraction, 1)
    return layoutSpec
  }

  private static func itemLayoutSpec(with context: ASCollectionLayoutContext, section: Int, children: [ASLayoutElement]) -> ASLayoutSpec {
    let constrainedSize = context.constrainedSize()
    if let layout = context.layout,
       let layoutProvider = context.layoutProvider,
       let layoutSpec = layoutProvider.flexLayout?(layout, layoutSpecThatFits: constrainedSize, forSectionAt: section, itemElements: children) {
      return layoutSpec
    }
    let defaultLayoutSpec = ASCollectionFlexLayout.defaultLayoutSpecThatFits(constrainedSize, forSectionAt: section, itemElements: children)
    return defaultLayoutSpec
  }
}

private struct AdditionalInfo {
  let layout: ASCollectionFlexLayout?
  let layoutProvider: ASCollectionFlexLayoutProvider?
}

private extension ASCollectionLayoutContext {
  var layout: ASCollectionFlexLayout? {
    return self.info?.layout
  }

  var layoutProvider: ASCollectionFlexLayoutProvider? {
    return self.info?.layoutProvider
  }

  private var info: AdditionalInfo? {
    return self.additionalInfo as? AdditionalInfo
  }

  func constrainedSize() -> ASSizeRange {
    var sizeRange = ASSizeRangeUnconstrained
    if !ASScrollDirectionContainsVerticalDirection(self.scrollableDirections) {
      sizeRange.min.height = self.viewportSize.height
      sizeRange.max.height = self.viewportSize.height
    }
    if !ASScrollDirectionContainsHorizontalDirection(self.scrollableDirections) {
      sizeRange.min.width = self.viewportSize.width
      sizeRange.max.width = self.viewportSize.width
    }
    return sizeRange
  }
}
#endif
