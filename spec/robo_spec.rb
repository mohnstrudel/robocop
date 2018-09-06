require_relative '../robocop'

RSpec.describe Robot, '#chess' do 
	let(:robot) { Robot.new }

	context 'initial placing' do
		it "has valid values" do
			robot.place(0,0,'NORTH')

			expect(robot.x).to eq 0
			expect(robot.y).to eq 0
			expect(robot.f).to eq 'NORTH'
		end

		it 'has invalid values' do
			robot.place(-1,6, 'EAST')

			expect(robot.x).to eq nil
			expect(robot.y).to eq nil
			expect(robot.f).to eq nil
		end
	end

	context 'turning' do
		it 'does turn right' do
			robot.place(0,0,'NORTH')
			robot.right

			expect(robot.f).to eq 'EAST'
		end

		it 'does turn left' do
			robot.place(0,0,'NORTH')
			robot.left

			expect(robot.f).to eq 'WEST'
		end
	end

	context 'movement' do
		it 'does not move into invalid direction' do
			robot.place(0,0,'SOUTH')
			robot.move

			expect(robot.x).to eq 0
			expect(robot.y).to eq 0
		end

		it 'does move into valid direction up' do
			robot.place(0,0,'NORTH')
			robot.move

			expect(robot.x).to eq 0
			expect(robot.y).to eq 1
		end

		it 'does move into valid direction right' do
			robot.place(0,0,'NORTH')
			robot.right
			robot.move

			expect(robot.x).to eq 1
			expect(robot.y).to eq 0
		end
	end

	context 'file' do
		it 'does not accept invalid files' do
			ARGV[0] = 'invalid_file.txt'
			
			expect{robot.read_file}.to raise_error(InvalidFileError)
		end
	end
	
end