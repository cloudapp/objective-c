# objective-c (iOS)
CloudApp's first-party Objective-C API wrapper

Using in Swift 4
### Configuration
To be able to use in the current ViewController the delegates import `CLAPIEngineDelegate` and then before anything else.
```swift
        CLAPIEngine.shared().delegate = self
```
### LogIn / LogOut
```swift
        CLAPIEngine.shared().logIn()
```
```swift
        CLAPIEngine.shared().logOut()
```

### Getting drops

```swift
CLAPIEngine.sharedInstance()?.getItemListStarting(atPage: 1, ofType: CLWebItemTypeVideo, itemsPerPage: 10, showOnlyItemsInTrash: false, userInfo: nil)
```

To know the response whe have this delegates.

```swift
    func itemListRetrievalSucceeded(_ items: [CLWebItem]!, connectionIdentifier: String!, userInfo: Any!) {   
        for item in items {
            print(item.name)
            //do whatever you want with your drops
        }
    }
```

### Uploading new drops

Here we have an example to upload one drop getted from the ```UIImagePickerController```
```swift
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
        
        CLAPIEngine.shared().uploadFile(withName: imageURL.lastPathComponent, atPathOnDisk: imageURL.path, options: nil, userInfo: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
```


### Functions you can use

``` objective-c
- (CLAPIRequestType)requestTypeForConnectionIdentifier:(NSString *)identifier;

- (void)createAccountWithEmail:(NSString *)accountEmail password:(NSString *)accountPassword acceptTerms:(BOOL)acceptTerms userInfo:(id)userInfo;
- (void)changeDefaultSecurityOfAccountToUsePrivacy:(BOOL)privacy userInfo:(id)userInfo;

- (void)changePrivacyOfItem:(CLWebItem *)webItem toPrivate:(BOOL)isPrivate userInfo:(id)userInfo;
- (void)changePrivacyOfItemAtHref:(NSURL *)href toPrivate:(BOOL)isPrivate userInfo:(id)userInfo;
- (void)changeNameOfItem:(CLWebItem *)webItem toName:(NSString *)newName userInfo:(id)userInfo;
- (void)changeNameOfItemAtHref:(NSURL *)href toName:(NSString *)newName userInfo:(id)userInfo;
- (void)getAccountInformationWithUserInfo:(id)userInfo;
- (void)getItemInformation:(CLWebItem *)item userInfo:(id)userInfo;
- (void)getItemInformationAtURL:(NSURL *)itemURL userInfo:(id)userInfo;
- (void)bookmarkLinkWithURL:(NSURL *)URL name:(NSString *)name userInfo:(id)userInfo;
- (void)uploadFileWithName:(NSString *)fileName fileData:(NSData *)fileData userInfo:(id)userInfo;
- (void)bookmarkLinkWithURL:(NSURL *)URL name:(NSString *)name options:(NSDictionary *)options userInfo:(id)userInfo;
- (void)uploadFileWithName:(NSString *)fileName fileData:(NSData *)fileData options:(NSDictionary *)options userInfo:(id)userInfo;
- (void)uploadFileWithName:(NSString *)fileName atPathOnDisk:(NSString *)pathOnDisk options:(NSDictionary<NSString*,NSString*>*)options userInfo:(id)userInfo;

- (void)deleteItem:(CLWebItem *)webItem userInfo:(id)userInfo;
- (void)deleteItemAtHref:(NSURL *)href userInfo:(id)userInfo;
- (void)restoreItem:(CLWebItem *)webItem userInfo:(id)userInfo;
- (void)restoreItemAtHref:(NSURL *)href userInfo:(id)userInfo;
- (void)getItemListStartingAtPage:(NSInteger)pageNumStartingAtOne itemsPerPage:(NSInteger)perPage userInfo:(id)userInfo;
- (void)getItemListStartingAtPage:(NSInteger)pageNumStartingAtOne ofType:(CLWebItemType)type itemsPerPage:(NSInteger)perPage userInfo:(id)userInfo;
- (void)getItemListStartingAtPage:(NSInteger)pageNumStartingAtOne ofType:(CLWebItemType)type itemsPerPage:(NSInteger)perPage showOnlyItemsInTrash:(BOOL)showOnlyItemsInTrash userInfo:(id)userInfo;

- (void)getStoreProductsWithUserInfo:(id)userInfo;
- (void)redeemStoreReceipt:(NSString *)base64Receipt userInfo:(id)userInfo;
- (void)getAccountToken:(id)userInfo;
- (void)loadAccountStatisticsWithUserInfo:(id)userInfo;
- (void)getAccountTokenFromGoogleAuth:(NSString*)accessToken and:(id)userInfo;
- (void)getJWTfromToken:(NSString*)accessToken and:(id)userInfo;
- (void)logIn;
- (void)logOut;
```
