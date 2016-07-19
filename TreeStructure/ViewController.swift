//
//  ViewController.swift
//  TreeStructure
//
//  Created by Gerardo Garrido on 13/07/16.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let root = Node.init(name: "1");
        let node2 = Node.init(name: "2");
        let node3 = Node.init(name: "3");
        let node4 = Node.init(name: "4");
        root.insertChildren([node2, node3, node4]);
        
        let node5 = Node.init(name: "5");
        let node6 = Node.init(name: "6");
        let node7 = Node.init(name: "7");
        let node8 = Node.init(name: "8");
        node2.insertChildren([node5, node6, node7, node8]);
        print(node2.neededSize());
        
        let node9 = Node.init(name: "9");
        let node10 = Node.init(name: "10");
        node3.insertChildren([node9, node10]);
        
        let node11 = Node.init(name: "11");
        node5.insertChild(node11);
        
        let node12 = Node.init(name: "12");
        let node13 = Node.init(name: "13");
        node7.insertChildren([node12, node13]);
        
        let node14 = Node.init(name: "14");
        let node15 = Node.init(name: "15");
        let node16 = Node.init(name: "16");
        let node17 = Node.init(name: "17");
        node11.insertChildren([node14, node15, node16, node17]);
        
        
        let rootView = NodeView.initFromXib(with: root);
        rootView.drawChildrenNodes();
        self.view.addSubview(rootView);
        rootView.frame.origin.y = 50;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



