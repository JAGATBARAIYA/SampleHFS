//
//  RBImagePickerController.m
//  RBImagePicker
//
//  Created by Roshan Balaji on 1/31/14.
//  Copyright (c) 2014 Uniq Labs. All rights reserved.
//

#import "RBImagePickerController.h"

@interface RBImagePickerController ()

@end

@implementation RBImagePickerController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMaxSelectionCount:1];
    [self setMinSelectionCount:0];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = LINE_SPACING;
    layout.minimumLineSpacing = LINE_SPACING;
    [self.collectionView setCollectionViewLayout:layout];
    [self.collectionView registerClass:[RBImageCollectionCell class] forCellWithReuseIdentifier:CELLIDENTIFIER];

    self.selected_images = [[NSMutableDictionary alloc] init];
    self.selected_images_index = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchAssets];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchAssets {
    _assets = [@[] mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    
    _assetslibrary = [self defaultAssetsLibrary];
    [_assetslibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result)
            {
                if([[result valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]){
                    [tmpAssets addObject:result];
                }
            }
        }];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"assetDate" ascending:NO];
        self.assets = [tmpAssets sortedArrayUsingDescriptors:@[sort]];
        
        [self.collectionView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
    }];
}

- (IBAction)btnBackTapped:(id)sender{
    [self onCancel:nil];
}

-(void)onCancel:(id)sender{
    if([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)])
        [self.delegate imagePickerControllerDidCancel:self];
    else
       [self.navigationController popViewControllerAnimated:YES];
}

-(void)finishPickingImages{
    [self.delegate imagePickerController:self didFinishPickingImagesWithURL:[self getSelectedAssets]];
}

-  (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count + 1;
}

- (RBImageCollectionCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RBImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLIDENTIFIER forIndexPath:indexPath];
    
    if(indexPath.row == 0)
    {
        cell.assetImage.contentMode = UIViewContentModeCenter;
        cell.assetImage.image =[UIImage imageNamed:@"add_photo"];
        [cell.contentView addSubview:cell.assetImage];
    }
    else {
        cell.assetImage.image =[UIImage imageNamed:@"add_photo"];
        ALAsset *asset = self.assets[indexPath.row - 1];
//        [cell setImageAsset:asset];
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
//            ALAssetRepresentation *rep = [myasset defaultRepresentation];
            @autoreleasepool {
                CGImageRef iref = [myasset aspectRatioThumbnail];
                if (iref) {
                    UIImage *image = [UIImage imageWithCGImage:iref];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //UIMethod trigger...
                        [cell.assetImage setImage:image];
                    });
                    iref = nil;
                }
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror) {
            NSLog(@"Can't get image - %@",[myerror localizedDescription]);
        };
        
        [_assetslibrary assetForURL:[[asset defaultRepresentation] url]
                       resultBlock:resultblock
                      failureBlock:failureblock];
        
        
        
        cell.assetImage.contentMode = UIViewContentModeScaleToFill;

        [cell.contentView addSubview:cell.assetImage];
        
        if([self selectionType] != RBSingleImageSelectionType ){
            if([self.selected_images_index containsObject:indexPath]){
                [cell highlightCell];
            }
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout  *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/2 - LINE_SPACING, collectionView.frame.size.width/2 - LINE_SPACING);
}

-(NSArray *)getSelectedAssets{
    return [self.selected_images allValues];
}

-(BOOL)didReachMaxCount
{
    
    if([self.selected_images_index count] <= self.maxSelectionCount || self.maxSelectionCount == 0)
    {
        
        return NO;
        
    }
    
    return YES;
    
}

-(BOOL)didReachMinCount
{
    if([self.selected_images_index count] < self.minSelectionCount )
    {
        return NO;
    }
    return YES;
}

-(void)selectAssestAtIndexPath:(NSIndexPath* )indexPath
{
    ALAsset *asset = self.assets[indexPath.row-1];
    // ALAssetRepresentation *defaultRep = [asset defaultRepresentation];
    //UIImage *image = [UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0];
    [self.selected_images setObject:[[asset defaultRepresentation] url] forKey:indexPath];
    [self.selected_images_index addObject:indexPath];
}

-(void)deselectSelectedImageFromIndexpath:(NSIndexPath *)indexPath
{
    [self.selected_images removeObjectForKey:indexPath];
    [self.selected_images_index removeObject:indexPath];
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _imagePickerController = [[UIImagePickerController alloc] init];
            [_imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            [_imagePickerController setDelegate:self];
            [self presentViewController:_imagePickerController animated:YES completion:nil];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera not available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }
    else {
        if(![self.selected_images_index containsObject:indexPath]){
            [self selectAssestAtIndexPath:indexPath];
        }
        else{
            [self deselectSelectedImageFromIndexpath:indexPath];
        }
        if([self selectionType] == RBSingleImageSelectionType){
            [self finishPickingImages];
        }
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self performSelector:@selector(reloadCollectionView) withObject:nil afterDelay:1.0];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadCollectionView{
    [self fetchAssets];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
