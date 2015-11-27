//
//  SuperMock.swift
//  SuperMock
//
//  Created by Iain Smith on 27/11/2015.
//
//

import Foundation

public class SuperMockConfig: NSObject {
    public static let sharedConfig = SuperMockConfig()

    public var logSuppressionRegexes: [NSRegularExpression]?
    public var logURLTransforms = false
    public var logUnmockedURLs = true
    public var logMockedURLs = true

    public var useStrictMocks = false

    public var URLTransform: ((url: NSURL) -> (NSURL))?

    func shouldLogURL(url: NSURL, hasMock: Bool) -> Bool {
        if let regexes = logSuppressionRegexes {
            let requestURLString = url.absoluteString
            let requestURLRange = NSMakeRange(0, requestURLString.characters.count)

            let results: [NSTextCheckingResult] = regexes.flatMap({ regex in
                regex.matchesInString(requestURLString, options: .Anchored, range: requestURLRange)
            })

            let logThisURL = hasMock ? logMockedURLs : logUnmockedURLs
            let shouldLog = (results.count == 0 && logThisURL)
            return shouldLog
        } else {
            return true
        }
    }
}