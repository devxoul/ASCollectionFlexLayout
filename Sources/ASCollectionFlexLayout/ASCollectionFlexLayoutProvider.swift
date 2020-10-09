#if os(iOS) || os(tvOS)
import AsyncDisplayKit

@objc public protocol ASCollectionFlexLayoutProvider: NSObjectProtocol {
  /// A layout spec for sections.
  ///
  /// The default layout spec is a stretched stack layout with no spacing.
  ///
  /// The number of `sectionElements` is equal to the number of sections in collection node.
  @objc optional func layoutSpecThatFits(_ constrainedSize: ASSizeRange, sectionElements: [ASLayoutElement]) -> ASLayoutSpec?

  /// A layout spec for items in a section.
  ///
  /// The default layout spec is a flex-wrapping stack with no spacing.
  ///
  /// The number of `itemElements` is equal to the number of items in the given section.
  @objc optional func layoutSpecThatFits(_ constrainedSize: ASSizeRange, forSectionAt section: Int, itemElements: [ASLayoutElement]) -> ASLayoutSpec?
}
#endif
