class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protect_from_forgery :except => :form_csv
  skip_before_action :verify_authenticity_token
  before_action :now, :db, :logger, :defaultdayrange, :html_title
  require 'geoip'
  require 'geo_location'
  require 'active_support'
  require 'csv'
  require 'httparty'
  
  require 'roo'
  
  require 'net/http'
  require 'mailgun'
  
  require 'open-uri'
  require 'json'
  
  require 'simple-rss'
  require 'htmlentities'
  
  def html_title
      @title = " | The Next Generation Digital Media Optimization Platform"
  end
  
  def not_found
    
  end
  
  
  # def exporteventfile
      # begin
      # @one_hour_ago = Time.now - 1.hours
# 
      # name_datetime = @one_hour_ago.in_time_zone('Beijing').strftime("%Y-%m-%d-%H")
      # # @one_hour_ago = @one_hour_ago.in_time_zone('Beijing').strftime("%Y-%m-%d %H:%M:%S %Z")
      # @one_hour_ago = @one_hour_ago.in_time_zone('Beijing').strftime("%Y-%m-%d %H")
      # @one_hour_ago = @one_hour_ago.to_s + ":00:00 CST"
#       
      # total_events = @db2["events"].find('date' => { '$gte' => @one_hour_ago.to_s })
      # @db2.close()
#       
      # name = "export_event_"+name_datetime.to_s
      # del_event_array = []
#       
      # if total_events.count.to_i > 0
#         
          # event_array = []
          # total_events.each do |total_events_d|
#             
              # del_event_array << total_events_d["id"]
#               
              # array = []
#               
              # array << total_events_d["id"]
              # array << total_events_d["random_number"]
              # array << total_events_d["session_id"]
              # array << total_events_d["tag_version"]
              # array << total_events_d["company_id"]
              # array << total_events_d["referer"]
              # array << total_events_d["ip"]
              # array << total_events_d["country"]
              # array << total_events_d["city"]
              # array << total_events_d["variant"]
              # array << total_events_d["user_agent"]
              # array << total_events_d["cookies"]
              # array << total_events_d["other_param"]
              # array << total_events_d["date"]
              # array << total_events_d["check_status"]
#               
              # event_array << array
          # end
#           
#           
          # p = Axlsx::Package.new
          # wb = p.workbook
#             
          # wb.add_worksheet(:name => "Basic Worksheet") do |sheet|
               # event_array.each_with_index do |csv, csv_index|
                  # sheet.add_row csv
               # end
          # end
#            
          # create_excel_path = '/home/bmg/adeqo/public/export_event/'+name+'.xlsx'
          # p.serialize(create_excel_path)
#           
      # end
#       
      # # @db2["events"].find('id' => { "$in" => del_event_array}).delete_many
      # rescue Exception
      # end
#       
      # data = {:export_event => total_events.count.to_i, :export_event_time => @one_hour_ago, :del_event_array => del_event_array.count.to_i, :status => "true"}
      # return render :json => data, :status => :ok
#       
  # end
  
  def cleaneventfile
      begin
      @all_event_files = Dir.glob('/home/bmg/adeqo/public/export_event/*')
      
      file_year = (Time.now - 1.day).to_date.strftime("%Y")
      file_month = (Time.now - 1.day).to_date.strftime("%m")
      file_day = (Time.now - 1.day).to_date.strftime("%d")
       
      file_date = file_year + "-" + file_month + "-" + file_day
      
      @all_event_files.each do |all_files_p|
          if all_files_p.to_s.include?(file_date)
              File.delete(all_files_p) if File.exist?(all_files_p)
          end
      end
      rescue Exception
      end
      
      data = {:message => "clean event file", :clean_day => file_date, :status => "true"}
      return render :json => data, :status => :ok
    
  end
  
  
  
  def getmissingeventfile
    
      # begin
          @logger.info "run get missing event file"
                    
          @one_hour_ago = Time.now - 1.hours
          @all_event_files = Dir.glob('/home/bmg/adeqo/public/export_event/*')
          name_datetime = @one_hour_ago.in_time_zone('Beijing').strftime("%Y-%m-%d-%H")
          
          
          @all_event_files.each do |all_files_p|
               
              if !all_files_p.to_s.include?(name_datetime)
                
                  @logger.info all_files_p.to_s
                  
                  xlsx = Roo::Spreadsheet.open(all_files_p, extension: :xlsx)
                  xlsx.each_with_index do |csv, csv_index|
                      
                      begin
                          @logger.info "."
                          
                          cookies_hash = {}
                          csv_cookies_array = []
                          
                          if csv[11].to_s != "{}"
                              csv_cookies_array = csv[11].to_s.gsub('{', '').gsub('}', '').split(",")
                              
                              csv_cookies_array.each do |csv_cookies_array_d|
                                  temp_arr = csv_cookies_array_d.split("=>")
                                  
                                  if !temp_arr[0].nil?
                                      name = temp_arr[0].gsub('"', '')
                                  end
                                  
                                  if !temp_arr[1].nil?
                                      value = temp_arr[1].gsub('"', '')
                                  else
                                      value = ""
                                  end
                                  
                                  if !temp_arr[0].nil?
                                      cookies_hash[name] = value
                                  end
                                  
                                  cookies_hash[name] = value
                              end
                              
                          end
                          
                          @db2[:events].insert_one({ 
                                              id: csv[0].to_s, 
                                              random_number: csv[1].to_i.to_s,
                                              session_id: csv[2].to_s,
                                              tag_version: csv[3].to_s,
                                              company_id: csv[4].to_i,
                                              referer: csv[5].to_s,
                                              ip: csv[6],
                                              country: csv[7].to_s,
                                              city: csv[8].to_s,
                                              variant: csv[9].to_s,
                                              user_agent: csv[10].to_s,
                                              cookies: cookies_hash,
                                              other_param: JSON.parse(csv[12]),
                                              date: csv[13].to_s,
                                              check_status: csv[14].to_i
                                            })
                          @db2.close()
                      rescue Exception
                          @logger.info csv
                      end
                  end
                  
                  File.delete(all_files_p) if File.exist?(all_files_p)
              end
          end
          
      # rescue Exception
