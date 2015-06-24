require 'rspec'
require 'pry'
require './ranked_pairs.rb'

describe Contest do
  context "#vote" do

    context "two contestants" do
      context "single vote" do
        before do
          subject.vote('a', 'b')
        end
        
        it "should tally correctly" do
          tally = subject.tally
          expect(tally['a']['b']).to eql 1
          expect(tally['b']).to be_nil
        end

        it "should have the right contestants" do
          expect(subject.contestants).to eql ['a', 'b']
        end

        it "should have the correct margins matrix" do
          margins = subject.margins_matrix
          expect(margins[0, 0]).to eql nil
          expect(margins[0, 1]).to eql 1
          expect(margins[1, 0]).to eql -1
          expect(margins[1, 1]).to eql nil
        end

        it "should have the correct outcomes matrix" do
          outcomes = subject.outcomes_matrix
          expect(outcomes[0, 0]).to eql nil
          expect(outcomes[0, 1]).to eql 1
          expect(outcomes[1, 0]).to eql -1
          expect(outcomes[1, 1]).to eql nil
        end

        it "should return the right leaderboard" do
          leaderboard = subject.leaderboard
          expect(leaderboard).to eql ['a', 'b']
        end
      end

      context "tie" do
        before do
          subject.vote('a', 'b')
          subject.vote('b', 'a')
        end
        
        it "should tally correctly" do
          tally = subject.tally
          expect(tally['a']['b']).to eql 1
          expect(tally['b']['a']).to eql 1
        end

        it "should have the right contestants" do
          expect(subject.contestants).to eql ['a', 'b']
        end

        it "should have the correct margins matrix" do
          margins = subject.margins_matrix
          expect(margins[0, 0]).to eql nil
          expect(margins[0, 1]).to eql 0
          expect(margins[1, 0]).to eql 0
          expect(margins[1, 1]).to eql nil
        end

        it "should have the correct outcomes matrix" do
          outcomes = subject.outcomes_matrix
          expect(outcomes[0, 0]).to eql nil
          expect(outcomes[0, 1]).to eql 0
          expect(outcomes[1, 0]).to eql 0
          expect(outcomes[1, 1]).to eql nil
        end

        it "should return the right leaderboard" do
          leaderboard = subject.leaderboard
          expect(leaderboard).to eql ['a', 'b']
        end
      end

      context "multiple votes" do
        before do
          subject.vote('a', 'b')
          subject.vote('a', 'b')
          subject.vote('a', 'b')
          subject.vote('a', 'b')
          subject.vote('b', 'a')
        end

        it "should tally correctly" do
          tally = subject.tally
          expect(tally['a']['b']).to eql 4
          expect(tally['b']['a']).to eql 1
        end

        it "should have the right contestants" do
          expect(subject.contestants).to eql ['a', 'b']
        end

        it "should have the correct margins matrix" do
          margins = subject.margins_matrix
          expect(margins[0, 0]).to eql nil
          expect(margins[0, 1]).to eql 3
          expect(margins[1, 0]).to eql -3 
          expect(margins[1, 1]).to eql nil
        end

        it "should have the correct outcomes matrix" do
          outcomes = subject.outcomes_matrix
          expect(outcomes[0, 0]).to eql nil
          expect(outcomes[0, 1]).to eql 1
          expect(outcomes[1, 0]).to eql -1
          expect(outcomes[1, 1]).to eql nil
        end

        it "should return the right leaderboard" do
          leaderboard = subject.leaderboard
          expect(leaderboard).to eql ['a', 'b']
        end
      end

    end

    context "three contestants" do
      context "no ties" do
        before do
          subject.vote('a', 'b')
          subject.vote('a', 'b')
          subject.vote('a', 'b')
          subject.vote('a', 'b')
          subject.vote('b', 'a')
          subject.vote('b', 'c')
          subject.vote('b', 'c')
          subject.vote('a', 'c')
        end

        it "should tally correctly" do
          tally = subject.tally
          expect(tally['a']['b']).to eql 4
          expect(tally['b']['a']).to eql 1
          expect(tally['a']['c']).to eql 1
          expect(tally['b']['c']).to eql 2
          expect(tally['c']).to be_nil
        end

        it "should have the right contestants" do
          expect(subject.contestants).to eql ['a', 'b', 'c']
        end

        it "should have the correct margins matrix" do
          margins = subject.margins_matrix
          expect(margins[0, 0]).to eql nil
          expect(margins[0, 1]).to eql 3
          expect(margins[0, 2]).to eql 1
          expect(margins[1, 0]).to eql -3
          expect(margins[1, 1]).to eql nil
          expect(margins[1, 2]).to eql 2
          expect(margins[2, 0]).to eql -1
          expect(margins[2, 1]).to eql -2
          expect(margins[2, 2]).to eql nil
        end

        it "should have the correct outcomes matrix" do
          outcomes = subject.outcomes_matrix
          expect(outcomes[0, 0]).to eql nil
          expect(outcomes[0, 1]).to eql 1
          expect(outcomes[0, 2]).to eql 1
          expect(outcomes[1, 0]).to eql -1
          expect(outcomes[1, 1]).to eql nil
          expect(outcomes[1, 2]).to eql 1
          expect(outcomes[2, 0]).to eql -1
          expect(outcomes[2, 1]).to eql -1
          expect(outcomes[2, 2]).to eql nil
        end

        it "should return the right leaderboard" do
          leaderboard = subject.leaderboard
          expect(leaderboard).to eql ['a', 'b', 'c']
        end
      end


      context "ties" do
        before do
          subject.vote('a', 'b')
          subject.vote('a', 'b')
          subject.vote('a', 'b')
          subject.vote('b', 'a')
          subject.vote('c', 'b')
          subject.vote('c', 'b')
          subject.vote('c', 'b')
          subject.vote('b', 'c')
          subject.vote('a', 'c')
          subject.vote('a', 'c')
          subject.vote('a', 'c')
          subject.vote('a', 'c')
          subject.vote('a', 'c')
          subject.vote('a', 'c')
          subject.vote('a', 'c')
          subject.vote('c', 'a')
          subject.vote('c', 'a')
          subject.vote('b', 'a')
          subject.vote('b', 'a')
        end

        it "should tally correctly" do
          tally = subject.tally
          expect(tally['a']['b']).to eql 3
          expect(tally['a']['c']).to eql 7
          expect(tally['b']['a']).to eql 3
          expect(tally['b']['c']).to eql 1
          expect(tally['c']['a']).to eql 2
          expect(tally['c']['b']).to eql 3
        end

        it "should have the right contestants" do
          expect(subject.contestants).to eql ['a', 'b', 'c']
        end

        it "should have the correct margins matrix" do
          margins = subject.margins_matrix
          expect(margins[0, 0]).to eql nil
          expect(margins[0, 1]).to eql 0
          expect(margins[0, 2]).to eql 5
          expect(margins[1, 0]).to eql 0
          expect(margins[1, 1]).to eql nil
          expect(margins[1, 2]).to eql -2
          expect(margins[2, 0]).to eql -5 
          expect(margins[2, 1]).to eql 2
          expect(margins[2, 2]).to eql nil
        end

        it "should have the correct outcomes matrix" do
          outcomes = subject.outcomes_matrix
          expect(outcomes[0, 0]).to eql nil
          expect(outcomes[0, 1]).to eql 0
          expect(outcomes[0, 2]).to eql 1
          expect(outcomes[1, 0]).to eql 0
          expect(outcomes[1, 1]).to eql nil
          expect(outcomes[1, 2]).to eql -1
          expect(outcomes[2, 0]).to eql -1
          expect(outcomes[2, 1]).to eql 1
          expect(outcomes[2, 2]).to eql nil
        end

        it "should return the right leaderboard" do
          leaderboard = subject.leaderboard
          expect(leaderboard).to eql ['a', 'c', 'b']
        end
      end
    end

    context "losses sorted correctly" do
      before do
        subject.vote('a', 'c')
        subject.vote('a', 'b')
        subject.vote('d', 'b')
      end

      it "should return the right leaderboard" do
        leaderboard = subject.leaderboard
        expect(leaderboard).to eql ['a', 'd', 'c', 'b']
      end

    end
  end
end
