# Read in files - done manually for now
puts 'Please enter regex file path:'
# regexFilePath = File.open(gets.chomp)
regexFilePath = File.open('expressions.txt')
regexFile = File.read(regexFilePath).split("\n")
puts 'Please enter expressions file path:'
# targetFilePath = File.open(gets.chomp)
targetFilePath = File.open('targets.txt')
targetFile = File.read(targetFilePath).split("\n")
puts regexFile.length
puts targetFile.length

# Check whether target exactly matches regex
regexFile.each_with_index do |i, n|
  if regexFile[n] == targetFile[n] then
    puts "YES: " + regexFile[n] + " with " + targetFile[n]
  else
    puts "NO: " + regexFile[n] + " with " + targetFile[n]
  end
end