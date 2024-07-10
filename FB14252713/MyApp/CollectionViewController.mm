//
//  CollectionViewController.mm
//  MyApp
//
//  Created by Jinwoo Kim on 7/10/24.
//

#import "CollectionViewController.h"
#import "ModernTabBarController.h"
#import "LegacyTabBarController.h"

NSArray *viewControllerClasses = @[
    ModernTabBarController.class,
    LegacyTabBarController.class
];

@interface CollectionViewController ()
@property (retain, readonly, nonatomic) UICollectionViewCellRegistration *cellRegistration;
@end

@implementation CollectionViewController
@synthesize cellRegistration = _cellRegistration;

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    self = [super initWithCollectionViewLayout:collectionViewLayout];
    return self;
}

- (void)dealloc {
    [_cellRegistration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cellRegistration];
}

- (UICollectionViewCellRegistration *)cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, Class viewControllerClass) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = NSStringFromClass(viewControllerClass);
        
        cell.contentConfiguration = contentConfiguration;
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return viewControllerClasses.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:viewControllerClasses[indexPath.item]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    __kindof UIViewController *rootViewController = [viewControllerClasses[indexPath.item] new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [rootViewController release];
    
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navigationController animated:YES completion:nil];
    [navigationController release];
}

@end
