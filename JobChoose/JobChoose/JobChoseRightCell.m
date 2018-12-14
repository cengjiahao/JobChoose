//
//  JobChoseRightCell.m
//  OutsideWorld
//
//  Created by ZJH on 2018/12/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JobChoseRightCell.h"

@implementation JobChoseRightCell

-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    _choseBtn.hidden = isSelect?NO:YES;
}
-(UIButton *)choseBtn{
    if (!_choseBtn) {
        _choseBtn = [[UIButton alloc]init];
//        [_choseBtn setTitle:@"√" forState:UIControlStateNormal];
        [_choseBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateNormal];
 
 
        _choseBtn.hidden = YES;
    }
    return _choseBtn;
}
-(void)addChose{
    [self.contentView addSubview:self.choseBtn];
    self.choseBtn.frame = CGRectMake(100, 20, 50, 50);
}

@end
