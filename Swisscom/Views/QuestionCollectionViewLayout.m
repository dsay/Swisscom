//
//  QuestionCollectionViewLayout.m
//  Swisscom
//
//  Created by Anatoly Tukhtarov on 1/31/15.
//  Copyright (c) 2015 Dima Sai. All rights reserved.
//

#import "QuestionCollectionViewLayout.h"
#import "QuestionDataSource.h"

@interface CollectionViewLayoutInvalidationContext : UICollectionViewFlowLayoutInvalidationContext
@property (nonatomic, assign) BOOL invalidateLayoutMetrics;
@end

@implementation CollectionViewLayoutInvalidationContext
@end

@interface QuestionCollectionViewLayout ()
@property (nonatomic, strong) NSMutableDictionary *itemSizesByIndexPath;
@property (nonatomic, strong) NSMutableDictionary *itemAttributesByIndexPath;
@property (nonatomic, strong) NSMutableDictionary *headerSizesByIndexPath;
@property (nonatomic, strong) NSMutableDictionary *headerAttributesByIndexPath;
@property (nonatomic, strong) NSMutableArray *layoutAttributes;
@property (nonatomic, strong) NSMutableDictionary *itemsOffsetBySection;
@property (nonatomic, assign) BOOL preparingLayout;
@property (nonatomic, assign) BOOL invalidatingLayout;
@end

@implementation QuestionCollectionViewLayout

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _itemAttributesByIndexPath = [NSMutableDictionary dictionary];
        _itemSizesByIndexPath = [NSMutableDictionary dictionary];
        _headerAttributesByIndexPath = [NSMutableDictionary dictionary];
        _headerSizesByIndexPath = [NSMutableDictionary dictionary];
        _layoutAttributes = [NSMutableArray array];
        _itemsOffsetBySection = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)prepareLayout {
    if (self.preparingLayout) {
        return;
    }
    
    self.preparingLayout = YES;
    if (!self.invalidatingLayout) {
        [self.layoutAttributes removeAllObjects];
        [self.itemAttributesByIndexPath removeAllObjects];
        [self.itemSizesByIndexPath removeAllObjects];
        [self.itemsOffsetBySection removeAllObjects];
        [self.headerAttributesByIndexPath removeAllObjects];
        [self.headerSizesByIndexPath removeAllObjects];
        
        QuestionDataSource *dataSource = (QuestionDataSource *)self.collectionView.dataSource;
        if (![dataSource isKindOfClass:[QuestionDataSource class]]) {
            dataSource = nil;
        }
        
        NSInteger numberOfSections = [self.collectionView numberOfSections];
        for (NSInteger section = 0; section < numberOfSections; ++section) {
            NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
            for (NSInteger item = 0; item < numberOfItemsInSection; ++item) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                if (item == 0) {
                    CGSize size = [dataSource collectionView:self.collectionView sizeFittingSize:self.collectionView.bounds.size forSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
                    self.headerSizesByIndexPath[indexPath] = [NSValue valueWithCGSize:size];
                }
                
                CGSize size = [dataSource collectionView:self.collectionView sizeFittingSize:CGSizeMake(100, 100) forItemAtIndexPath:indexPath];
                self.itemSizesByIndexPath[indexPath] = [NSValue valueWithCGSize:size];
            }
        }
        self.invalidatingLayout = YES;
        [self invalidateLayout];
    }
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numberOfSections; ++section) {
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < numberOfItemsInSection; ++item) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            if (item == 0) {
                UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
                self.headerAttributesByIndexPath[indexPath] = attributes;
                [self.layoutAttributes addObject:attributes];
            }
            
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            self.itemAttributesByIndexPath[indexPath] = attributes;
            [self.layoutAttributes addObject:attributes];
        }
    }
    self.preparingLayout = NO;
    self.invalidatingLayout = NO;
    [super prepareLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attribute in self.layoutAttributes) {
        if (CGRectIntersectsRect(rect, attribute.frame)) {
            [attributes addObject:attribute];
        }
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = self.itemAttributesByIndexPath[indexPath];
    if (attributes) {
        return attributes;
    }
    
    attributes = [[self.class layoutAttributesClass] layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = [self frameForItemAtIndexPath:indexPath];
    
    if (!self.preparingLayout) {
        self.itemAttributesByIndexPath[indexPath] = attributes;
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = self.headerAttributesByIndexPath[indexPath];
    if (attributes) {
        return attributes;
    }
    
    attributes = [[self.class layoutAttributesClass] layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    attributes.frame = [self frameForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    
    if (!self.preparingLayout) {
        self.headerAttributesByIndexPath[indexPath] = attributes;
    }
    
    return attributes;
}

- (CGSize)collectionViewContentSize {
    return self.collectionView.bounds.size;
}

- (CGRect)frameForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CGRect frame;
    /// TODO: support multiple sections
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        frame.origin = CGPointZero;
        frame.size = [self.headerSizesByIndexPath[indexPath] CGSizeValue];
    }
    return frame;
}

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath {
    /// TODO: support multiple sections
    CGRect frame;
    frame.size = [self.itemSizesByIndexPath[indexPath] CGSizeValue];
    
    CGFloat topOffset = 0;
    NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.section];
    CGRect headerFrame = [self frameForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:headerIndexPath];
    topOffset += CGRectGetMaxY(headerFrame);
    
    frame.origin.y = topOffset;
    
    CGFloat leftOffset = [self offsetOfItemsInSection:indexPath.section];
    for (NSInteger item = 0; item < indexPath.item; ++item) {
        NSIndexPath *ip = [NSIndexPath indexPathForItem:item inSection:indexPath.section];
        leftOffset += [self.itemSizesByIndexPath[ip] CGSizeValue].width;
    }
    frame.origin.x = leftOffset;
    
    return frame;
}

- (CGFloat)offsetOfItemsInSection:(NSInteger)section {
    __block CGFloat itemsWidth = 0;
    [self.itemSizesByIndexPath enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *key, NSValue *obj, BOOL *stop) {
        if (key.section == section) {
            itemsWidth += [obj CGSizeValue].width;
        }
    }];
    
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds);
    CGFloat itemsOffset = (collectionViewWidth - itemsWidth) / 2.0;
    self.itemsOffsetBySection[@(section)] = @(itemsWidth);
    return itemsOffset;
}
@end