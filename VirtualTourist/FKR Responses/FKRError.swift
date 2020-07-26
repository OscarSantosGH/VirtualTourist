//
//  FKRError.swift
//  VirtualTourist
//
//  Created by Oscar Santos on 7/26/20.
//  Copyright © 2020 Oscar Santos. All rights reserved.
//

import Foundation

struct FKRError: Error, Decodable{
    let stat:String
    let code:Int
}

extension FKRError{
    var message: String{
        switch code {
        case 1:
            return "Too many tags in ALL query"
        case 2:
            return "Unknown user"
        case 3:
            return "Parameterless searches have been disabled"
        case 4:
            return "You don't have permission to view this pool"
        case 5:
            return "User deleted"
        case 10:
            return "Sorry, the Flickr search API is not currently available."
        case 11:
            return "No valid machine tags"
        case 12:
            return "Exceeded maximum allowable machine tags"
        case 17:
            return "You can only search within your own contacts"
        case 18:
            return "Illogical arguments"
        case 100:
            return "Invalid API Key"
        case 105:
            return "Service currently unavailable"
        case 106:
            return "Write operation failed"
        case 111:
            return "Format 'xxx' not found"
        case 112:
            return "Method 'xxx' not found"
        case 114:
            return "Invalid SOAP envelope"
        case 115:
            return "Invalid XML-RPC Method Call"
        case 116:
            return "Bad URL found"
        default:
            return "Something went wrong"
        }
    }
    
    var errorDescription: String{
        switch code {
        case 1:
            return "When performing an 'all tags' search, you may not specify more than 20 tags to join together."
        case 2:
            return "A user_id was passed which did not match a valid flickr user."
        case 3:
            return "To perform a search with no parameters (to get the latest public photos, please use flickr.photos.getRecent instead)."
        case 4:
            return "The logged in user (if any) does not have permission to view the pool for this group."
        case 5:
            return "The user id passed did not match a Flickr user."
        case 10:
            return "The Flickr API search databases are temporarily unavailable."
        case 11:
            return "The query styntax for the machine_tags argument did not validate."
        case 12:
            return "The maximum number of machine tags in a single query was exceeded."
        case 17:
            return "The call tried to use the contacts parameter with no user ID or a user ID other than that of the authenticated user."
        case 18:
            return "The request contained contradictory arguments."
        case 100:
            return "The API key passed was not valid or has expired."
        case 105:
            return "The requested service is temporarily unavailable."
        case 106:
            return "The requested operation failed due to a temporary issue."
        case 111:
            return "The requested response format was not found."
        case 112:
            return "The requested method was not found."
        case 114:
            return "The SOAP envelope send in the request could not be parsed."
        case 115:
            return "The XML-RPC request document could not be parsed."
        case 116:
            return "One or more arguments contained a URL that has been used for abuse on Flickr."
        default:
            return "Try again later."
        }
    }
}
