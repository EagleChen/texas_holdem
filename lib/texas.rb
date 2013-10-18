Card = Struct.new(:suit, :rank)
Suit = {spade: 1, heart: 2, club: 3, diamond: 4}

class Hand
  def get_largest(cards)
    suits = {}
    Suit.each { |k, _| suits[k] = {count: 0, cards:[]}}
    ranks = Array(14, 0)
    cards.each do |card|
      suits[card.suit][:count] += 1
      suits[card.suit][:cards] << card.rank
      ranks[card.rank] += 1
    end

    suits.each { |s| s[:cards].sort! }

    pick(suits, cards)
  end

  def pick(suits, cards)
    hand = nil
    suits.each do |k, v|
      hand = straight?(v[:cards]) if v[:count] >= 5
    end
  end

  def straight?(cards)
    cards.reverse!

  end
end

Hand.new.get_largest(nil)
