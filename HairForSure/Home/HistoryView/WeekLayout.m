//
//  WeekLayout.m
//  HairForSure
//
//  Created by Manish Dudharejia on 01/07/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "WeekLayout.h"
#import "Common.h"

@implementation WeekLayout

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = CGRectMake(0, 0, self.collectionView.frame.size.width/4, 170);

    CGFloat yTopCell;
    CGFloat yBottomCell;

    if (IPHONE4) {
        yTopCell = 10;
        yBottomCell = frame.size.height-10;
    }else{
       yTopCell = IPHONE6PLUS ? 60 : (IPHONE6 ? 40 : 20);
       yBottomCell = frame.size.height + (IPHONE6PLUS ? 120 : (IPHONE6 ? 80 : 40));
    }

    if(indexPath.row >= 4) {
        frame.origin.y = yBottomCell;
        frame.origin.x = frame.size.width * (indexPath.item - 4) + (frame.size.width/2);
    }
    else {
        frame.origin.y = yTopCell;
        frame.origin.x = frame.size.width * indexPath.item;
    }
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = frame;
    return attributes;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for(NSInteger i = 0, size = 7; i<size; i++ )
    {
        UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if( CGRectIntersectsRect( attributes.frame, rect) )
            [array addObject:attributes];
    }
    return [NSArray arrayWithArray:array];
}

@end
