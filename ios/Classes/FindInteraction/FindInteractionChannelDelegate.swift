//
//  FindInteractionChannelDelegate.swift
//  flutter_inappwebview
//
//  Created by Lorenzo Pichilli on 07/10/22.
//

import Foundation

public class FindInteractionChannelDelegate : ChannelDelegate {
    private weak var findInteractionController: FindInteractionController?
    
    public init(findInteractionController: FindInteractionController, channel: FlutterMethodChannel) {
        super.init(channel: channel)
        self.findInteractionController = findInteractionController
    }
    
    public override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? NSDictionary
        
        switch call.method {
            case "findAllAsync":
                if let findInteractionController = findInteractionController {
                    let find = arguments!["find"] as! String
                    findInteractionController.findAllAsync(find: find, completionHandler: {(value, error) in
                        if error != nil {
                            result(FlutterError(code: "FindInteractionChannelDelegate", message: error?.localizedDescription, details: nil))
                            return
                        }
                        result(true)
                    })
                } else {
                    result(false)
                }
                break
            case "findNext":
                if let findInteractionController = findInteractionController {
                    let forward = arguments!["forward"] as! Bool
                    findInteractionController.findNext(forward: forward, completionHandler: {(value, error) in
                        if error != nil {
                            result(FlutterError(code: "FindInteractionChannelDelegate", message: error?.localizedDescription, details: nil))
                            return
                        }
                        result(true)
                    })
                } else {
                    result(false)
                }
                break
            case "clearMatches":
                if let findInteractionController = findInteractionController {
                    findInteractionController.clearMatches(completionHandler: {(value, error) in
                        if error != nil {
                            result(FlutterError(code: "FindInteractionChannelDelegate", message: error?.localizedDescription, details: nil))
                            return
                        }
                        result(true)
                    })
                } else {
                    result(false)
                }
                break
            case "setSearchText":
                if #available(iOS 16.0, *) {
                    if let interaction = findInteractionController?.webView?.findInteraction {
                        let searchText = arguments!["searchText"] as? String
                        interaction.searchText = searchText
                        result(true)
                    } else {
                        result(false)
                    }
                } else {
                    result(false)
                }
                break
            case "getSearchText":
                if #available(iOS 16.0, *) {
                    if let interaction = findInteractionController?.webView?.findInteraction {
                        result(interaction.searchText)
                    } else {
                        result(nil)
                    }
                } else {
                    result(nil)
                }
                break
            case "isFindNavigatorVisible":
                if #available(iOS 16.0, *) {
                    if let interaction = findInteractionController?.webView?.findInteraction {
                        result(interaction.isFindNavigatorVisible)
                    } else {
                        result(false)
                    }
                } else {
                    result(false)
                }
                break
            case "updateResultCount":
                if #available(iOS 16.0, *) {
                    if let interaction = findInteractionController?.webView?.findInteraction {
                        interaction.updateResultCount()
                        result(true)
                    } else {
                        result(false)
                    }
                } else {
                    result(false)
                }
                break
            case "presentFindNavigator":
                if #available(iOS 16.0, *) {
                    if let interaction = findInteractionController?.webView?.findInteraction {
                        interaction.presentFindNavigator(showingReplace: false)
                        result(true)
                    } else {
                        result(false)
                    }
                } else {
                    result(false)
                }
                break
            case "dismissFindNavigator":
                if #available(iOS 16.0, *) {
                    if let interaction = findInteractionController?.webView?.findInteraction {
                        interaction.dismissFindNavigator()
                        result(true)
                    } else {
                        result(false)
                    }
                } else {
                    result(false)
                }
                break
            case "getActiveFindSession":
                if #available(iOS 16.0, *) {
                    if let interaction = findInteractionController?.webView?.findInteraction {
                        result(interaction.activeFindSession?.toMap())
                    } else {
                        result(nil)
                    }
                } else {
                    result(nil)
                }
                break
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }
    
    public func onFindResultReceived(activeMatchOrdinal: Int, numberOfMatches: Int, isDoneCounting: Bool) {
        let arguments: [String : Any?] = [
            "activeMatchOrdinal": activeMatchOrdinal,
            "numberOfMatches": numberOfMatches,
            "isDoneCounting": isDoneCounting
        ]
        channel?.invokeMethod("onFindResultReceived", arguments: arguments)
    }
    
    public override func dispose() {
        super.dispose()
        findInteractionController = nil
    }
    
    deinit {
        dispose()
    }
}