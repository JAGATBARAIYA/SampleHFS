//
//  AFBlockAttributedLabel.m
//  AFBlockAttributedLabel
//
//  Created by Daniel Kuhnke on 27.02.15.
//  Copyright (c) 2015 appfarms GmbH & Co. KG. All rights reserved.
//

#import "AFBlockAttributedLabel.h"

#define kDidSelectLinkWithURLBlockKey @"kDidSelectLinkWithURLBlockKey"

@interface AFBlockAttributedLabel () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) NSMutableDictionary * blocks;

@end

@implementation AFBlockAttributedLabel

- (void) setHTML:(NSString *)html
{
  [self setHTML:html andDidSelectLinkWithURLBlock:nil];
}

- (void) setHTML:(NSString *)html andDidSelectLinkWithURLBlock:(void(^)(NSURL * url))block
{
  [self setHTML:html linkAttributes:[AFBlockAttributedLabel defaultLinkAttributes] activeLinkAttributes:[AFBlockAttributedLabel defaultActiveLinkAttributes] andDidSelectLinkWithURLBlock:block];
}

- (void) setHTML:(NSString *)html linkAttributes:(NSDictionary *)linkAttributes activeLinkAttributes:(NSDictionary *)activeLinkAttributes andDidSelectLinkWithURLBlock:(void(^)(NSURL * url))block
{
  self.numberOfLines = 0;
  self.enabledTextCheckingTypes = NSTextCheckingTypeLink;
  self.linkAttributes           = linkAttributes;
  self.activeLinkAttributes     = activeLinkAttributes;
  self.text                     = [self attributedStringByHTML:html];
  [self setDidSelectLinkWithURLBlock:block];
}

+ (NSMutableAttributedString *) attributedStringByHTML:(NSString *)html withFont:(UIFont *)font andTextColor:(UIColor *)textColor
{
  if (!html || [html isKindOfClass:[NSString class]] == NO)
  {
    html = @"";
  }

  if (!font || [font isKindOfClass:[UIFont class]] == NO)
  {
    font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
  }

  if (!textColor || [textColor isKindOfClass:[UIColor class]] == NO)
  {
    textColor = [UIColor blackColor];
  }

  NSDictionary * documentAttributes = nil;
  NSError      * error              = nil;

  CGFloat r, g, b, a;
  [textColor getRed:&r green:&g blue:&b alpha:&a];

  html = [NSString stringWithFormat:@"<html><head><style>body { font-family: '%@'; font-size:%fpx; margin: 0px; padding: 0px; color: rgb(%d,%d,%d); }</style></head><body>%@</body></html>", font.fontName, font.pointSize, (int)(r*255), (int)(g*255), (int)(b*255), html];

  NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding]
                                                                               options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding) }
                                                                    documentAttributes:&documentAttributes
                                                                                 error:&error];

  return (string && [string isKindOfClass:[NSMutableAttributedString class]]) ? string : nil;
}

- (NSMutableAttributedString *) attributedStringByHTML:(NSString *)html
{
  return [AFBlockAttributedLabel attributedStringByHTML:html
                                               withFont:self.font
                                           andTextColor:self.textColor];
}

#pragma mark - Getter

- (NSMutableDictionary *)blocks
{
  if (!_blocks || [_blocks isKindOfClass:[NSMutableDictionary class]] == NO)
  {
    _blocks = [NSMutableDictionary dictionary];
  }

  return _blocks;
}

#pragma mark - Setter

- (void) setDidSelectLinkWithURLBlock:(void(^)(NSURL * url))block
{
  self.delegate = self;
  if (block)
  {
    self.blocks[kDidSelectLinkWithURLBlockKey] = [block copy];
  }
  else
  {
    [self.blocks removeObjectForKey:kDidSelectLinkWithURLBlockKey];
  }
}

#pragma mark - TTTAttributedLabelDelegate

- (void) attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
  void(^block)(NSURL * url);
  block = self.blocks[kDidSelectLinkWithURLBlockKey];
  if (block)
  {
    block(url);
  }
}

#pragma mark - Static

+ (NSDictionary *) defaultLinkAttributes
{
  return @{ NSForegroundColorAttributeName: [UIColor orangeColor],
            NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
}

+ (NSDictionary *) defaultActiveLinkAttributes
{
  return @{ NSForegroundColorAttributeName: [UIColor orangeColor],
            NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };
}

@end