#           
          # @logger.info "get missing event file error"
#           
      # end
      
      
      @logger.info "done get missing event file"
      data = {:message => "get missing event file", :status => "true"}
      return render :json => data, :status => :ok
  end
  
  
  
  
  
  def geteventfile
    
      # begin
          @start_time = @now
          
          @logger.info "get event file"
                                  
          @one_hour_ago = Time.now - 1.hours
          name_datetime = @one_hour_ago.in_time_zone('Beijing').strftime("%Y-%m-%d-%H")
          
          domain_name = "http://trackadeqo.chinacloudapp.cn:8000/export_event/"      
          name = domain_name + "export_event_" + name_datetime + ".xlsx"
          
          download_name = "/home/bmg/adeqo/public/export_event/export_event_"+ name_datetime + ".xlsx"
          
          begin
              IO.copy_stream(open(name) , download_name)
          rescue Exception
              @logger.info "download file fail"
              
              data = {:message => "download file fail", :status => "true"}
              return render :json => data, :status => :ok
          end
          @logger.info "download done"
          
          tmp_file_path = download_name
    
          @logger.info "start loop"              
          xlsx = Roo::Spreadsheet.open(tmp_file_path, extension: :xlsx)
          xlsx.each_with_index do |csv, csv_index|
             
              begin
                  cookies_hash = {}
                  csv_cookies_array = []
                  
                  @logger.info csv_index.to_s 
                  
                  if csv[11].to_s != "{}"
                      csv_cookies_array = csv[11].to_s.gsub('{', '').gsub('}', '').split(",")
                      
                      csv_cookies_array.each do |csv_cookies_array_d|
                          temp_arr = csv_cookies_array_d.split("=>")
                          
                          if !temp_arr[0].nil?
                              name = temp_arr[0].gsub('"', '')
                          end
                          
                          if !temp_arr[1].nil?
                              value = temp_arr[1].gsub('"', '')
                          else
                              value = ""
                          end
                          
                          if !temp_arr[0].nil?
                              cookies_hash[name] = value
                          end
                          
                          cookies_hash[name] = value
                      end
                      
                  end
                  
                     
                  @db2[:events].insert_one({ 
                                      id: csv[0].to_s, 
                                      random_number: csv[1].to_i.to_s,
                                      session_id: csv[2].to_s,
                                      tag_version: csv[3].to_s,
                                      company_id: csv[4].to_i,
                                      referer: csv[5].to_s,
                                      ip: csv[6],
                                      country: csv[7].to_s,
                                      city: csv[8].to_s,
                                      variant: csv[9].to_s,
                                      user_agent: csv[10].to_s,
                                      cookies: cookies_hash,
                                      other_param: JSON.parse(csv[12]),
                                      date: csv[13].to_s,
                                      check_status: csv[14].to_i
                                    })
                  @db2.close() 
              rescue Exception
                  @logger.info csv
              end
          end    
          
          
          @logger.info "get event file done"      
          
          @all_event_files = Dir.glob('/home/bmg/adeqo/public/export_event/*')
          
          @all_event_files.each do |all_files_p|
              if all_files_p.to_s.include?(name_datetime)
                  File.delete(all_files_p) if File.exist?(all_files_p)
              end
          end                   
      # rescue Exception
          # @logger.info "get event file empty"
      # end
      
      @end_time = @now
      
           
      data = {:message => "get and insert event", :clean_day => name_datetime, :start_time => @start_time, :end_time => @end_time, :status => "true"}
      return render :json => data, :status => :ok
      
      
  end
  
  
  # def exportclickfile
      # begin
      # @one_hour_ago = Time.now - 1.hours
# 
      # name_datetime = @one_hour_ago.in_time_zone('Beijing').strftime("%Y-%m-%d-%H")
      # # @one_hour_ago = @one_hour_ago.in_time_zone('Beijing').strftime("%Y-%m-%d %H:%M:%S %Z")
      # @one_hour_ago = @one_hour_ago.in_time_zone('Beijing').strftime("%Y-%m-%d %H")
      # @one_hour_ago = @one_hour_ago.to_s + ":00:00 CST"
#       
      # total_clicks = @db2["clicks"].find('date' => { '$gte' => @one_hour_ago.to_s })
      # @db2.close()
#       
      # name = "export_click_"+name_datetime.to_s
      # del_click_array = []
#       
      # if total_clicks.count.to_i > 0
#           
          # click_array = []
          # total_clicks.each do |total_clicks_d|
#             
              # del_click_array << total_clicks_d["id"]
