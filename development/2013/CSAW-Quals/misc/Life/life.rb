module GameOfLife
    class Board 
        attr_reader :grid

        def initialize(rows, columns, state = nil)
            @rows = rows
            @columns = columns
            @grid = Array.new(rows) { Array.new(columns, StateMachine::DEAD) }
            if state
                initialize_state(state)
            end
        end

        def initialize_state(state)
            state.each do |i, j|
                @grid[i][j] = StateMachine::LIVE
            end
        end

        def randomize()
            rng = Random.new()
            state = []
            cells = (@rows * @columns) / ((@rows + @columns) / 4)
            rng.rand(cells..cells+16).times do |i|
                if rng.rand(2) > 0 or i == 0
                    # place completely random point
                    state << [rng.rand(@rows), rng.rand(@columns)]
                else
                    # attempt to cluster in some way
                    row = state[i-1][0] + rng.rand(-1..1)
                    column = state[i-1][1] + rng.rand(-1..1)
                    # catch edge cases
                    row = rng.rand(@rows) if (row >= @rows or row < 0)
                    column = rng.rand(@columns) if (column >= @columns or column < 0)
                    state << [row, column]
                end
            end
            initialize_state(state)
        end

        def next_state
            new_grid = []
            @grid.each_with_index do |row, i|
                new_row = []
                row.each_with_index do |column, j|
                    new_row << StateMachine.next_state(@grid[i][j], live_neighbors(i, j))
                end
                new_grid << new_row
            end
            @grid = new_grid
        end

        def live_neighbors(row, column)
            count = 0
            (-1..1).each do |i|
                (-1..1).each do |j|
                    next if (i.zero?() and j.zero?())
                    row_index = row + i
                    column_index = column + j
                    if row_index >= 0 and row_index < @rows and column_index >= 0 and column_index < @columns
                        count += 1 if @grid[row_index][column_index] == StateMachine::LIVE
                    end
                end
            end
            return count
        end

        def to_s
            s = ""
            s << "#" * (@columns + 2) << "\n"
            @grid.each do |row|
                s << "#"
                row.each do |column|
                    if column == StateMachine::LIVE
                        s << "*"
                    else
                        s << " "
                    end
                end
                s << "#\n"
            end
            return s << "#" * (@columns + 2) << "\n"
        end
    end

    class StateMachine
        # Any live cell with fewer than two live neighbors dies, as if caused by under-population
        # Any live cell with two or three live neighbors lives on to the next generation
        # Any live cell with more than three live neighbors dies, as if by overcrowding
        # Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction
        DEATH = [0, 1, 4, 5, 6, 7, 8]
        BIRTH = [3]

        LIVE = 1
        DEAD = 0

        def self.next_state(cell, live_neighbors)
            if cell == DEAD
                if BIRTH.include?(live_neighbors)
                    return LIVE
                else
                    return DEAD
                end
            elsif cell == LIVE
                if DEATH.include?(live_neighbors)
                    return DEAD
                else
                    return LIVE
                end
            else
                return DEAD
            end
        end
    end
end

if __FILE__ == $0
    require "socket"
    require "timeout"

    # bind and listen
    acceptor = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
    address = Socket.pack_sockaddr_in(45678, "0.0.0.0")
    acceptor.bind(address)
    acceptor.listen(10)

    # set up traps
    trap("EXIT") { acceptor.close() }
    trap("INT") { exit() }

    # accept and fork
    loop do
        socket, addr = acceptor.accept()
        fork do
            begin
                # create new random number generator
                rng = Random.new()

                # start our game loop
                100.times do |i|
                    # create a randomly-generated board
                    columns = rng.rand(8..32)
                    rows = rng.rand(8..32)
                    game = GameOfLife::Board.new(rows, columns)
                    game.randomize()

                    # send the board to the client
                    generations = rng.rand(16..64)
                    socket.write("\n##### Round #{i + 1}: #{generations} Generations #####\n")
                    socket.write(game)
                    socket.flush()

                    # advance the state machine
                    generations.times do
                        game.next_state()
                    end
                    #puts(game)  # UNCOMMENT FOR DEBUGGING (can then copy/paste answers into netcat)

                    # read and check the client's answer
                    begin
                        timeout(2) do
                            game.to_s.each_line do |line|
                                response = socket.gets()
                                if response != line
                                    socket.close()
                                    exit()
                                end
                            end
                        end
                    rescue Timeout::Error
                        socket.puts("\nToo slow!")
                        socket.close()
                        exit()
                    end
                end

                # if the client made it through, send them the key as the 100th round
                File.open("key", "r") do |key|
                    puts("\nCongratulations!")
                    puts("You made it!")
                    puts("Here's your prize: #{key.read()}")
                end
            rescue
                socket.close()
                exit()
            end
        end
        socket.close()
    end
end
