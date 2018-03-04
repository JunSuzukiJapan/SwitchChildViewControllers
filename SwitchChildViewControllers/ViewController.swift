//
//  ViewController.swift
//  SwitchChildViewControllers
//
//  Created by jun suzuki on 2018/03/03.
//  Copyright © 2018年 jun suzuki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    enum CenterViewType {
        case First
        case Second
        case Third
        
        func id() -> String {
            switch self {
            case .First:
                return "First"
            case .Second:
                return "Second"
            case .Third:
                return "Third"
            }
        }
    }
    
    @IBAction func firstButtonTapped(_ sender: Any) {
        self.changeCenterView(.First)
    }
    
    @IBAction func secondButtonTapped(_ sender: Any) {
        self.changeCenterView(.Second)
    }

    @IBAction func thirdButtonTapped(_ sender: Any) {
        self.changeCenterView(.Third)
    }

    @IBOutlet weak var centerView: UIView!
    
    var currentViewController: UIViewController?

    func addSubview(_ subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[subView]|",
                options: [],
                metrics: nil,
                views: viewBindingsDict))
        parentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[subView]|",
                options: [],
                metrics: nil,
                views: viewBindingsDict))
    }
    
    func changeCenterView(_ type: CenterViewType) {
        let identifier = type.id()
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: identifier)
        newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
        self.currentViewController = newViewController
    }
    
    func cycleFromViewController(_ oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.centerView!)
        // TODO: Set the starting state of your constraints here
        newViewController.view.layoutIfNeeded()
        
        // TODO: Set the ending state of your constraints here
        
        UIView.animate(withDuration: 0.5,
            animations: {
                // only need to call layoutIfNeeded here
                newViewController.view.layoutIfNeeded()
            },
            completion: { finished in
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
                newViewController.didMove(toParentViewController: self)
            }
        )
    }
    
    override func viewDidLoad() {
        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: CenterViewType.First.id())
        let view = self.currentViewController!.view!
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.centerView)

        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