#                
              # array = []
              # array << total_clicks_d["id"]
              # array << total_clicks_d["random_number"]
              # array << total_clicks_d["session_id"]
              # array << total_clicks_d["company_id"]
              # array << total_clicks_d["network_id"]
              # array << total_clicks_d["network_type"]
              # array << total_clicks_d["campaign_id"]
              # array << total_clicks_d["adgroup_id"]
              # array << total_clicks_d["keyword_id"]
              # array << total_clicks_d["ad_id"]
              # array << total_clicks_d["target_id"]
              # array << total_clicks_d["search_q"]
              # array << total_clicks_d["ip"]
              # array << total_clicks_d["country"]
              # array << total_clicks_d["city"]
              # array << total_clicks_d["variant"]
              # array << total_clicks_d["user_agent"]
              # array << total_clicks_d["device"]
              # array << total_clicks_d["cookies"]
              # array << total_clicks_d["other_parameters"]
              # array << total_clicks_d["date"]
              # array << total_clicks_d["referer"]
              # array << total_clicks_d["destination_url"]
#               
              # click_array << array
          # end
#         
#          
          # p = Axlsx::Package.new
          # wb = p.workbook
#             
          # wb.add_worksheet(:name => "Basic Worksheet") do |sheet|
               # click_array.each_with_index do |csv, csv_index|
                  # sheet.add_row csv
               # end
          # end
#            
          # create_excel_path = '/home/bmg/adeqo/public/export_click/'+name+'.xlsx'
          # p.serialize(create_excel_path)
      # end
#       
      # # @db2["clicks"].find('id' => { "$in" => del_click_array}).delete_many
      # rescue Exception
      # end
#       
      # data = {:export_click => total_clicks.count.to_i, :export_click_time => @one_hour_ago, :total_del_clicks => del_click_array.count.to_i, :status => "true"}
      # return render :json => data, :status => :ok
  # end
  
  
  def cleanclickfile
      begin
      @all_click_files = Dir.glob('/home/bmg/adeqo/public/export_click/*')
      
      file_year = (Time.now - 1.day).to_date.strftime("%Y")
      file_month = (Time.now - 1.day).to_date.strftime("%m")
      file_day = (Time.now - 1.day).to_date.strftime("%d")
       
      file_date = file_year + "-" + file_month + "-" + file_day
      
      @all_click_files.each do |all_files_p|
          if all_files_p.to_s.include?(file_date)
              File.delete(all_files_p) if File.exist?(all_files_p)
          end
      end
      rescue Exception
      end
      data = {:message => "clean click file", :clean_day => file_date, :status => "true"}
      return render :json => data, :status => :ok
  end
  
  
  
  def getmissingclickfile
      
      # begin
          
          @logger.info "run get missing click file"
          
          @one_hour_ago = Time.now - 1.hours
          @all_click_files = Dir.glob('/home/bmg/adeqo/public/export_click/*')
          name_datetime = @one_hour_ago.in_time_zone('Beijing').strftime("%Y-%m-%d-%H")
          
          
          @all_click_files.each do |all_files_p|
               
              if !all_files_p.to_s.include?(name_datetime)
                
                  @logger.info all_files_p
                  
                  xlsx = Roo::Spreadsheet.open(all_files_p, extension: :xlsx)
                  xlsx.each_with_index do |csv, csv_index|
                      begin
                          @logger.info csv_index.to_s
                          
                          cookies_hash = {}
                          csv_cookies_array = []
                          
                          if csv[18].to_s != "{}"
                              csv_cookies_array = csv[18].to_s.gsub('{', '').gsub('}', '').split(",")
                              
                              
                              csv_cookies_array.each do |csv_cookies_array_d|
                                  temp_arr = csv_cookies_array_d.split("=>")
                                  
                                  if !temp_arr[0].nil?
                                      name = temp_arr[0].gsub('"', '')
                                  end
                                  
                                  if !temp_arr[1].nil?
                                      value = temp_arr[1].gsub('"', '')
                                  else
                                      value = ""
                                  end
                                  
                                  if !temp_arr[0].nil?
                                      cookies_hash[name] = value
                                  end
                              end
                          end
                          
                          if csv[5].to_s == "sogou"
                            @type = "sogou"
                          elsif csv[5].to_s.include?("360")
                            @type = "360"
                          end
                          
                          @db2[:clicks].insert_one({ 
                                              id: csv[0].to_s, 
                                              random_number: csv[1].to_i.to_s,
                                              session_id: csv[2].to_s,
                                              company_id: csv[3].to_i,
                                              network_id: csv[4].to_i,
                                              network_type: @type.to_s,
                                              campaign_id: csv[6].to_i,
                                              adgroup_id: csv[7].to_i,
                                              keyword_id: csv[8].to_i,
                                              ad_id: csv[9].to_i,
                                              target_id: csv[10].to_s,
                                              search_q: csv[11].to_s,
                                              ip: csv[12],
                                              country: csv[13].to_s,
                                              city: csv[14].to_s,
                                              variant: csv[15].to_s,
                                              user_agent: csv[16].to_s,
                                              device: csv[17].to_s,
                                              cookies: cookies_hash,
                                              other_parameters: csv[19].to_s,
                                              date: csv[20].to_s,
                                              referer: csv[21].to_s,
                                              destination_url: csv[22].to_s
                                            })
                          @db2.close() 
                      rescue Exception
                          @logger.info csv
                      end
                  end
                  
                  File.delete(all_files_p) if File.exist?(all_files_p)
              end
          end
          
      # rescue Exception
#           
          # @logger.info "get missing click file error"
