# frozen_string_literal: true

class HellosController < BotController

  def say_hello
    send_replies
    update_session_to state: :get_hello_response
  end

  def get_hello_response
    handle_message(
      :yes => proc { step_to flow: :question },
      :no => proc {
        step_to flow: :goodbye, state: :say_goodbye
      }
    )
  end

end
