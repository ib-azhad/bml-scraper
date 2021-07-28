# frozen_string_literal: true

require 'mechanize'
require 'json'

class Hash
  def as_json(_opts = {})
    self
  end
end

def sign_in(email, password)
  @agent = Mechanize.new
  # @agent.log = Logger.new(STDERR)
  @agent.get('https://www.bankofmaldives.com.mv/internetbanking/login')

  url = 'https://www.bankofmaldives.com.mv/internetbanking/api/login'
  data = {
    username: email, password: password
  }
  params = {
    data: data.as_json
  }
  res = @agent.post(url, data.as_json, {})

  set_profile = @agent.get('https://www.bankofmaldives.com.mv/internetbanking/api/profile')
  activity_page = @agent.get('https://www.bankofmaldives.com.mv/internetbanking/api/activities?page=1')
  history_page = @agent.get('https://www.bankofmaldives.com.mv/internetbanking/api/account/E3F8B30D-E150-XXXX-XXXX-00155D020F0A/history/today')
  # puts activity_page.body
  parsed_json = JSON.parse(history_page.body)
  puts "\n"

  # puts parsed_json['payload']['history']
  history = parsed_json['payload']['history']
  history.each do |item|
    puts item['amount']
    puts item['narrative3']
    puts item['minus']
    puts "\n"
  end

  # transactions = jsonn['payload']['content']['data']
  # puts transactions.count
  # transactions.reverse.each do |tr|
  #   # check if datetime > last_datetime
  #   # if found last updated item, start updating remaining
  #   #
  #   puts tr['datetime']
  #   puts tr['type']
  #   puts tr['creditName']
  #   puts tr['content']
  #   content = tr['content']
  #   content.each do |cont|
  #     puts cont['name']
  #     puts cont['value']
  #   end
  #   puts "\n"
  # end
rescue StandardError => e
  raise "PinterestSpammer SignIn Error: #{e}"
end

sign_in('user', 'password')

# start
