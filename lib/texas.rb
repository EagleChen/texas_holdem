Card = Struct.new(:suit, :rank)
Hand = Struct.new(:type, :cards)
SUITS = {spade: 1, heart: 2, club: 3, diamond: 4}
HANDS = {straight_flush: 1, four_of_a_kind: 2, full_house: 3, flush: 4,
         straight: 5, three_of_a_kind: 6, two_pair: 7, one_pair: 8,
         high_card: 9}

class HandUtil
  class << self

    # ace should be 14
    def get_largest(cards)
      prepare(cards)

      check_straight_flush
    end

    def prepare(cards)
      @suits = {}
      @ranks = []
      @fours = []
      @threes = []
      @pairs = []

      SUITS.each { |k, _| @suits[k] = {count: 0, cards: []} }
      (0..14).each { |i| @ranks[i] = {count: 0, cards: []} }
      cards.each do |card|
        @suits[card.suit][:count] += 1
        @suits[card.suit][:cards] << card
        @ranks[card.rank][:count] += 1
        @ranks[card.rank][:cards] << card
      end

      14.downto(2).each do |index|
        rank = @ranks[index]
        case rank[:count]
        when 4 then @fours << index
        when 3 then @threes << index
        when 2 then @pairs << index
        end
      end
    end

    def check_straight_flush
      hand = nil
      @suits.each do |k, v|
        if v[:count] >= 5 # at least flush
          hand = check_straight(v[:cards])
          if hand
            hand.type = :straight_flush
            return hand
          else
            cards = v[:cards].sort { |x, y| y.rank <=> x.rank }
            return Hand.new(:flush, cards[0, 5])
          end
        end
      end

      check_four_of_a_kind
    end

    def check_four_of_a_kind
      if @fours.size == 1
        cards = [] + @ranks[@fours[0]][:cards]
        cards += get_high_card([@fours[0]], 1)
        return Hand.new(:four_of_a_kind, cards)
      end

      check_fullhouse
    end

    def check_fullhouse
      if @threes.size >= 1 # at least three_of_a_kind
        cards = [] + @ranks[@threes[0]][:cards]
        if @threes.size == 2 # full_house
          cards += @ranks[@threes[1]][:cards][0, 2]
          return Hand.new(:full_house, cards)
        end

        if @pairs.size > 0 # full_house
          cards += @ranks[@pairs[0]][:cards]
          return Hand.new(:full_house, cards)
        end

        # straight or three_of_a_kind
        straight_candidates = []
        @ranks.each do |rank|
          straight_candidates << rank[:cards][0] if rank[:count] > 0
        end
        if straight_candidates.size >= 5
          hand = check_straight(straight_candidates)
          return hand if hand
        end

        # three_of_a_kind
        cards += get_high_card([@threes[0]], 2)
        return Hand.new(:three_of_a_kind, cards)
      end

      check_pairs
    end

    def check_straight(cards)
      raise "Absolutely not straight" if cards.size < 5
      cards.sort! { |x, y| y.rank <=> x.rank }
      index = 0
      while (cards.size - index >= 5) do
        if (cards[index].rank - cards[index+4].rank == 4)
          return Hand.new(:straight, cards[index, 5])
        end
        index += 1
      end
      # check ace, 2, 3, 4, 5
      if cards[0].rank == 14 && cards[-4].rank == 5
        return Hand.new(:straight, [cards[0]] + cards[-4, 4])
      end
      nil
    end

    def check_pairs
      if @pairs.size > 0 # at least one pair
        cards = [] + @ranks[@pairs[0]][:cards]
        if @pairs.size >= 2
          cards += @ranks[@pairs[1]][:cards]
          cards += get_high_card(@pairs[0..1], 1)
          return Hand.new(:two_pair, cards)
        end

        # one pair
        cards += get_high_card([@pairs[0]], 3)
        return Hand.new(:one_pair, cards)
      end

      return Hand.new(:high_card, get_high_card([], 5))
    end

    def get_high_card(excepts, size)
      cards = []
      14.downto(2).each do |index|
        next if excepts.include? index
        rank = @ranks[index]
        if rank[:count] > 0
          if size < rank[:count]
            cards += rank[:cards][0, size]
            return cards
          else
            cards += rank[:cards]
            size -= rank[:count]
            return cards if size == 0
          end
        end
      end

      raise "Obviously something went wrong!!!"
    end

    # > 1 , = 0, < -1
    def compare(hand1, hand2)
      return 1 if HANDS[hand1.type] < HANDS[hand2.type]
      return -1 if HANDS[hand1.type] > HANDS[hand2.type]

      normalize(hand1)
      normalize(hand2)

      case hand1.type
      when :straight_flush, :straight
        indexes = [0]
      when :four_of_a_kind, :full_house
        indexes = [0, 4]
      when :flush, :high_card
        indexes = (0..4).to_a
      when :three_of_a_kind
        indexes = (2..4).to_a
      when :two_pair
        indexes = [0, 2, 4]
      when :one_pair
        indexes = [0, 2, 3, 4]
      end

      indexes.each do |i|
        next if hand1.cards[i].rank == hand2.cards[i].rank
        return hand1.cards[i].rank - hand2.cards[i].rank
      end

      0
    end

    def normalize(hand)
      hand.cards.sort! { |x, y| y.rank <=> x.rank }
      cards = hand.cards
      case hand.type
      when :straight_flush, :straight
        if cards[0].rank == 14 && cards[1].rank == 5
          tmp = cards[0]
          cards.delete_at(0)
          cards << tmp
        end
      when :four_of_a_kind # xxxxy
        swap(cards, 0, 4) if cards[0].rank != cards[1].rank
      when :full_house # xxxyy
        hand.cards.reverse! if hand.cards[1].rank != hand.cards[2].rank
      when :three_of_a_kind # xxxyz
        swap(cards, 0, 3) if cards[1].rank == cards[3].rank
        if cards[2].rank == cards[4].rank
          swap(cards, 0, 3)
          swap(cards, 1, 4)
        end
      when :two_pair
        if cards[0].rank != cards[1].rank
          tmp = cards[0]
          cards.delete_at(0)
          cards << tmp
        elsif cards[3].rank == cards[4].rank
          swap(cards, 2, 4)
        end
      when :one_pair
        (1..3).each do |i|
          if cards[i].rank == cards[i+1].rank
            pre = [cards.delete_at(i), cards.delete_at(i)]
            hand.cards = pre + cards
            return
          end
        end
      end
    end

    def swap(arr, i, j)
      tmp = arr[j]
      arr[i] = arr[j]
      arr[j] = tmp
    end
  end
end
