//
//  ViewController.swift
//  TreeStructure
//
//  Created by Gerardo Garrido on 13/07/16.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let root = NodeView.initFromXib(withName: "1");
        let node2 = NodeView.initFromXib(withName: "2");
        let node3 = NodeView.initFromXib(withName: "3");
        let node4 = NodeView.initFromXib(withName: "4");
        root.insertChildren([node2, node3, node4]);
        print("Root needed size \(root.neededSize())");
        
        let node5 = NodeView.initFromXib(withName: "5");
        let node6 = NodeView.initFromXib(withName: "6");
        let node7 = NodeView.initFromXib(withName: "7");
        let node8 = NodeView.initFromXib(withName: "8");
        node2.insertChildren([node5, node6, node7, node8]);
        print(node2.neededSize());
        print("Root needed size \(root.neededSize())");
        
        let node9 = NodeView.initFromXib(withName: "9");
        let node10 = NodeView.initFromXib(withName: "10");
        node3.insertChildren([node9, node10]);
        print("Root needed size \(root.neededSize())");
        
        let node11 = NodeView.initFromXib(withName: "11");
        node5.insertChild(node11);
        print("Root needed size \(root.neededSize())");
        
        let node12 = NodeView.initFromXib(withName: "12");
        let node13 = NodeView.initFromXib(withName: "13");
        node7.insertChildren([node12, node13]);
        print("Root needed size \(root.neededSize())");
        
        let node14 = NodeView.initFromXib(withName: "14");
        let node15 = NodeView.initFromXib(withName: "15");
        let node16 = NodeView.initFromXib(withName: "16");
        let node17 = NodeView.initFromXib(withName: "17");
        node11.insertChildren([node14, node15, node16, node17]);
        
        self.drawNode(root, at: CGPointMake(0, 20));
        self.scrollView.hidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private methods
    func drawNode(node: NodeView, at position: CGPoint) {
        let size = node.neededSize();
        
        node.center.x = position.x + size.width / 2;
        
        var rect = node.frame;
        rect.origin.y = position.y;
        node.frame = rect;
        
        var newPosition = CGPointMake(position.x, position.y + NodeView.nodeSize.height + NodeView.separatorSize.height);
        
        self.view.addSubview(node);
        
        for child in node.children {
            self.drawNode(child, at: newPosition);
            newPosition.x += child.neededSize().width + NodeView.separatorSize.width;
            
            let connector = self.connectorBetween(node, and: child);
            self.view.addSubview(connector);
            self.view.sendSubviewToBack(connector);
            
            node.insertConnector(connector);
        }
    }
    
    func connectorBetween(node: NodeView, and child: NodeView) -> UIImageView {
        UIGraphicsBeginImageContext(self.view.frame.size);
        let context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextMoveToPoint(context, node.center.x, node.center.y);
        CGContextAddLineToPoint(context, child.center.x, child.center.y);
        CGContextStrokePath(context);
        
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return UIImageView(image: img);
    }
}



