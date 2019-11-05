//
//  TransparentView.swift
//  uiKitTask2
//
//  Created by Papillon on 2019/11/05.
//  Copyright © 2019 Papillon. All rights reserved.
//

import Foundation
import UIKit

class TransparentView: UIView {
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let view = super.hitTest(point, with: event)
    
    if view == self {
      return nil
    }
    
    return view
  }
}
