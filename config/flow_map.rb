class FlowMap

  include Xip::Flow

  flow :hello do
    state :say_hello
    state :get_hello_response, fails_to: :say_hello
  end

  flow :question do
    state :ask_favorite_author
    state :get_favorite_author, fails_to: :ask_favorite_author

    state :ask_robot_joke
    state :get_joke_response, fails_to: :ask_robot_joke

    state :ask_robot_joke
    state :get_joke_response, fails_to: :ask_robot_joke
    state :say_correct
    state :say_incorrect
    state :say_answer

    state :ask_joke_humor
    state :get_joke_humor, fails_to: :ask_joke_humor

    state :say_glad_you_liked_it
    state :say_try_harder
  end

  flow :goodbye do
    state :say_goodbye
  end

  flow :interrupt do
    state :say_interrupted
  end

  flow :unrecognized_message do
    state :handle_unrecognized_message
  end

  flow :catch_all do
    state :level1
    state :level2
    state :level3
  end

end
