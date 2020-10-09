#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <ASCollectionFlexLayout/ASCollectionLayout.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ASCollectionFlexLayoutProvider;

@interface _ASCollectionFlexLayout : ASCollectionLayout

- (instancetype)initWithScrollableDirections:(ASScrollDirection)scrollableDirections layoutProvider:(nullable id<ASCollectionFlexLayoutProvider>)layoutProvider NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLayoutDelegate:(id<ASCollectionLayoutDelegate>)layoutDelegate NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
