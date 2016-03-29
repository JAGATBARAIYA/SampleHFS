//
//  PhotoDetailViewController.m
//  HairForSure
//
//  Created by Manish on 10/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "Helper.h"
#import "SQLiteManager.h"
#import "UIKit+AFNetworking.h"
#import "DetailCell.h"
#import "AppDelegate.h"
#import "SIAlertView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#define kTableName                @"tblPhotos"

@interface PhotoDetailViewController ()<UIGestureRecognizerDelegate>
{
    BOOL isScroll;
}



@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIView *viewBig;
@property (strong, nonatomic) NSMutableArray *arrImages;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation PhotoDetailViewController
AppDelegate *app;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    isScroll = YES;
    [self commonInit];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    _arrImages = [[NSMutableArray alloc]init];
    [_arrImages removeAllObjects];

    NSArray *data  = [[SQLiteManager singleton]executeSql:@"SELECT * from tblPhotos order by date desc"];
    if (data.count == 0) {
        [self btnBackTapped:nil];
    }else{
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Photos *photos = [Photos dataWithInfo:obj];
            [_arrImages addObject:photos];
        }];
        [_collectionView reloadData];
        [Helper addIntToUserDefaults:0 forKey:@"PhotoShow"];
        
        [self.view layoutIfNeeded];
        
        if (isScroll)
        {
            NSLog(@"%ld",(long)_photos.intSection);
            
           // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_photos.indexPath inSection:_photos.intSection];
           
            
            //-------
            
            NSInteger ii =[app.strTag integerValue];
         
            NSPredicate *preone = [NSPredicate predicateWithFormat:@"self.intPhotoID = %d",ii];
            NSUInteger index = [_arrImages  indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                return [preone evaluateWithObject:obj];
            }];
            
            NSLog(@"index:::%lu",(unsigned long)index);
            
            
            //---------
            
            NSIndexPath *aIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
            
            [self.collectionView scrollToItemAtIndexPath:aIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            isScroll = NO;
        }
    }
}

- (IBAction)btnBackTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDeleteTapped:(UIButton *)sender{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Delete" andMessage:@"Are you sure you want to delete this photo?"];
    alertView.buttonsListStyle = SIAlertViewButtonsListStyleNormal;
    [alertView addButtonWithTitle:@"YES"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              NSString *deleteSQL = [NSString stringWithFormat: @"delete from tblPhotos where photoID = %ld",(long)sender.tag];
                              [[SQLiteManager singleton] executeSql:deleteSQL];
                              [Helper addIntToUserDefaults:2 forKey:@"DeleteImage"];
                              [self commonInit];
                          }];
    [alertView addButtonWithTitle:@"NO"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                              
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

#pragma mark - UICollectionView Delegate Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arrImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailCell" forIndexPath:indexPath];
    
    Photos *photo = _arrImages[indexPath.row];
    
    //cell.imgView.image = [UIImage imageWithContentsOfFile:photo.strPhotoURL];
    [cell.imgView sd_setImageWithURL:[NSURL fileURLWithPath:photo.strPhotoURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         [cell.imgView setImage:image];
     }];

    cell.btnDelete.tag = [[[_arrImages objectAtIndex:indexPath.row] valueForKey:@"intPhotoID"]integerValue];
    [cell.btnBack addTarget:self action:@selector(btnBackTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDelete addTarget:self action:@selector(btnDeleteTapped:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    Photos *photo = _arrImages[indexPath.row];
//    app.strTag = [NSString stringWithFormat:@"%ld",(long)photo.intPhotoID];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

@end
