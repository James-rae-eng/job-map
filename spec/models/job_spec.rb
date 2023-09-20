require 'rails_helper'

RSpec.describe Job do
    
    describe ".convertAddress" do
        subject {described_class} 

        it "Convert address can find a searched address" do
            result = subject.convertAddress("Glasgow", "Exeter")
            glasgowCoords = [55.861155, -4.2501687]
            expect(result).to eql(glasgowCoords)
        end  

        it "Convert address defaults to searched address when address cant be geocoded" do
            result = subject.convertAddress("fkjhfdfghjk", "Exeter")
            expect(result).to eql([50.7255794, -3.5269497])
        end  

        it "Convert address defaults to searched address when address includes numbers/characters" do
            result = subject.convertAddress("qwe123 -45+f f.", "Exeter")
            expect(result).to eql([50.7255794, -3.5269497])
        end  
    end


end