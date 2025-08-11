class FollowUserService
  Result = Struct.new(:success?, :message, :status, :errors, keyword_init: true)

  def self.call(follower, followed)
    new(follower, followed).call
  end

  def initialize(follower, followed)
    @follower = follower
    @followed = followed
    @follow = Follow.find_or_initialize_by(follower: @follower, followed_user: @followed)
  end

  def call
    if @follow.new_record? && @follow.save
      Result.new(
        success?: true,
        message: "Successfully followed",
        status: :created,
        errors: nil
      )
    elsif !@follow.new_record?
      Result.new(
        success?: true,
        message: "Already following",
        status: :ok,
        errors: nil
      )
    else
      Result.new(
        success?: false,
        message: nil,
        status: :unprocessable_entity,
        errors: @follow.errors.full_messages
      )
    end
  rescue
    Result.new(
      success?: false,
      message: "User not found",
      status: :not_found,
      errors: [e.message]
    )
  end
end
