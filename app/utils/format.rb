class Format
  class << self
    def phone(phone)
      phone&.to_s&.gsub(/\D/, "")
    end
  end
end
