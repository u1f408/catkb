module CatKB
  def self.generate_id(length = 20)
    Base32.random_base32(length, false).downcase
  end

  def self.generate_barcode
    "%CatKB/#{generate_id(16)}/"
  end
end
