#!/usr/bin/env ruby
require 'pry'
# YOUR CODE HERE
class Card
  attr_reader :rank, :suit
  def initialize (rank, suit)
    @rank = rank
    @suit = suit
  end
  def face?
    ['J','Q','K'].include?(@rank)
  end
  def ace?
    ['A'].include?(@rank)
  end
end

class Deck
  SUITS = ['♤','♧','♡','♢']
  RANKS = ['A','2','3','4','5','6','7','8','9','10','J','Q','K']
  attr_reader
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
  attr_reader :score
  def initialize(deck, name)
    @score = 0
    @deck = deck
    @name = name.downcase
  end
  def deal
    card = @deck.draw!
    if card.ace? == true
      if @score + 11 > 21
        @score += 1
      else
        @score += 11
      end
    elsif card.face? == true
      @score += 10
    else
      @score += card.rank.to_i
    end
    "#{@name.capitalize} was dealt #{card.rank}#{card.suit}"
  end
  def update
    "#{@name.capitalize} score: #{@score}"
  end
end

class Blackjack
  attr_reader
  def initialize
  end
end

def game
  deck = Deck.new
  player = Hand.new(deck,'player')
  dealer = Hand.new(deck, 'dealer')
  puts 'Welcome to Blackjack!'
  puts
  2.times do
    puts player.deal
  end
  puts player.update
  loop do
    puts
    print "Hit or stand (H/S):"
    input = gets.chomp
    puts
    if input == 'h'.downcase
      puts player.deal
      puts player.update
      if player.score > 21
        puts
        puts 'Bust! You lose...'
        break
      end
    elsif input == 's'.downcase
      puts player.update
      puts
      puts
      puts dealer.deal
      loop do
        puts dealer.deal
        puts dealer.update
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
      break
    else
      puts 'Invalid input'
    end
  end
end

game
