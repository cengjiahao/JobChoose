//
//  FiltrateCVCell.m
 
#import "FiltrateCVCell.h"
#import "Masonry.h"
#define rgbColor(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
@implementation FiltrateCVCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
-(UIButton *)titleBtn{
    if (!_titleBtn) {
        _titleBtn =[ UIButton new];
        [_titleBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
   
        _titleBtn.backgroundColor = rgbColor(208, 208, 208);
 
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _titleBtn.adjustsImageWhenDisabled = NO;
        _titleBtn.adjustsImageWhenHighlighted = NO;
        [_titleBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_titleBtn];
    }
    return _titleBtn;
}
-(void)setup{
 
    self.titleBtn.frame = self.bounds;
}
-(void)clickBtn:(UIButton *)sender{
    
    if (sender.selected && self.isCancel == NO) {
        return;
    }
    if (!self.isNoSelect) {
        sender.selected = !sender.selected;
    }

    if (self.indexBlock) {
        self.indexBlock(sender.selected);
    }
}
-(void)setDic:(NSDictionary *)dic {
    _dic = dic;
    //刷新后要重新赋值frame 不然会出现短小
    self.titleBtn.frame = self.bounds;
    [self.titleBtn setTitle:dic[@"name"] forState:UIControlStateNormal];
    
    if([dic[@"showclose"] integerValue]==1){
        self.imgView.hidden = NO;
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(20);
        }];
        self.bgView.backgroundColor = [UIColor greenColor];
        self.titleBtn.selected = YES;
    }else{
        
        self.imgView.hidden = YES;
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        self.bgView.backgroundColor = [UIColor redColor];
        self.titleBtn.selected = NO;


    }
}



@end
