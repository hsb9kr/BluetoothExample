//
//  MPCHandler.swift
//  BluetoothExample
//
//  Created by hsb9kr on 2017. 10. 11..
//  Copyright © 2017년 hsb9kr. All rights reserved.
//

import UIKit
import MultipeerConnectivity

public protocol MPCHandlerDelegate : NSObjectProtocol {
    func mpcHandler(peerID: MCPeerID, state: MCSessionState)
    func mpcHandler(didReceiveData data:Data, fromPeer peerID: MCPeerID)
}

class MPCHandler: NSObject, MCSessionDelegate {
    static let shared = MPCHandler()
    var peerID: MCPeerID!
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant? = nil
    var serviceType: String = "MPC-Helper"
    weak open var delegate: MPCHandlerDelegate?
    
    var isAdvertise: Bool = false {

        willSet(newValue) {
            if newValue {
                advertiser = MCAdvertiserAssistant(serviceType: self.serviceType, discoveryInfo: nil, session: self.session)
                advertiser!.start()
            } else {
                advertiser!.stop()
                advertiser = nil
            }
        }
    }
    
    func initPeerWithDisplayName(displayName: String) {
        peerID = MCPeerID(displayName: displayName)
        session = MCSession(peer: peerID)
        session.delegate = self
    }
    
    func initBrowser() {
        browser = MCBrowserViewController(serviceType: serviceType, session: session)
    }
    
//    func advertiseSelf(advertise: Bool) {
//        if advertise {
//            advertiser = MCAdvertiserAssistant(serviceType: "chat-files", discoveryInfo: nil, session: self.session)
//            advertiser!.start()
//        } else {
//            advertiser!.stop()
//            advertiser = nil
//        }
//    }
    
    //MARK: MCSession delegate
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        delegate?.mpcHandler(peerID: peerID, state: state)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        delegate?.mpcHandler(didReceiveData: data, fromPeer: peerID)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
//    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
//        certificateHandler(true)
//    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
}
