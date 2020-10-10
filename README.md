# ASCollectionFlexLayout

ASCollectionFlexLayout is a custom collection layout that allows to use Texture layout specs in ASCollectionNode.

![screenshot](https://user-images.githubusercontent.com/931655/95620861-c3776800-0aab-11eb-81cd-7dd67a71ce4d.png)

## Usage

### Create a layout

```swift
let layout = ASCollectionFlexLayout()
layout.layoutProvider = self

let collectionNode = ASCollectionNode(collectionViewLayout: layout)
```

If you don't specify the `layoutProvider`, it will use a `ASStackLayout` as default.

### Implement ASCollectionFlexLayoutProvider protocol

There are two kind of layout specs in ASCollectionFlexLayout:

1. A layout for sections
2. A Layout for items in a section

You can optionally provide each layout specs by implementing `ASCollectionFlexLayoutProvider` protocol.

```swift
protocol ASCollectionFlexLayoutProvider {
  /// A layout spec for sections. The default layout spec is a stretched stack layout with no spacing.
  func flexLayout(_ layout: ASCollectionFlexLayout, layoutSpecThatFits constrainedSize: ASSizeRange, sectionElements: [ASLayoutElement]) -> ASLayoutSpec?

  /// A layout spec for items in a section. The default layout spec is a flex-wrapping stack with no spacing.
  func flexLayout(_ layout: ASCollectionFlexLayout, layoutSpecThatFits constrainedSize: ASSizeRange, forSectionAt section: Int, itemElements: [ASLayoutElement]) -> ASLayoutSpec?
}
```

For example:

```swift
extension MyViewController: ASCollectionFlexLayoutProvider {
  func flexLayout(_ layout: ASCollectionFlexLayout, layoutSpecThatFits constrainedSize: ASSizeRange, sectionElements: [ASLayoutElement]) -> ASLayoutSpec? {
    return ASStackLayoutSpec(
      direction: .vertical,
      spacing: 20,
      justifyContent: .start,
      alignItems: .start,
      children: sectionElements
    )
  }

  func flexLayout(_ layout: ASCollectionFlexLayout, layoutSpecThatFits constrainedSize: ASSizeRange, forSectionAt section: Int, itemElements: [ASLayoutElement]) -> ASLayoutSpec? {
    return ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 10,
      justifyContent: .start,
      alignItems: .start,
      flexWrap: .wrap,
      alignContent: .start,
      lineSpacing: 10,
      children: itemElements
    )
  }
}
```

## License

ASCollectionFlexLayout is under MIT license. See the [LICENSE](LICENSE) for more info.
