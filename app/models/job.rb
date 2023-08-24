class Job < ApplicationRecord
    require 'open-uri'
    require 'geocoder'

    def self.convertAddress(address, location)
        result = Geocoder.search(address)
        if result.first.present?
            return result.first.coordinates
        else 
            return baseLocation = Geocoder.search(location)
        end
    end

    def self.jobList(parsed_page, location)
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
                  latlong: convertAddress(job_item.css('span.res-dettfq')[0].text.strip, location)
            }
            jobs << job
        end
        jobs # Return the array here
    end
    
    def self.scrape(job, location, radius)
        cleanJob = job.gsub(" ", "-")
        cleanlocation = location.gsub(" ", "-")
        url = 'https://www.totaljobs.com/jobs/'+cleanJob+'/in-'+location+'?radius='+radius
        parsed_page = Nokogiri::HTML(URI.open(url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36'))
        
        result = jobList(parsed_page, location)
    end

    def self.advancedScrape(job, location, radius, remote = 0)
        cleanJob = job.gsub(" ", "-")
        cleanlocation = location.gsub(" ", "-")
        if remote = 0
            url = 'https://www.totaljobs.com/jobs/'+cleanJob+'/in-'+location+'?radius='+radius
        else
            url = 'https://www.totaljobs.com/jobs/work-from-home/'+cleanJob+'/in-'+location+'?radius='+radius
        end
        parsed_page = Nokogiri::HTML(URI.open(url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36'))
        
        result = jobList(parsed_page, location)
    end
end
