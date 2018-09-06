class InvalidFileError < StandardError
  def initialize(msg="Fehlermeldung")
    super
  end
end

module Validation
	def is_number? string
	  true if Float(string) rescue false
	end
end

class Robot

	include Validation

	attr_accessor :x, :y, :f
	DIRECTION = %w(NORTH EAST SOUTH WEST)

	def next_step_valid?(x, y)
		if ((x >= 0 and x < 5) and (y >= 0 and y < 5))
			return true
		else
			puts 'Vorsicht! Absturz des Roboters bevorstehend. Befehl wird ignoriert.' unless ENV['RACK_ENV'] == 'test'
			
			return false
		end
	end

	def place(x, y, f)
		if next_step_valid?(x,y)
			@x = x
			@y = y
			f rescue nil
			until DIRECTION[0] == f do
				DIRECTION.rotate!(1)	
			end
			@f = DIRECTION[0]
		end
	end

	def move
		case self.f 
		when 'NORTH'
			next_step_valid?(self.x, self.y+1)? self.y+=1 : self.y
		when 'SOUTH'
			next_step_valid?(self.x, self.y-1)? self.y-=1 : self.y
		when 'EAST'
			next_step_valid?(self.x+1, self.y)? self.x+=1 : self.x
		when 'WEST'
			next_step_valid?(self.x-1, self.y)? self.x-=1 : self.x
		end
	end

	def left
		self.f = DIRECTION.rotate!(-1)[0]
	end

	def right
		self.f = DIRECTION.rotate!(1)[0]
	end

	def report
		puts "x: #{self.x} | y: #{self.y} | Richtung: #{self.f}"
	end

	def get_input
		commands = []
		p "Bitte einen Roboterbefehl nach dem anderen eingeben. Drücken der Eingabe-Taste führt zur nächsten Eingabezeile. Um Eingabe zu beenden und alle Befehle vom Roboter ausführen zu lassen, bitte 'exit' eintippen."
		$/ = "exit"  
		user_input = STDIN.gets
		commands = user_input.chomp.split("\n")
    execute_commands(commands)
	end

	def execute_commands(commands)
		allowed = false
		commands.each do |command|
			# Hier erhält man beispielsweise folgenden Code: ['Place 0,0,North']
			# da dieser entweder am Komma oder am Leerzeichen getrennt werden muss
			# wird hier eine RegExp verwendet
			command = command.split(/[\s,']/)
			if (command.include?("PLACE") and next_step_valid?(command[1].to_i, command[2].to_i))
				allowed = true
			end
			perform(command, allowed)
		end
	end

	def perform(command_array, allowed)
		if allowed
			args = []
			command = command_array[0]	
			if command_array.length > 1
				args = command_array.drop(1).map { |i| is_number?(i) ? i.to_i : i}
			end
			begin
				self.send(command.downcase, *args)
			rescue=>e
				puts "Command rescued with following error message: #{e.message}"
			end
		else
			puts "Befehl wird nicht ausgeführt, da kein gültiger PLACE-Befehl eingegeben wurde."
		end
	end

	def read_file
		begin
			commands = Array.new
			
			ARGV[0] ? file = ARGV[0] : file = 'user_input.txt'

			File.open(file).each do |line|
				commands << line.chomp
			end
			execute_commands(commands)
		rescue=>e
			raise InvalidFileError, "Invalid file provided. #{e}"
		end
	end

	def start
		if ARGV[0] == 'user'
			self.get_input
		else
			self.read_file
		end
	end

end


