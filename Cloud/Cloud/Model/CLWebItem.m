//
//  CLWebItem.m
//  Cloud
//
//  Created by Nick Paulson on 7/20/10.
//  Copyright 2010 Linebreak. All rights reserved.
//

#import "CLWebItem.h"

#import "SharingOption.h"
#import <UIKit/UIKit.h>

#import "NSString+Substrings.h"

static NSString * const CLWebItemNameKey       = @"CLWebItemNameKey";
static NSString * const CLWebItemTypeKey       = @"CLWebItemTypeKey";
static NSString * const CLWebItemContentURLKey = @"CLWebItemContentURLKey";
static NSString * const CLWebItemURLKey        = @"CLWebItemURLKey";
static NSString * const CLWebItemMimeTypeKey   = @"CLWebItemMimeTypeKey";
static NSString * const CLWebItemViewCountKey  = @"CLWebItemViewCountKey";
static NSString * const CLWebItemRemoteURLKey  = @"CLWebItemRemoteURLKey";
static NSString * const CLWebItemHrefKey       = @"CLWebItemHrefKey";
static NSString * const CLWebItemIconURLKey    = @"CLWebItemIconURLKey";
static NSString * const CLWebItemIconKey       = @"CLWebItemIconKey";
static NSString * const CLWebItemTrashedKey    = @"CLWebItemTrashedKey";
static NSString * const CLWebItemPrivateKey    = @"CLWebItemPrivateKey";
static NSString * const CLWebItemCreatedAtKey  = @"CLWebItemCreatedAtKey";
static NSString * const CLWebItemUpdatedAtKey  = @"CLWebItemUpdatedAtKey";
static NSString * const CLWebItemDeletedAtKey  = @"CLWebItemDeletedAtKey";
static NSString * const CLWebItemThumbnailURLKey  = @"CLWebItemThumbnailURLKey";

@implementation CLWebItem

@synthesize name = _name, type = _type, contentURL = _contentURL, mimeType = _mimeType,
viewCount = _viewCount, remoteURL = _remoteURL,  href = _href, URL = _URL, iconURL = _iconURL,
icon = _icon, trashed = _trashed, private = _private, createdAt = _createdAt,
updatedAt = _updatedAt, deletedAt = _deletedAt, thumbnailURL = _thumbnailURL;

- (id)init
{
    return [self initWithName:nil];
}

- (id)initWithName:(NSString *)theName
{
    return [self initWithName:theName type:CLWebItemTypeNone viewCount:0];
}

- (id)initWithName:(NSString *)theName type:(CLWebItemType)theType viewCount:(NSInteger)theCount
{
    if ((self = [super init])) {
        _name      = [theName copy];
        _type      = theType;
        _viewCount = theCount;
    }
    return self;
}

+ (id)webItem
{
    return [[[self class] alloc] init];
}

+ (id)webItemWithName:(NSString *)theName
{
    return [[[self class] alloc] initWithName:theName];
}

+ (id)webItemWithName:(NSString *)theName type:(CLWebItemType)theType viewCount:(NSInteger)theCount
{
    return [[[self class] alloc] initWithName:theName type:theType viewCount:theCount];
}

- (NSString *)description
{
    static NSString *format = @"<%@: %@ (%i) %@ private:%d>";
    return [NSString stringWithFormat:format, NSStringFromClass([self class]), self.name, self.viewCount, self.URL, self.private];
}

