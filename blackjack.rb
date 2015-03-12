#!/usr/bin/env ruby
class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def face?
    %w(J Q K).include?(rank)
  end

  def ace?
    %w(A).include?(rank)
  end
end

class Deck
  SUITS = %w(♤ ♧ ♡ ♢)
  RANKS = %w(A 2 3 4 5 6 7 8 9 10 J Q K)

  def initialize
    @deck = []
    SUITS.each do |suit|
      RANKS.each do |rank|
        @deck << Card.new(rank, suit)
      end
    end
    @deck.shuffle!
  end

  def draw!
    @deck.pop
  end
end

class Hand
  attr_reader :cards, :score

  def initialize(name)
    @cards = []
    @name = name.downcase
    @score = 0
  end

  def deal(card)
    cards << card
    "#{@name.capitalize} was dealt #{card.rank}#{card.suit}"
  end

  def scoring
    points = 0
    aces = 0
    cards.each do |card|
      if card.ace? == true
        aces += 1
      elsif card.face? == true
        points += 10
      else
        points += card.rank.to_i
      end
    end
    while aces > 0
      if points + (aces * 11) <= 21
        points += aces * 11
        aces = 0
      else
        points += 1
        aces -= 1
      end
    end
    @score = points
    "#{@name.capitalize} score: #{points}"
  end
end

class Blackjack
  attr_reader :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Hand.new('player')
    @dealer = Hand.new('dealer')
    puts 'Welcome to Blackjack!'
    puts
    2.times do
      puts player.deal(@deck.draw!)
    end
    puts player.scoring
    puts
    choice
  end

  def choice
    loop do
      print 'Hit or stand (H/S): '
      input = gets.chomp
      puts
      if input == 'h'.downcase
        puts player.deal(@deck.draw!)
        puts player.scoring
        if player.score > 21
          puts 'Bust! You lose...'
          break
        end
      elsif input == 's'.downcase
        puts player.scoring
        puts
        puts
        turn
        break
      else
        puts 'Invalid input'
      end
    end
  end

  def turn
    puts dealer.deal(@deck.draw!)
    loop do
      puts dealer.deal(@deck.draw!)
      puts dealer.scoring
      puts
      if dealer.score.between?(17, 21)
        puts 'Dealer stands.'
        puts
        if player.score == dealer.score
          puts 'Tie! Better luck next time...'
        elsif player.score > dealer.score
          puts 'You win!'
        else
          puts 'House wins!'
        end
        break
      elsif dealer.score > 21
        puts 'Bust! You win!'
        break
      end
    end
  end
end

Blackjack.new
