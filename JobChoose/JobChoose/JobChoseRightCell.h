//
//  JobChoseRightCell.h
//  OutsideWorld
//
//  Created by ZJH on 2018/12/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface JobChoseRightCell : UITableViewCell
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) UIButton * choseBtn;
-(void)addChose;
@end

NS_ASSUME_NONNULL_END
