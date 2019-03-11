class String
  def pluralize_sentence(count = 0, locale = :en)
    words = split
    words.map do |word|
      if word.first == ':'
        word = word.delete ':'
        word.pluralize count, locale
      else word
      end
    end.join ' '
  end
end
