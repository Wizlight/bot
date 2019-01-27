class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  def start!(*)
    respond_with :message, text: 'What would you like to do?', reply_markup: {
        inline_keyboard: [
            [{text: 'Buy/Sell a Commodity', callback_data: 'commodity'}],
            [{text: 'Check Market news', callback_data: 'news'}],
        ],
    }
  end

  def help!(*)
    respond_with :message, text: t('.content')
  end

  def memo!(*args)
    if args.any?
      session[:memo] = args.join(' ')
      respond_with :message, text: t('.notice')
    else
      respond_with :message, text: t('.prompt')
      save_context :memo!
    end
  end

  def remind_me!(*)
    to_remind = session.delete(:memo)
    reply = to_remind || t('.nothing')
    respond_with :message, text: reply
  end

  def keyboard!(value = nil, *)
    if value
      respond_with :message, text: t('.selected', value: value)
    else
      save_context :keyboard!
      respond_with :message, text: t('.prompt'), reply_markup: {
          keyboard: [t('.buttons')],
          resize_keyboard: true,
          one_time_keyboard: true,
          selective: true,
      }
    end
  end

  def inline_keyboard!(*)
    respond_with :message, text: 'What would you like to do?', reply_markup: {
        inline_keyboard: [
            [{text: 'Buy/Sell a Commodity', callback_data: 'commodity'}],
            [{text: 'Check Market news', callback_data: 'news'}],
        ],
    }
  end

  def type_market_update!(*)
    respond_with :message, text: 'Which type of market update would you like?', reply_markup: {
        inline_keyboard: [
            [{text: 'Freight prices', callback_data: 'thx'}],
            [{text: 'Supply and demand figures', callback_data: 'thx'}],
            [{text: 'Physical Commodity Prices', callback_data: 'thx'}],
        ],
    }
  end

  def commodity_type!(*)
    respond_with :message, text: 'Which Commodity would you like to sell?', reply_markup: {
        inline_keyboard: [
            [{text: 'Grains', callback_data: 'grains'}],
            [{text: 'Vegetable Oil', callback_data: 'oil'}],
        ],
    }
  end

  def grains!(*)
    respond_with :message, text: 'Choose the type of grain', reply_markup: {
        inline_keyboard: [
            [{text: 'Wheat', callback_data: 'wheat'}],
            [{text: 'Corn', callback_data: 'wheat'}],
            [{text: 'Barley', callback_data: 'wheat'}],
        ],
    }
  end

  def oil!(*)
    respond_with :message, text: 'Choose the type of grain', reply_markup: {
        inline_keyboard: [
            [{text: 'Sunflower Oil', callback_data: 'sunflower_oil'}],
            [{text: 'Rapeseed Oil', callback_data: 'rapeseed_oil'}],
            [{text: 'Soyabean oilarley', callback_data: 'soyabean_oilarley'}],
        ],
    }
  end

  def sunflower_oil!(*)
    respond_with :message, text: 'Choose the type of oil', reply_markup: {
        inline_keyboard: [
            [{text: 'Crude Sunflower Oil', callback_data: 'bulk_or_bottled'}],
            [{text: 'Refined Sunflower Oil', callback_data: 'bulk_or_bottled'}],
        ],
    }
  end

  def rapeseed_oil!(*)
    respond_with :message, text: 'Choose the type of oil', reply_markup: {
        inline_keyboard: [
            [{text: 'Crude Rapeseed Oil', callback_data: 'bulk_or_bottled'}],
            [{text: 'Refined Rapeseed Oil', callback_data: 'bulk_or_bottled'}],
        ],
    }
  end

  def soyabean_oilarley!(*)
    respond_with :message, text: 'Choose the type of oil', reply_markup: {
        inline_keyboard: [
            [{text: 'Crude Soyabean Oil', callback_data: 'bulk_or_bottled'}],
            [{text: 'Refined Soyabean Oil', callback_data: 'bulk_or_bottled'}],
        ],
    }
  end

  def bulk_or_bottled!(*)
    respond_with :message, text: 'Choose packing materials', reply_markup: {
        inline_keyboard: [
            [{text: 'Bulk', callback_data: 'shipment_period'}],
            [{text: 'Bottled', callback_data: 'shipment_period'}],
        ],
    }
  end

  def wheat!(*)
    respond_with :message, text: 'Choose the type of grain', reply_markup: {
        inline_keyboard: [
            [{text: 'Feed wheat', callback_data: 'shipment_period'}],
            [{text: 'Milling wheat', callback_data: 'shipment_period'}],
        ],
    }
  end

  def shipment_period!(*)
    respond_with :message, text: 'Which shipment period can you sell your commodity?', reply_markup: {
        inline_keyboard: [
            [{text: 'first half of month', callback_data: 'thx'}],
            [{text: 'second half of month', callback_data: 'thx'}],
            [{text: 'whole month', callback_data: 'incoterms'}],
        ],
    }
  end

  def incoterms!(*)
    respond_with :message, text: 'Which incoterms can you sell on?', reply_markup: {
        inline_keyboard: [
            [
                {text: 'CIF', callback_data: 'set_incoterms'},
                {text: 'FOB', callback_data: 'set_incoterms'},
                {text: 'FCA', callback_data: 'set_incoterms'},
                {text: 'CPT', callback_data: 'set_incoterms'},
                {text: 'CFR', callback_data: 'set_incoterms'},
                {text: 'DAP', callback_data: 'set_incoterms'},
            ],
        ],
    }
  end

  def payment_terms!(*)
    respond_with :message, text: 'What payment terms can you sell on?', reply_markup: {
        inline_keyboard: [
            [{text: 'Cash against documents', callback_data: 'set_payment_terms'}],
            [{text: 'Letter of credit', callback_data: 'set_payment_terms'}],
            [{text: 'Partial prepayment', callback_data: 'set_payment_terms'}],
            [{text: 'Full prepayment', callback_data: 'set_payment_terms'}],
        ],
    }
  end

  def request_valid!(*)
    respond_with :message, text: 'Until when is this request valid? Please send a command "/expire_date" with message in the format MM/DD/YYYY'
  end

  def expire_date!(date)
    respond_with :message, text: "#{from['first_name']}, thx. Please put your 20$ deposit while we search for a suitable buyer. Incase we do not find a suitable buyer before the validity period expires, we guarantee to return the deposit"
  end

  def callback_query(data)
    case data
    when 'commodity'
      commodity_type!
    when 'news'
      type_market_update!
    when 'thx'
      respond_with :message, text: "#{from['first_name']}, thx"
    when 'grains'
      grains!
    when 'vegetable_oil'
      vegetable_oil!
    when 'wheat'
      wheat!
    when 'shipment_period'
      shipment_period!
    when 'incoterms'
      incoterms!
    when 'set_incoterms'
      payment_terms!
    when 'set_payment_terms'
      request_valid!
    when 'oil'
      oil!
    when 'sunflower_oil'
      sunflower_oil!
    when 'rapeseed_oil'
      rapeseed_oil!
    when 'soyabean_oilarley'
      soyabean_oilarley!
    when 'bulk_or_bottled'
      bulk_or_bottled!
    else
      puts "it was something else"
    end

    # if data == 'products'
    #   answer_callback_query t('.alert'), show_alert: true
    # else
    #   answer_callback_query t('.no_alert')
    # end
  end

  def message(message)
    respond_with :message, text: t('.content', text: message['text'])
  end

  def inline_query(query, _offset)
    query = query.first(10) # it's just an example, don't use large queries.
    t_description = t('.description')
    t_content = t('.content')
    results = Array.new(5) do |i|
      {
          type: :article,
          title: "#{query}-#{i}",
          id: "#{query}-#{i}",
          description: "#{t_description} #{i}",
          input_message_content: {
              message_text: "#{t_content} #{i}",
          },
      }
    end
    answer_inline_query results
  end

  # As there is no chat id in such requests, we can not respond instantly.
  # So we just save the result_id, and it's available then with `/last_chosen_inline_result`.
  def chosen_inline_result(result_id, _query)
    session[:last_chosen_inline_result] = result_id
  end

  def last_chosen_inline_result!(*)
    result_id = session[:last_chosen_inline_result]
    if result_id
      respond_with :message, text: t('.selected', result_id: result_id)
    else
      respond_with :message, text: t('.prompt')
    end
  end

  def action_missing(action, *_args)
    if action_type == :command
      respond_with :message,
                   text: t('telegram_webhooks.action_missing.command', command: action_options[:command])
    else
      respond_with :message, text: t('telegram_webhooks.action_missing.feature', action: action)
    end
  end
end
