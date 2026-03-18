# Flappy

## Overview
Flappy bird like game

## Objective
1. Learn flutter and dart
2. Build incrementally using skills with CLAUDE
3. Playable on Chrome, iOS, Android
4. Image must be svg ones

## Rules
1. Almost never use nested construction, prefer declaring one element, and give it as argument to another one
    - avoid ```cpp

    ObjectA {
        subObject: ObjectB {
            subSubObject: ObjectC{

            }
        }
    }
   ```
   - Prefer do ```cpp
        objectC = ObjectC{};
        objectB = ObjectB { subSubObject: objectC };
        objectA = ObjectA { subObject: objectB };
   ```
3. Always add new feature incrementally
4. Always make reusable component
5. Try to optimize for performance when it's possible.