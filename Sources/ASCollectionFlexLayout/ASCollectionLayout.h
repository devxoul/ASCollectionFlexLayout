#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ASCollectionLayout : UICollectionViewLayout

@property (nonatomic, weak) ASCollectionNode *collectionNode;
@property (nonatomic, readonly) id<ASCollectionLayoutDelegate> layoutDelegate;

- (instancetype)initWithLayoutDelegate:(id<ASCollectionLayoutDelegate>)layoutDelegate NS_DESIGNATED_INITIALIZER;

@end
