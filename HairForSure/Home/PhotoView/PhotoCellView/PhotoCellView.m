//
//  PhotoCellView.m
//  HairForSure
//
//  Created by Manish on 06/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "PhotoCellView.h"
#import "CustomCell.h"
#import "Photos.h"
#import "SIAlertView.h"
#import "Common.h"
#import "Helper.h"
#import "AppDelegate.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface PhotoCellView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PhotoCellView
AppDelegate *app;

- (void)awakeFromNib {
    
    app =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(150.0, 150.0);
    [self.collectionView setCollectionViewLayout:flowLayout];
    [_collectionView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellWithReuseIdentifier:@"CustomCell"];
    EdgeInsets = 25;
}

#pragma mark - Getter/Setter overrides
- (void)setCollectionData:(NSArray *)collectionData {
    _collectionData = collectionData;
    [_collectionView setContentOffset:CGPointZero animated:NO];
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCell" forIndexPath:indexPath];
    Photos *photo = [self.collectionData objectAtIndex:[indexPath row]];
//    [cell.articleImage setImage:[UIImage imageWithContentsOfFile:photo.strPhotoURL]];
    [cell.articleImage sd_setImageWithURL:[NSURL fileURLWithPath:photo.strPhotoURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         [cell.articleImage setImage:image];
     }];

    [cell.btnDelete addTarget:self action:@selector(btnDeleteTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDelete.tag = indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Photos *photo = [self.collectionData objectAtIndex:[indexPath row]];
    photo.indexPath = photo.intPhotoID;
    
    app.strTag = [NSString stringWithFormat:@"%ld",(long)photo.intPhotoID];
    
    [Helper addIntToUserDefaults:0 forKey:@"DeleteImage"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionView" object:photo];
}

- (void)btnDeleteTapped:(UIButton*)sender{
    Photos *photo = [self.collectionData objectAtIndex:sender.tag];
    photo.indexPath = sender.tag;
    [Helper addIntToUserDefaults:1 forKey:@"DeleteImage"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionView" object:photo];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = [UIScreen mainScreen].bounds.size.width-(EdgeInsets);
    return CGSizeMake(width/2, width/2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(7, 7, 7, 7);
}

@end
