//
//  JobChoseVC.m
//  OutsideWorld
//
//  Created by ZJH on 2018/11/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JobChoseVC.h"
#import "JobChoseRightCell.h"
#import "MBProgressHUD+ADD.h"
#import "FiltrateCVCell.h"

#define rgbColor(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface JobChoseVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UISearchBar *theSearchBar;
@property(nonatomic,strong)UITableView *lefttableview;
@property(nonatomic,strong)UITableView *righttableview;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong,readwrite)NSMutableArray * tableData;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary * dataDict;//搜索数据源


@property (nonatomic,assign)BOOL isChange;
@property (nonatomic,strong)NSMutableArray *cellAttributesArray;
@end

@implementation JobChoseVC{
    UITableViewCell *leftSelectCell;
    JobChoseRightCell *rightSelectCell;
 
    NSInteger rightSelectIndex;
    NSArray *leftArr;
    NSArray *rightArr;
    NSMutableArray *selectArr;//选中的数组
    UILabel *headL;
    UILabel *countL;
    
}
#pragma mark - 懒加载
-(UISearchBar *)theSearchBar{
    if (!_theSearchBar) {
        _theSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,  64 , kScreenWidth,  50)];
        _theSearchBar.delegate = self;
        _theSearchBar.backgroundColor = [UIColor whiteColor];
        _theSearchBar.placeholder = @"搜索职位";
        UIView *firstSubView = _theSearchBar.subviews.firstObject;
        firstSubView.backgroundColor = [UIColor clearColor];
        UIView *backgroundImageView = [firstSubView.subviews firstObject];
        [backgroundImageView removeFromSuperview];
        UITextField *searchField = [_theSearchBar valueForKey:@"searchField"];
        if (searchField) {
            searchField.layer.cornerRadius = 5;
            searchField.layer.borderColor = [UIColor colorWithRed:247/255.0 green:75/255.0 blue:31/255.0 alpha:1].CGColor;
            searchField.layer.borderWidth = 1;
            searchField.layer.masksToBounds = YES;
        }
        [_theSearchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    }
    return _theSearchBar;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
 
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
      _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake( 17, 64+ 50+17, kScreenWidth- 34,  133) collectionViewLayout:flowLayout];
        _collectionView.delegate=self;
        _collectionView.dataSource  =self;
        _collectionView.tag = 111;
        _collectionView.backgroundColor=[UIColor whiteColor];
        [self.collectionView registerClass:[FiltrateCVCell class] forCellWithReuseIdentifier:@"FiltrateCVCellID"];
    }
    return _collectionView;
}
-(void)clickSkip{
    NSLog(@"选择了: %@",selectArr);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"职位选择";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(clickSkip)];
    self.navigationItem.rightBarButtonItem = item;
  
    NSString* leftPlistPath = [[NSBundle mainBundle]pathForResource:@"JobLeft"ofType:@"plist"];
    NSString* righPlistPath = [[NSBundle mainBundle]pathForResource:@"JobRight"ofType:@"plist"];
    //不能用外层字典  只能用双plist
    leftArr = [[NSArray alloc]initWithContentsOfFile:leftPlistPath];
    rightArr = [[NSArray alloc]initWithContentsOfFile:righPlistPath];
  
    [self.view addSubview:self.theSearchBar];
    [self.view addSubview:self.collectionView];
    
    [self lefttableview];
    [self righttableview];
    
    
    selectArr = [NSMutableArray new];
    

    [self addSearchTab];
}

-(void)addSearchTab{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+50, kScreenWidth, kScreenHeight - 64 - 50) style:UITableViewStylePlain];
     _tableView.backgroundColor = rgbColor(248, 248, 248);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.estimatedRowHeight  = 0 ;
    _tableView.estimatedSectionHeaderHeight  = 0 ;
    _tableView.estimatedSectionFooterHeight  = 0 ;
    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;//隐藏
    
}



