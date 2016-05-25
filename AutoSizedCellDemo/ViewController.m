//
//  ViewController.m
//  AutoSizedCellDemo
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "LCHCollectionViewCell.h"
#import "LCHModel.h"

@interface ViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *models;

@end

@implementation ViewController


#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LCHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    LCHModel *model = self.models[indexPath.row];
    cell.firstLabel.text = model.firstString;
    cell.secondLabel.text = model.secondString;
    
    CGSize sizeForFirstLabel = [model.firstString boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, __FLT_MAX__) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:25]} context:nil].size;
    
    CGSize sizeForSecondLabel = [model.secondString boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, __FLT_MAX__) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:25]} context:nil].size;
    
    CGRect firstLabelFrame = cell.firstLabel.frame;
    CGRect secondLabelFrame = cell.secondLabel.frame;
    firstLabelFrame.size = sizeForFirstLabel;
    secondLabelFrame.size = sizeForSecondLabel;
    secondLabelFrame.origin.x = sizeForFirstLabel.width;
    cell.firstLabel.frame = firstLabelFrame;
    cell.secondLabel.frame = secondLabelFrame;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LCHModel *model = self.models[indexPath.row];
    
    CGSize sizeForFirstLabel = [model.firstString boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, __FLT_MAX__) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:25]} context:nil].size;
    
    CGSize sizeForSecondLabel = [model.secondString boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, __FLT_MAX__) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:25]} context:nil].size;

    return CGSizeMake(sizeForFirstLabel.width + sizeForSecondLabel.width, MAX(sizeForFirstLabel.height, sizeForSecondLabel.height));
    
}

#pragma mark - lazyLoading

- (UICollectionView *)collectionView {
    
    if (_collectionView) {
        
        return _collectionView;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.estimatedItemSize = CGSizeMake(100, 50);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.center.y, self.view.frame.size.width, self.view.frame.size.height/15) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor yellowColor];
    [_collectionView registerClass:[LCHCollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
    
    return _collectionView;
}

- (NSArray *)models {
    
    if (_models) {
        
        return _models;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Model" ofType:@"plist"];
    NSArray *dics = [[NSArray alloc] initWithContentsOfFile:path];
    NSMutableArray *tem = [[NSMutableArray alloc] initWithCapacity:dics.count];
    for (NSDictionary *dic in dics) {
        LCHModel *model = [[LCHModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [tem addObject:model];
    }
    _models = [[NSArray alloc] initWithArray:tem copyItems:NO];
    
    return _models;
}

@end