#           
      # end
      
      @logger.info "done get missing click file"
      data = {:message => "get missing click file", :status => "true"}
      return render :json => data, :status => :ok
  end
  
  def test
                
      @logger.info "test"
      
      # @db2[:clicks_2_2].indexes.create_one(ad_id: Mongo::Index::ASCENDING)
      # @db2[:clicks_2_2].indexes.create_one(adgroup_id: Mongo::Index::ASCENDING)
      # @db2[:clicks_2_2].indexes.create_one(campaign_id: Mongo::Index::ASCENDING)
      # @db2[:clicks_2_2].indexes.create_one(company_id: Mongo::Index::ASCENDING)
      # @db2[:clicks_2_2].indexes.create_one(date: Mongo::Index::ASCENDING)
      # @db2[:clicks_2_2].indexes.create_one(destination_url: Mongo::Index::ASCENDING)
      # @db2[:clicks_2_2].indexes.create_one(id: Mongo::Index::ASCENDING)
      # @db2[:clicks_2_2].indexes.create_one(keyword_id: Mongo::Index::ASCENDING)
      # @db2[:clicks_2_2].indexes.create_one(network_id: Mongo::Index::ASCENDING)
      # @db2[:clicks_2_2].indexes.create_one(other_parameters: Mongo::Index::ASCENDING)
      # @db2[:clicks_2_2].indexes.create_one(random_number: Mongo::Index::ASCENDING)
      # @db2[:clicks_2_2].indexes.create_one(session_id: Mongo::Index::ASCENDING)
      
      @click = @db2[:clicks].find() 
      @db2.close()
      
      # 100000.times { |i| @db2[:clicks_2].insert_one("i" => i, "id" => "sad") }
      # 100000.times { |i| @db2[:clicks_2].insert_one("i" => i, "id" => "sad") }
      
      data = {:message => "test", :test => @click, :status => "true"}
      return render :json => data, :status => :ok
      
          
      # @click = @db2[:clicks].find()
      # @db.close() 
#       
      # click_array = []
#       
#       
      # @click.each do |click_d|
        # begin
            # @db2[:clicks_2].insert_one({
                          # id: click_d['id'].to_s,
                          # random_number: click_d['random_number'].to_i.to_s,
                          # session_id: click_d['session_id'].to_s,
                          # company_id: click_d['company_id'].to_i,
                          # network_id: click_d['network_id'].to_i,
                          # network_type: click_d['network_type'].to_s,
                          # campaign_id: click_d['campaign_id'].to_i,
                          # adgroup_id: click_d['adgroup_id'].to_i,
                          # keyword_id: click_d['keyword_id'].to_i,
                          # ad_id: click_d['ad_id'].to_i,
                          # target_id: click_d['target_id'].to_s,
                          # search_q: click_d['search_q'].to_s,
                          # ip: click_d['ip'],
                          # country: click_d['country'].to_s,
                          # city: click_d['city'].to_s,
                          # variant: click_d['variant'].to_s,
                          # user_agent: click_d['user_agent'].to_s,
                          # device: click_d['device'].to_s,
                          # cookies: click_d['cookies'],
                          # other_parameters: click_d['other_parameters'].to_s,
                          # date: click_d['date'].to_s,
                          # referer: click_d['referer'].to_s,
                          # destination_url: click_d['destination_url'].to_s
                        # })
              # @db2.close()
          # rescue Exception
#             
              # array = []
#               
              # array << click_d["id"]
              # array << click_d["random_number"]
              # array << click_d["session_id"]
              # array << click_d["company_id"]
              # array << click_d["network_id"]
              # array << click_d["network_type"]
              # array << click_d["campaign_id"]
              # array << click_d["adgroup_id"]
              # array << click_d["keyword_id"]
              # array << click_d["ad_id"]
              # array << click_d["target_id"]
              # array << click_d["search_q"]
              # array << click_d["ip"]
              # array << click_d["country"]
              # array << click_d["city"]
              # array << click_d["variant"]
              # array << click_d["user_agent"]
              # array << click_d["device"]
              # array << click_d["cookies"]
              # array << click_d["other_parameters"]
              # array << click_d["date"]
              # array << click_d["referer"]
              # array << click_d["destination_url"]
#               
              # click_array << array
#               
              # @logger.info click_d
          # end     
      # end
#       
      # if click_array.count.to_i > 0
          # p = Axlsx::Package.new
          # wb = p.workbook
#             
          # wb.add_worksheet(:name => "Basic Worksheet") do |sheet|
               # click_array.each_with_index do |csv, csv_index|
                  # sheet.add_row csv
               # end
          # end
      # end
#        
      # create_excel_path = '/home/bmg/adeqo/public/export_click/test.xlsx'
      # p.serialize(create_excel_path)
#       
      # @logger.info "test done"
