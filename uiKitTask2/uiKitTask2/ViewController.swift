//
//  ViewController.swift
//  uiKitTask2
//
//  Created by Papillon on 2019/11/04.
//  Copyright © 2019 Papillon. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

  @IBOutlet weak var scrollArea: UIScrollView!
  @IBOutlet weak var botRect: UIView!
  @IBOutlet weak var topRect: UIView!
  @IBOutlet weak var midRect: UIView!
  @IBOutlet weak var titleField: UITextField!
  
  var topPadding: CGFloat = 0
  var bottomPadding: CGFloat = 0
  var leftPadding: CGFloat = 0
  var rightPadding: CGFloat = 0
  
  let screenSize: CGRect = UIScreen.main.bounds
  let goalHeight: CGFloat = 60.0
  var tapPoint: CGPoint = CGPoint(x: 0, y: 0)

  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleField.delegate = self
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if #available(iOS 11.0, *) {
      topPadding = self.view.safeAreaInsets.top
      bottomPadding = self.view.safeAreaInsets.bottom
    }
    
    scrollArea.contentSize = CGSize(
      width: screenSize.width * 2,
      height: screenSize.height - topPadding - goalHeight - bottomPadding
    )
    
    scrollArea.frame = CGRect(
      origin: CGPoint(
        x: 0,
        y: topPadding + goalHeight
      ),
      size: CGSize(
        width: screenSize.width,
        height: screenSize.height - topPadding - goalHeight - bottomPadding
      )
    )
    scrollArea.tag = 88
    scrollArea.delegate = self
    self.view.sendSubviewToBack(scrollArea)
    
    titleField.frame = CGRect(
      origin: CGPoint(
        x: 0,
        y: topPadding
      ),
      size: CGSize(
        width: screenSize.width,
        height: goalHeight
      )
    )
    titleField.tag = 99
    
    topRect.frame = CGRect(
      origin: CGPoint(
        x: 0,
        y: 0
      ),
      size: CGSize(
        width: screenSize.width * 2,
        height: (screenSize.height - topPadding - bottomPadding - goalHeight) / 3
      )
    )
    topRect.tag = 100
    
    midRect.frame = CGRect(
      origin: CGPoint(
        x: 0,
        y: (screenSize.height - topPadding - bottomPadding - goalHeight) / 3
      ),
      size: CGSize(
        width: screenSize.width * 2,
        height: (screenSize.height - topPadding - bottomPadding - goalHeight) / 3
      )
    )
    midRect.tag = 101
    
    botRect.frame = CGRect(
      origin: CGPoint(
        x: 0,
        y: (screenSize.height - topPadding - bottomPadding - goalHeight) / 3 * 2
      ),
      size: CGSize(
        width: screenSize.width * 2,
        height: (screenSize.height - topPadding - bottomPadding - goalHeight) / 3
      )
    )
    botRect.tag = 102
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    print(scrollView.contentOffset)
  }
}