-(UITableView *)lefttableview{
    if (_lefttableview==nil) {
        _lefttableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 50, kScreenWidth/2,kScreenHeight - 64 - 50) style:UITableViewStylePlain];

        _lefttableview.backgroundColor=[UIColor whiteColor];
        _lefttableview.showsVerticalScrollIndicator=NO;
       _lefttableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        _lefttableview.dataSource=self;
        _lefttableview.delegate=self;
        [_lefttableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"leftCell"];
        [self.view addSubview:_lefttableview];
    }
    return _lefttableview;
}
-(UITableView *)righttableview{
    if (_righttableview==nil) {
        _righttableview=[[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth /2, 64 +  50, kScreenWidth/2,kScreenHeight - 64 - 50) style:UITableViewStylePlain];
        _righttableview.showsVerticalScrollIndicator=NO;
        _righttableview.backgroundColor = rgbColor(248, 248, 248); _righttableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        _righttableview.dataSource=self;
        _righttableview.delegate=self;
        [_righttableview registerClass:[JobChoseRightCell class] forCellReuseIdentifier:@"JobChoseRightCellID"];
        [self.view addSubview:_righttableview];
    }
    return _righttableview;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==_lefttableview) {
        return leftArr.count;
    }else if(tableView==_righttableview){
        NSArray * arr = rightArr[rightSelectIndex];
        return arr.count;
    }
    return self.tableData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _lefttableview) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leftCell"];

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = [NSString stringWithFormat:@"%@",leftArr[indexPath.section]];
            if (indexPath.section == 0) {
                cell.backgroundColor = rgbColor(248, 248, 248);
                cell.textLabel.textColor = [UIColor orangeColor];
                leftSelectCell = cell;
            }else{
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.textColor = [UIColor blackColor];
            }
             
        }

        return cell;
    }
    else if (tableView == _righttableview){
        JobChoseRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JobChoseRightCellID" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = rgbColor(248, 248, 248);
        NSArray *arr = rightArr[rightSelectIndex];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", arr[indexPath.section]];
           [cell addChose];
        if ([selectArr containsObject:arr[indexPath.section]]) {
            cell.isSelect = YES;
            cell.textLabel.textColor = [UIColor orangeColor];

        }else{
            cell.isSelect = NO;
            cell.textLabel.textColor = [UIColor blackColor];
        }

        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    DXFreContModel *model = self.tableData[indexPath.section];
//    cell.textLabel.text = model.name;
//    cell.textLabel.attributedText = model.attributedString;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView==_lefttableview) {
        //先取消再选中
        leftSelectCell.backgroundColor = [UIColor whiteColor];
        leftSelectCell.textLabel.textColor = [UIColor blackColor];

        leftSelectCell = [tableView cellForRowAtIndexPath:indexPath];
        leftSelectCell.backgroundColor = rgbColor(248, 248, 248);
        leftSelectCell.textLabel.textColor = [UIColor orangeColor];
        rightSelectIndex = indexPath.section;
        [self.righttableview reloadData];
    }
    else if(tableView == _righttableview){

        rightSelectCell = [tableView cellForRowAtIndexPath:indexPath];
        rightSelectCell.backgroundColor = rgbColor(248, 248, 248);
        if (!rightSelectCell.isSelect && selectArr.count == 6) {
            [MBProgressHUD  
showInformationCenter:@"最多选择6个" toView:self.view andAfterDelay:2];
            return;
        }
        rightSelectCell.isSelect = !rightSelectCell.isSelect;

        rightSelectCell.textLabel.textColor = rightSelectCell.isSelect?[UIColor orangeColor]:[UIColor blackColor];
        if (rightSelectCell.isSelect) {
            [selectArr addObject:rightSelectCell.textLabel.text];
        }else{
            [selectArr removeObject:rightSelectCell.textLabel.text];
        }
        [self isHiddenHeadView];

    }
    else{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([selectArr containsObject:cell.textLabel.text]) {
            [MBProgressHUD showInformationCenter:@"已选择该职位" toView:self.view andAfterDelay:2];
        }else if(selectArr.count == 6){
              [MBProgressHUD showInformationCenter:@"最多选择6个" toView:self.view andAfterDelay:2];
        }else{
            [selectArr addObject:cell.textLabel.text];
            //刷新
            [self.righttableview reloadData];
        }

        [self isHiddenHeadView];
        //取消搜索
        [self searchBarCancelButtonClicked:self.theSearchBar];

        //隐藏搜索
        self.tableView.hidden = YES;
    }
}

