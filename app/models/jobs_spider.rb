class JobsSpider < Tanakai::Base
    @name = 'jobs_spider'
    @engine = :selenium_firefox

    def self.process(url)
        @start_urls = [url]
        self.crawl!
    end

    def parse(response, url:, data:{})
        response.xpath("//div[@class='res-j4ovlb']").each do |job|
            item= {}

            title = job.css('div.res-1v262t5')&.text&.squish
            location = job.css('span.res-dettfq'[0])&.text&.squish #fix this and the next one having the same class
            salary = job.css('span.res-hbjkz4'[0])&.text&.squish

            link = job.css('a.href.res-r3jqsu')&.text&.squish # figure out how to grab the url

            #Job.where(item).first_or_create!
            Job.create(:title => title, :location => location, :salary => salary, :link => link)
        end
    end
end