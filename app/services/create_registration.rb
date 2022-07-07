class CreateRegistration < ApplicationService
  def initialize(payload)
    @payload = payload
    @result = nil
  end

  def call
    create_account
    notify_partner_or_partners
    @result
  end

  private

  def create_account
    @result = CreateAccount.call(@payload)
  end

  def notify_partner_or_partners
    return unless from_partner?

    many_partners? ? NotifyPartners.call : NotifyPartner.new.perform
  end

  def from_partner?
    @payload[:from_partner] == true
  end

  def many_partners?
    @payload[:many_partners] == true
  end
end
