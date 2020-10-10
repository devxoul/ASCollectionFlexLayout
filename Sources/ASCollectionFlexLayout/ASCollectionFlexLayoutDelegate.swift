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
      let header = elementMap.supplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section))?.node
      let footer = elementMap.supplementaryElement(ofKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: section))?.node

      let indexPaths = items.lazy.map { IndexPath(item: $0, section: section) }
      let itemElements = indexPaths.compactMap { elementMap.elementForItem(at: $0) }
      let children = Array(itemElements.map(\.node))
      let itemLayoutSpec = self.itemLayoutSpec(with: context, section: section, children: children)

      return ASStackLayoutSpec(
        direction: .vertical,
        spacing: 0,
        justifyContent: .start,
        alignItems: .stretch,
        children: [header, itemLayoutSpec, footer].compactMap { $0 }
      )
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
    guard let layout = context.layout else { return ASLayoutSpec() }

    let layoutSpec: ASLayoutSpec = {
      if let layoutSpec = context.layoutProvider?.flexLayout?(layout, layoutSpecThatFits: context.constrainedSize(), sectionElements: children) {
        return layoutSpec
      }

      let defaultLayoutSpec = ASStackLayoutSpec.copied(from: layout.defaultSectionLayoutSpec)
      defaultLayoutSpec.children = children
      return defaultLayoutSpec
    }()

    (layoutSpec as? ASStackLayoutSpec)?.isConcurrent = true
    layoutSpec.style.preferredLayoutSize.width = ASDimensionMake(.fraction, 1)
    return layoutSpec
  }

  private static func itemLayoutSpec(with context: ASCollectionLayoutContext, section: Int, children: [ASLayoutElement]) -> ASLayoutSpec {
    guard let layout = context.layout else { return ASLayoutSpec() }

    if let layoutSpec = context.layoutProvider?.flexLayout?(layout, layoutSpecThatFits: context.constrainedSize(), forSectionAt: section, itemElements: children) {
      return layoutSpec
    }

    let defaultLayoutSpec = ASStackLayoutSpec.copied(from: layout.defaultItemLayoutSpec)
    defaultLayoutSpec.children = children
    return defaultLayoutSpec
  }
}

private extension ASStackLayoutSpec {
  static func copied(from original: ASStackLayoutSpec) -> ASStackLayoutSpec {
    let layoutSpec = ASStackLayoutSpec(
      direction: original.direction,
      spacing: original.spacing,
      justifyContent: original.justifyContent,
      alignItems: original.alignItems,
      flexWrap: original.flexWrap,
      alignContent: original.alignContent,
      lineSpacing: original.lineSpacing,
      children: original.children ?? []
    )
    layoutSpec.isConcurrent = original.isConcurrent
    return layoutSpec
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
