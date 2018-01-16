require 'watir'
require 'pry'
require 'date'
require 'tzinfo'


namespace :scraper do
  desc "Get calls for the last hour"

  task calls: :environment do
    YEAR, MONTH, DATE  = Time.now.year, Time.now.strftime("%m"), Time.now.day

    browser = Watir::Browser.new :phantomjs

    browser.goto 'https://www.elocal.com/partner_users/login'

    browser.text_field(name: 'partner_user[username]').set("Daniel7rusu@gmail.com")
    browser.text_field(name: 'partner_user[password]').set("welcome")
    browser.button(name: 'button').click

    calls = []
    page = 1

    loop do
      browser.goto "https://www.elocal.com/partner_users/campaign_results?end_date=#{YEAR}-#{MONTH}-#{DATE}&id=8144&page=#{page}&start_date=#{YEAR}-#{MONTH}-#{DATE}"

      call_table = browser.tables[1]

      (1..call_table.count-1).each do |num|
        row = call_table[num]
        datetime_of_call = Time.strptime("#{row[0].text} -05:00", '%m/%d/%y %I:%M %p %z')
        datetime_in_est = Time.now.getlocal('-05:00')
        next if (datetime_in_est - datetime_of_call) / 3600 > 24

        date_of_call = row[0].text
        arr_date = date_of_call.split("/")
        date_of_call = "20#{arr_date[2][0..1]}-#{arr_date[1]}-#{arr_date[0]}"

        caller_id = row[1].text.split("\n")[1]
        category, city, zip = row[2].text.split("\n")
        screen, post_screen, total_duration = row[3].text.split("\n")
        disposition= row[5].text
        payout = row[6].text.sub("$","").to_f * 0.8

        call =  {date_of_call: date_of_call,
                caller_id: caller_id,
                category: category,
                city: city,
                zip: zip,
                screen: screen,
                post_screen: post_screen,
                total_duration: total_duration,
                disposition: disposition,
                payout: payout
                }

        calls << call
        Report.create(call).save

      end



      page += 1
      break if (browser.link class: 'next disabled').exists?
    end

    binding.pry
  end
end
