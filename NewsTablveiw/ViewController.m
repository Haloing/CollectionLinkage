//
//  ViewController.m
//  NewsTablveiw
//
//  Created by Mac OS X on 2016/11/16.
//  Copyright © 2016年 Haooing. All rights reserved.
//

#import "ViewController.h"
#import "TopLabel.h"
#import "NewsCollectionCell.h"

@interface ViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSMutableArray *labelArray;

@end

static NSString *collectionCell = @"collectionCell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataArray = [self loadData];
    
    //创建一个可变数组。用于存储创建的label
    self.labelArray = [NSMutableArray arrayWithCapacity:self.dataArray.count];
    
    [self creatTopLabel];
    
    [self setupCollectionView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.collectionLayout.itemSize = self.collectionView.bounds.size;
    
}

- (void)creatTopLabel{
    
    float labelW = 85;
    float labelH = 44;
    float labelY = 0;
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        float labelX = i * labelW;
        
        TopLabel *label = [[TopLabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        
        label.backgroundColor = [UIColor grayColor];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.font = [UIFont systemFontOfSize:17];
        
        label.text = self.dataArray[i];
        
        [self.topScrollView addSubview:label];
        
        //label的用户交互默认关闭，需要手动开启UIImageViewy也是
        label.userInteractionEnabled = YES;
        
        //设置一个tag值，后面会用到
        label.tag = i;
        
        //给每个label添加一个tap手势，用来监听label的点击从而联动UIscrolview
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        [label addGestureRecognizer:tap];
        
        if (i == 0) {
            
            label.scale = 1;
            
        }
        
        [self.labelArray addObject:label];
        
    }
    
    //初始化scrollView
    self.topScrollView.contentSize = CGSizeMake(labelW * self.dataArray.count, 0);
    
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    
    self.topScrollView.bounces = NO;
    
    self.topScrollView.backgroundColor = [UIColor grayColor];
    
}

//实现tap手势点击方法
- (void)tap:(UITapGestureRecognizer *)tap{
    
    //获取点击点击label的tag值
    NSInteger tag = tap.view.tag;
    
    TopLabel *label = self.labelArray[tag];
    
    float offsetX = label.center.x - self.view.bounds.size.width * 0.5;
    
    float minOffsetX = 0;
    
    float maxOffsetX = _topScrollView.contentSize.width - self.view.bounds.size.width;
    
    if (offsetX < 0) {
        
        offsetX = minOffsetX;
        
    }if (offsetX > maxOffsetX) {
        
        offsetX = maxOffsetX;
        
    }
    
    [self.topScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    //点击label联动collection的滚动
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:tag inSection:0];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
}

- (void)setupCollectionView{
    
    self.collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionLayout.minimumLineSpacing = 0;
    
    self.collectionLayout.minimumInteritemSpacing = 0;
    
    self.collectionView.dataSource = self;
    
    self.collectionView.delegate = self;
    
    self.collectionView.pagingEnabled = YES;
    
    self.collectionView.bounces = NO;
    
    self.collectionView.backgroundColor = [UIColor redColor];

}

#warning mark - collection的代理方法，滚动的时候执行
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger current_index = scrollView.contentOffset.x / self.view.bounds.size.width;
    
    float float_index = scrollView.contentOffset.x / self.view.bounds.size.width;
    
    float scale_right = float_index - current_index;
    
    float scale_left = 1 - scale_right;
    
    TopLabel *current_label = self.labelArray[current_index];
    
    //取出右侧label的index
    NSInteger right_index = current_index + 1;
    
    //判断右侧的label是否移动到最后一个
    if (right_index < self.labelArray.count) {
        
        TopLabel *right_label = self.labelArray[right_index];
        
        right_label.scale = scale_right;
        
    }
    
    current_label.scale = scale_left;
    
}

#warning mark - collection的代理方法，停止滚动执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / self.view.bounds.size.width;
    
    //取出选中的label
    TopLabel *label = self.labelArray[index];
    
    float offsetX = label.center.x - self.view.bounds.size.width * 0.5;
    
    float minOffsetX = 0;
    
    float maxOffsetX = _topScrollView.contentSize.width - self.view.bounds.size.width;
    
    if (offsetX < 0) {
        
        offsetX = minOffsetX;
        
    }if (offsetX > maxOffsetX) {
        
        offsetX = maxOffsetX;
        
    }
    
    [self.topScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];

}

#warning mark - 实现collection的数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    
    return cell;
    
}

//加载plist数据
- (NSArray *)loadData{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"LabelNameList.plist" ofType:nil];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    
    return array;
    
}
@end
