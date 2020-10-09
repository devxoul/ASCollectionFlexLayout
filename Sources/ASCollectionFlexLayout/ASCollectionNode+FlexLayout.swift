#if os(iOS) || os(tvOS)
public extension ASCollectionNode {
  var flexLayoutProvider: ASCollectionFlexLayoutProvider? {
    get { return self.flexLayoutDelegate?.layoutProvider }
    set { self.flexLayoutDelegate?.layoutProvider = newValue }
  }

  private var flexLayoutDelegate: ASCollectionFlexLayoutDelegate? {
    return self.layoutDelegate as? ASCollectionFlexLayoutDelegate
  }
}
#endif
