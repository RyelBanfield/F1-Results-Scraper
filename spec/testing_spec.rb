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
end
