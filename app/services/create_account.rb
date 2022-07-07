class CreateAccount < ApplicationService
  def initialize(payload, from_fintera = false)
    @payload = payload
    @from_fintera = from_fintera
    @errors = []
  end

  def call
    validate_account
    validate_users
    return @result unless @errors.empty?

    build_account
    build_users
    account_save
  end

  private

  def validate_account
    return if @payload.present?

    @errors << "Account is not valid"
    @result = Result.new(false, nil, @errors.join(","))
  end

  def validate_users
    return unless @payload[:users] && @payload[:users].empty?

    @errors << "Users can't be blank"
    @result = Result.new(false, nil, @errors.join(","))
  end

  def build_account
    @account = Account.new(account_params)
  end

  def account_params
    { name: @payload[:name],
      active: @from_fintera, }
  end

  def build_users
    @payload[:users].each do |user|
      @account.users.build(user_params(user))
    end
  end

  def user_params(user)
    user.merge(phone: Format.phone(user[:phone]))
  end

  def account_save
    @result = if @account.save
                Result.new(true, @account)
              else
                @errors << @account.errors.full_messages
                Result.new(false, nil, @errors.join(","))
              end
  end
end
