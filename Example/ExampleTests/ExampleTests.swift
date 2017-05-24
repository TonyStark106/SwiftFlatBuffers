//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by TonyStark106 on 2017/5/21.
//  Copyright © 2017年 TonyStark106. All rights reserved.
//

import XCTest
@testable import Example
import SwiftFlatBuffers
import MyFlatBuffers

class ExampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {

    }
    
    func testPerformanceExample() {
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func getMonster() -> Monster {
        let m = Monster()
        let v = Vec3()
        v.x = 1
        v.y = 2
        v.z = 3
        v.test1 = 4.7
        v.test2 = .Blue
        m.pos = v

        m.name = "Tony"
        m.color = .Green
        m.testarrayofstring = ["111", "222"]
        m.testarrayofbools = [true, false, true]
        m.inventory = [111, 222, 22]
        m.hp = 16
        let ab0 = Ability()
        ab0.id = 3
        ab0.distance = 999

        let ab1 = Ability()
        ab1.id = 87
        ab1.distance = 21
        m.testarrayofsortedstruct = [ab0, ab1]

        let st0 = Stat()
        st0.id = "id_0"
        st0.count = 999
        st0.val = 888

        let st1 = Stat()
        st1.id = "id_1"
        st1.count = 23
        st1.val = 4412
        m.testarrayoftables = [st0, st1]
        return m
    }

    func testSwiftToSwift() {
        let m = getMonster()
        let n = Monster(root: m.toFBData())!

        assert(m.pos?.x == n.pos?.x)
        assert(m.pos?.y == n.pos?.y)
        assert(m.pos?.z == n.pos?.z)
        assert(m.pos?.test1 == n.pos?.test1)
        assert(m.pos?.test2 == n.pos?.test2)

        assert(n.name == m.name)
        assert(n.hp == m.hp)
        assert(n.color == m.color)
        assert(n.testarrayoftables![0].id == "id_0")
        assert(n.testarrayoftables![0].count == 999)
        assert(n.testarrayoftables![0].val == 888)
        assert(n.testarrayoftables![1].id == "id_1")
        assert(n.testarrayoftables![1].count == 23)
        assert(n.testarrayoftables![1].val == 4412)

        assert(m.testarrayofstring! == n.testarrayofstring!)
        assert(m.testarrayofbools! == n.testarrayofbools!)
        assert(m.inventory! == n.inventory!)
        assert(n.testarrayofsortedstruct![0].id == 3)
        assert(n.testarrayofsortedstruct![0].distance == 999)
        assert(n.testarrayofsortedstruct![1].id == 87)
        assert(n.testarrayofsortedstruct![1].distance == 21)
    }

    func testSwiftToCpp() {
        Helper.testSwift(toCpp: getMonster().toFBData())
    }

    func testCppToSwift() {
        let m = Monster(root: Helper.getData())!
        assert(m.name == "Tony")
        assert(m.mana == 222)
        assert(m.hp == 100)
        assert(m.color == .Green)

        assert(m.pos!.x == 1)
        assert(m.pos!.y == 2)
        assert(m.pos!.z == 3)
        assert(m.pos!.test1 == 4.7)
        assert(m.pos!.test2 == .Blue)

        assert(m.inventory?.count == 3)
        assert(m.inventory![0] == 2)
        assert(m.inventory![1] == 3)
        assert(m.inventory![2] == 4)

        assert(m.testarrayofstring?.count == 2)
        assert(m.testarrayofstring![0] == "xxx")
        assert(m.testarrayofstring![1] == "yyy")

        assert(m.testarrayoftables?.count == 2)
        assert(m.testarrayoftables![0].id == "s1_id")
        assert(m.testarrayoftables![0].val == 111)
        assert(m.testarrayoftables![0].count == 222)
        assert(m.testarrayoftables![1].id == "s2_id")
        assert(m.testarrayoftables![1].val == 333)
        assert(m.testarrayoftables![1].count == 444)

        assert(m.testarrayofbools?.count == 2)
        assert(m.testarrayofbools![0] == true)
        assert(m.testarrayofbools![1] == false)

        assert(m.testarrayofsortedstruct?.count == 2)
        assert(m.testarrayofsortedstruct![0].id == 23)
        assert(m.testarrayofsortedstruct![0].distance == 321)
        assert(m.testarrayofsortedstruct![1].id == 99)
        assert(m.testarrayofsortedstruct![1].distance == 88)

    }

    func testDefaultValue() {
        let data = Monster().toFBData()
        let m = Monster(root: data)!

        assert(m.color == .Blue)
        assert(m.mana == 150)
        assert(m.hp == 100)
        assert(m.pos == nil)
        assert(m.testarrayofsortedstruct == nil)
        assert(m.testarrayofbools == nil)
        assert(m.test == nil)
    }

    func testUnionValue() {
        let m = Monster()
        assert(Monster(root: m.toFBData())?.test == nil)
        
        let n = Monster()
        n.name = "Cat"
        m.test = n
        assert((Monster(root: m.toFBData())?.test as! Monster).name == "Cat")
        
        let s = Stat()
        s.id = "ID007"
        s.count = 3
        m.test = s
        let newS = (Monster(root: m.toFBData())!.test!) as! Stat
        assert(newS.id == s.id)
        assert(newS.count == s.count)
        assert(newS.val == 0)
    }
    

}
