require 'set'

class WordChainer
  def initialize(dictionary_file_name)
    @dictionary = readfile(dictionary_file_name)
  end

  def readfile(dictionary_file_name)
    words = Set.new()
    File.foreach(dictionary_file_name) do |line|
      words << line.strip
    end
    words
  end

  def adjacent_words(curr_word)
    correct_length_words = @dictionary.select { |word| word.length == curr_word.length }
    adj_words = []
    correct_length_words.each do |word|
      dif = 0
      (0...curr_word.length).each do |i|
        if word[i] != curr_word[i]
          dif += 1
        end
      end
      if dif == 1
        adj_words << word
      end
    end
    adj_words
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = {source => nil}
    until @current_words.empty? || @all_seen_words.include?(target)
      @current_words = explore_current_words
    end
    build_path(target)
  end

  def explore_current_words
    new_current_words = []
    @current_words.each do |curr_word|
      adjacent_words(curr_word).each do |adj_word|
        unless @all_seen_words.include?(adj_word)
          new_current_words << adj_word
          @all_seen_words[adj_word] = curr_word
        end
      end
    end
    new_current_words
  end

  def build_path(target)
    add_word = target
    path = [target]
    until @all_seen_words[add_word] == nil
      add_word = @all_seen_words[add_word]
      path.unshift(add_word)
    end
    p path
  end
end

if $PROGRAM_NAME == __FILE__
  w = WordChainer.new(ARGV.shift)
  w.run("duck", "ruby")
end
