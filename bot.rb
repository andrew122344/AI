require 'telegram/bot'

TOKEN = '7995020719:AAHf1ARdqj8vug844WFcNyPB4LP-9PovEs0' 

def random_quote
  quotes = File.readlines('quotes.txt', chomp: true)
  quotes.sample
end

puts "🚀 Бот успішно запущено! Очікую повідомлень…"

MAIN_KEYBOARD = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
  keyboard: [
    [
      Telegram::Bot::Types::KeyboardButton.new(text: '🎲 Випадкова цитата'),
      Telegram::Bot::Types::KeyboardButton.new(text: '📜 Список команд')
    ]
  ],
  resize_keyboard: true
)

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "👋 Привіт! Я *Генератор цитат.* Натисни кнопку або введи команду!",
        parse_mode: "Markdown",
        reply_markup: MAIN_KEYBOARD
      )

    when '/quote', '🎲 Випадкова цитата'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "✨ *Цитата дня:*\n\n_#{random_quote}_",
        parse_mode: "Markdown"
      )

    when '/help', '📜 Список команд'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "📘 *Команди:*\n" \
              "🎲 /quote — випадкова цитата\n" \
              "📜 /help — список команд\n" \
              "👋 /start — запуск бота",
        parse_mode: "Markdown"
      )

    else
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "🤖 Не знаю такої команди. Спробуй /help.",
        reply_markup: MAIN_KEYBOARD
      )
    end
  end
end
