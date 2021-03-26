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

  def CheckExactMatch(regex, target)
    return regex == target
  end

  def ParseRegex(regex, target)
    # Check if regex or target are empty
    if regex == ""
      return target == ""
    end
    # Recursively iterate through regex and target, checking for dots and asterisk matches
    matched = (target != "" && (regex[0] == target[0] || regex[0] == "."))

    if regex.length >= 2 && regex[1] == "*"
      return ParseRegex(regex[2..regex.length], target) || (matched && ParseRegex(regex, target[1..target.length]))
    elsif regex.length > 2 and regex[1] == "|"
      return ParseRegex(regex[2..regex.length], target) || regex[0] == target[0]
    else
      return matched && ParseRegex(regex[1..regex.length], target[1..target.length])
    end
  end

  def CheckTargetAsterisk(regex, target)
    return (target.count "*") > 0
  end

  def CheckTargetPipe(regex, target)
    return (target.count "|") > 0
  end

  def CheckBracketMismatch(regex, target)
    open = regex.count "("
    close = regex.count ")"
    return open != close
  end

  def CheckInvalidAsterisk(regex, target)
    if (regex.count "*") == 0
      return false
    elsif regex[0] == "*"
      return true
    else
      index = regex.index("*")
      return (regex[index-1] == "(") || (regex[index-1] == "|")
    end
  end

  # Iterate through the expressions and targets and check whether the regex matches
  regexFile.each_with_index do |i, n|
    if CheckTargetAsterisk(regexFile[n], targetFile[n]) then
      puts "NO: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("NO: " + regexFile[n] + " with " + targetFile[n] + "\n")

    elsif CheckTargetPipe(regexFile[n], targetFile[n]) then
      puts "NO: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("NO: " + regexFile[n] + " with " + targetFile[n] + "\n")

    elsif CheckBracketMismatch(regexFile[n], targetFile[n]) then
      puts "SYNTAX ERROR: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("SYNTAX ERROR: " + regexFile[n] + " with " + targetFile[n] + "\n")

    elsif CheckInvalidAsterisk(regexFile[n], targetFile[n]) then
      puts "SYNTAX ERROR: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("SYNTAX ERROR: " + regexFile[n] + " with " + targetFile[n] + "\n")

    elsif CheckExactMatch(regexFile[n], targetFile[n])
      puts "YES: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("YES: " + regexFile[n] + " with " + targetFile[n] + "\n")

    elsif ParseRegex(regexFile[n], targetFile[n])
      puts "YES: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("YES: " + regexFile[n] + " with " + targetFile[n] + "\n")

    else
      puts "NO: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("NO: " + regexFile[n] + " with " + targetFile[n] + "\n")
    end
  end

  outputFile.close

# rescue
#   puts "Looks like something has gone wrong."
end
