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

    def self.underMaxSalary(salaryMax, jobSalary)
        result = false
        if salaryMax != "none"
            cleanSalaryMax = salaryMax.tr('^0-9', '').to_i
            if jobSalary.include? "-"
                newJobSalary = jobSalary.gsub(/.*-/, '').tr('^0-9', '').to_i
                if newJobSalary <= cleanSalaryMax
                    result = true
                end
            else
                result = true
            end
        else
            result = true 
        end
        result
    end

    def self.jobList(parsed_page, location, salaryMax = "none")
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
            # Check if job salary is above max salary input, dont add to jobs array if it is
            if underMaxSalary(salaryMax, job[:salary]) == true 
                jobs << job
            end
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

    def self.getURL(cleanJob, location, radius, remote, salaryMin)
        url = 'https://www.totaljobs.com/jobs/'
        # Deal with remote option
        if remote == "1"
            url << 'work-from-home/'
        end
        url << cleanJob+'/in-'+location+'?'
        # Deal with minimum salary option
        if salaryMin != "none"
            cleanSalaryMin = salaryMin.tr('^0-9', '')
            url << 'salary='+cleanSalaryMin+'&salarytypeid=1&radius='+radius+'&action=facet_selected%3bsalary%3b'+cleanSalaryMin+'%3bsalarytypeid%3b1'
        else
            url << 'radius='+radius
        end    
        # Return completed url
        url
    end

    def self.advancedScrape(job, location, radius, remote = 0, salaryMin, salaryMax)
        cleanJob = job.gsub(" ", "-")
        cleanlocation = location.gsub(" ", "-")
        url = getURL(cleanJob, location, radius, remote, salaryMin)
        parsed_page = Nokogiri::HTML(URI.open(url, 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36'))
        
        result = jobList(parsed_page, location, salaryMax)
    end
end
