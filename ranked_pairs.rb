require 'matrix'
require 'ostruct'

class Matrix
  def print
    to_a.each { |r| puts r.inspect } && nil 
  end
  public :"[]=", :set_element, :set_component
end

class Contest

  def initialize
    @tally = {}
  end

  def vote(winner, loser, multiplier = 1)
    add_contestants(winner, loser)
    create_if_missing(winner, loser)
    @tally[winner][loser] = @tally[winner][loser] + (1 * multiplier)
  end

  def leaderboard
    obc = outcomes_by_contestant
    contestants.sort do |a, b|
      wtl_a = obc[a]
      wtl_b = obc[b]
      if wtl_a.wins != wtl_b.wins
        wtl_b.wins <=> wtl_a.wins
      elsif wtl_a.ties != wtl_b.ties
        wtl_b.ties <=> wtl_a.ties
      elsif wtl_a.losses != wtl_b.losses
        wtl_a.losses <=> wtl_b.losses
      else
        0
      end
    end
  end

  def outcomes_by_contestant
    retval = {}
    matrix = outcomes_matrix
    contestants.each_with_index do |contestant, index|
      row = matrix.row(index).to_a
      wins = row.count { |e| e && e > 0 }
      ties = row.count { |e| e && e == 0 }
      losses = row.count { |e| e && e < 0 }
      retval[contestant] = OpenStruct.new(wins: wins, ties: ties, losses: losses)
    end
    retval
  end

  def tally
    @tally
  end

  def contestants
    @contestants
  end

  def print_tally
    puts @tally.to_s
  end

  def print_margins_matrix
    t1 = Time.now
    margins_matrix.print
    t2 = Time.now
    msecs = time_diff_milli t1, t2
    puts "Time for margins matrix: #{msecs}"
  end

  def print_outcomes_matrix
    t1 = Time.now
    outcomes_matrix.print
    t2 = Time.now
    msecs = time_diff_milli t1, t2
    puts "Time for outcomes matrix: #{msecs}"
  end

  def margins_matrix
    keys = contestants
    m = Matrix.zero(keys.length)
    keys.each_with_index do |row_name, row_index|
      keys.each_with_index do |column_name, column_index|
        if row_name == column_name
          m[row_index, column_index] = nil
          next
        else
          if @tally[row_name] && @tally[row_name][column_name]
            m[row_index, column_index] += @tally[row_name][column_name]
            m[column_index, row_index] -= @tally[row_name][column_name]
          end
        end
      end
    end
    m
  end

  def outcomes_matrix
    mm = margins_matrix
    Matrix.build(mm.row_size) do |row, column|
      if mm[row, column] == nil
        nil
      else
        mm[row, column] == 0 ? 0 : mm[row, column] / mm[row, column].abs
      end
    end
  end

  private

    def add_contestants(*toadd) 
      @contestants ||= []
      @contestants << toadd
      @contestants.flatten!.uniq!
      @contestants.sort!
    end

    def create_if_missing(a, b)
      @tally[a] = {} unless @tally && @tally[a]
      @tally[a][b] = 0 unless @tally[a][b]
    end
    
    def time_diff_milli(start, finish)
      (finish - start) * 1000.0
    end
end
