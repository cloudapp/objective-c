// PKMultipartInputStream.h
// py.kerembellec@gmail.com

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTType.h>
#import "PKMultipartInputStream.h"

#ifndef min
#define min(a,b) ((a) < (b) ? (a) : (b))
#endif

@interface PKMultipartElement : NSObject {
    @private
    NSData        *headers;
    NSInputStream *body;
    NSUInteger    headersLength, bodyLength, length, delivered;
}

@end

@implementation PKMultipartElement

- (NSString *)mimeTypeForExtension:(NSString *)extension {
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    if (uti != NULL)
    {
        CFStringRef mime = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType);
        CFRelease(uti);
        if (mime != NULL)
        {
            NSString *type = [NSString stringWithString:(__bridge NSString *)mime];
            CFRelease(mime);
            return type;
        }
    }
    return @"application/octet-stream";
}

- (void)updateLength {
    length = headersLength + bodyLength + 2;
    [body open];
}

- (id)initWithName:(NSString *)name boundary:(NSString *)boundary string:(NSString *)string {
    self = [self init];
    
    if (self) {
        headers       = [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n", boundary, name] dataUsingEncoding:NSUTF8StringEncoding];
        headersLength = [headers length];
        body          = [NSInputStream inputStreamWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
        bodyLength    = [[string dataUsingEncoding:NSUTF8StringEncoding] length];
        [self updateLength];
    }
    
    return self;
}

- (id)initWithName:(NSString *)name boundary:(NSString *)boundary data:(NSData *)data {
    self = [self init];
    
    if (self) {
        headers       = [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n", boundary, name] dataUsingEncoding:NSUTF8StringEncoding];
        headersLength = [headers length];
        body          = [NSInputStream inputStreamWithData:data];
        bodyLength    = [data length];
        
        [self updateLength];
    }
    
    return self;
}
                         
- (id)initWithName:(NSString *)name boundary:(NSString *)boundary path:(NSString *)path {
    return [self initWithName:name boundary:boundary path:path targetFileName:nil];
}

- (id)initWithName:(NSString *)name boundary:(NSString *)boundary path:(NSString *)path targetFileName:(NSString *)targetFileName {
    self = [self init];
    
    if (self) {
        headers       = [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\n\r\n", boundary, name, (targetFileName) ? targetFileName : path.lastPathComponent, [self mimeTypeForExtension:path.pathExtension]] dataUsingEncoding:NSUTF8StringEncoding];
        headersLength = [headers length];
        body          = [NSInputStream inputStreamWithFileAtPath:path];
        bodyLength    = [[[[NSFileManager defaultManager] attributesOfItemAtPath:path error:NULL] objectForKey:NSFileSize] unsignedIntegerValue];
        [self updateLength];
    }
    
    return self;
}
                         
- (NSUInteger)length {
    return length;
}
                         
- (NSUInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len {
    NSUInteger sent = 0, read;

    if (delivered >= length) {
        return 0;
    }
    
    if (delivered < headersLength && sent < len) {
        read       = min(headersLength - delivered, len - sent);
        [headers getBytes:buffer + sent range:NSMakeRange(delivered, read)];
        sent      += read;
        delivered += sent;
    }
    
    while (delivered >= headersLength && delivered < (length - 2) && sent < len) {
        if ((read = [body read:buffer + sent maxLength:len - sent]) == 0) {
            break;
        }
        sent      += read;
        delivered += read;
    }
    
    if (delivered >= (length - 2) && sent < len) {
        if (delivered == (length - 2))
        {
            *(buffer + sent) = '\r';
            sent ++; delivered ++;
        }
        *(buffer + sent) = '\n';
        sent ++; delivered ++;
    }
    
    return sent;
}
                         
@end

@implementation PKMultipartInputStream

- (void)updateLength {
    NSEnumerator *enumerator;
    PKMultipartElement *part;

    length     = footerLength;
    enumerator = parts.objectEnumerator;
    
    while ((part = enumerator.nextObject)) {
        length += [part length];
    }
}
                         
- (id)init {
    self = [super init];
    
    if (self) {
        parts        = [NSMutableArray arrayWithCapacity:1];
        boundary     = [[NSProcessInfo processInfo] globallyUniqueString];
        footer       = [[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding];
        footerLength = footer.length;
        
        [self updateLength];
    }

    return self;
}

- (NSArray *)parts {
    return parts;
}

- (void)addPartWithName:(NSString *)name string:(NSString *)string {
    [parts addObject:[[PKMultipartElement alloc] initWithName:name boundary:boundary string:string]];
    [self updateLength];
}
                         
- (void)addPartWithName:(NSString *)name data:(NSData *)data {
    [parts addObject:[[PKMultipartElement alloc] initWithName:name boundary:boundary data:data]];
    [self updateLength];
}
                         
- (void)addPartWithName:(NSString *)name path:(NSString *)path {
    [self addPartWithName:name path:path targetFileName:nil];
}

- (void)addPartWithName:(NSString *)name path:(NSString *)path targetFileName:(NSString *)targetFileName {
    [parts addObject:[[PKMultipartElement alloc] initWithName:name boundary:boundary path:path targetFileName:targetFileName]];
    [self updateLength];
}
                         
- (NSString *)boundary {
    return boundary;
}
                         
- (NSUInteger)length {
    return length;
}
                         
- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len {
    NSUInteger sent = 0, read;

    status = NSStreamStatusReading;
    
    while (delivered < length && sent < len && currentPart < [parts count])
    {
        if ((read = [[parts objectAtIndex:currentPart] read:buffer + sent maxLength:len - sent]) == 0)
        {
            currentPart ++;
            continue;
        }
        sent      += read;
        delivered += read;
    }
    
    if (delivered >= (length - footerLength) && sent < len) {
        read       = min(footerLength - (delivered - (length - footerLength)), len - sent);
        
        [footer getBytes:buffer + sent range:NSMakeRange(delivered - (length - footerLength), read)];
        
        sent      += read;
        delivered += read;
    }
 
    return sent;
}
                         
- (BOOL)hasBytesAvailable {
    return delivered < length;
}
                         
- (void)open {
    status = NSStreamStatusOpen;
}
                         
- (void)close {
    status = NSStreamStatusClosed;
}
                         
- (NSStreamStatus)streamStatus {
    if (status != NSStreamStatusClosed && delivered >= length) {
        status = NSStreamStatusAtEnd;
    }
    
    return status;
}
                         
- (void)_scheduleInCFRunLoop:(NSRunLoop *)runLoop forMode:(id)mode {

}
                         
- (void)_setCFClientFlags:(CFOptionFlags)flags callback:(CFReadStreamClientCallBack)callback context:(CFStreamClientContext)context {

}
                         
@end
