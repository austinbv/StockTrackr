//
//  LinkedList.swift
//  StockTrackr
//
//  Created by Austin Vance on 3/26/19.
//  Copyright © 2019 Focused Labs. All rights reserved.
//

import Foundation

class Node<T: Equatable> {
    var value: T? = nil
    var next: Node? = self
}

class LinkedList<T: Equatable> {
    var head = Node<T>()
    var tail = 
    
    func insert(value: T) {
        if self.head.value == nil {
            self.head.value = value
        } else {
            //find the last node without a next value
            var lastNode = self.head
            while lastNode.next != nil {
                lastNode = lastNode.next!
            }
            //once found, create a new node and connect the linked list
            let newNode = Node<T>()
            newNode.value = value
            lastNode.next = newNode
        }
    }
}
