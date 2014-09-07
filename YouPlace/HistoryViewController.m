//
//  HistoryViewController.m
//  FollowMe
//
//  Created by Jacopo Pappalettera on 12/08/14.
//  Copyright (c) 2014 private. All rights reserved.
//

#import "HistoryViewController.h"
#import "ParseData.h"
#import "MomentCell.h"

@interface HistoryViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSArray *dataSource;
@end

@implementation HistoryViewController
-(NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc]init];
    }
    return _dataSource;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor  = [UIColor whiteColor];
    [self loadDataFromParse];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(300, 100);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    Moment *singleMoment = [self.dataSource objectAtIndex:indexPath.row];
    
    if ([cell isKindOfClass:[MomentCell class]]) {
        MomentCell *momCell = (MomentCell *)cell;
        momCell.title.text = singleMoment.place.name;
    }
    
    return cell;
}
#pragma mark - data loading -
-(void)loadDataFromParse
{
    [ParseData getMomentsFromServerSuccess:^(NSArray *moments) {
        
        self.dataSource = moments;
        [self.collectionView reloadData];
    } failure:^{
        
    }];
}
@end