- (BOOL)isEqual:(id)object {
    CLWebItem *anotherItem = object;
    
    return [self.contentURL isEqual:anotherItem.contentURL];
}
#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    CLWebItem *retItem = [[[self class] alloc] initWithName:self.name type:self.type viewCount:self.viewCount];
    retItem.contentURL = self.contentURL;
    retItem.mimeType   = self.mimeType;
    retItem.remoteURL  = self.remoteURL;
    retItem.href       = self.href;
    retItem.trashed    = self.trashed;
    retItem.private    = self.private;
    retItem.iconURL    = self.iconURL;
    retItem.icon       = self.icon;
    retItem.URL        = self.URL;
    retItem.thumbnailURL = self.thumbnailURL;
    
    return retItem;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        if ([decoder allowsKeyedCoding]) {
            _name       = [decoder decodeObjectForKey:CLWebItemNameKey];
            _type       = [decoder decodeIntegerForKey:CLWebItemTypeKey];
            _viewCount  = [decoder decodeIntegerForKey:CLWebItemViewCountKey];
            _contentURL = [decoder decodeObjectForKey:CLWebItemContentURLKey];
            _URL        = [decoder decodeObjectForKey:CLWebItemURLKey];
            _mimeType   = [decoder decodeObjectForKey:CLWebItemMimeTypeKey];
            _remoteURL  = [decoder decodeObjectForKey:CLWebItemRemoteURLKey];
            _href       = [decoder decodeObjectForKey:CLWebItemHrefKey];
            _trashed    = [decoder decodeBoolForKey:CLWebItemTrashedKey];
            _private    = [decoder decodeBoolForKey:CLWebItemPrivateKey];
            _iconURL    = [decoder decodeObjectForKey:CLWebItemIconURLKey];
            _icon       = [decoder decodeObjectForKey:CLWebItemIconKey];
            _createdAt  = [decoder decodeObjectForKey:CLWebItemCreatedAtKey];
            _updatedAt  = [decoder decodeObjectForKey:CLWebItemUpdatedAtKey];
            _deletedAt  = [decoder decodeObjectForKey:CLWebItemDeletedAtKey];
            _thumbnailURL = [decoder decodeObjectForKey:CLWebItemThumbnailURLKey];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    if ([encoder allowsKeyedCoding]) {
        [encoder encodeObject:self.name forKey:CLWebItemNameKey];
        [encoder encodeInteger:self.type forKey:CLWebItemTypeKey];
        [encoder encodeInteger:self.viewCount forKey:CLWebItemViewCountKey];
        [encoder encodeObject:self.contentURL forKey:CLWebItemContentURLKey];
        [encoder encodeObject:self.URL forKey:CLWebItemURLKey];
        [encoder encodeObject:self.mimeType forKey:CLWebItemMimeTypeKey];
        [encoder encodeObject:self.remoteURL forKey:CLWebItemRemoteURLKey];
        [encoder encodeObject:self.href forKey:CLWebItemHrefKey];
        [encoder encodeBool:self.trashed forKey:CLWebItemTrashedKey];
        [encoder encodeBool:self.private forKey:CLWebItemPrivateKey];
        [encoder encodeObject:self.icon forKey:CLWebItemIconKey];
        [encoder encodeObject:self.iconURL forKey:CLWebItemIconURLKey];
        [encoder encodeObject:self.createdAt forKey:CLWebItemCreatedAtKey];
        [encoder encodeObject:self.updatedAt forKey:CLWebItemUpdatedAtKey];
        [encoder encodeObject:self.deletedAt forKey:CLWebItemDeletedAtKey];
        [encoder encodeObject:self.thumbnailURL forKey:CLWebItemThumbnailURLKey];
    }
}

+ (NSString *)iconImageFileNameForWebItemType:(CLWebItemType)type {
    switch (type) {
        case CLWebItemTypeArchive:
            return @"Archives";
            break;
            
        case CLWebItemTypeAudio:
            return @"Audio";
            break;
        case CLWebItemTypeBookmark:
            return @"Bookmarks";
            break;
        case CLWebItemTypeImage:
            return @"Images";
            break;
        case CLWebItemTypeText:
            return @"Text";
            break;
            
        case CLWebItemTypeVideo:
            return @"Video";
            break;
            
        case CLWebItemTypeNone:
            return @"None";
            break;
            
        default:
            return @"Other";
            break;
    }
}

