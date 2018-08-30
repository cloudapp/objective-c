// PKMultipartInputStream.h
// py.kerembellec@gmail.com

@interface PKMultipartInputStream : NSInputStream {
    @private
    NSMutableArray *parts;
    NSString       *boundary;
    NSData         *footer;
    NSUInteger     footerLength, currentPart, length, delivered, status;
}

- (void)addPartWithName:(NSString *)name string:(NSString *)string;
- (void)addPartWithName:(NSString *)name data:(NSData *)data;
- (void)addPartWithName:(NSString *)name path:(NSString *)path;
- (void)addPartWithName:(NSString *)name path:(NSString *)path targetFileName:(NSString *)targetFileName;

- (NSString *)boundary;
- (NSUInteger)length;

- (NSArray *)parts;

@end
