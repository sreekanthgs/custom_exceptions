class String
  def classify
    self.split('_').collect!{ |w| w.capitalize }.join
  end
end
