require './vfl2objc.rb'
require 'test/unit'

class VFLTest < Test::Unit::TestCase
    def test_basic
        input = "|[b1]|"
        output = %Q{
frame = b1.frame;
frame.origin.x = 0;
frame.size.width = superview.bounds.size.width - (0) - frame.origin.x;
// You need to set frame.size.height
// You need to set frame.origin.y
b1.frame = frame;
b1.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
// You need to figure out the vertical autoresizing mask
[superview addSubview:b1];
}
        assert str2str(input).include? output
    end


    def test_predefined_size
        input = "V:|-x-[itemA(w)]-x2-[itemB]-x3-[itemC(>0)]|"
        output = %Q{
frame = itemA.frame;
// You need to set frame.size.width
// You need to set frame.origin.x
frame.origin.y = 0 + x;
frame.size.height = w;
itemA.frame = frame;
// You need to figure out the horizontal autoresizing mask
itemA.autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
[superview addSubview:itemA];

frame = itemB.frame;
// You need to set frame.size.width
// You need to set frame.origin.x
frame.origin.y = 0 + x + w + x2;
// You need to set frame.size.height
itemB.frame = frame;
// You need to figure out the horizontal autoresizing mask
itemB.autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
[superview addSubview:itemB];

frame = itemC.frame;
// You need to set frame.size.width
// You need to set frame.origin.x
frame.origin.y = CGRectGetMaxY(itemB.frame) + 0 + x3;
frame.size.height = superview.bounds.size.height - (0) - frame.origin.y;
itemC.frame = frame;
// You need to figure out the horizontal autoresizing mask
itemC.autoresizingMask |= UIViewAutoresizingFlexibleHeight;
[superview addSubview:itemC];
}
        assert str2str(input).include? output
    end


    def test_incomplete
        input = "[d(40)]"
        output = %Q{
frame = d.frame;
frame.size.width = 40;
// You need to set frame.origin.x
// You need to set frame.size.height
// You need to set frame.origin.y
d.frame = frame;
// You need to figure out the horizontal autoresizing mask
// You need to figure out the vertical autoresizing mask
[superview addSubview:d];
}
        assert str2str(input).include? output
    end


end