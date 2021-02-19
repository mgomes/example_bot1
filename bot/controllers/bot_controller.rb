# frozen_string_literal: true

class BotController < Xip::Controller

  helper :all

  def route
    # We have to route SMS messages to the payload handler because
    # SMS doesn't directly support payloads
    if current_message.payload.present? || current_service == 'twilio'
      payload_matched = handle_payloads
      current_message.payload = nil
      return if payload_matched
    end

    # Allow devs to jump around flows and states by typing:
    #   /flow_name/state_name or
    #   /flow_name (jumps to first state) or
    #   //state_name (jumps to state in current flow)
    # (only works for bots in development)
    return if dev_jump_detected?

    if current_session.present?
      step_to session: current_session
    else
      step_to flow: 'hello', state: 'say_hello'
    end
  end

private

  # Handle payloads globally since payload buttons remain in the chat
  # and we cannot guess in which states they will be tapped.
  def handle_payloads
    payload = if current_service == 'twilio'
                current_message.message&.downcase&.strip
              else
                current_message.payload
              end

    case payload
    when 'developer_restart', 'new_user', 'restart'
      step_to flow: 'hello', state: 'say_hello'
    when 'goodbye'
      step_to flow: 'goodbye'
    else
      # For SMS or quick replies, we just continue
      if current_service == 'twilio' || current_message.message.present?
        return false
      end
    end

    true
  end

  # Automatically called when clients receive an opt-out error from
  # the platform. You can write your own steps for handling.
  def handle_opt_out
    do_nothing
  end

  # Automatically called when clients receive an invalid session_id error from
  # the platform. For example, attempting to text a landline.
  # You can write your own steps for handling.
  def handle_invalid_session_id
    do_nothing
  end

end
