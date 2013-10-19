require_relative "../lib/texas"

pocket_cards1 = [Card.new(:spade, 14), Card.new(:heart, 13)]
pocket_cards2 = [Card.new(:spade, 2), Card.new(:heart, 2)]

cards = []
SUITS.each do |k, _|
  (2..14).each do |rank|
    card = Card.new(k, rank)
    cards << card unless (pocket_cards1 + pocket_cards2).include? card
  end
end

puts cards.count

count = 0
win1 = 0
win2 = 0
tie  = 0
start_time = Time.now
(0..43).each do |a|
  ((a+1)..44).each do |b|
    ((b+1)..45).each do |c|
      ((c+1)..46).each do |d|
        ((d+1)..47).each do |e|
          count += 1
          community_cards = cards.values_at(a, b, c, d, e)
          cards1 = pocket_cards1 + community_cards
          cards2 = pocket_cards2 + community_cards

          hand1 = HandUtil.get_largest(cards1)
          hand2 = HandUtil.get_largest(cards2)
          result = HandUtil.compare(hand1, hand2)

          result == 0 ? tie += 1 : (result > 0 ? win1 += 1 : win2 += 1)
        end
      end
    end
  end
end

puts count, win1, win2, tie

puts "cost time : #{Time.now - start_time}"