#       
      # data = {:message => "network test", :status => "true"}
      # return render :json => data, :status => :ok
  end
   
  
  def getclickfile
      # begin
      
          @logger.info "get click file"
          
          @one_hour_ago = Time.now - 1.hours
          name_datetime = @one_hour_ago.in_time_zone('Beijing').strftime("%Y-%m-%d-%H")
          
          domain_name = "http://trackadeqo.chinacloudapp.cn:8000/export_click/"      
          name = domain_name + "export_click_" + name_datetime + ".xlsx"
          
          download_name = "/home/bmg/adeqo/public/export_click/export_click_"+ name_datetime + ".xlsx"
          begin
              IO.copy_stream(open(name) , download_name)
          rescue Exception
              @logger.info "download file fail"
          end     
          @logger.info "download file done"
          
          tmp_file_path = download_name
                        
          xlsx = Roo::Spreadsheet.open(tmp_file_path, extension: :xlsx)
          xlsx.each_with_index do |csv, csv_index|
              
              begin
                  @logger.info csv_index.to_s
                  cookies_hash = {}
                  csv_cookies_array = []
                  
                  if csv[18].to_s != "{}"
                      csv_cookies_array = csv[18].to_s.gsub('{', '').gsub('}', '').split(",")
                      
                      
                      csv_cookies_array.each do |csv_cookies_array_d|
                          temp_arr = csv_cookies_array_d.split("=>")
                          
                          if !temp_arr[0].nil?
                              name = temp_arr[0].gsub('"', '')
                          end
                          
                          if !temp_arr[1].nil?
                              value = temp_arr[1].gsub('"', '')
                          else
                              value = ""
                          end
                          
                          if !temp_arr[0].nil?
                              cookies_hash[name] = value
                          end
                          
                          cookies_hash[name] = value
                      end
                      
                  end
                            
                            
                  
                  if csv[5].to_s == "sogou"
                    @type = "sogou"
                  elsif csv[5].to_s.include?("360")
                    @type = "360"
                  end
                  
                  
                  @db2[:clicks].insert_one({
                                id: csv[0].to_s,
                                random_number: csv[1].to_i.to_s,
                                session_id: csv[2].to_s,
                                company_id: csv[3].to_i,
                                network_id: csv[4].to_i,
                                network_type: @type.to_s,
                                campaign_id: csv[6].to_i,
                                adgroup_id: csv[7].to_i,
                                keyword_id: csv[8].to_i,
                                ad_id: csv[9].to_i,
                                target_id: csv[10].to_s,
                                search_q: csv[11].to_s,
                                ip: csv[12],
                                country: csv[13].to_s,
                                city: csv[14].to_s,
                                variant: csv[15].to_s,
                                user_agent: csv[16].to_s,
                                device: csv[17].to_s,
                                cookies: cookies_hash,
                                other_parameters: csv[19].to_s,
                                date: csv[20].to_s,
                                referer: csv[21].to_s,
                                destination_url: csv[22].to_s
                              })
                    @db2.close()
                
              rescue Exception
                  @logger.info csv
              end
          end
          
          @logger.info "get click file done"
          
          @all_click_files = Dir.glob('/home/bmg/adeqo/public/export_click/*')
          
          @all_click_files.each do |all_files_p|
              if all_files_p.to_s.include?(name_datetime)
                  File.delete(all_files_p) if File.exist?(all_files_p)
              end
          end
                              
      # rescue Exception
          # @logger.info "get click file empty"
      # end     
      
      
               
      data = {:message => "get and insert click", :clean_day => name_datetime, :status => "true"}
      return render :json => data, :status => :ok
  end
  
  
  def cleanexportfile
    
      @all_export_files = Dir.glob('/home/bmg/adeqo/public/export_excel/*')
      
      # file_year = (Time.now - 1.day).to_date.strftime("%Y")
      # file_month = (Time.now - 1.day).to_date.strftime("%m")
      # file_day = (Time.now - 1.day).to_date.strftime("%d")
