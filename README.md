# VLens iOS SDK Documentation

`VLensManager` is the main entry point for integrating the VLens framework into your iOS application. It provides tools for managing transactions, setting access tokens, and presenting the VLens validation screen.

---

## Installation

### Requirements
- **iOS**: 16.0 or later
- **Swift**: 5.0 or later

### Swift Package Manager
To add VLensManager to your project using Swift Package Manager:

1. In Xcode, go to **File > Add Packages...**
2. Enter the repository/local URL for the VLens package.
3. Select the desired version and add the package.

---

## Usage

### Importing VLens
Make sure to import the framework where needed:
```swift
import VLens
```

### Initializing `VLensManager`
To start using `VLensManager`, initialize it with the required parameters:

```swift
let vlensManager = VLensManager(
    transactionId: "your_transaction_id",
    apiKey: "your_api_key",
    secretKey: "your_secret_key",
    tenancyName: "your_tenancy_name",
    language: "en" // Default is "en", but you can use "ar" for Arabic or other supported languages.
)
```

#### Parameters:
- `transactionId`: Unique identifier for the transaction.
- `apiKey`: API key for your channel.
- `secretKey`: Secret key for secure operations.
- `tenancyName`: Name of the tenancy for scoping operations.
- `language`: (Optional) Language for the interface. Defaults to English (`"en"`).

---

### Setting the Access Token
Set the access token when available:

```swift
vlensManager.setAccessToken("your_access_token")
```

---

### Presenting the VLens Validation Screen
To present the validation screen, use the `present` method:

```swift
vlensManager.present(on: self, withLivenessOnly: false)
```

#### Parameters:
- `on`: The view controller on which the VLens validation screen will be presented.
- `withLivenessOnly`: (Optional) A Boolean indicating whether to enable only liveness detection. Defaults to `false`.

---

### Delegate for Handling Callbacks
Set the `VLensDelegate` to handle callbacks from the validation process:

```swift
vlensManager.delegate = self
```

#### Conform to the `VLensDelegate` Protocol
Implement the required delegate methods to handle results:
```swift
extension YourViewController: VLensDelegate {
    func onValidationSuccess() {
        print("Validation successful!")
    }

    func onValidationFailure(error: Error) {
        print("Validation failed with error: \(error.localizedDescription)")
    }
}
```

---

## Debugging
To enable debug logging, ensure the `Constants.IS_DEBUG` flag is set to `true`. Debug logs will be printed to the console.

---

## Example Usage
Here's a complete example:
```swift
import VLens

class ExampleViewController: UIViewController {
    private var vlensManager: VLensManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize VLensManager
        vlensManager = VLensManager(
            transactionId: "123456",
            apiKey: "your_api_key",
            secretKey: "your_secret_key",
            tenancyName: "example_tenancy",
            language: "en"
        )
        
        vlensManager.setAccessToken("your_access_token")
        vlensManager.delegate = self
    }

    @IBAction func startValidation(_ sender: UIButton) {
        vlensManager.present(on: self)
    }
}

extension ExampleViewController: VLensDelegate {
    func onValidationSuccess() {
        print("Validation successful!")
    }

    func onValidationFailure(error: Error) {
        print("Validation failed: \(error.localizedDescription)")
    }
}
```

---

## Support
For issues or inquiries, please contact [mohamedt@silverkeytech.com](mailto:mohamedt@silverkeytech.com).

---
