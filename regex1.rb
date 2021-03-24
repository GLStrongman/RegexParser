begin
  # Check the correct number of arguments has been given
  if ARGV.length < 2
    puts "Too few arguments given."
    exit
  elsif ARGV.length > 2
    puts "Too many arguments given."
    exit
  end

  # Read in files from arguments
  regexFilePath = File.open(ARGV[0])
  targetFilePath = File.open(ARGV[1])

  regexFile = File.read(regexFilePath).split("\n")
  targetFile = File.read(targetFilePath).split("\n")

  # Close files
  regexFilePath.close
  targetFilePath.close

  # Create or overwrite output file
  outputFile = File.open("output.txt", "w")

  def checkMatch(regex, target)
    if regex == target then
      return true
    else
      return false
    end
  end

  def checkBracketMismatch(regex, target)
    open = regex.count "("
    close = regex.count ")"
    if open != close then
      return true
    else
      return false
    end
  end

  # Iterate through the expressions and targets and check whether the regex matches
  regexFile.each_with_index do |i, n|
    if checkMatch(regexFile[n], targetFile[n]) then
      puts "YES: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("YES: " + regexFile[n] + " with " + targetFile[n] + "\n")

    elsif checkBracketMismatch(regexFile[n], targetFile[n]) then
      puts "SYNTAX ERROR: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("SYNTAX ERROR: " + regexFile[n] + " with " + targetFile[n] + "\n")

    else
      puts "NO: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("NO: " + regexFile[n] + " with " + targetFile[n] + "\n")
    end
  end
  outputFile.close

end
