require_relative '../lib/scraper'

describe Scraper do
  scraper = Scraper.new('https://www.formula1.com/en/results.html')

  describe 'initialize' do
    it 'creates a new scraper object with correct url' do
      expect(scraper.url).to eql('https://www.formula1.com/en/results.html')
    end
    it 'creates a new scraper object with correct url' do
      expect(scraper.url).not_to eql('https://www.formula2.com/en/results.html')
    end
  end

  describe 'scrape_data' do
    it 'scrapes the correct data' do
      expect(scraper.scrape_data).to be_an_instance_of(Nokogiri::XML::NodeSet)
    end
  end
  describe 'scrape_data' do
    it 'scrapes the correct data' do
      expect(scraper.scrape_data).not_to be_an_instance_of(Nokogiri::XML::Document)
    end
  end

  describe 'results' do
    it 'returns an array of the results' do
      expect(scraper.results).to be_an_instance_of(Array)
    end
  end
  describe 'results' do
    it 'returns an array of the results' do
      expect(scraper.results).not_to be_an_instance_of(String)
    end
  end

  describe 'summary' do
    it 'outputs a summary of the results returing NilClass' do
      expect(scraper.summary).to be_an_instance_of(NilClass)
    end
  end
  describe 'summary' do
    it 'outputs a summary of the results returing NilClass' do
      expect(scraper.summary).not_to be_an_instance_of(String)
    end
  end
end
