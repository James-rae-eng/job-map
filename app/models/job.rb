class Job < ApplicationRecord
    require 'open-uri'
    require 'geocoder'

    def self.convertAddress(address)
        result = Geocoder.search(address)
        if result.first.present?
            return result.first.coordinates
        else 
            return "na"
        end
    end
    
    def self.scrape
        
        url = 'https://www.totaljobs.com/jobs/web-developer/in-exeter?radius=5'
        parsed_page = Nokogiri::HTML(URI.open(url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36'))
        # container to hold jobs:
        jobs = Array.new
        # Below is all of the job items that appear within the specified range
        job_listings = parsed_page.css("div.res-pqdyr5")
        job_box = job_listings.css("article.res-ihwgmh")
        job_box.each do |job_item|
           job = {
                  title: job_item.css('div.res-1v262t5')[0].text.strip,
                  location: job_item.css('span.res-dettfq')[0].text.strip,
                  salary: job_item.css('div.res-hbjkz4')[0].text.strip,
                  link: "https://www.totaljobs.com" + job_item.css('a')[1].attributes['href'].value,
                  latlong: convertAddress(job_item.css('span.res-dettfq')[0].text.strip)
            }
            jobs << job
        end
        return jobs # Return the array here
    end
end
