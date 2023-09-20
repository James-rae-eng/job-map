class Job < ApplicationRecord
    require 'geocoder'
    require 'selenium-webdriver'

    def self.convertAddress(address, location)
        result = Geocoder.search(address)
        # Set location originally searched for as deafult if geocode cant find location
        baseLocation = Geocoder.search(location)
        # Check a result has been found & it's in the uk
        if result.first.present? && result.first.country_code === "gb"
            return result.first.coordinates
          
        else 
            return baseLocation.first.coordinates
        end
    end

    def self.underMaxSalary(salaryMax, jobSalary)
        result = false
        # Check if salary max is even required & return tru if not
        if salaryMax != "none"
            # Strip desired salary max entered by user of letters & convert to workable number
            cleanSalaryMax = salaryMax.tr('^0-9', '').to_i
            # Check if job included a salary range in the description with a hyphen
            if jobSalary.include? "-"
                # Strip job salary description of all but numbers and remove any prior to hyphen
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

    def self.jobList(url, location, salaryMax = "none")
        # container to hold jobs:
        jobs = Array.new
 
        # configuring Chrome to run in headless mode 
        options = Selenium::WebDriver::Chrome::Options.new 
        options.add_argument("--headless") 
        
        # initializing the Selenium Web Driver for Chrome 
        driver = Selenium::WebDriver.for :chrome, options: options 
        
        # visiting a web page in the browser opened by Selenium behind the scene 
        driver.get(url)

        # Manage time to load 
        driver.manage.timeouts.implicit_wait = 5

        job_listings = driver.find_element(xpath: '//div[@data-genesis-element="CARD_GROUP_CONTAINER"]')
        job_box = job_listings.find_elements(class: 'res-ihwgmh')
        job_box.each do |job_item|
           job = {
                  title: job_item.find_element(class: 'res-1v262t5').text,
                  location: job_item.find_element(css: '.res-dettfq .res-1wac8dr').text,
                  #Fix the salary below, just taking the first jobs one, same class as location
                  salary: job_item.find_element(css: '.res-hbjkz4 .res-1wac8dr').text,
                  link: job_item.find_element(class: 'res-r3jqsu').attribute('href'),
                  latlong: convertAddress(job_item.find_element(css: '.res-dettfq .res-1wac8dr').text, location)
            }
            # Check if job salary is above max salary input, dont add to jobs array if it is
            if underMaxSalary(salaryMax, job[:salary]) == true 
                jobs << job
            end
        end
        # Close the driver
        driver.quit

        jobs # Return the array here
    end
    
    def self.scrape(job, location, radius)
        # Get job & location in format ready for url (no spaces between words)
        cleanJob = job.gsub(" ", "-")
        cleanLocation = location.gsub(" ", "-")
        url = 'https://www.totaljobs.com/jobs/'+cleanJob+'/in-'+cleanLocation+'?radius='+radius
        result = jobList(url, location)
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
        # Get job & location in format ready for url (no spaces between words)
        cleanJob = job.gsub(" ", "-")
        cleanLocation = location.gsub(" ", "-")
        url = getURL(cleanJob, cleanLocation, radius, remote, salaryMin)
        result = jobList(url, location, salaryMax)
    end
end