#       
      # file_date = file_year + "-" + file_month + "-" + file_day
      
      @all_export_files.each do |all_files_p|
          # if all_files_p.to_s.include?(file_date)
              File.delete(all_files_p) if File.exist?(all_files_p)
          # end
      end
      
      data = {:message => "clean export", :status => "true"}
      return render :json => data, :status => :ok
  end
    
  def cleanlogfile
      @all_log_files = Dir.glob('/home/bmg/adeqo/log/*')
      
      file_year = (Time.now - 1.month).to_date.strftime("%Y")
      file_month = (Time.now - 1.month).to_date.strftime("%m")
      
      file_date = file_year + "-" + file_month 
      
      @all_log_files.each do |all_files_p|
          if all_files_p.to_s.include?(file_date) && all_files_p.to_s.include?("logfile")
              File.delete(all_files_p) if File.exist?(all_files_p)
          end
      end
      
      data = {:message => "clean log", :status => "true", :file_date => file_date}
      return render :json => data, :status => :ok
  end  
    
  def defaultdayrange
      
      if session[:start_date].nil?
          session[:start_date] = @today - 1.days
      end
      
      if session[:end_date].nil?
          session[:end_date] = @today - 1.days
      end
      
      if session[:bulk_start_date].nil?
          session[:bulk_start_date] = @today
      end
      
      if session[:bulk_end_date].nil?
          session[:bulk_end_date] = @today
      end
      
      if session[:adv_start_date].nil?
          session[:adv_start_date] = @today
      end
      
      if session[:adv_end_date].nil?
          session[:adv_end_date] = @today
      end
        
  end
  
  
  def logger
    @day = Time.now.in_time_zone('Beijing').strftime("%Y-%m-%d")
    @logger = Logger.new('/home/bmg/adeqo/log/'+@day+'logfile.log')
  end
  
  
  def useragent
      @user_agent = request.user_agent
    
      case @user_agent
        when /iPad/i
          @variant = "tablet"
        when /iPhone/i
          @variant = "phone"
        when /Android/i && /mobile/i
          @variant = "phone"
        when /Android/i
          @variant = "tablet"
        when /Windows Phone/i
          @variant = "phone"
        else
          @variant = "desktop"
      end
  end
  
  def location
      @ip = request.remote_ip
      @geoip = GeoIP.new("#{Rails.root}/public/GeoLiteCity.dat")
      @location = @geoip.city(@ip)
      
      @country = @location[:country_name]
      @city = @location[:city_name]
  end
  
  
  
  
  def getconversion
      
      @all_company = @db[:company].find()
      @db.close()
      conversion_array = []
      
      
      if @all_company.count.to_i > 0
          @all_company.each do |all_company_d|
            
                @events = @db[:events].find('company_id'=> all_company_d['id'].to_i, 'id' => { '$ne' => nil }, 'random_number' => { '$ne' => nil }, 'session_id' => { '$ne' => nil }).limit(100)
                @db.close()
                
                if @events.count.to_i > 0
                 
                    @events.each do |events_d|
                        revenue = 0
                        
                        other_param_array = events_d['other_param'].split(",")
                        other_param_array.each do |other_param_array_d|
                          
                            # @logger.info other_param_array_d.to_s
                          
                            param_detail_array = other_param_array_d.split(":")
                            
                            if !param_detail_array[1].nil? && param_detail_array[1].include?("val")
                                revenue = param_detail_array[1].gsub('val=','').to_f  
                            end
                        end
                        
                        
                        @clicks = @db[:clicks].find(
                                                    'id' => events_d['id'],
                                                    'company_id' => events_d['company_id'].to_i,  
                                                    'network_id' => { '$ne' => 0}, 
                                                    'campaign_id' => { '$ne' => 0}, 
                                                    'adgroup_id' => { '$ne' => 0}, 
                                                    'ad_id' => { '$ne' => 0}
                    
                                                  )
                        @db.close()                         
                                                  
                        if @clicks.count.to_i > 0
                              @clicks.each do |click_d|
                                    if click_d['keyword_id'].to_i == 0 then
                                      
                                        if click_d['target_id'].to_s != ""
                                            target_array = click_d['target_id'].to_s.split(":")
                                            
                                            target_array.each do |target_array_d|
                                                if target_array_d.to_s.include?("kwd-")
                                                    keyword_id = target_array_d.to_s.gsub('kwd-','').to_i
                                                end
                                            end
                                        end
                                          
                                    else
                                        keyword_id = click_d['keyword_id'].to_i
                                    end
                                    
                                    conversion = {}
                                    conversion[:id] = click_d['id']
                                    conversion[:random_number] = click_d['random_number']
                                    conversion[:session_id] = click_d['session_id']
                                    conversion[:tag_version] = click_d['tag_version'] 
                                    conversion[:company_id] = click_d['company_id']
                                    conversion[:network_id] = click_d['network_id']
                                    conversion[:campaign_id] = click_d['campaign_id']
                                    conversion[:adgroup_id] = click_d['adgroup_id']
                                    conversion[:ad_id] = click_d['ad_id']
                                    conversion[:keyword_id] = click_d['keyword_id']
                                    conversion[:revenue] = revenue
                                    conversion[:date] = click_d['date'] 
                                     
                                    conversion_array << conversion
                                    
                              end  
                        end    
                    end
                    
                end  
          end
      end
      
      
      
      
      data = {:conversion => conversion_array, :status => "true"}
      return render :json => data, :status => :ok
  end
  
  
  def getevent
      @events = @db[:events].find("company_id" => nil)
      @db.close()
      data = {:count => @events.count.to_i, :events => @events, :cookies => request.cookies, :status => "true"}
      return render :json => data, :status => :ok
  end
  
  
  def event
        useragent()
        location()
        
        @tag_version = ""
        @company_id = params[:companyid]
        
        if params[:companyid].nil?
            @company_id = params[:cid]
        end
        
        if @company_id.to_i == 0
            return render :nothing => true, :status => 200, :content_type => 'text/javascript'
        end
        
        if !params[:tag_version].nil?
            @tag_version = @tag_version.to_s + "/" + params[:tag_version].to_s
        end
        
        if !params[:v].nil?
            @tag_version = @tag_version.to_s + "/" + params[:v].to_s
        end
          
        
        params_array = []
    
        params.each do |key,value|
            if key.include?("param")
                params_array << key+":"+value
            end
        end
        
        #we dont have company 4, cause the first 3 company id is wrong. need to -1
        if @company_id.to_i <= 4
          @company_id = @company_id.to_i - 1
        end
        #we dont have company 4, cause the first 3 company id is wrong. need to -1
        
        begin
            if !cookies[:clicks_id].nil? && cookies[:clicks_id].to_s != ""
              
                @db2[:events].insert_one({ 
                                        id: cookies[:clicks_id], 
                                        random_number: cookies[:clicks_random_id],
                                        session_id: cookies[:clicks_session_id],
                                        tag_version: @tag_version,
                                        company_id: @company_id.to_i,
                                        referer: request.referer,
                                        ip: @ip,
                                        country: @country,
                                        city: @city,
                                        variant: @variant,
                                        user_agent: @user_agent,
                                        cookies: request.cookies,
                                        other_param: params_array,                                
                                        date: @now
                                      })       
                @db2.close()                      
            end
        rescue Exception
            logger.debug "event: db is too busy"
        end 
        
        # data = {:click_id => cookies[:clicks_id], :cookies => request.cookies, :status => "true"}
        # return render :json => data, :status => :ok
        
        
        return render :nothing => true, :status => 200, :content_type => 'text/javascript'
  end
  
  
  
  
  
  
  def getclick
      @clicks = @db[:clicks].find('referer' => { '$ne' => nil }).limit(100)
      
      @db.close()
      data = {:count => @db[:clicks].find().count.to_i, :clicks => @clicks, :cookies => request.cookies, :status => "true"}
      return render :json => data, :status => :ok
  end
  
  
  def click
     
    useragent()
    location()
    
    
    @id = SecureRandom.uuid
    @random_number = rand(1000000)
    @session_id = SecureRandom.uuid
    
    total_minutes = 1
    
    @company_id = params[:company_id]
    @network_id = params[:network_id]
    @campaign_id = params[:campaign_id]
    @adgroup_id = params[:adgroup_id]
    @ad_id = params[:ad_id]
    @keyword_id = params[:keyword_id]
    @durl = params[:durl]
    @search_q = params[:search_q]
    
    @target_id = params[:target_id]
    
    @cookie = params[:cookie]
    @device = params[:device]
    
    @test = params[:test]
    
    if !@test.nil? || @network_id.to_i == 0
      data = {:@durl => @durl}
      return render :json => data, :status => :ok
    end
    
    @network_type = ""
    
    
    if request.referer.to_s.include?("bing")
        @search_q = params[:q].to_s + "," + params[:pq].to_s
        
        @network_type = "bing"
    end
    
    
    if request.referer.to_s.include?("google")
        @search_q = params[:q].to_s + "," + params[:as_q].to_s + "," + params[:oq].to_s
        
        @network_type = "google"
    end
    
    
    if request.referer.to_s.include?("360") || request.referer.to_s.include?("haosou.com") || request.referer.to_s.include?("so.com")
         
        @referr_array = request.referer.split("?")
        @referr_param_array = @referr_array[1]
        
        if !@referr_param_array.nil?
            @referr_param_array = @referr_param_array.split("&")
            @search_q_array = []
            
            # @search_q_array << params[:q].to_s
            # @search_q_array << params[:pq].to_s
            
            @referr_param_array.each do |ref|
                @referr_keyword_array = ref.split("=")
                if ref.to_s.include?("keyword") || @referr_keyword_array[0].to_s == "p" || ref.to_s.include?("query") || @referr_keyword_array[0].to_s == "q"  
                    
                    @search_q_array << URI.unescape(@referr_keyword_array[1].to_s)
                    # @search_q = @search_q.to_s + "," + URI.unescape(@referr_keyword_array[1].to_s)
                end          
            end
            
            @search_q = @search_q_array.join(",") 
        else
            @search_q = ""
        end 
        @network_type = "360"
    end
    
    if request.referer.to_s.include?("sogou")
        
        @referr_array = request.referer.split("?")
        @referr_param_array = @referr_array[1]
        
        if !@referr_param_array.nil?
          @referr_param_array = @referr_param_array.split("&") 
          @search_q_array = []
          
          @referr_param_array.each do |ref|
              @referr_keyword_array = ref.split("=")
              if ref.to_s.include?("keyword") || @referr_keyword_array[0].to_s == "p" || ref.to_s.include?("query")
                  @search_q_array << URI.unescape(@referr_keyword_array[1].to_s)
                  # @search_q = @search_q.to_s + "," + URI.unescape(@referr_keyword_array[1].to_s)
              end          
          end
          
          @search_q = @search_q_array.join(",")
        else
          @search_q = ""
        end
        # if !params[:query].nil?
            # @search_q = @search_q + "," + params[:query].to_s 
        # end
