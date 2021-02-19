# frozen_string_literal: true

class QuestionsController < BotController

  def ask_favorite_author
    send_replies
    update_session_to state: :get_favorite_author
  end

  def get_favorite_author
    handle_message(
      "Kafka"       => proc { @author = "Kafka" },
      "Hemingway"   => proc { @author = "Hemingway" },
      "Dostoevsky"  => proc { @author = "Dostoevsky" },
      "Thoreau"     => proc { @author = "Thoreau" }
    )

    send_replies
    step_to state: :ask_robot_joke
  end

  def ask_robot_joke
    send_replies
    update_session_to state: :get_joke_response
  end

  def get_joke_response
    handle_message(
      "computer chips" => proc { step_to state: :say_correct },
      :dunno => proc { step_to state: :say_answer },
      nil => proc { step_to state: :say_incorrect }
    )
  end

  def say_correct
    send_replies
    step_to state: :ask_joke_humor
  end

  def say_incorrect
    send_replies
    step_to state: :say_answer
  end

  def say_answer
    send_replies
    step_to state: :ask_joke_humor
  end

  def ask_joke_humor
    send_replies
    update_session_to state: :get_joke_humor
  end

  def get_joke_humor
    handle_message(
      :yes => proc { step_to state: :say_glad_you_liked_it },
      :no => proc { step_to state: :say_try_harder }
    )
  end

  def say_glad_you_liked_it
    send_replies
    step_to flow: :goodbye
  end

  def say_try_harder
    send_replies
    step_to flow: :goodbye
  end

end
