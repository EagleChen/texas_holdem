require_relative '../lib/texas'

describe HandUtil do
  it "should handle straight_flush" do
    cards = [
      Card.new(:spade, 14),
      Card.new(:spade, 2),
      Card.new(:spade, 3),
      Card.new(:spade, 4),
      Card.new(:spade, 5),
      Card.new(:diamond, 5),
      Card.new(:heart, 5)
    ]
    hand = HandUtil.get_largest(cards)
    hand.type.should == :straight_flush
    hand.cards.map { |c| c.rank }.should =~ [14, 2, 3, 4, 5]

    cards = [
      Card.new(:spade, 14),
      Card.new(:spade, 13),
      Card.new(:spade, 12),
      Card.new(:spade, 11),
      Card.new(:spade, 10),
      Card.new(:diamond, 14),
      Card.new(:heart, 14)
    ]
    hand = HandUtil.get_largest(cards)
    hand.type.should == :straight_flush
    hand.cards.map { |c| c.rank }.should =~ [14, 13, 12, 11, 10]
  end

  it "should handle four of a kind" do
    cards = [
      Card.new(:spade, 14),
      Card.new(:heart, 14),
      Card.new(:diamond, 14),
      Card.new(:club, 14),
      Card.new(:spade, 5),
      Card.new(:diamond, 5),
      Card.new(:heart, 5)
    ]

    hand = HandUtil.get_largest(cards)
    hand.type.should == :four_of_a_kind
    hand.cards.map { |c| c.rank }.should =~ [14, 14, 14, 14, 5]
  end

  it "should handle full house" do
    cards = [
      Card.new(:spade, 14),
      Card.new(:heart, 14),
      Card.new(:diamond, 14),
      Card.new(:spade, 13),
      Card.new(:heart, 13),
      Card.new(:diamond, 13),
      Card.new(:heart, 5)
    ]
    hand = HandUtil.get_largest(cards)
    hand.type.should == :full_house
    hand.cards.map { |c| c.rank }.should =~ [14, 14, 14, 13, 13]

    cards = [
      Card.new(:spade, 14),
      Card.new(:heart, 12),
      Card.new(:diamond, 12),
      Card.new(:spade, 13),
      Card.new(:heart, 13),
      Card.new(:diamond, 13),
      Card.new(:heart, 5)
    ]
    hand = HandUtil.get_largest(cards)
    hand.type.should == :full_house
    hand.cards.map { |c| c.rank }.should =~ [12, 12, 13, 13, 13]

    cards = [
      Card.new(:spade, 4),
      Card.new(:heart, 4),
      Card.new(:diamond, 12),
      Card.new(:spade, 13),
      Card.new(:heart, 13),
      Card.new(:diamond, 13),
      Card.new(:heart, 12)
    ]
    hand = HandUtil.get_largest(cards)
    hand.type.should == :full_house
    hand.cards.map { |c| c.rank }.should =~ [12, 12, 13, 13, 13]
  end

  it "should handle flush" do
    cards = [
      Card.new(:spade, 14),
      Card.new(:spade, 10),
      Card.new(:spade, 9),
      Card.new(:spade, 11),
      Card.new(:spade, 6),
      Card.new(:diamond, 12),
      Card.new(:heart, 13)
    ]

    hand = HandUtil.get_largest(cards)
    hand.type.should == :flush
    hand.cards.map { |c| c.rank }.should =~ [14, 10, 9, 11, 6]
  end

  it "should handle straight" do
    cards = [
      Card.new(:spade, 14),
      Card.new(:spade, 2),
      Card.new(:spade, 3),
      Card.new(:heart, 4),
      Card.new(:spade, 5),
      Card.new(:diamond, 5),
      Card.new(:heart, 5)
    ]

    hand = HandUtil.get_largest(cards)
    hand.type.should == :straight
    hand.cards.map { |c| c.rank }.should =~ [14, 2, 3, 4, 5]
  end

  it "should handle three_of_a_kind" do
    cards = [
      Card.new(:spade, 14),
      Card.new(:spade, 12),
      Card.new(:spade, 3),
      Card.new(:spade, 4),
      Card.new(:club, 5),
      Card.new(:diamond, 5),
      Card.new(:heart, 5)
    ]

    hand = HandUtil.get_largest(cards)
    hand.type.should == :three_of_a_kind
    hand.cards.map { |c| c.rank }.should =~ [14, 12, 5, 5, 5]
  end

  it "should handle two_pair" do
    cards = [
      Card.new(:spade, 14),
      Card.new(:heart, 2),
      Card.new(:club, 2),
      Card.new(:spade, 4),
      Card.new(:club, 4),
      Card.new(:diamond, 5),
      Card.new(:heart, 5)
    ]

    hand = HandUtil.get_largest(cards)
    hand.type.should == :two_pair
    hand.cards.map { |c| c.rank }.should =~ [14, 4, 4, 5, 5]
  end

  it "should handle one_pair" do
    cards = [
      Card.new(:spade, 4),
      Card.new(:heart, 4),
      Card.new(:spade, 3),
      Card.new(:spade, 7),
      Card.new(:club, 6),
      Card.new(:diamond, 5),
      Card.new(:heart, 9)
    ]

    hand = HandUtil.get_largest(cards)
    hand.type.should == :one_pair
    hand.cards.map { |c| c.rank }.should =~ [4, 4, 9, 7, 6]
  end

  it "should handle high_card" do
    cards = [
      Card.new(:spade, 4),
      Card.new(:heart, 14),
      Card.new(:spade, 3),
      Card.new(:spade, 7),
      Card.new(:club, 6),
      Card.new(:diamond, 5),
      Card.new(:heart, 9)
    ]

    hand = HandUtil.get_largest(cards)
    hand.type.should == :high_card
    hand.cards.map { |c| c.rank }.should =~ [14, 5, 9, 7, 6]
  end

  it "shoul compare two hands with different types" do
    hand1 = Hand.new(:flush, [])
    hand2 = Hand.new(:three_of_a_kind, [])
    HandUtil.compare(hand1, hand2).should be > 0


    hand1 = Hand.new(:full_house, [])
    hand2 = Hand.new(:high_card, [])
    HandUtil.compare(hand1, hand2).should be > 0
  end

  it "shoul compare two hands with same types" do
    hand1 = Hand.new(:straight_flush,
                     [
                       Card.new(:spade, 4),
                       Card.new(:spade, 5),
                       Card.new(:spade, 3),
                       Card.new(:spade, 7),
                       Card.new(:spade, 6),
                     ])
    hand2 = Hand.new(:straight_flush,
                     [
                       Card.new(:spade, 2),
                       Card.new(:spade, 14),
                       Card.new(:spade, 3),
                       Card.new(:spade, 5),
                       Card.new(:spade, 4),
                     ])
    HandUtil.compare(hand1, hand2).should be > 0


    hand1 = Hand.new(:straight,
                     [
                       Card.new(:spade, 13),
                       Card.new(:club, 14),
                       Card.new(:spade, 12),
                       Card.new(:spade, 11),
                       Card.new(:spade, 10),
                     ])
    hand2 = Hand.new(:straight,
                     [
                       Card.new(:spade, 2),
                       Card.new(:spade, 14),
                       Card.new(:spade, 3),
                       Card.new(:club, 4),
                       Card.new(:spade, 5),
                     ])
    HandUtil.compare(hand1, hand2).should be > 0

    hand1 = Hand.new(:full_house,
                     [
                       Card.new(:spade, 12),
                       Card.new(:club,  12),
                       Card.new(:heart, 12),
                       Card.new(:heart, 13),
                       Card.new(:heart, 13),
                     ])
    hand2 = Hand.new(:full_house,
                     [
                       Card.new(:spade, 10),
                       Card.new(:club,  10),
                       Card.new(:heart, 10),
                       Card.new(:heart, 14),
                       Card.new(:club,  14),
                     ])
    HandUtil.compare(hand1, hand2).should be > 0

    hand1 = Hand.new(:one_pair,
                     [
                       Card.new(:spade, 12),
                       Card.new(:club,  12),
                       Card.new(:heart, 7),
                       Card.new(:heart, 14),
                       Card.new(:heart, 11),
                     ])
    hand2 = Hand.new(:one_pair,
                     [
                       Card.new(:spade, 12),
                       Card.new(:club,  12),
                       Card.new(:heart, 10),
                       Card.new(:heart, 11),
                       Card.new(:heart, 13),
                     ])
    HandUtil.compare(hand1, hand2).should be > 0
  end
end
