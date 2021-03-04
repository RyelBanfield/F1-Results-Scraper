require 'byebug'
require 'colorize'
require 'httparty'
require 'nokogiri'

class Scraper
  attr_accessor :url, :race_season, :race_results

  def initialize(url)
    @url = url
    @race_season = race_season
    @race_results = race_results
    @races = []
    @driver_wins = {}
    @car_wins = {}
    @total_laps = 0
  end

  def scrape_data
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page.body)
    @race_season = parsed_page.css('.ResultsArchiveTitle').text.strip
    @race_results = parsed_page.css('tbody tr')
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

  def results
    puts "HERE ARE THE #{race_season}".red
    puts
    @races.each do |race|
      puts "Grand Prix: #{race[:grand_prix]}
      Date: #{race[:date]}
      Winner: #{race[:winner]}
      Car: #{race[:car]}
      Laps: #{race[:laps]}"
      puts
      @driver_wins[race[:winner]] ? @driver_wins[race[:winner]] += 1 : @driver_wins[race[:winner]] = 1
      @driver_wins = @driver_wins.sort_by { |_driver, wins| wins }.reverse.to_h
      @car_wins[race[:car]] ? @car_wins[race[:car]] += 1 : @car_wins[race[:car]] = 1
      @car_wins = @car_wins.sort_by { |_car, wins| wins }.reverse.to_h
      @total_laps += race[:laps].to_i
    end
  end

  def summary
    puts
    puts "SUMMARY OF #{race_results.count} RACES".colorize(:red)
    puts
    puts "Out of #{@total_laps} laps driven,
#{@driver_wins.count} drivers won races in #{@car_wins.count} different cars."
    puts
    puts "THE TOP 3 DRIVERS WERE:
#{@driver_wins.keys[0]} with #{@driver_wins.values[0]} wins,
#{@driver_wins.keys[1]} with #{@driver_wins.values[1]} wins
and #{@driver_wins.keys[2]} with #{@driver_wins.values[2]} wins."
    puts
    puts "THE TOP 3 CARS/TEAMS WERE:
#{@car_wins.keys[0]} with #{@car_wins.values[0]} wins,
#{@car_wins.keys[1]} with with #{@car_wins.values[1]} wins
and #{@car_wins.keys[2]} with #{@car_wins.values[2]} wins."
    puts
  end
end
