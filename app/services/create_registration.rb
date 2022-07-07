class CreateRegistration < ApplicationService
  def initialize(payload)
    @payload = payload
  end

  def call
    if @payload[:from_partner] == true && @payload[:many_partners] == true
      @result = create_account_and_notify_partners
    elsif @payload[:from_partner] == true
      @result = create_account_and_notify_partner
    else
      @result = create_account
    end

    return Result.new(true, @result.data) if @result.success?

    @result
  end

  private

  def create_account_and_notify_partner
    CreateAccountAndNotifyPartner.call(@payload)
  end

  def create_account_and_notify_partners
    CreateAccountAndNotifyPartners.call(@payload)
  end

  def create_account
    if @payload[:name].include?("Fintera") && fintera_users
      CreateAccount.call(@payload, true)
    else
      CreateAccount.call(@payload, false)
    end
  end

  def fintera_users
    @payload[:entities].any? { |entity| entity[:users].any? { |user| user[:email]&.include? "fintera.com.br" } }
  end
end
