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
        for child in self.children {
            child.hidden = !child.hidden;
        }
        
        for connector in self.connectors {
            connector.hidden = !connector.hidden;
        }
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
    
}



