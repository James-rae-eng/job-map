class Job < ApplicationRecord
    require 'open-uri'
    
    def self.scrape
        
        url = 'https://www.totaljobs.com/jobs/web-developer/in-exeter?radius=5'
        #unparsed_page = HTTParty.get(url)
        #parsed_page = Nokogiri::HTML(unparsed_page)
        parsed_page = Nokogiri::HTML(URI.open(url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36'))
        jobs = Array.new
        job_listings = parsed_page.css("article.res-ihwgmh")
        job_listings.each do |job_listing|
           job = {
                  title: job_listing.css('div.res-1v262t5')[0].text.strip,
                  location: job_listing.css('span.res-dettfq')[0].text.strip,
                  salary: job_listing.css('div.res-hbjkz4')[0].text.strip,
                  link: "https://www.totaljobs.com" + job_listing.css('a')[1].attributes['href'].value
            }
            jobs << job
        end
        return jobs # Return the array here
    end
end
