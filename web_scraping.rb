require 'Nokogiri'
require 'open-uri'

main = 'https://www.set.or.th/'
all_company = 'https://www.set.or.th/set/commonslookup.do?language=th&country=TH&prefix='
all_alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

all_alphabet.each_char { |each_alphabet|
    each_url_prefix = open(all_company + each_alphabet)
    all_company_prefix = Nokogiri::HTML(each_url_prefix)
    # Get all info url of company from each alphabet
    all_company_info = all_company_prefix.xpath('//*[@id="maincontent"]/div/div/div[3]/table').css('a').map { |l| l['href'] }
   
    all_company_info.each do |each_company_info|
        company_info = open(main + each_company_info)
        new_source = Nokogiri::HTML(company_info)
        # Get Profit url of each company
        all_profits_path = new_source.xpath('//*[@id="maincontent"]/div/div[2]/div/ul/li[2]/a').map { |l| l['href'] }

        all_profits_path.each do |each_profits_path|
            # Open profit path of each company
            each_company_profits = open(main + each_profits_path)
            profits_source = Nokogiri::HTML(each_company_profits)
            # Get company's name
            company_name = profits_source.xpath('//*[@id="maincontent"]/div/div[1]/div[1]/h3').text
            # Get company's asset
            company_asset = profits_source.xpath('//*[@id="maincontent"]/div/div[4]/table/tbody[1]/tr[2]/td[5]').text
            puts '%s : ' % company_name +  company_asset  
        end
    end
}


