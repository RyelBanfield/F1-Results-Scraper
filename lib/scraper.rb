require 'byebug'
require 'colorize'
require 'httparty'
require 'nokogiri'

class Scraper
  attr_accessor :url, :race_season

  def initialize(url)
    @url = url
    @race_season = race_season
    @races = []
  end

  def scrape_data
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page.body)
    @race_season = parsed_page.css('.ResultsArchiveTitle').text.strip
    race_results = parsed_page.css('tbody tr')
    race_results.each do |race_result|
      race = {
        grand_prix: race_result.css('td')[1].text.strip,
        date: race_result.css('td')[2].text,
        winner: race_result.css('td')[3].text.strip.gsub(' ', '').gsub("\n", ' '),
        car: race_result.css('td')[4].text,
        laps: race_result.css('td')[5].text
      }
      @races << race
    end
  end

  def results_output
    puts "THESE ARE THE #{race_season}".red
    puts
    @races.each do |race|
      puts "Grand Prix: #{race[:grand_prix]}
      Date: #{race[:date]}
      Winner: #{race[:winner]}
      Car: #{race[:car]}
      Laps: #{race[:laps]}"
      puts
    end
  end
end
