//
//  FiltrateCVCell.h
 

#import <UIKit/UIKit.h>
typedef void (^IndexBlock)(NSInteger index);
@interface FiltrateCVCell : UICollectionViewCell
@property(nonatomic,strong)NSDictionary *dic;
@property(nonatomic,copy)IndexBlock indexBlock;
@property (nonatomic,strong)  UIButton *titleBtn;
@property (strong, nonatomic)  UIImageView *imgView;
@property (strong, nonatomic)  UIView *bgView;
@property (nonatomic, assign) BOOL isCancel;//是否可以取消选中

@property (nonatomic, assign) BOOL isNoSelect;//是否不要选中效果
@end
