class CreateAccount < ApplicationService
  FINTERA_NAME = "Fintera".freeze
  FINTERA_DOMAIN = "fintera.com.br".freeze

  def initialize(payload)
    @payload = payload
    @errors = []
  end

  def call
    validate_account
    return @result unless @errors.empty?

    build_account
    build_entities_and_users
    account_save
  end

  private

  def validate_account
    return if @payload.present?

    @errors << "Account is not valid"
    @result = Result.new(false, nil, @errors.join(","))
  end

  def build_account
    @account = Account.new(account_params)
  end

  def account_params
    { name: @payload[:name],
      active: from_fintera?, }
  end

  def build_entities_and_users
    @payload[:entities].each do |entity|
      builded_entity = @account.entities.build(entity_params(entity))
      build_users(builded_entity, entity[:users])
    end
  end

  def entity_params(entity)
    { name: entity[:name] }
  end

  def build_users(entity, users)
    users.each do |user|
      entity.users.build(user_params(user))
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

  def from_fintera?
    fintera_name? && any_fintera_user?
  end

  def fintera_name?
    @payload[:name]&.include? FINTERA_NAME
  end

  def any_fintera_user?
    @payload[:entities].any? { |entity| entity[:users].any? { |user| user[:email]&.include? FINTERA_DOMAIN } }
  end
end
