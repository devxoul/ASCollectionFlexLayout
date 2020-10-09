#if os(iOS) || os(tvOS)
import AsyncDisplayKit

@objcMembers final class ASCollectionFlexLayoutInspector: ASCollectionViewLayoutInspector {
  private weak var layout: UICollectionViewLayout? /* ASCollectionLayout */

  init(layout: UICollectionViewLayout? = nil) {
    self.layout = layout
  }

  override func scrollableDirections() -> ASScrollDirection {
    guard let layoutDelegate = self.layoutDelegate() else { return [] }
    return layoutDelegate.scrollableDirections()
  }

  private func layoutDelegate() -> ASCollectionLayoutDelegate? {
    return self.layout?.value(forKey: "layoutDelegate") as? ASCollectionLayoutDelegate
  }
}
#endif
