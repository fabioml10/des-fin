class NotifyPartners < ApplicationService
  def initialize(data)
    @params = data
  end

  def call
    NotifyPartner.new.perform
    NotifyPartner.new("another").perform
  end
end
