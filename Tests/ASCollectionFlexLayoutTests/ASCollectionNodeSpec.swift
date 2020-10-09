#if os(iOS) || os(tvOS)
import AsyncDisplayKit
import Nimble
import Quick

@testable import ASCollectionFlexLayout

final class ASCollectionNodeSpec: QuickSpec {
  override func spec() {
    describe("flexLayoutProvider") {
      it("forwards to layout delegate") {
        let collectionNode = ASCollectionNode(collectionViewLayout: ASCollectionFlexLayout())
        let layoutDelegate = collectionNode.layoutDelegate as? ASCollectionFlexLayoutDelegate

        let expectedLayoutProvider = LayoutProviderObject()

        collectionNode.flexLayoutProvider = expectedLayoutProvider
        expect(layoutDelegate?.layoutProvider) === expectedLayoutProvider

        collectionNode.flexLayoutProvider = nil
        expect(layoutDelegate?.layoutProvider).to(beNil())

        layoutDelegate?.layoutProvider = expectedLayoutProvider
        expect(collectionNode.flexLayoutProvider) === expectedLayoutProvider
      }
    }
  }
}

private final class LayoutProviderObject: NSObject, ASCollectionFlexLayoutProvider {
}
#endif
