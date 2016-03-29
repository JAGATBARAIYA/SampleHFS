//
//  PhotoViewController.m
//  HairForSure
//
//  Created by Manish on 30/06/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoCell.h"
#import "Photos.h"
#import "SQLiteManager.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "Helper.h"
#import "NSDate+Calendar.h"
#import "PhotoTipsViewController.h"
#import "PhotoDetailViewController.h"
#import "SIAlertView.h"
#import "HistoryViewController.h"
#import "HomeViewController.h"
#import "PECropViewController.h"
#import "RBImagePickerController.h"
#import "UIImage+fixOrientation.h"
#import "PhotoHeaderView.h"
#import "AppDelegate.h"

#define kTableName                @"tblPhotos"

@interface PhotoViewController ()<UIActionSheetDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate,RBImagePickerDelegate>
{
    NSInteger photoID;
    NSInteger numOfPhotos;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrPhotos;
@property (assign, nonatomic) BOOL isBeforeTapped;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) IBOutlet UIView *addview;
@property (strong, nonatomic) IBOutlet UIButton *btnPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lblAddPhoto;
@property (strong, nonatomic) RBImagePickerController *imagePicker;

@end

@implementation PhotoViewController
AppDelegate *app;

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    app =(AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self commonInit];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    _addview.layer.cornerRadius = 25.0;
    _arrPhotos = [[NSMutableArray alloc]init];
    NSMutableArray *arrAllPhotos =[[NSMutableArray alloc]init];
    NSArray *data  = [[SQLiteManager singleton]executeSql:@"SELECT * from tblPhotos order by date desc"];
    [_arrPhotos removeAllObjects];
    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Photos *photos = [Photos dataWithInfo:obj];
        [arrAllPhotos addObject:photos];
    }];
    _addview.hidden = arrAllPhotos.count!=0;
    _lblAddPhoto.hidden = arrAllPhotos.count!=0;
    _btnPhoto.hidden = arrAllPhotos.count!=0;
    [arrAllPhotos enumerateObjectsUsingBlock:^(Photos *photos, NSUInteger idx, BOOL *stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strDate = %@",photos.strDate];
        NSMutableArray *arrTemp = [[arrAllPhotos filteredArrayUsingPredicate:predicate] mutableCopy];
        if([arrTemp count]) {
            if(![arrTemp containsObject:photos]) {
                [arrTemp addObject:photos];
            }
            NSDictionary *dict = @{@"date": photos.strDate,
                                   @"articles":arrTemp};
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"date = %@",photos.strDate];
            NSArray *arr = [_arrPhotos filteredArrayUsingPredicate:predicate1];
            if([arr count]) {
                [_arrPhotos removeObject:[arr objectAtIndex:0]];
            }
            [_arrPhotos addObject:dict];
        }
        else {
            [_arrPhotos addObject:@{@"date": photos.strDate,
                                    @"articles":@[photos]}];
        }
    }];

    if(IPHONE4 || IPHONE5){
        EdgeInsets = 30;
    }else if(IPHONE6 || IPHONE6PLUS){
        EdgeInsets = 30;
    }

    [aCollectionView reloadData];

    self.imagePicker = [[RBImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.selectionType = RBSingleImageSelectionType;
    self.imagePicker.navigationController.navigationItem.leftBarButtonItem.title = @"no";
}

#pragma mark - UICollectionView Delegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(aCollectionView.frame.size.width, 50.f);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        PhotoHeaderView *headerView = (PhotoHeaderView *)[aCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        [headerView.lblDate setText:_arrPhotos[indexPath.section][@"date"]];
        reusableview = headerView;
    }
    
    return reusableview;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_arrPhotos count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_arrPhotos[section][@"articles"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyPhotoCell" forIndexPath:indexPath];
    UIImageView *aImageView = (UIImageView *)[aCell viewWithTag:1000];
    Photos *aPhotos = _arrPhotos[indexPath.section][@"articles"][indexPath.row];
    [aImageView sd_setImageWithURL:[NSURL fileURLWithPath:aPhotos.strPhotoURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        [aImageView setImage:image];
    }];
    
    return aCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoDetailViewController *photoDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoDetailViewController"];
    photoDetailViewController.photos = _arrPhotos[indexPath.section][@"articles"][indexPath.row];
    Photos *photo = _arrPhotos[indexPath.section][@"articles"][indexPath.row];
    photo.indexPath = photo.intPhotoID;
    app.strTag = [NSString stringWithFormat:@"%ld",(long)photo.intPhotoID];
    [Helper addIntToUserDefaults:1 forKey:@"PhotoShow"];
    [self.navigationController pushViewController:photoDetailViewController animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = [UIScreen mainScreen].bounds.size.width-(EdgeInsets);
    return CGSizeMake(width/2, width/2);
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [tableView cellForRowAtIndexPath:0];
    return [_arrPhotos count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 728, 50)];
    sectionView.backgroundColor = [UIColor colorWithRed:170.0 / 255.0 green:147.0 / 255.0 blue:98.0 / 255.0 alpha:1.0f];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 728, 50)];
    titleLabel.textColor = [UIColor whiteColor];
    NSDictionary *sectionData = [_arrPhotos objectAtIndex:section];
    NSString *header = [sectionData objectForKey:@"date"];
    titleLabel.text = header;
    [sectionView addSubview:titleLabel];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    NSDictionary *cellData = [_arrPhotos objectAtIndex:[indexPath section]];
    NSArray *articleData = [cellData objectForKey:@"articles"];
    numOfPhotos = articleData.count;
    [cell.collectionView setCollectionData:articleData];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark UITableViewDelegate methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionData = [_arrPhotos objectAtIndex:section];
    NSString *header = [sectionData objectForKey:@"date"];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (numOfPhotos == 1) {
        if (IPHONE4 || IPHONE5) {
            return 160.0;
        }else if (IPHONE6){
            return 188.0;
        }else if (IPHONE6PLUS){
            return 208.0;
        }
    }else{
        if (IPHONE4 || IPHONE5) {
            return 160.0 * ((numOfPhotos %2 == 0)?numOfPhotos/2:ceilf((numOfPhotos/2))+1);
        }else if (IPHONE6){
            return 188.0 * ((numOfPhotos %2 == 0)?numOfPhotos/2:ceilf((numOfPhotos/2))+1);
        }else if (IPHONE6PLUS){
            return 208.0 * ((numOfPhotos %2 == 0)?numOfPhotos/2:ceilf((numOfPhotos/2))+1);
        }
    }
    return 160.0;
}

