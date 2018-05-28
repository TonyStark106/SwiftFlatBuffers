## Introduction
FlatBuffers is an efficient cross platform serialization library for games and other memory constrained apps. It allows you to directly access serialized data without unpacking/parsing it first, while still having great forwards/backwards compatibility.

SwiftFlatBuffers is a Swift library for FlatBuffers which support most FlatBuffers feature with firendly interface. `1.1.0` version starts to be compatible with Linux, Carthage and Swift Package Manager.

## Usage
### Generate Source code

#### Build flatc

Open `SwiftFlatBuffers.xcworkspace` and set the active schema to `flatc` then run. Find binary file `flatc` in the folder which was named `flatc`.

#### Write a schema
[schema syntax](https://google.github.io/flatbuffers/flatbuffers_guide_writing_schema.html)

```
// example schema
attribute "priority";

enum Color:byte (bit_flags) { Red = 0, Green, Blue = 3 }

union Any { Monster, Stat }

struct Vec3 (force_align: 16) {
  x:float;
  y:float;
  z:float;
  test1:double;
  test2:Color;
}

struct Ability {
  id:uint(key);
  distance:uint;
}

table Stat {
  id:string;
  val:long;
  count:ushort;
}

table Monster {
  pos:Vec3 (id: 0);
  hp:short = 100 (id: 2);
  mana:short = 150 (id: 1);
  name:string (id: 3, required, key);
  color:Color = Blue (id: 6);
  inventory:[ubyte] (id: 5);
  friendly:bool = false (deprecated, priority: 1, id: 4);
  testarrayoftables:[Stat] (id: 7);
  testarrayofstring:[string] (id: 8);
  testarrayofbools:[bool] (id: 9);
  testarrayofsortedstruct:[Ability] (id: 10);
  test:Any (id: 12);
}

root_type Monster;
```
#### Generate
include namespace:

```
./flatc -sw xxx.fbs
``` 
with namespace:

```
./flatc -sw xxx.fbs --sw-namespace
```

### Installation
CocoaPods:

```
pod "SwiftFlatBuffers"
```

Carthage:

```
github "TonyStark106/SwiftFlatBuffers" ~> 1.2.2
```

Swift Package Manager:

```
.Package(url: "https://github.com/TonyStark106/SwiftFlatBuffers.git", majorVersion: 1)
```

### Code
```
import SwiftFlatBuffers

// Serialize
let m = Monster()
m.name = "Tony"
m.hp = 255
m.testarrayofstring = ["Spitfire", "coding"]
let data = m.toFBData()

// Deserialize
if let n = Monster(root: data) {
  print("Monster name:    \(n.name!)")
  print("Monster hp:      \(n.hp)")
  print("Monster skills:  \(n.testarrayofstring!)")
}
```

## Example
1. Write your schema files and save them to `fbs` folder.
2. Run `sh build_flatbuffers.sh` will auto generate your source code and build in `MyFlatBuffers.framework`.
3. add `import MyFlatBuffers` in Example project and try your generated source code.


## Unit Test

Open `SwiftFlatBuffers.xcworkspace` and set the active schema to `Example` then hit `Command + U`.

[ExampleTests.swift](https://github.com/TonyStark106/SwiftFlatBuffers/blob/master/Example/ExampleTests/ExampleTests.swift)

## Licensing
SwiftFlatBuffers is licensed under the Apache License, Version 2.0. See [LICENSE](https://github.com/TonyStark106/SwiftFlatBuffers/blob/master/LICENSE.txt) for the full license text.
