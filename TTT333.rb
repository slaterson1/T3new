module TicTacToe

	class Run
		def initialize
			puts "Welcome to Tic Tac Toe!"
			puts ""
			puts "Please Select An Option"
			puts "------------------------------"
			puts "1: Human vs Human"
			puts "2: Human vs Computer"
			puts "3: Exit"
			puts "------------------------------"
			puts ""

			response = gets.chomp.to_s

			if response =~ (/[123]/)
				case response
				when "1"
					HumanHumanGame.new
				when "2"
					HumanCompGame.new
				when "3"
					puts "Goodbye!"
					puts ""
					exit
				else
					puts "Invalid Input!"
					puts "Please enter either 1, 2, or 3"
					Run.new
				end
			end
		end
	end

	class Board
		attr_accessor :board
		def initialize
			@board = [1,2,3,4,5,6,7,8,9]
		end

		def display_board
	  		puts ""         
   	  		puts "|#{@board[0]}|#{@board[1]}|#{@board[2]}|"
	  		puts "|#{@board[3]}|#{@board[4]}|#{@board[5]}|"
	  		puts "|#{@board[6]}|#{@board[7]}|#{@board[8]}|"
	  		puts ""
		end

		def place_piece(space, xo)
			@board[space - 1] = xo
			display_board
		end

		def available?(space)
			((@board[space - 1] == "X") || (@board[space - 1] == "O")) ? false : true
		end

		def win?(xo)
			solutions = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
			container = []
				solutions.each do |solve|
				container.clear
				solve.each do |number|
					container << @board[number]
				end
				return true if container.all? {|position| position == xo}
			end
			false
		end
	end




	class Player1
		attr_reader :name, :x_or_o
		def initialize(computer = false)
			@computer = computer
			@name = get_name
			@piece = choose_piece
		end

		def get_name
			if @computer == true
				"CPU"
			elsif @computer == false
				print "Please Enter Your Name: "
				gets.chomp
			end
		end

		def choose_piece
			print "Would you like to play as X or O?: "
			choice = gets.chomp.capitalize
			if choice =~ (/[^XO]/)
				puts "Invalid Selection.  Please Enter Either X or O"
				choose_piece
			else
				choice
			end
		end

		def take_turn(board, xo)
			if @computer == true
				comp_take_turn(board, xo)
			else
				puts "Select a number to place an #{xo} in."
				position = gets.chomp.to_i
				if position.to_s =~ (/[1-9]/) && position.to_s.length == 1 && board.available?(position)
					position
				else
					puts "Invalid position. Please enter a number between 1 - 9."
					take_turn(board, xo)
				end
			end
		end

		def comp_take_turn(board, xo)
			loop do
				choice = rand(1..9)
				if board.available?(choice)
					return choice
				end
			end
		end
	end

	class Player2 < Player1
		def initialize(computer = false)
			@computer = computer
			@name = get_name
		end
	end

	class Game
		def initialize
			@player1 = Player1.new(false)
			@player2 = Player2.new(false)
			define
		end

		def define
			@playerX = @player1.x_or_o == "X" ? @player2 : @player1
			@playerO = @playerX == @player1 ? @player2 : @player1
			display_players
			@current_game = Board.new
			@current_game.display_board
			run_game(@current_game, @playerX, @playerO)
		end

		def display_players
			puts "(X) #{@playerX.name}"
			puts "(O) #{@playerO.name}"
			puts ""
		end

		def run_game(board, playerX, playerO)
			moves = 0
		
			5.times do
				if who_won?(board, "O", playerO)
					break
				else
					selection_x = @playerX.take_turn(@current_game, "X")
					@current_game.place_piece(selection_x, "X")
					moves += 1
				end
				if who_won?(board, "X", playerX) || draw?(moves)
					break
				else
					selection_o = @playerO.take_turn(@current_game, "O")
					@current_game.place_piece(selection_o, "O")
					moves += 1
				end 
			end
		end

		def draw?(moves)
			if moves == 9
				puts "Draw!"
				true
			end
		end

		def who_won?(board, xo, player)
			if board.win?(xo)
				puts "#{player.name} Has Won!"
				true
			else
				false
			end
		end
	end

	class HumanHumanGame < Game
	end

	class HumanCompGame < Game
		def initialize
			@player1 = Player1.new(false)
			@player2 = Player2.new(true)
			define
		end
	end

end

TicTacToe::Run.new