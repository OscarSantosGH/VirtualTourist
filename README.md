#  Virtual Tourist

The Virtual Tourist allows users to drop pins on a map, as if they were stops on a tour. Users will then be able to download pictures for the location and persist both the pictures, and the association of the pictures with the pin.

## Usage
This app use Flickr API to download images, so you must have a valid Flickr API Key. If you dont already have a Flickr account, you can get one [here](https://www.flickr.com).

## Setting it up with your own API KEY

In the **FlickrClient.swift** file there is a property called `apiKey`, initialize the _String_ with your own API KEY in the following line:

```Swift
//INSERT YOU OWN API KEY HERE
static let apiKey = "{INSERT YOU OWN API KEY HERE}"
```

## APIs

* [Flickr API](https://www.flickr.com/services/api) to download the images in the region of the pin.
* [URLSession](https://developer.apple.com/documentation/foundation/urlsession) for networking.
* [Core Data](https://developer.apple.com/documentation/coredata) to save the Pins with there images on the map.
* [Map Kit](https://developer.apple.com/documentation/mapkit) to show the map and pins.




