#if os(iOS) || os(tvOS)
import AsyncDisplayKit
import Nimble
import Quick

@testable import ASCollectionFlexLayout

final class ASCollectionFlexLayoutSpec: QuickSpec {
  override func spec() {
    describe("init") {
      it("can initialize with overloaded initializers") {
        _ = ASCollectionFlexLayout()
        _ = ASCollectionFlexLayout(layoutProvider: LayoutProviderObject())
        _ = ASCollectionFlexLayout(scrollableDirections: [.down])
        _ = ASCollectionFlexLayout(scrollableDirections: [.up], layoutProvider: LayoutProviderObject())
      }
    }

    describe("layoutDelegate") {
      it("is ASCollectionFlexLayoutDelegate") {
        let layout = ASCollectionFlexLayout()
        let layoutDelegate = layout.layoutDelegate
        expect(layoutDelegate).to(beAKindOf(ASCollectionFlexLayoutDelegate.self))
      }
    }

    describe("layoutProvider") {
      it("forwards to layoutDelegate") {
        let layout = ASCollectionFlexLayout()
        let layoutDelegate = layout.layoutDelegate as? ASCollectionFlexLayoutDelegate
        let expectedLayoutProvider = LayoutProviderObject()

        layout.layoutProvider = expectedLayoutProvider
        expect(layoutDelegate?.layoutProvider) === expectedLayoutProvider

        layout.layoutProvider = nil
        expect(layoutDelegate?.layoutProvider).to(beNil())

        layoutDelegate?.layoutProvider = expectedLayoutProvider
        expect(layout.layoutProvider) === expectedLayoutProvider
      }
    }

    describe("asdk_layoutInspector") {
      it("is ASCollectionFlexLayoutInspector") {
        let layout = ASCollectionFlexLayout()
        let layoutInspector = layout.asdk_layoutInspector()
        expect(layoutInspector).to(beAKindOf(ASCollectionFlexLayoutInspector.self))
      }
    }
  }
}

private final class LayoutProviderObject: NSObject, ASCollectionFlexLayoutProvider {
}
#endif
