//
//  ReusedPagerCollectionViewCell.swift
//  Astrolabe
//
//  Created by Sergei Mikhan on 1/4/17.
//  Copyright © 2017 Netcosports. All rights reserved.
//

import UIKit

public protocol ReusedPageData {
  associatedtype PageData: Equatable

  var data: PageData? { get set }
}

public final class ReusedPagerCollectionViewCell<Controller: UIViewController>: CollectionViewCell, Reusable
  where Controller: ReusedPageData {

  public typealias Data = Controller.PageData
  public var viewController = Controller()

  public func setup(with data: Data) {
    containerViewController?.addChildViewController(viewController)
    contentView.addSubview(viewController.view)

    viewController.view.translatesAutoresizingMaskIntoConstraints = false
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[content]|", metrics: nil,
                                                              views: ["content": viewController.view]))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[content]|", metrics: nil,
                                                              views: ["content": viewController.view]))
    contentView.layoutIfNeeded()

    if viewController.data != data {
      viewController.data = data
    }
  }

  public static func size(for data: Data, containerSize: CGSize) -> CGSize {
    return containerSize
  }

  public override func willDisplay() {
    super.willDisplay()
    viewController.didMove(toParentViewController: containerViewController)
  }

  public override func endDisplay() {
    super.endDisplay()
    viewController.willMove(toParentViewController: nil)
    viewController.view.removeFromSuperview()
    viewController.removeFromParentViewController()
  }

}