#pragma mark - NSNotification to select table cell

- (void)didSelectItemFromCollectionView:(NSNotification *)notification
{
    if ([Helper getIntFromNSUserDefaults:@"PhotoShow"] == 1) {
        
    }else if ([Helper getIntFromNSUserDefaults:@"DeleteImage"] == 1){
        photoID = [[notification.object valueForKey:@"intPhotoID"]integerValue];
        NSString *deleteSQL = [NSString stringWithFormat: @"delete from tblPhotos where photoID = %ld",(long)photoID];
        [[SQLiteManager singleton] executeSql:deleteSQL];
        [Helper addIntToUserDefaults:2 forKey:@"DeleteImage"];
        [self commonInit];
    }
    else if ([Helper getIntFromNSUserDefaults:@"DeleteImage"] == 0){
        PhotoDetailViewController *photoDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoDetailViewController"];
        photoDetailViewController.photos = notification.object;
        [Helper addIntToUserDefaults:1 forKey:@"PhotoShow"];
        [self.navigationController pushViewController:photoDetailViewController animated:YES];
    }
}

#pragma mark - Button Click Event

- (IBAction)btnAddTapped:(id)sender{
    [self showActionSheet];
}

- (IBAction)btnPhotoTipsTapped:(id)sender{
    PhotoTipsViewController *photoTipsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoTipsViewController"];
    [self.navigationController pushViewController:photoTipsViewController animated:YES];
}

