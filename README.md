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
