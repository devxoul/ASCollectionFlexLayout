#if os(iOS) || os(tvOS)
@objcMembers public class ASCollectionFlexLayout: _ASCollectionFlexLayout {
  public weak var layoutProvider: ASCollectionFlexLayoutProvider? {
    get { return self.flexLayoutDelegate?.layoutProvider }
    set { self.flexLayoutDelegate?.layoutProvider = newValue }
  }

  private var flexLayoutDelegate: ASCollectionFlexLayoutDelegate? {
    return self.layoutDelegate as? ASCollectionFlexLayoutDelegate
  }

  public override init(
    scrollableDirections: ASScrollDirection = ASScrollDirectionVerticalDirections,
    layoutProvider: ASCollectionFlexLayoutProvider? = nil
  ) {
    super.init(scrollableDirections: scrollableDirections, layoutProvider: layoutProvider)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  public static func defaultLayoutSpecThatFits(_ constrainedSize: ASSizeRange, sectionElements: [ASLayoutElement]) -> ASLayoutSpec {
    return ASStackLayoutSpec(
      direction: .vertical,
      spacing: 0,
      justifyContent: .start,
      alignItems: .stretch,
      flexWrap: .noWrap,
      alignContent: .start,
      lineSpacing: 0,
      children: sectionElements
    )
  }

  public static func defaultLayoutSpecThatFits(_ constrainedSize: ASSizeRange, forSectionAt section: Int, itemElements: [ASLayoutElement]) -> ASLayoutSpec {
    return ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 0,
      justifyContent: .start,
      alignItems: .start,
      flexWrap: .wrap,
      alignContent: .start,
      lineSpacing: 0,
      children: itemElements
    )
  }

  public override func asdk_layoutInspector() -> ASCollectionViewLayoutInspecting {
    return ASCollectionFlexLayoutInspector(layout: self)
  }
}
#endif