- (void)showActionSheet{
    UIActionSheet *act=[[UIActionSheet alloc]initWithTitle:@"Upload Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Camera",@"From Photo Library", nil];
    [act showInView:self.view];
}

#pragma mark - UIActionSheet Delegate Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        @try
        {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.delegate = self;

            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self presentViewController:picker animated:YES completion:nil];
            }];
        }
        @catch (NSException *exception)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Camera is not available  " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
        }
    }
    else if (buttonIndex ==1){

        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:picker animated:YES completion:nil];
        }];
    }
}

#pragma mark - RBImage Picker Delegate Method

-(void)imagePickerController:(RBImagePickerController *)imagePicker didFinishPickingImagesWithURL:(NSArray *)imageURLS{
    for (NSURL *imageURL in imageURLS) {
        NSLog(@"image url %@", imageURL);
        ALAssetsLibrary *assetsLib = [[ALAssetsLibrary alloc]init];
        [assetsLib assetForURL:imageURL resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            CGImageRef imgRef = [rep fullResolutionImage];
            UIImage *img = [UIImage imageWithCGImage:imgRef scale:rep.scale orientation:rep.orientation];
            [self openEditor:img];
            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSError *error) {
            
        }];
    }
}

#pragma mark - image choose from gallery

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditor:image];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePicker{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = kDateFormat;
    NSString *date = [formatter stringFromDate:[NSDate date]];
    double aTimeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *path = [Helper getDocumentDirectoryPath:[NSString stringWithFormat:@"/%.f.png",aTimeStamp]];

    NSData* data = UIImageJPEGRepresentation(croppedImage, 0.8);
    [data writeToFile:path atomically:YES];
    NSMutableArray *arrDatePhotos =[[NSMutableArray alloc]init];
    NSArray *photoData  = [[SQLiteManager singleton]executeSql:@"SELECT * from tblPhotos order by date desc"];
    [photoData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Photos *photos = [Photos dataWithInfo:obj];
        [arrDatePhotos addObject:photos];
    }];
    
    int count = 0;
    int sec = 0;
    for (int i = 0; i < arrDatePhotos.count; i++) {
        if ([date isEqualToString:[[arrDatePhotos objectAtIndex:i] valueForKey:@"strDate"]]) {
            
        }else{
            count++;
            for (int j = 0; j < count; j++) {
                if (count>1) {
                    
                }else{
                    NSString *str = [[arrDatePhotos objectAtIndex:j] valueForKey:@"intSection"];
                    sec = [str intValue];
                    sec++;
                }
            }
        }
    }

    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO tblPhotos (photoURL,date,section) VALUES ('%@','%@',%d)", [NSString stringWithFormat:@"/%.f.png",aTimeStamp],[NSString stringWithFormat:@"%.f",aTimeStamp],sec];
    
    [[SQLiteManager singleton] executeSql:insertSQL];

    for (UIViewController *aVC in self.navigationController.viewControllers){
        if ([aVC isKindOfClass:[HomeViewController class]]){
            HomeViewController *aHomeVC = (HomeViewController *)aVC;
            if ([Helper getIntFromNSUserDefaults:kIsFirstTime] == 1){
            }else{
                [aHomeVC.containerVC scrollToViewAtIndex:0];
                [Helper addIntToUserDefaults:1 forKey:kIsFirstTime];
            }
            break;
        }
    }
    [self commonInit];

}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Action methods

- (IBAction)openEditor:(UIImage *)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = sender;
    
    UIImage *image = sender;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (UIImage *) scaleAndRotateImage: (UIImage *)image
{
    int kMaxResolution = 3000; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef),      CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


@end
