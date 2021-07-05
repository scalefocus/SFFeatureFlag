# SFFeatureFlag
SFFeatureFlag provides a mechanism for controlling the availability of features based on a remote configuration.

Table of contents
=================  
* [Requirements](#requirements)
* [Installation](#installation)
* [How it works](#how-it-works)
* [Usage](#usage)
* [License](#license)

## Requirements
- iOS 11.0+
- Swift 5

## Installation
### Cocoapods
SFFeatureFlag is available through [CocoaPods](https://cocoapods.org/pods/SFFeatureFlag). 
CocoaPods is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate SFFeatureFlag into your Xcode project using CocoaPods, add the following lines in your Podfile:

```ruby
pod 'SFFeatureFlag'
pod 'FirebaseRemoteConfig'
```
Note that ```FirebaseRemoteConfig``` is not added as a dependency of SFFeatureFlag pod. This is because we wanted to avoid potential conflicts with the versions of Firebase supported on different projects. For that reason, you should include ```FirebaseRemoteConfig``` in your Podfile as well.

## How it works
SFFeatureFlag works by checking your project's RemoteConfig in Firebase for the existance of a specific parameter. This parameter is ```features_config``` and should be configured with a specific JSON value that will be used for evaluating if a certain feature is enabled. The JSON value should be in the following format:

```json
[
  {
    "feature_name": "NAME_OF_THE_FEATURE",
    "is_enabled": true,
    "criteria": {
      "os_version": {
        "min": "14.0",
        "max": "14.5"
      },
      "app_version": {
        "min": "3.0"
      },
      "active_interval": {
        "start_date": "08-06-2021"
      },
      "specific_conditions": [
        {
          "key": "country",
          "valid_values": ["usa"],
          "inverse": false
        }
      ]
    }
  }
]
```

For the ```features_config```  parameter, there is a list of JSON objects. Each object describes the availability of a specific feature and the criteria that needs to be met in order for that feature to be enabled. Note that for each object only the ```feature_name``` and ```is_enabled``` parameters are mandatory. The criteria object, as well as all key-value pairs within that criteria are optional and don't need to be defined if not necessary.

* ```feature_name``` - Name of the feature for which you want to control the availability
* ```is_enabled``` - Boolean value indicating whether the feature will be enabled
* ```criteria``` - Optional object that can be used for defining rules that will be taken into consideration when evaluating the availability of the feature. Note that, in order for these rules to be applied when determing the availibility, the ```is_enabled``` parameter needs to be to set to ```true```
* ```os_version``` - Optional object that can be used for restricting the availability of the feature only for specific range of iOS versions. Note that you don't have to define both ```min``` and ```max``` parameters, if you don't need both a lower and an upper boundry. For example, if you want to restrict the feature to be only available on devices with iOS version 14.0 or greater, you can set only the ```min``` parameter. If you want to restrict the feature to be available to all devices with iOS versions less or equal to let's say 14.5, you can set only the ```max``` parameter.
* ```app_version``` - Optional object that can be used for restring the availability of a certain feature based on the specific version of the application that the user has installed on the device. Similar like the ```os_version```, if not needed you can only define the ```min``` parameter, or just the ```max``` value of the application version
* ```active_interval``` - Optional object that can be used for restricting the availability of a feature only for a certain period of time by using the ```start_date``` and ```end_date``` to define the range. Both ```start_date``` and ```end_date``` are optional and there's no need to set them both if not necessary. The date set for ```start_date``` and ```end_date``` needs to be in the following format: "dd-MM-yyyy"
* ```specific_conditions``` - You can optionally set list of conditions if you want to target specific users for which the feature will be available. Each condition object is consisted of:
    * ```key``` - Unique key for the condition
    * ```valid_values``` - Array of strings. List of valid values for that condition
    * ```inverse``` - Boolean that indicates that the opposite values i.e the values that are not contained in the ```valid_values``` list, will fulfill the condition. In the example above this parameter is set to ```false``` which means that the feature is restricted to be available only for users that are from USA. If you want to restrict the feature to be available for all users except the ones that are from USA you need to set this parameter to ```true```

## Usage

### 1. Copy-paste FirebaseRemoteConfigService file from the Example project into your project
As mentioned above, ```FirebaseRemoteConfig``` is not added as a dependency of SFFeatureFlag pod. This means that the logic for configuring this service and providing the remote config data to the SFFeatureFlag module should be part of your main project. 

```FirebaseRemoteConfigService``` conforms to the ```RemoteConfigServiceProtocol```, which is defined in the SFFeatureFlag module. This protocol contains method definitions for configuring the Remote Config Service, setting its default values, fetching the remote config data and getting a config value for a certain key. 

### 2. Set in-app default parameter values
You can set in-app default parameter values for the RemoteConfig object, so that your app behaves as intended before it connects to the Remote Config backend. In ```FirebaseRemoteConfigService``` class there is already an initial implementation for setting default values. You just need to create a ```FeaturesConfigDefaults.json``` file and define your default config for the features. Take a look at the json file with the same name in the Example project for more reference.

### 3. Copy-paste FeatureFlagManager file from the Example project into your project
FeatureFlagManager is a singleton class that is wrapper around the SFFeatureFlag implementation. The main goal is to have one global class that will be used everywhere within the project for determing the availability of features without importing the SFFeatureFlag module and of course using the same instance of the ```FeatureFlagCenter``` class.

### 4. Setup FeatureFlagManager in AppDelegate
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    FeatureFlagManager.shared.setup()
    
    return true
}
```
This setup method creates an instance of the ```FeatureFlagCenter``` class and fetches the features config remote config data.

### 5. Check if a certain feature is enabled
To check if a feature, that is associated with a certain name, is enabled call the following method:
```swift
FeatureFlagManager.shared.isFeatureEnabled(featureType:)
```

Optionally, you can pass a conditionsDataSource dictionary which will be used when evaluating the specific conditions defined in the features config. For example, if some feature is restricted to be available only to users with specific profession and that are from specific country, you can provide these user's information by:
```swift
let conditionsDataSource = [
    "country": "usa",
    "profession": "singer"
]

FeatureFlagManager.shared.isFeatureEnabled(featureType: FEATURE_TYPE, conditionsDataSource: conditionsDataSource)
```

To run the example project, clone the repo, and run ***pod install*** from the Example directory first.

## License
SFFeatureFlag is available under the MIT license. See the LICENSE file for more info.

[swift-image]:https://img.shields.io/badge/swift-5-green.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE

