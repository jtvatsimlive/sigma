# Based on tutorial at: https://rubygems.org/gems/httparty
#
# 29 June 2018
# jtvatsim

require 'nokogiri'
require 'httparty'

class Scraper
    
    attr_accessor :parse_page
    
    def setPageToParse(address)
        page = HTTParty.get(address)
        @parse_page ||= Nokogiri::HTML(page)
    end
    
    def getIds
        parse_page.xpath('//div/a/@name')
    end
    
    def getText
        standards = [];
        cleanStandards =[];
        parse_page.xpath('//div[@class = "standard"]').each do |link|
            standards.push(link.content)
        end
        parse_page.xpath('//div[@class = "substandard"]').each do |link|
            standards.push(link.content) 
        end
        standards.each do |s|
            cleanStandards.push(s.gsub(/(\.\d(?=[A-Z])|\d\.[a-z])/, '\\1]['))
        end
        return cleanStandards
    end
    
end


# Address Library
library = [ "http://www.corestandards.org/Math/Content/CC/",
            "http://www.corestandards.org/Math/Content/OA/",
            "http://www.corestandards.org/Math/Content/NBT/",
            "http://www.corestandards.org/Math/Content/NF/",
            "http://www.corestandards.org/Math/Content/MD/",
            "http://www.corestandards.org/Math/Content/G/",
            "http://www.corestandards.org/Math/Content/RP/",
            "http://www.corestandards.org/Math/Content/NS/",
            "http://www.corestandards.org/Math/Content/EE/",
            "http://www.corestandards.org/Math/Content/F/",
            "http://www.corestandards.org/Math/Content/SP/"]


# Run webscraper
puts 'Sigma::Webscraper.1.0'
puts '*********************'
puts ''
s = File.open("scrapedStandards_CC.txt", "w")
    i = 0
    while i < library.length
        scraper = Scraper.new
        scraper.setPageToParse(library[i])
        s.puts scraper.getText()
        i += 1
    end
puts ''