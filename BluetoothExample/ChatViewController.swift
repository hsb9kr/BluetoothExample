//
//  ChatViewController.swift
//  BluetoothExample
//
//  Created by hsb9kr on 2017. 10. 11..
//  Copyright © 2017년 hsb9kr. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ChatViewController: UIViewController, MCBrowserViewControllerDelegate, MPCHandlerDelegate {
    
    weak var handler: MPCHandler! = MPCHandler.shared

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handler.delegate = self
        handler.serviceType = "my-app"
        handler.initPeerWithDisplayName(displayName: UIDevice.current.name)
        handler.isAdvertise = true
    }
    
    //MARK: MCBrowser view controller delegate
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        handler.browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        handler.browser.dismiss(animated: true, completion: nil)
    }
    
    //MARK: MPCHandler delegate
    
    func mpcHandler(peerID: MCPeerID, state: MCSessionState) {
        switch state {
        case .connected:
            navigationItem.title = "Connected"
        case .connecting:
            navigationItem.title = "Connecting"
            break
        case .notConnected:
            navigationItem.title = "notConnected"
            break
        }
    }
    
    func mpcHandler(didReceiveData data: Data, fromPeer peerID: MCPeerID) {
        do {
            let receivedJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, String>
            let user = receivedJson["user"]!
            let message = receivedJson["message"]!
            DispatchQueue.main.async {
                self.textView.text.append("\(user): \(message)\n")
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func didTouchUpInsideConnectBtn(_ sender: UIBarButtonItem) {
        if handler.session != nil {
            handler.initBrowser()
            handler.browser.delegate = self
            present(handler.browser, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTouchUpInsideDisconnectBtn(_ sender: UIBarButtonItem) {
        handler.session.disconnect()
    }
    
    @IBAction func didTouchUpInsideSendBtn() {
        //TODO: send message event
        
        let sendDataDict = ["user": UIDevice.current.name, "message": textField.text!] as [String : String]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: sendDataDict, options: .prettyPrinted)
           try handler.session.send(jsonData, toPeers: handler.session.connectedPeers, with: .reliable)
        } catch let error {
            print(error.localizedDescription)
        }
        
        textView.text.append("\(UIDevice.current.name): \(textField.text!)\n")
        textField.text = ""
    }
}
