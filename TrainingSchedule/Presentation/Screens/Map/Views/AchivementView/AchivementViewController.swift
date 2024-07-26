//
//  AchivementViewController.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 25/7/24.
//

import UIKit
import Flutter

class AchivementViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the Flutter view controller

        let flutterEngine = ((UIApplication.shared.delegate as? AppDelegate)?.flutterEngine)!

        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)

        let methodChannel = FlutterMethodChannel(name: "com.training-schedule/close",
                                                 binaryMessenger: flutterViewController.binaryMessenger)
        methodChannel.setMethodCallHandler { [weak self] call, _ in
            if call.method == "close" {
                self?.dismiss(animated: true, completion: nil)
            }
        }

        // Add the Flutter view controller as a child
        addChild(flutterViewController)
        flutterViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(flutterViewController.view)
        flutterViewController.didMove(toParent: self)

        // Center and constrain the Flutter view controller
        NSLayoutConstraint.activate([
            flutterViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flutterViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            flutterViewController.view.widthAnchor.constraint(equalToConstant: 300), // Adjust width as needed
            flutterViewController.view.heightAnchor.constraint(equalToConstant: 300) // Adjust height as needed
        ])
    }
}
