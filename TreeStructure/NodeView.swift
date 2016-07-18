//
//  Node.swift
//  TreeStructure
//
//  Created by Gerardo Garrido on 13/07/16.
//

import UIKit

class NodeView: UIView {
    static let nodeSize = CGSizeMake(50, 25);
    static let separatorSize = CGSizeMake(10, 25);
    
    
    var name: String {
        get {
            if let text = self.lbName.text {
                return text;
            }
            return "";
        }
        set(newValue) {
            self.lbName.text = newValue;
        }
    }
    weak var parent: NodeView?;
    var children: Array<NodeView> = [];
    var connectors: Array<UIImageView> = [];
    
    
    @IBOutlet weak var lbName: UILabel!;
    @IBOutlet weak var connectorsView: UIView!
    @IBOutlet weak var childrenView: UIView!
    @IBOutlet weak var node: UIView!
    
    
    override var hidden: Bool {
        get {
            return super.hidden;
        }
        set(hide) {
            super.hidden = hide;
            for child in self.children {
                child.hidden = hide;
            }
            
            for connector in self.connectors {
                connector.hidden = hide;
            }
        }
    }
    
    
    // MARK: Lifecycle methods
    
    class func initFromXib(withName name: String = "") -> NodeView {
        let node = NSBundle.mainBundle().loadNibNamed(String(NodeView), owner: self, options: nil)[0] as! NodeView
        node.name = name;
        
        return node;
    }
    
    // MARK: Actions
    
    @IBAction func onVisibilityTap(sender: UIButton) {
        self.childrenView.hidden = !self.childrenView.hidden;
        self.connectorsView.hidden = !self.connectorsView.hidden;
    }
    
    
    // MARK: Public methods
    
    func insertChild(child: NodeView) {
        child.parent = self;
        self.children.append(child);
    }
    
    func insertChildren(children: Array<NodeView>) {
        for child in children {
            self.insertChild(child);
        }
    }
    
    func removeChild(child: NodeView) {
        guard let index = self.children.indexOf(child) else {
            return;
        }
        self.children.removeAtIndex(index);
        
        // Remove connector if exists
        if self.connectors.indices.contains(index)  {
            self.connectors.removeAtIndex(index);
        }
    }
    
    func neededSize() -> CGSize {
        var size = NodeView.nodeSize;
        
        if (self.children.count == 0) {
            return size;
        }
        
        size.width = 0;
        for child in self.children {
            size +>= child.neededSize();
            if (self.children.last != child) {
                size +>= NodeView.separatorSize;
            }
        }
        
        return size +^ NodeView.separatorSize +^ NodeView.nodeSize;
    }
    
    
    func insertConnector(connector: UIImageView) {
        self.connectors.append(connector);
    }
    
    func numberOfLevels() -> UInt {
        var levels: UInt = 1;
        if self.children.count == 0 {
            return levels;
        }
        
        for child in self.children {
            levels = max(levels, child.numberOfLevels());
        }
        
        return levels+1;
    }
    
    func drawChildrenNodes() {
        let size = self.neededSize();
        
        self.frame.size = size;
        self.childrenView.frame.size = size;
        self.connectorsView.frame.size = size;
        
        var origin = CGPointMake(0, NodeView.nodeSize.height + NodeView.separatorSize.height);
        
        for child in self.children {
            self.childrenView.addSubview(child);
            child.drawChildrenNodes();
            child.frame.origin = origin;
            origin.x += child.frame.width + NodeView.separatorSize.width;
        }
        
        self.node.frame.origin.x = (size.width - NodeView.nodeSize.width) / 2;
        
        self.drawConnectors();
    }
    
    func drawConnectors() {
        if (self.children.count == 0) {
            return;
        }
        
        UIGraphicsBeginImageContext(self.frame.size);
        guard let context = UIGraphicsGetCurrentContext() else {
            return;
        }
        
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor);
        let firstChild = self.children.first!;
        
        if (self.children.count == 1) {
            CGContextMoveToPoint(context, firstChild.center.x, self.node.center.y);
            CGContextAddLineToPoint(context, firstChild.center.x, firstChild.frame.origin.y);
            CGContextStrokePath(context);
        }
        else if (self.children.count > 1) {
            let linePosY = NodeView.nodeSize.height/2 + NodeView.separatorSize.height;
            let lastChild = self.children.last!;
            CGContextMoveToPoint(context, firstChild.center.x, linePosY);
            CGContextAddLineToPoint(context, lastChild.center.x, linePosY);
            CGContextStrokePath(context);
            
            for child in self.children {
                self.drawLine(fromNode: child, toLineAt: linePosY, in: context);
            }
            
            self.drawLine(fromNode: self.node, toLineAt: linePosY, in: context);
        }
        
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.connectorsView.addSubview(UIImageView(image: img));
    }
    
    func drawLine(fromNode node: UIView, toLineAt posY: CGFloat, in context: CGContext) {
        CGContextMoveToPoint(context, node.center.x, node.frame.origin.y);
        CGContextAddLineToPoint(context, node.center.x, posY);
        CGContextStrokePath(context);
    }
    
}