+ (UIImage *)iconImageForWebItemType:(CLWebItemType)type {
    NSString *fileName = [self iconImageFileNameForWebItemType:type];
    
    return [UIImage imageNamed:fileName];
}

+ (UIImage *)largeIconImageForWebItemType:(CLWebItemType)type {
    NSString *fileName = [self iconImageFileNameForWebItemType:type];
    
    return [UIImage imageNamed:[fileName stringByAppendingString:@"-Big"]];
}

+ (CLWebItemType)webItemTypeForFilenameExtension:(NSString *)fileNameExtension {
    if ([fileNameExtension containsSubstringInArray:@[@"gtar", @"gz", @"rar", @"sit", @"tar", @"zip"]]) {
        return CLWebItemTypeArchive;
    } else if ([fileNameExtension containsSubstringInArray:@[@"aif", @"aifc", @"aiff", @"amr", @"anx", @"au", @"awb", @"axa", @"ecelp4800", @"ecelp7470", @"ecelp9600", @"eol", @"evc", @"flac", @"kar", @"l16", @"lvp", @"m4a", @"mid", @"midi", @"mp2", @"mp3", @"mpga", @"mxmf", @"oga", @"ogg", @"ogx", @"plj", @"qcp", @"ra", @"ram", @"rm", @"rpm", @"s1m", @"smp", @"smp3", @"smv", @"snd", @"spx", @"vbk", @"wav"]]) {
        return CLWebItemTypeAudio;
    } else if ([fileNameExtension containsSubstringInArray:@[@"bmp", @"dgn", @"djv", @"djvu", @"dwg", @"gif", @"ico", @"ief", @"jp2", @"jpe", @"jpeg", @"jpf", @"jpg", @"jpg2", @"jpgm", @"jpm", @"jpx", @"mdi", @"pbm", @"pgb", @"pgm", @"png", @"pnm", @"ppm", @"psp", @"pspimage", @"ras", @"rgb", @"s1g", @"s1j", @"s1n", @"sgi", @"sgif", @"sjp", @"sjpg", @"spn", @"spng", @"svg", @"tga", @"tif", @"tiff", @"wbmp", @"xbm", @"xpm", @"xwd"]]) {
        return CLWebItemTypeImage;
    } else if ([fileNameExtension containsSubstringInArray:@[@"atom", @"c", @"cc", @"ccp", @"css", @"csv", @"dtd", @"h", @"hh", @"hpp", @"htc", @"htm", @"html", @"js", @"json", @"kml", @"markdown", @"md", @"mdown", @"php", @"pht", @"phtml", @"pl", @"pm", @"py", @"rb", @"rhtml", @"rst", @"sgm", @"sgml", @"sh", @"shtml", @"t", @"tcl", @"tsv", @"txt", @"wml", @"xhtml", @"xls", @"xlsx", @"xlt", @"xslt", @"xul", @"yaml", @"yml", @"swift", @"h", @"m"]]) {
        return CLWebItemTypeText;
    } else if ([fileNameExtension containsSubstringInArray:@[@"3g2", @"3gp", @"3gpp", @"asf", @"asx", @"avi", @"dl", @"fli", @"gl", @"m4u", @"m4v", @"mj2", @"mjp2", @"mov", @"movie", @"mp3g", @"mp4", @"mpe", @"mpg", @"mxu", @"nim", @"ogv", @"qt", @"s11", @"s14", @"s1q", @"smo", @"smov", @"smpg", @"ssw", @"sswf", @"viv", @"vivo", @"wmv"]]) {
        return CLWebItemTypeVideo;
    }
    
    return CLWebItemTypeUnknown;
}

- (BOOL)isMarkdownText {
    return self.type == CLWebItemTypeText && [@[@"markdown", @"md", @"mdown", @"txt"] containsObject:self.contentURL.pathExtension.lowercaseString];
}
@end
