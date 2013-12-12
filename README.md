# Summary

`vfl2objc` is a tool to convert VFL (Visual Formatting Language) based UI layout to native, frame-based, Objective-C code.

# Table of Contents

1. [Usage](#usage)
2. [Sample Rules](#sample-rules)
3. [A rule of thumb](#a-rule-of-thumb)
4. [Variables and constants](#variables-and-constants)
5. [Frame overriding](#frame-overriding)
6. [Command line tools](#command-line-tools)
7. [Further integration](#further-integration)
8. [License](#license)

# Usage

## 1. One-time setup

```
sudo setup.rb
```

This will copy the necessary files to the necessary folders to integrate nicely with Xcode.

## 2. Restart Xcode and confirm installation

Fist, restart Xcode, then navigate to `Xcode > Services` in the upper left application menu. You should be able to see the vfl-file service listed under the General section.

## 3. Create a VFL code block

To start a new VFL based code block, enter something like below in the right place in your code:

    UIView* superview = someView;
    // begin VFL
    /*
        |-10-[someElement]-10-|
        V:|-5-[someElement(100)]
    */
    // end VFL

*Note:* the first line and the last line are important. The final `// end VFL` must be followed by a LF line break (`\n`). You can also `// VFL begin` and `// VFL end`

## 4. Save, then run the `vfl-file` service

Make sure you save the file (Cmd+S), then navigate to `Xcode > Services > vfl-file` in the upper left application menu. The VFL block you entered will expand to a full code block!

Each time after editing something in the VFL section, also press Cmd+S and run the vfl-file service, so the code will get updated.

**Protip:** you can add a keyboard shortcut to the vfl-file menu in `System Preferences > Keyboard > Keyboard Shortcuts`

# Sample Rules

```
|-5-[A(100)]
```
This means that element A is 5 points from the left edge of its container, and it's 100 points wide. And A has flexible right margin.

```
V:|-10-[B(50)]
```
This means that element B is 10 points from the top edge and is 50 points tall. (V means vertical). And B has flexible bottom margin.

```
|-5-[C]-5-|
```
This means that C has flexible width, and it's 5 points to the left edge and 5 points to the right edge.

```
V:[D]|
```
This means that D is touching the bottom edge, and have a flexible top margin, and D's height should be set beyond the VFL based block (either before or after)

```
|-5-[E]-5-[F(50)]-5-[G(>0)]-5-|
```
This means that E has a fixed width set outside the VFL block, F has a fixed width of 50 points, G has a flexible width

```
[H(100)]
```
This means that H is 100 points wide. However **it's position and autoresizing mask is unknown, so you need to set them beyond the VFL block**.

# A rule of thumb

The rule of thumb is that there can be 1 and only 1 flexible element in each dimension:

```
|-5-[A(100)]-5-|
```
This is wrong because when the superview width is not 110 there will be a conflict.

```
|-5-[A(>0)]-5-[B(>0)]-5-|
```
This is wrong because it is an ambiguous layout—it is unclear on how to assign the widths for A and B.

# Variables and constants

Variables and constants can be used to replace the numbers:

```
|-margin-[button(width)]
```

Everything else follows [Apple's official VFL documentation](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage/VisualFormatLanguage.html), with one exception: `vlf2objc` supports `center` before brackets.

```
center[A(200)]
```
This means A's width is 200 and A is horizontally centered in its superview.

```
V:center[B(100)]
```
This means B's height is 100 and B is vertically centered in its superview.

# Frame overriding

**Unlike** Cocoa Autolayout, `vfl2objc` allows you to override the frame of an element before or after the generated code block.

For example this is valid allowed:

    labelA.text = @"hi";
    [labelA sizeToFit];
    // generated code based on |-[labelA]-10-[itemB] 

This is also valid and allowed:

    // generated code based on [itemX(100)]
    UpdateWidthBasedOnSomeLogic(itemX); // this keeps the x, y, height set in the VFL block and just updates the width

However, the following example will not work:

    // generated code based on |[itemX]-[itemY(100)]
    [itemX setWidth:100];

`itemY`'s position depends on `itemX`'s frame, so `itemX`'s `setWidth` call must go before the generated code block.


Command line tools
==================

You can use this script to convert raw VFL to Objective-C code from command line:

    echo "|-10-[button]
    V:[button]-|" | vfl2objc.rb --raw

Or convert an Objective-C source code file, preserving non-VFL areas. To do so, run either:

    cat yourfile.m | vfl2objc.rb > yourfile_with_changes.m

Or transform it in place:

    vfl2objc.rb -f yourfile.m

Further integration
===================

Other than manually triggering the script with Mac Service, you can consider to integrate VFL code generation into pre-build script.

To do this:

1. In Xcode Toolbar, choose your scheme and edit your scheme.

    **Protip:** If you use git, you may want to go to "manage scheme" and make your scheme "shared" first, so the scheme config will be in your git repo.
2. Inside scheme editor, expand "Build", and add a pre-action
3. Use whatever scripting language to create a script that loops through all your `.m` files, and call `vfl2objc.rb -f {file_path}`

License
=======

Copyright (C) 2013 by Hulu, LLC

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