#         
        # if !params[:oq].nil?
            # @search_q = @search_q + "," + params[:oq].to_s
        # end
#         
        # if !params[:pg].nil?
            # @search_q = @search_q + "," + params[:pg].to_s
        # end
                
        @network_type = "sogou"
    end
    
    
    params_array = []
    
    params.each do |key,value|
        if key.include?("params")
            params_array << key+":"+value
        end
    end
    
    begin
       
      @db2[:clicks].insert_one({ 
                              id: @id.to_s, 
                              random_number: @random_number.to_s,
                              session_id: @session_id.to_s,
                              company_id: @company_id.to_i,
                              network_id: @network_id.to_i,
                              network_type: @network_type.to_s,
                              campaign_id: @campaign_id.to_i,
                              adgroup_id: @adgroup_id.to_i,
                              keyword_id: @keyword_id.to_i,
                              ad_id: @ad_id.to_i,
                              target_id: @target_id.to_s,
                              search_q: @search_q.to_s,
                              ip: @ip,
                              country: @country,
                              city: @city,
                              variant: @variant,
                              user_agent: @user_agent,
                              device: @device,
                              cookies: request.cookies,
                              other_parameters: params_array.join(","),
                              date: @now,
                              referer: request.referer,
                              destination_url: @durl
                            })
        @db2.close() 
        
    rescue Exception
        logger.debug "DB is somehow not working, can't insert clicks, add email function in application controller later."
    end
    
    
    if @cookie.nil? || @cookie.to_i == 0 
        expire_day = 30
    else
        expire_day = @cookie.to_i
    end
    
    cookies[:clicks_id] = {
       :value => @id,
       :expires => expire_day.days.from_now,
       :domain => 'adeqo.com'
    }
    cookies[:clicks_random_id] = {
       :value => @random_number,
       :expires => expire_day.days.from_now,
       :domain => 'adeqo.com'
    }
    cookies[:clicks_session_id] = {
       :value => @session_id,
       :expires => expire_day.days.from_now,
       :domain => 'adeqo.com'
    }
    
    
    
    begin
        return redirect_to @durl
    rescue Exception
        return redirect_to "http://china.adeqo.com"
    end
    
    # data = {:uid => @id,:random_number => @random_number,:session_id => @session_id, :company_id => @company_id,:network_id => @network_id,:campaign_id => @campaign_id,:adgroup_id => @adgroup_id, :ad_id => @ad_id, :keyword_id => @keyword_id, :durl => @durl, :status => "true"}
    # return render :json => data, :status => :ok

  end
  
  
   
  
  
  
  
  def drop
  end
  
  
  
  def get_last_id(table)
    id = 0
    
    if table == "user"
        @db[:last_user_id].find.each do |last|
           id = last["id"]
        end
        @db.close()
    end
    
    if table == "company"
        @db[:last_company_id].find.each do |last|
           id = last["id"]
        end
        @db.close()
    end
    
    if table == "network"
        @db[:last_network_id].find.each do |last|
           id = last["id"]
        end
        @db.close()
    end
    
    return id    
  end
  
  def update_last_id(table,update_id)
    
    if table == "user"
        @db[:last_user_id].drop()
        @db.close()
        @db[:last_user_id].insert_one({
          id: update_id
        })
        @db.close()
    end
    
    if table == "company"
        @db[:last_company_id].drop()
        @db.close()
        @db[:last_company_id].insert_one({
          id: update_id
        })
        @db.close()
    end
    
    if table == "network"
        @db[:last_network_id].drop()
        @db.close()
        @db[:last_network_id].insert_one({
          id: update_id
        })
        @db.close()
    end
    
    
    
    
  end
  
 
  
  
  def now
    @now = Time.now.in_time_zone('Beijing').strftime("%Y-%m-%d %H:%M:%S %Z")
    @today = Date.today.in_time_zone('Beijing')
  end
  
  
  def loginuser
    # @logger.info "Load Application Login user "+ @now.to_s
    if !session[:user_id].nil?
      # @logger.info "user "+ session[:user_id].to_s
      return redirect_to "/dashboard"
    end
  end
  
  
  def authuser    
    
    if session[:user_id].nil?
      return redirect_to "/"
    end
      
    @current_user = @db[:user].find('id' => session[:user_id])
    @db.close()
    @user_count = @current_user.count.to_i
    
    if @user_count != 1
      session[:user_id] = nil
      return redirect_to "/"
    end
    
    @current_user.each do |doc|
      @user_company_id = doc["company_id"]
      @user_role = doc["role"]
      @user_name = doc["username"]
      @currency = doc["currency"]
      @current_user_status = doc["status"]
      @current_user_email = doc["email"]
    end
    
    if @current_user_status.to_s != "start"
      session[:user_id] = nil
      return redirect_to "/"
    end
    
    @user_company = @db[:company].find('id' => @user_company_id)
    @db.close()
    @all_user_in_company = @db[:user].find('company_id' => @user_company_id)
    @db.close()
  end
   
   
  def db
    begin
        if @sogou_db.nil?
            # @sogou_db = Mongo::Client.new([ '10.215.96.101:27017' ], :database => 'adeqo', :connect => :direct , :timeout => 5, :max_pool_size => 50, :pool_timeout => 5, :socket_timeout => 5, :connect_timeout => 5)
            @sogou_db = Mongo::Client.new([ '10.215.96.101:27017' ], :database => 'adeqo', :connect => :direct, :max_pool_size => 10)
            @sogou_db.close()
        end
        
        if @threesixty_db.nil?
            # @threesixty_db = Mongo::Client.new([ '10.215.134.32:27017' ], :database => 'adeqo', :connect => :direct , :timeout => 5, :max_pool_size => 50, :pool_timeout => 5, :socket_timeout => 5, :connect_timeout => 5)
            @threesixty_db = Mongo::Client.new([ '10.215.134.32:27017' ], :database => 'adeqo', :connect => :direct, :max_pool_size => 10)
            @threesixty_db.close()
        end
        
        
        if @baidu_db.nil? 
            # @baidu_db = Mongo::Client.new([ '10.215.124.104:27017' ], :database => 'adeqo', :connect => :direct , :timeout => 5, :max_pool_size => 50, :pool_timeout => 5, :socket_timeout => 5, :connect_timeout => 5)
            @baidu_db = Mongo::Client.new([ '10.215.124.104:27017' ], :database => 'adeqo', :connect => :direct, :max_pool_size => 10)
            @baidu_db.close()
        end
        
        
        
        if @db.nil? 
            # this one is for account structure
            # @db = Mongo::Client.new([ '10.215.148.65:27017' ], :database => 'adeqo', :connect => :direct , :timeout => 5, :max_pool_size => 50, :pool_timeout => 5, :socket_timeout => 5, :connect_timeout => 5)
            @db = Mongo::Client.new([ '10.215.148.65:27017' ], :database => 'adeqo', :connect => :direct, :max_pool_size => 10, :timeout => 5)
            @db.close()
        end
        
        if @db2.nil?
            # this one is for clicks
            # @db2 = Mongo::Client.new([ '10.215.152.50:27017' ], :database => 'adeqo', :connect => :direct , :timeout => 5, :max_pool_size => 50, :pool_timeout => 15, :socket_timeout => 5, :connect_timeout => 5)
            @db2 = Mongo::Client.new([ '10.215.124.60:27017' ], :database => 'adeqo', :connect => :direct, :max_pool_size => 10)
            @db2.close()
        end
        
        
        if @db3.nil?
          # this one is for report
          # @db3 = Mongo::Client.new([ '10.215.100.15:27017' ], :database => 'adeqo', :connect => :direct , :timeout => 5, :max_pool_size => 50, :pool_timeout => 15, :socket_timeout => 5, :connect_timeout => 5)
          @db3 = Mongo::Client.new([ '10.215.100.15:27017' ], :database => 'adeqo', :connect => :direct, :max_pool_size => 10)
          @db3.close()
        end
    rescue Exception
        return redirect_to "/"
    end
  end
  
  
  
end
