class PaymentProviderApi
  def self.call(user)
    new.call(user)
  end

  def call(user)
    begin
      ['All good', false].sample ? true : raise('Error')
    rescue RuntimeError
      false
    end
  end
end

