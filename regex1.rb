begin
  # Check the correct number of arguments has been given
  if ARGV.length < 2
    puts "Too few arguments given."
    exit
  elsif ARGV.length > 2
    puts "Too many arguments given."
    exit
  end

  # Handles file reading erros
  begin
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

  rescue
    puts "Something has gone wrong with opening the expressions and targets files - is the path correct?"
  end

  # Check whether the regex and target match exactly
  def CheckExactMatch(regex, target)
    return regex == target
  end

  # Check for bracket syntax errors
  def CheckBracketMismatch(regex)
    open = regex.count "("
    close = regex.count ")"
    return open != close
  end

  # Check for invalid characters before asterisks
  def CheckInvalidAsterisk(regex)
    if (regex.count "*") == 0
      return false
    elsif regex[0] == "*"
      return true
    else
      index = regex.index("*")
      return (regex[index-1] == "(") || (regex[index-1] == "|")
    end
  end

  # Check whether asterisks match target pattern
  def CheckMatch(regex, target)
    # Check if regex or target are empty
    if regex == ""
      return target == ""
    end
    # Recursively iterate through regex and target, checking for dots and asterisk matches
    matched = (target != "" && (regex[0] == target[0] || regex[0] == "."))
    if regex.length >= 2 && regex[1] == "*"
     return CheckMatch(regex[2..regex.length], target) || (matched && CheckMatch(regex, target[1..target.length]))
    else
     return matched && CheckMatch(regex[1..regex.length], target[1..target.length])
    end
  end

  # Helper method to remove brackets from string
  def ScrapeBrackets(regex)
    r = ''
    (0..regex.length-1).each do |i|
      if (regex[i] != ")") && (regex[i] != "(")
        r += regex[i]
      end
    end
    return r
  end

  # Helper method to check two strings ignoring periods
  def SkipDots(r, t)
    if r.length != t.length
      return false
    end
    if r == "" && t == ""
      return true
    end
    (0..r.length-1).each do |i|
      if (r[i] != ".") && (r[i] != t[i])
        return false
      end
    end
    return true
  end

  # Check whether regex matches target with no brackets
  def CheckBrackets(regex, target)
    r = ScrapeBrackets(regex)
    if r.length == target.length
      return SkipDots(r, target)
    end
    return false
  end

  # Check whether regex with pipes match the target
  def CheckPipe(regex, target)
    pipe = regex.count "|"
    if pipe == 0
      return false
    # Handle one pipe
    elsif pipe == 1
      if regex[0] == "|"
        l = ""
      else
        l = regex[0..(regex.index("|")-1)]
      end
      r = regex[(regex.index("|")+1)..regex.length]
      left = ScrapeBrackets(l)
      right = ScrapeBrackets(r)
      return SkipDots(left, target) || SkipDots(right, target)
      # Handle double pipes
    elsif pipe == 2
      l = regex[0..(regex.index("|")-1)]
      remainder = regex[(regex.index("|")+1..regex.length)]
      if remainder[0] == "|"
        m = ""
      else
        m = remainder[0..(remainder.index("|")-1)]
      end
      r = remainder[(remainder.index("|")+1)..remainder.length]
      left = ScrapeBrackets(l)
      middle = ScrapeBrackets(m)
      right = ScrapeBrackets(r)
      return SkipDots(left, target) || SkipDots(middle, target) || SkipDots(right, target)
    else
      return false
    end
  end

  # Check whether target contains asterisk
  def CheckTargetAsterisk(regex, target)
    return (target.count "*") > 0
  end

  # Check whether target contains pipe
  def CheckTargetPipe(regex, target)
    return (target.count "|") > 0
  end

  # Iterate through the expressions and targets and check whether the regex matches
  regexFile.each_with_index do |i, n|

    if CheckTargetAsterisk(regexFile[n], targetFile[n]) then
      puts "NO: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("NO: " + regexFile[n] + " with " + targetFile[n] + "\n")

    elsif CheckTargetPipe(regexFile[n], targetFile[n]) then
      puts "NO: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("NO: " + regexFile[n] + " with " + targetFile[n] + "\n")

    elsif CheckExactMatch(regexFile[n], targetFile[n]) then
      puts "YES: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("YES: " + regexFile[n] + " with " + targetFile[n] + "\n")

    elsif CheckBracketMismatch(regexFile[n]) then
      puts "SYNTAX ERROR: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("SYNTAX ERROR: " + regexFile[n] + " with " + targetFile[n] + "\n")

    elsif CheckInvalidAsterisk(regexFile[n]) then
      puts "SYNTAX ERROR: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("SYNTAX ERROR: " + regexFile[n] + " with " + targetFile[n] + "\n")

    elsif CheckMatch(regexFile[n], targetFile[n]) then
      puts "YES: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("YES: " + regexFile[n] + " with " + targetFile[n] + "\n")

    elsif CheckBrackets(regexFile[n], targetFile[n]) then
      puts "YES: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("YES: " + regexFile[n] + " with " + targetFile[n] + "\n")

    elsif CheckPipe(regexFile[n], targetFile[n]) then
      puts "YES: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("YES: " + regexFile[n] + " with " + targetFile[n] + "\n")

    else
      puts "NO: " + regexFile[n] + " with " + targetFile[n]
      outputFile.write("NO: " + regexFile[n] + " with " + targetFile[n] + "\n")
    end
  end

  outputFile.close

rescue
  puts "Looks like something has gone wrong."
end
