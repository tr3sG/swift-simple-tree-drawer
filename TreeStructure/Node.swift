//
//  Node.swift
//  TreeStructure
//
//  Created by Gerardo Garrido on 19/07/16.
//  Copyright © 2016 Code d'Azur. All rights reserved.
//

import UIKit


class Node {
    var name: String;
    weak var parent: Node?;
    var children: Array<Node> = [];
    
    
    init(name: String = "") {
        self.name = name;
    }
    
    // MARK: Public methods
    
    func insertChild(child: Node) {
        child.parent = self;
        self.children.append(child);
    }
    
    func insertChildren(children: Array<Node>) {
        for child in children {
            self.insertChild(child);
        }
    }
    
    func removeChild(child: Node) {
        guard let index = self.children.indexOf(child) else {
            return;
        }
        self.children.removeAtIndex(index);
    }
    
    func numberOfLevels() -> Int {
        var levels: Int = 1;
        if self.children.count == 0 {
            return levels;
        }
        
        for child in self.children {
            levels = max(levels, child.numberOfLevels());
        }
        
        return levels+1;
    }
    
    func numberOfChildren() -> Int {
        return self.children.count;
    }
    
    func neededSize() -> CGSize {
        var size = NodeView.nodeSize;
        
        if self.children.count == 0 {
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
    
}

extension Node: Equatable {}
func == (lhs: Node, rhs: Node) -> Bool {
    return lhs === rhs;
}