//#pragma mark - UICollectionView
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    return CGSizeMake(70, 35);
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return selectArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    FiltrateCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FiltrateCVCellID" forIndexPath:indexPath];

    cell.dic = @{@"name":selectArr[indexPath.row]};
    cell.layer.cornerRadius = 7;
    cell.layer.masksToBounds= YES;
    cell.isCancel = NO;
 
   
    cell.indexBlock = ^(NSInteger index) {
 
        [self->selectArr removeObject:cell.titleBtn.titleLabel.text];
        [self isHiddenHeadView];
        [self.collectionView reloadData];
        [self.righttableview reloadData];
    };

    //为每个cell 添加长按手势1️⃣
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [cell addGestureRecognizer:longPress];

    return cell;
}

/**
 长按选中cell 拖拽2️⃣

 */
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {

    FiltrateCVCell *cell = (FiltrateCVCell *)longPress.view;
    NSIndexPath *cellIndexpath = [self.collectionView indexPathForCell:cell];
    [self.collectionView bringSubviewToFront:cell];
    _isChange = NO;
    switch (longPress.state) {
            //开始拖拽
        case UIGestureRecognizerStateBegan: {
            [self.cellAttributesArray removeAllObjects];
            for (int i = 0; i < selectArr.count; i++) {
                [self.cellAttributesArray addObject:[self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
            }
        }
            break;
            //位置改变
        case UIGestureRecognizerStateChanged: {

            cell.center = [longPress locationInView:self.collectionView];

            for (UICollectionViewLayoutAttributes *attributes in self.cellAttributesArray) {
                if (CGRectContainsPoint(attributes.frame, cell.center) && cellIndexpath != attributes.indexPath) {
                    _isChange = YES;

                   id object = selectArr[cellIndexpath.row];
                    [selectArr removeObjectAtIndex:cellIndexpath.row];
                    [selectArr insertObject:object atIndex:attributes.indexPath.row];
                    [self.collectionView moveItemAtIndexPath:cellIndexpath toIndexPath:attributes.indexPath];
                }
            }
        }
            break;
            //结束
        case UIGestureRecognizerStateEnded: {
            if (!_isChange) {
                cell.center = [self.collectionView layoutAttributesForItemAtIndexPath:cellIndexpath].center;
            }
        }
            break;
        default:
            break;
    }
}

/** 3️⃣ cell长按手势 */
- (NSMutableArray *)cellAttributesArray {
    if(_cellAttributesArray == nil) {
        _cellAttributesArray = [[NSMutableArray alloc] init];
    }
    return _cellAttributesArray;
}

-(void)isHiddenHeadView{
    if (selectArr.count == 0) {
        self.collectionView.hidden = YES;
                //选中
        _lefttableview.frame = CGRectMake(0, 64 +50 , kScreenWidth/ 2,kScreenHeight - 64 -   50);
        _righttableview.frame = CGRectMake(kScreenWidth/ 2, 64 +  50, kScreenWidth/2,kScreenHeight - 64 - 50);
    }else{
        countL.text = [NSString stringWithFormat:@"%zd/6",selectArr.count];
         self.collectionView.hidden = NO;
        //选中
        _lefttableview.frame = CGRectMake(0, 64 + 50 + 150 , kScreenWidth/ 2,kScreenHeight - 64 -  50 - 150);
        _righttableview.frame = CGRectMake(kScreenWidth/ 2, 64 + 50+150 , kScreenWidth/2,kScreenHeight - 64 - 50 - 150);
    }


    [self.collectionView reloadData];
}


@end
