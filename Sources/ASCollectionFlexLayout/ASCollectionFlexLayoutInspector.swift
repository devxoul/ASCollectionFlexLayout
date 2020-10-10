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

  override func collectionView(_ collectionView: ASCollectionView, constrainedSizeForSupplementaryNodeOfKind kind: String, at indexPath: IndexPath) -> ASSizeRange {
    var constrainedSize = ASSizeRangeUnconstrained
    if ASScrollDirectionContainsVerticalDirection(self.scrollableDirections()) {
      constrainedSize.min.width = collectionView.bounds.width
      constrainedSize.max.width = collectionView.bounds.width
    } else {
      constrainedSize.min.height = collectionView.bounds.height
      constrainedSize.max.height = collectionView.bounds.height
    }
    return constrainedSize
  }

  override func collectionView(_ collectionView: ASCollectionView, supplementaryNodesOfKind kind: String, inSection section: UInt) -> UInt {
    let constrainedSize = self.collectionView(collectionView, constrainedSizeForSupplementaryNodeOfKind: kind, at: IndexPath(item: 0, section: Int(section)))
    if ASScrollDirectionContainsVerticalDirection(self.scrollableDirections()) {
      return constrainedSize.max.height > 0 ? 1 : 0
    } else {
      return constrainedSize.max.width > 0 ? 1 : 0
    }
  }
}
#endif
