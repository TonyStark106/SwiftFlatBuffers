//
//  Helper.m
//  Example
//
//  Created by TonyStark106 on 2017/5/17.
//  Copyright © 2017年 TonyStark106. All rights reserved.
//

#import "Helper.h"
#import "fbtest_generated.h"

using namespace flatbuffers;

@implementation Helper



+ (NSData *)getData {
    FlatBufferBuilder builder;
    auto s1_id = builder.CreateSharedString("s1_id");
    auto s1 = CreateStat(builder,
                         s1_id,
                         111,
                         222);
    
    auto s2_id = builder.CreateSharedString("s2_id");
    auto s2 = CreateStat(builder,
                         s2_id,
                         333,
                         444);
    
    auto pos = Vec3(1, 2, 3, 4.7, Color_Blue);
    auto name = builder.CreateSharedString("Tony");
    
    auto ab0 = Ability(23, 321);
    auto ab1 = Ability(99, 88);
    
    auto test = CreateStat(builder,
                           NULL,
                           777,
                           888);

    std::vector<uint8_t> v_inventory;
    v_inventory.push_back(2);
    v_inventory.push_back(3);
    v_inventory.push_back(4);
    auto inventory = builder.CreateVector(v_inventory);
    
    std::vector<Offset<Stat>> v_testarrayoftables;
    v_testarrayoftables.push_back(s1);
    v_testarrayoftables.push_back(s2);
    auto testarrayoftables = builder.CreateVector(v_testarrayoftables);
    
    std::vector<std::string> v_testarrayofstring;
    v_testarrayofstring.push_back("xxx");
    v_testarrayofstring.push_back("yyy");
    auto testarrayofstring = builder.CreateVectorOfStrings(v_testarrayofstring);

    std::vector<uint8_t> v_testarrayofbools;
    v_testarrayofbools.push_back(true);
    v_testarrayofbools.push_back(false);
    auto testarrayofbools = builder.CreateVector(v_testarrayofbools);

    std::vector<Ability> v_testarrayofsortedstruct;
    v_testarrayofsortedstruct.push_back(ab0);
    v_testarrayofsortedstruct.push_back(ab1);
    auto testarrayofsortedstruct = builder.CreateVectorOfStructs(v_testarrayofsortedstruct);
    
    auto m = CreateMonster(builder,
                           &pos,
                           222,
                           0,
                           name,
                           inventory,
                           Color_Green,
                           testarrayoftables,
                           testarrayofstring,
                           testarrayofbools,
                           testarrayofsortedstruct,
                           Any_Stat,
                           test.Union());
    builder.Finish(m);
    NSData *data = [NSData dataWithBytes:builder.GetBufferPointer() length:builder.GetSize()];
    return data;
}

+ (void)testSwiftToCpp:(NSData *)data {
    auto m = GetMonster(data.bytes);
    auto v = m->pos();
    assert(v->x() == 1);
    assert(v->y() == 2);
    assert(v->z() == 3);
    assert(v->test1() == 4.7);
    assert(v->test2() == Color_Blue);
    
    assert(m->testarrayofstring()->size() == 2);
    assert(isEqualToString(m->testarrayofstring()->operator[](0)->c_str(), @"111"));
    assert(isEqualToString(m->testarrayofstring()->operator[](1)->c_str(), @"222"));
    assert(m->color() == Color_Green);
    assert(m->hp() == 16);
    assert(m->mana() == 150);
    
    assert(m->inventory()->size() == 3);
    assert(m->inventory()->operator[](0) == 111);
    assert(m->inventory()->operator[](1) == 222);
    assert(m->inventory()->operator[](2) == 22);
    
    assert(m->testarrayofbools()->size() == 3);
    assert(m->testarrayofbools()->operator[](0) == true);
    assert(m->testarrayofbools()->operator[](1) == false);
    assert(m->testarrayofbools()->operator[](2) == true);
    
    assert(m->testarrayofsortedstruct()->size() == 2);
    assert(m->testarrayofsortedstruct()->operator[](0)->id() == 3);
    assert(m->testarrayofsortedstruct()->operator[](0)->distance() == 999);
    assert(m->testarrayofsortedstruct()->operator[](1)->id() == 87);
    assert(m->testarrayofsortedstruct()->operator[](1)->distance() == 21);
    
    assert(m->testarrayoftables()->size() == 2);
    assert(isEqualToString(m->testarrayoftables()->operator[](0)->id()->c_str(), @"id_0"));
    assert(m->testarrayoftables()->operator[](0)->count() == 999);
    assert(m->testarrayoftables()->operator[](0)->val() == 888);
    assert(isEqualToString(m->testarrayoftables()->operator[](1)->id()->c_str(), @"id_1"));
    assert(m->testarrayoftables()->operator[](1)->count() == 23);
    assert(m->testarrayoftables()->operator[](1)->val() == 4412);
    
}

bool isEqualToString(const char * c_str, NSString *str) {
    NSString *temp = [NSString stringWithUTF8String:c_str];
    return [temp containsString:str] && temp.length - str.length == 1;
}

@end
