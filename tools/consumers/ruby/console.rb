require "irb"
require "irb/completion"

ARGV = []
puts "This is Ruby console. You have access to database through $db and following $models:
#{$models.values.join("\n")}"
puts "You can investigate also $services."

IRB.start
