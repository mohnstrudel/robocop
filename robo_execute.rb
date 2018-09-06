require_relative 'robocop'


# Anweisung zur Ausführung:
# ruby robo_execute.rb <- führt den Skript durch mit Testbewegungen
# ruby robo_execute.rb 'user' <- führt den Skript durch mit Befehlen, welcher Benutzer in der
# Shell eingeben kann
# ruby robo_execute.rb my_command_file.txt <- führt den Skript durch mit Befehln, welche in der
# Datei my_command_file.txt gespeichert sind

et = Robot.new
et.start