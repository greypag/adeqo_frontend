class HomesController < ApplicationController
  before_action :set_home, only: [:show, :edit, :update, :destroy]
  before_action :authuser, except: [:index,:demo,:contact_us,:send_demo_email,:send_contact_us_email,:services,:searchenginemarketing,:searchengineoptimization,:socialmediamarketing,:contentlocalisation,:pricing,:demo_thank_you,:contact_us_thank_you,:terms]
  # before_action :loginuser, only: [:index]
  
  layout "application", :only => [ :index,:demo,:contact_us,:services,:searchenginemarketing,:searchengineoptimization,:socialmediamarketing,:contentlocalisation,:pricing,:pricing,:demo_thank_you,:contact_us_thank_you,:terms]  
  layout "home", :except => [ :index,:demo,:contact_us,:services,:searchenginemarketing,:searchengineoptimization,:socialmediamarketing,:contentlocalisation,:pricing,:pricing,:demo_thank_you,:contact_us_thank_you,:terms ] 
  
  require 'savon'
  require "azure"
  
  require 'rubygems'
  require 'mongo'
  
  
  # GET /homes
  # GET /homes.json
  
  def terms
    
  end
  
  def demo_thank_you
    
  end
  
  def contact_us_thank_you
    
  end
  
  def pricing
      @title = " | Pricing"
  end
  
  def searchenginemarketing
      @title = " | Search Engine Marketing"
  end
  
  def searchengineoptimization
      @title = " | Search Engine Optimization"
  end
  
  def socialmediamarketing
      @title = " | Social Media Marketing"
  end
  
  def contentlocalisation
      @title = " | Content Localisation"
  end
  
  
  def services
      @title = " | Services"
  end
  
  def contact_us
      @title = " | Contact Us"
  end
  
  def demo
      @title = " | Request Demo"
  end
  
  def send_contact_us_email
      @select_email_subject = params[:select]
      @first_name = params[:first_name]
      @last_name = params[:last_name]
      @company_name = params[:company_name]
      @contact_email = params[:contact_email]
      @phone_number = params[:phone_number]
      @country = params[:country]
      @contact_message = params[:contact_message]
      
      if @first_name.to_s == "" || @last_name.to_s == "" || @contact_email.to_s == "" || @contact_message.to_s == ""
          data = {:message => "Missing require field", :status => "false"}
          return render :json => data, :status => :ok
      end
      
      
      
      begin
          mg_client = Mailgun::Client.new("key-c72a65e7d3d818852d40757182bd82c9")  
          mb_obj = Mailgun::MessageBuilder.new()
       
          mb_obj.set_from_address("do-not-reply@adeqo.com", {"first"=>"Adeqo", "last" => ""});
          
          
          # mb_obj.add_recipient(:cc, "bpo@bmgww.com", {"first" => "", "last" => ""});  
          mb_obj.add_recipient(:to, "sales@adeqo.com", {"first" => "", "last" => ""});
          mb_obj.add_recipient(:cc, "jkwan@bmgww.com", {"first" => "", "last" => ""});
          # mb_obj.add_recipient(:cc, "xfung@bmgww.com", {"first" => "", "last" => ""});
          
          mb_obj.set_subject("Adeqo | Contact Us | "+@select_email_subject.to_s);  
          # mb_obj.set_text_body(result_msg);
          @name = @first_name + " " + @last_name
          result_msg = "<p>Name: "+@name+"</p>"
          result_msg = result_msg + "<p>Company Name: "+@company_name+"</p>"
          result_msg = result_msg + "<p>Email: "+@contact_email+"</p>"
          result_msg = result_msg + "<p>Phone Number: "+@phone_number+"</p>"
          result_msg = result_msg + "<p>Country: "+@country+"</p>"
          result_msg = result_msg + "<p>Message:<br /><br />"+@contact_message+"</p>"
          
           
          mb_obj.set_html_body(result_msg);
          mg_client.send_message("china.adeqo.com", mb_obj)
          
      rescue Exception
          data = {:message => "email error", :status => "false"}
          return render :json => data, :status => :ok
      end
      
      data = {:message => "email done", :status => "true"}
      return render :json => data, :status => :ok
      
  end
  
  def send_demo_email
    
      @personal_demo_first_name = params[:personal_demo_first_name]
      @personal_demo_last_name = params[:personal_demo_last_name]
      @personal_demo_company_name = params[:personal_demo_company_name]
      @personal_demo_business_email = params[:personal_demo_business_email]
      @personal_demo_phone_number = params[:personal_demo_phone_number]
      @personal_demo_country = params[:personal_demo_country]
      @personal_demo_help = params[:personal_demo_help]
      
      if @personal_demo_first_name.to_s == "" || @personal_demo_last_name.to_s == "" || @personal_demo_business_email.to_s == ""
          data = {:message => "miss require field", :status => "false"}
          return render :json => data, :status => :ok
      end
      
      begin
          
          mg_client = Mailgun::Client.new("key-c72a65e7d3d818852d40757182bd82c9")  
          mb_obj = Mailgun::MessageBuilder.new()
       
          mb_obj.set_from_address("do-not-reply@adeqo.com", {"first"=>"Adeqo", "last" => ""});
          
          mb_obj.add_recipient(:to, "sales@adeqo.com", {"first" => "", "last" => ""});
          mb_obj.add_recipient(:cc, "jkwan@bmgww.com", {"first" => "", "last" => ""});
          # mb_obj.add_recipient(:cc, "xfung@bmgww.com", {"first" => "", "last" => ""});
          
          mb_obj.set_subject("Adeqo | Request Demo");  
          # mb_obj.set_text_body(result_msg);
          
          result_msg = "<p>First Name: "+@personal_demo_first_name+"</p>"
          result_msg = result_msg + "<p>Last Name: "+@personal_demo_last_name+"</p>"
          result_msg = result_msg + "<p>Company Name: "+@personal_demo_company_name+"</p>"
          result_msg = result_msg + "<p>Business Email: "+@personal_demo_business_email+"</p>"
          result_msg = result_msg + "<p>Phone Number: "+@personal_demo_phone_number+"</p>"
          result_msg = result_msg + "<p>Company: "+@personal_demo_country+"</p>"
          result_msg = result_msg + "<p>How can we help:<br /><br />"+@personal_demo_help+"</p>"
          
           
          mb_obj.set_html_body(result_msg);
          mg_client.send_message("china.adeqo.com", mb_obj)
          
      rescue Exception
          
          data = {:message => "email error", :status => "false"}
          return render :json => data, :status => :ok
      end
      
      data = {:message => "email done", :status => "true"}
      return render :json => data, :status => :ok
  end
  
  def index
    # @logger.info "Load Home index "+ @now.to_s
    loginuser()
    
    @rss = SimpleRSS.parse open('http://blog.adeqo.com/feed/')


  end

  # GET /homes/1
  # GET /homes/1.json
  def show
  end

  # GET /homes/new
  def new
    @home = Home.new
  end

  # GET /homes/1/edit
  def edit
  end

  
  def dashboard
      session[:user_network_id_array] = nil
      
      @user_allow_network = @db[:network_user].find("user" => session[:user_id])
      @db.close()
      
      if @user_allow_network.count.to_i == 0
          return redirect_to "/account/portfolio"
      end
      
  end


  def dashboarddetail
      session[:user_network_id_array] = nil
  end
  
  
  
  def getdashboard
      # session[:user_network_id_array] = nil 
      # @logger.info "Load Home getdashboard "+ @now.to_s
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      @channel_array = params[:channel_array]
      @account_id_array = params[:account_array]
      
      if @channel_array.nil?
          @channel_array = []
      end
      
      
      if @end_date.nil?
          request_start_date = @today - 1.days
          @end_date = request_start_date.strftime("%Y-%m-%d")
      else
          session[:end_date] = @end_date.to_date
          @end_date = @end_date.to_date + 1.days
          @end_date = @end_date.strftime("%Y-%m-%d")
      end
      
      if @start_date.nil?
          request_start_date = @today - 8.days
          @start_date = request_start_date.strftime("%Y-%m-%d")
      else
          session[:start_date] = @start_date.to_date
          @start_date = @start_date.to_date
          @start_date = @start_date.strftime("%Y-%m-%d")
      end
      
      
      day_range = (@end_date.to_date - @start_date.to_date).to_i
      
      current_day = @today.strftime("%d")
      last_day = Date.today.end_of_month.strftime("%d")
      first_date_of_this_month = Date.today.at_beginning_of_month.strftime("%Y-%m-%d")
      
      @channels = []      
      @request_date = []
      
      @account = []
      
      @user_network_id_array = []
      @user_network_array = []
      
      conversion_date_hash = {}
      
      if session[:user_network_id_array].nil?
        
          @user_network = @db[:network_user].find('user' => session[:user_id].to_i)
          @db.close()
          
          @total_network_array = []
          
          @user_network.each do |user_network_d|
              @user_network_id_array << user_network_d["network_id"]
          end
          
          # @total_network_array = @db[:network].find('id' => { "$in" => @user_network_id_array}, 'type' => { "$in" => @channel_array})
          # @db.close()
          
          
          
          @total_network_array = @db[:network].find({ "$and" => [ {:id => { "$in" => @user_network_id_array}}, {:type => { "$in" => @channel_array}}] })
          @db.close()
    
          if @total_network_array.count.to_i > 0
              @user_network_id_array = []
              
               @total_network_array.each do |total_network_array_d|
                  @user_network_id_array << total_network_array_d["id"]
               end
          end
          
          session[:user_network_id_array] = @user_network_id_array.join(",")
      else
          
          if @account_id_array.nil?
            
              @user_network_id_array = session[:user_network_id_array].split(",")
              @user_network_id_array = @user_network_id_array.map(&:to_i)
              
              
              @total_network_array = @db[:network].find({ "$and" => [ {:id => { "$in" => @user_network_id_array}}, {:type => { "$in" => @channel_array}}] })
              @db.close()
              
          else
            
              @account_id_array = @account_id_array.map(&:to_i)
              @user_network_id_array = @account_id_array
              
              @total_network_array = @db[:network].find('id' => { "$in" => @account_id_array})
              @db.close()
              
              session[:user_network_id_array] = @user_network_id_array.join(",")
          end
          
      end
          
      # data = {:tmp => session[:user_network_id_array],:channel_array => @channel_array,  :status => "true"}
      # return render :json => data, :status => :ok
      
      #account do same thing for other channel
      # session[:user_network_id_array] = nil
      
      
      if @start_date < first_date_of_this_month
        request_date_start_from = @start_date
      else
        request_date_start_from = first_date_of_this_month
      end
      
      # @sogou_report_account = @db3[:sogou_report_account].find('network_id' => { "$in" => @user_network_id_array}, 'report_date' => { '$gte' => request_date_start_from.to_s }, 'display' => { "$gt" => 0})
      # @db3.close()
#       
      # @report_account_360 = @db3[:report_account_360].find('network_id' => { "$in" => @user_network_id_array}, 'report_date' => { '$gte' => request_date_start_from.to_s }, 'display' => { "$gt" => 0})
      # @db3.close()
#       
      # @baidu_report_account = @db3[:baidu_report_account].find('network_id' => { "$in" => @user_network_id_array}, 'report_date' => { '$gte' => request_date_start_from.to_s }, 'display' => { "$gt" => 0})
      # @db3.close()
      
      
      
      
      @sogou_report_account = @db3[:sogou_report_account].find({ "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:report_date => { '$gte' => request_date_start_from.to_s }}, {:display => { "$gt" => 0}}] })
      @db3.close()
      
      @report_account_360 = @db3[:report_account_360].find({ "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:report_date => { '$gte' => request_date_start_from.to_s }}, {:display => { "$gt" => 0}}] })
      @db3.close()
      
      @baidu_report_account = @db3[:baidu_report_account].find({ "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:report_date => { '$gte' => request_date_start_from.to_s }}, {:display => { "$gt" => 0}}] })
      @db3.close()
      
      @shenma_report_account = @db3[:shenma_report_account].find({ "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:report_date => { '$gte' => request_date_start_from.to_s }}, {:display => { "$gt" => 0}}] })
      @db3.close()
      
      # data = {:message => @shenma_report_account, :status => "true", :param => params}
      # return render :json => data, :status => :ok
      
      report_account_total_cost_hash = {}
      request_date_hash = {}
      
      # channels[]
      @sogou_object = {}
      @three_sixty_object = {}
      @baidu_object = {}
      @shenma_object = {}
      
      
      @shenma_impressions = 0
      @shenma_clicks = 0
      @shenma_ctr = 0
      @shenma_cost = 0
      @shenma_avg_cpc = 0
      @shenma_avg_pos = 0
      
      @sogou_impressions = 0
      @sogou_clicks = 0
      @sogou_ctr = 0
      @sogou_cost = 0
      @sogou_avg_cpc = 0
      @sogou_avg_pos = 0
      
      @baidu_impressions = 0
      @baidu_clicks = 0
      @baidu_ctr = 0
      @baidu_cost = 0
      @baidu_avg_cpc = 0
      @baidu_avg_pos = 0
      
      @three_sixty_impressions = 0
      @three_sixty_clicks = 0
      @three_sixty_ctr = 0
      @three_sixty_cost = 0
      @three_sixty_avg_cpc = 0
      @three_sixty_avg_pos = 0
      
      @conversion_sogou_count = 0
      @conversion_360_count = 0
      @conversion_baidu_count = 0
      @conversion_shenma_count = 0
      # channels[]
      
      # request date[]
      @request_end_date = params[:end_date].to_date + 1.days
      @request_date_array = []
      
      (1..day_range).each do |i|
          request_date =  @request_end_date.to_date - i.to_i.days
          request_date = request_date.strftime("%Y-%m-%d")
          
          @request_date_array << request_date
      end
      # request date[]
      
      
      if @shenma_report_account.count.to_i > 0 && @channel_array.include?("shenma")
        
          conversion_date_hash["typeshenma"] = 0
          conversion_date_hash["revenueshenma"] = 0
        
          @shenma_report_account.each do |shenma_report_account_d|
              if shenma_report_account_d['report_date'].to_date >= first_date_of_this_month.to_date
                    
                    if report_account_total_cost_hash["id"+shenma_report_account_d['network_id'].to_s]
                        report_account_total_cost_hash["id"+shenma_report_account_d['network_id'].to_s] += shenma_report_account_d['total_cost'].to_f
                    else
                        report_account_total_cost_hash["id"+shenma_report_account_d['network_id'].to_s] = shenma_report_account_d['total_cost'].to_f
                    end
                
              end
              
              if @request_date_array.include?(shenma_report_account_d['report_date'])
                
                  @shenma_impressions = @shenma_impressions.to_i + shenma_report_account_d["display"].to_i
                  @shenma_clicks = @shenma_clicks.to_i + shenma_report_account_d["clicks"].to_i
                  @shenma_cost = @shenma_cost.to_f + shenma_report_account_d["total_cost"].to_f
                  
                  avg_pos = shenma_report_account_d["avg_position"].to_f * shenma_report_account_d["display"].to_f
                  @shenma_avg_pos = @shenma_avg_pos.to_f + avg_pos.to_f
                                    
                  if request_date_hash["date"+shenma_report_account_d['report_date'].to_s+"display"]
                      request_date_hash["date"+shenma_report_account_d['report_date'].to_s+"display"] += shenma_report_account_d['display'].to_i
                  else
                      request_date_hash["date"+shenma_report_account_d['report_date'].to_s+"display"] = shenma_report_account_d['display'].to_i
                  end
                  
                  if request_date_hash["date"+shenma_report_account_d['report_date'].to_s+"clicks"]
                      request_date_hash["date"+shenma_report_account_d['report_date'].to_s+"clicks"] += shenma_report_account_d['clicks'].to_i
                  else
                      request_date_hash["date"+shenma_report_account_d['report_date'].to_s+"clicks"] = shenma_report_account_d['clicks'].to_i
                  end
                  
                  if request_date_hash["date"+shenma_report_account_d['report_date'].to_s+"total_cost"]
                      request_date_hash["date"+shenma_report_account_d['report_date'].to_s+"total_cost"] += shenma_report_account_d['total_cost'].to_f
                  else
                      request_date_hash["date"+shenma_report_account_d['report_date'].to_s+"total_cost"] = shenma_report_account_d['total_cost'].to_f
                  end
                  
                  if request_date_hash["date"+shenma_report_account_d['report_date'].to_s+"avg_position"]
                                                
                      if shenma_report_account_d['display'].to_f > 0 && shenma_report_account_d['avg_position'].to_f > 0
                          avg_pos = shenma_report_account_d["avg_position"].to_f * shenma_report_account_d["display"].to_f
                          request_date_hash["date"+shenma_report_account_d['report_date'].to_s+"avg_position"] += avg_pos.to_f
                      end
                      
                  else
                      request_date_hash["date"+shenma_report_account_d['report_date'].to_s+"avg_position"] = shenma_report_account_d["avg_position"].to_f * shenma_report_account_d["display"].to_f
                  end
                  
              end
          end
      end
      
      if @baidu_report_account.count.to_i > 0 && @channel_array.include?("baidu")
        
          conversion_date_hash["typebaidu"] = 0
          conversion_date_hash["revenuebaidu"] = 0
          
          @baidu_report_account.each do |baidu_report_account_d|
              if baidu_report_account_d['report_date'].to_date >= first_date_of_this_month.to_date
                    
                    if report_account_total_cost_hash["id"+baidu_report_account_d['network_id'].to_s]
                        report_account_total_cost_hash["id"+baidu_report_account_d['network_id'].to_s] += baidu_report_account_d['total_cost'].to_f
                    else
                        report_account_total_cost_hash["id"+baidu_report_account_d['network_id'].to_s] = baidu_report_account_d['total_cost'].to_f
                    end
                
              end
              
              if @request_date_array.include?(baidu_report_account_d['report_date'])
                
                  @baidu_impressions = @baidu_impressions.to_i + baidu_report_account_d["display"].to_i
                  @baidu_clicks = @baidu_clicks.to_i + baidu_report_account_d["clicks"].to_i
                  @baidu_cost = @baidu_cost.to_f + baidu_report_account_d["total_cost"].to_f
                  
                  avg_pos = baidu_report_account_d["avg_position"].to_f * baidu_report_account_d["display"].to_f
                  @baidu_avg_pos = @baidu_avg_pos.to_f + avg_pos.to_f
                                    
                  if request_date_hash["date"+baidu_report_account_d['report_date'].to_s+"display"]
                      request_date_hash["date"+baidu_report_account_d['report_date'].to_s+"display"] += baidu_report_account_d['display'].to_i
                  else
                      request_date_hash["date"+baidu_report_account_d['report_date'].to_s+"display"] = baidu_report_account_d['display'].to_i
                  end
                  
                  if request_date_hash["date"+baidu_report_account_d['report_date'].to_s+"clicks"]
                      request_date_hash["date"+baidu_report_account_d['report_date'].to_s+"clicks"] += baidu_report_account_d['clicks'].to_i
                  else
                      request_date_hash["date"+baidu_report_account_d['report_date'].to_s+"clicks"] = baidu_report_account_d['clicks'].to_i
                  end
                  
                  if request_date_hash["date"+baidu_report_account_d['report_date'].to_s+"total_cost"]
                      request_date_hash["date"+baidu_report_account_d['report_date'].to_s+"total_cost"] += baidu_report_account_d['total_cost'].to_f
                  else
                      request_date_hash["date"+baidu_report_account_d['report_date'].to_s+"total_cost"] = baidu_report_account_d['total_cost'].to_f
                  end
                  
                  if request_date_hash["date"+baidu_report_account_d['report_date'].to_s+"avg_position"]
                                                
                      if baidu_report_account_d['display'].to_f > 0 && baidu_report_account_d['avg_position'].to_f > 0
                          avg_pos = baidu_report_account_d["avg_position"].to_f * baidu_report_account_d["display"].to_f
                          request_date_hash["date"+baidu_report_account_d['report_date'].to_s+"avg_position"] += avg_pos.to_f
                      end
                      
                  else
                      request_date_hash["date"+baidu_report_account_d['report_date'].to_s+"avg_position"] = baidu_report_account_d["avg_position"].to_f * baidu_report_account_d["display"].to_f
                  end
                  
              end
          end
      end
      
      
      if @sogou_report_account.count.to_i > 0 && @channel_array.include?("sogou")
        
        
          conversion_date_hash["typesogou"] = 0
          conversion_date_hash["revenuesogou"] = 0
        
          @sogou_report_account.each do |sogou_report_account_d|
            
              if sogou_report_account_d['report_date'].to_date >= first_date_of_this_month.to_date
                    
                    if report_account_total_cost_hash["id"+sogou_report_account_d['network_id'].to_s]
                        report_account_total_cost_hash["id"+sogou_report_account_d['network_id'].to_s] += sogou_report_account_d['total_cost'].to_f
                    else
                        report_account_total_cost_hash["id"+sogou_report_account_d['network_id'].to_s] = sogou_report_account_d['total_cost'].to_f
                    end
                
              end
            
              if @request_date_array.include?(sogou_report_account_d['report_date'])
                  # channels[]
                  @sogou_impressions = @sogou_impressions.to_i + sogou_report_account_d["display"].to_i
                  @sogou_clicks = @sogou_clicks.to_i + sogou_report_account_d["clicks"].to_i
                  @sogou_cost = @sogou_cost.to_f + sogou_report_account_d["total_cost"].to_f
                  
                  avg_pos = sogou_report_account_d["avg_position"].to_f * sogou_report_account_d["display"].to_f
                  @sogou_avg_pos = @sogou_avg_pos.to_f + avg_pos.to_f
                  # channels[]
                  
                  if request_date_hash["date"+sogou_report_account_d['report_date'].to_s+"display"]
                      request_date_hash["date"+sogou_report_account_d['report_date'].to_s+"display"] += sogou_report_account_d['display'].to_i
                  else
                      request_date_hash["date"+sogou_report_account_d['report_date'].to_s+"display"] = sogou_report_account_d['display'].to_i
                  end
                  
                  if request_date_hash["date"+sogou_report_account_d['report_date'].to_s+"clicks"]
                      request_date_hash["date"+sogou_report_account_d['report_date'].to_s+"clicks"] += sogou_report_account_d['clicks'].to_i
                  else
                      request_date_hash["date"+sogou_report_account_d['report_date'].to_s+"clicks"] = sogou_report_account_d['clicks'].to_i
                  end
                  
                  if request_date_hash["date"+sogou_report_account_d['report_date'].to_s+"total_cost"]
                      request_date_hash["date"+sogou_report_account_d['report_date'].to_s+"total_cost"] += sogou_report_account_d['total_cost'].to_f
                  else
                      request_date_hash["date"+sogou_report_account_d['report_date'].to_s+"total_cost"] = sogou_report_account_d['total_cost'].to_f
                  end
                  
                  if request_date_hash["date"+sogou_report_account_d['report_date'].to_s+"avg_position"]
                                                
                      if sogou_report_account_d['display'].to_f > 0 && sogou_report_account_d['avg_position'].to_f > 0
                          avg_pos = sogou_report_account_d["avg_position"].to_f * sogou_report_account_d["display"].to_f
                          request_date_hash["date"+sogou_report_account_d['report_date'].to_s+"avg_position"] += avg_pos.to_f
                      end
                      
                  else
                      request_date_hash["date"+sogou_report_account_d['report_date'].to_s+"avg_position"] = sogou_report_account_d["avg_position"].to_f * sogou_report_account_d["display"].to_f
                  end
              end
          end    
      end
      
      
      if @report_account_360.count.to_i > 0 && @channel_array.include?("360")
        
          conversion_date_hash["type360"] = 0
          conversion_date_hash["revenue360"] = 0
        
          @report_account_360.each do |report_account_360_d|
            
              if report_account_360_d['report_date'].to_date >= first_date_of_this_month.to_date
                  
                  if report_account_total_cost_hash["id"+report_account_360_d['network_id'].to_s]
                      report_account_total_cost_hash["id"+report_account_360_d['network_id'].to_s] += report_account_360_d['total_cost'].to_f
                  else
                      report_account_total_cost_hash["id"+report_account_360_d['network_id'].to_s] = report_account_360_d['total_cost'].to_f
                  end
                  
              end
              
              if @request_date_array.include?(report_account_360_d['report_date'])   
                  # channels[]    
                  @three_sixty_impressions = @three_sixty_impressions.to_i + report_account_360_d["display"].to_i
                  @three_sixty_clicks = @three_sixty_clicks.to_i + report_account_360_d["clicks"].to_i
                  @three_sixty_cost = @three_sixty_cost.to_f + report_account_360_d["total_cost"].to_f
                  # channels[]
                  
                  avg_pos = report_account_360_d["avg_position"].to_f * report_account_360_d["display"].to_f
                  @three_sixty_avg_pos = @three_sixty_avg_pos.to_f + avg_pos.to_f
                  
                  if request_date_hash["date"+report_account_360_d['report_date'].to_s+"display"]
                      request_date_hash["date"+report_account_360_d['report_date'].to_s+"display"] += report_account_360_d['display'].to_i
                  else
                      request_date_hash["date"+report_account_360_d['report_date'].to_s+"display"] = report_account_360_d['display'].to_i
                  end
                  
                  if request_date_hash["date"+report_account_360_d['report_date'].to_s+"clicks"]
                      request_date_hash["date"+report_account_360_d['report_date'].to_s+"clicks"] += report_account_360_d['clicks'].to_i
                  else
                      request_date_hash["date"+report_account_360_d['report_date'].to_s+"clicks"] = report_account_360_d['clicks'].to_i
                  end
                  
                  if request_date_hash["date"+report_account_360_d['report_date'].to_s+"total_cost"]
                      request_date_hash["date"+report_account_360_d['report_date'].to_s+"total_cost"] += report_account_360_d['total_cost'].to_f
                  else
                      request_date_hash["date"+report_account_360_d['report_date'].to_s+"total_cost"] = report_account_360_d['total_cost'].to_f
                  end
                  
                  if request_date_hash["date"+report_account_360_d['report_date'].to_s+"avg_position"]
                                                
                      if report_account_360_d['display'].to_f > 0 && report_account_360_d['avg_position'].to_f > 0
                          avg_pos = report_account_360_d["avg_position"].to_f * report_account_360_d["display"].to_f
                          request_date_hash["date"+report_account_360_d['report_date'].to_s+"avg_position"] += avg_pos.to_f
                      end
                      
                  else
                      request_date_hash["date"+report_account_360_d['report_date'].to_s+"avg_position"] = report_account_360_d["avg_position"].to_f * report_account_360_d["display"].to_f
                  end    
              end    
              
          end
      end
      #account do same thing for other channel
      
      # request date[]
      
      
      if @request_date_array.count.to_i > 0
          @request_date_array.each do |request_date_array_d|
            
              conversion_request_start_date = request_date_array_d.to_s+" 00:00:00 CST"
              conversion_request_end_date = request_date_array_d.to_s+" 23:59:59 CST"
              
              if !request_date_hash["date"+request_date_array_d.to_s+"revenue"].nil?
                  request_date_hash["date"+request_date_array_d.to_s+"revenue"] = 0
              end
              
              @conversion_date = @db2[:conversion].find.aggregate([ 
                                                             { '$match' => { "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:network_type => { "$in" => @channel_array}},{:company_id => @user_company_id.to_i}, {:date => { '$gte' => conversion_request_start_date.to_s }}, {:date => { '$lte' => conversion_request_end_date.to_s }}] } },
                                                             { '$group' => { '_id' => '$order_id' } }
                                                          ])
              @db2.close()
              
              
              # @conversion_date = @db2[:conversion].find({ "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:network_type => { "$in" => @channel_array}},{:company_id => @user_company_id.to_i},{:date => { '$gte' => conversion_request_start_date.to_s }}, {:date => { '$lte' => conversion_request_end_date.to_s }}] })
              # @db2.close()
              
              conversion_date_hash["date"+request_date_array_d.to_s] = @conversion_date.count.to_i
              
              
              
              
              
              
              # @all_conversion = @db2[:conversion].find.aggregate([ 
                                                           # { '$match' => { "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:network_type => { "$in" => @channel_array}},{:company_id => @user_company_id.to_i},{:date => { '$gt' => conversion_request_start_date.to_s }}, {:date => { '$lt' => conversion_request_end_date.to_s }}] } },
                                                           # { '$group' => { '_id' => '$network_type', 
                                                                           # 'revenue' => { '$sum' => "$revenue" } } }
                                                        # ])
              # @db2.close()
              
              
              
              
              @all_conversion = @db2[:conversion].find.aggregate([ 
                                                           { '$match' => { "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:network_type => { "$in" => @channel_array}},{:company_id => @user_company_id.to_i},{:date => { '$gt' => conversion_request_start_date.to_s }}, {:date => { '$lt' => conversion_request_end_date.to_s }}] } },
                                                           { '$group' => { '_id' => { 'network_type' => '$network_type',  'order_id' => '$order_id'}, 
                                                                           'count' => { '$sum' => 1 }, 'revenue' => { '$sum' => "$revenue" } } }
                                                        ])
              @db2.close()
              
              
              if @all_conversion.count.to_i > 0 
                  @all_conversion.each do |all_conversion_arr|
                    
                      request_date_hash["date"+request_date_array_d.to_s+"revenue"] = request_date_hash["date"+request_date_array_d.to_s+"revenue"].to_f + (all_conversion_arr['revenue'].to_f / all_conversion_arr['count'].to_f)
                  end
              end
              
              
              
          end  
      end
      
      
      
      conversion_request_start_date = @request_date_array.min.to_s+" 00:00:00 CST"
      conversion_request_end_date = @request_date_array.max.to_s+" 23:59:59 CST"
      
      
      # @all_conversion = @db2[:conversion].find.aggregate([ 
                                                           # { '$match' => { 'network_type' => { "$in" => @channel_array}, 'network_id' => { "$in" => @user_network_id_array}, 'date' => { '$gt' => conversion_request_start_date.to_s, '$lt' => conversion_request_end_date.to_s },'company_id' => @user_company_id.to_i } },
                                                           # { '$group' => { '_id' => '$network_type', 'count' => { '$sum' => 1 }, 'revenue' => { '$sum' => "$revenue" } } }
                                                        # ])
      # @db2.close()
      
      
      
      @all_conversion = @db2[:conversion].find.aggregate([ 
                                                           { '$match' => { "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:network_type => { "$in" => @channel_array}},{:company_id => @user_company_id.to_i},{:date => { '$gt' => conversion_request_start_date.to_s }}, {:date => { '$lt' => conversion_request_end_date.to_s }}] } },
                                                           { '$group' => { '_id' => { 'network_type' => '$network_type',  'order_id' => '$order_id'}, 
                                                                           'count' => { '$sum' => 1 }, 'revenue' => { '$sum' => "$revenue" } } }
                                                        ])
      @db2.close()
      
      if @all_conversion.count.to_i > 0 
          @all_conversion.each do |all_conversion_arr|
              conversion_date_hash["type"+all_conversion_arr['_id']['network_type'].to_s] = conversion_date_hash["type"+all_conversion_arr['_id']['network_type'].to_s] + 1
              conversion_date_hash["revenue"+all_conversion_arr['_id']['network_type'].to_s] = conversion_date_hash["revenue"+all_conversion_arr['_id']['network_type'].to_s].to_f + (all_conversion_arr['revenue'].to_f / all_conversion_arr['count'].to_f)
          end
      end
      
      
      # data = {:conversion_date_hash => conversion_date_hash, :all_conversion => @all_conversion, :status => "true"}
      # return render :json => data, :status => :ok
     
      
      
      # request date[]                              
      
      
      if @total_network_array.count.to_i > 0
          
          # account[]
          @total_network_array.each do |doc|
            
              # # @logger.info "Load Home getdashboard, network id: "+ doc["id"].to_s + " " +@now.to_s
              
              @account_object = {}
              @account_object["name"] = doc["name"]
              @estimate = 0
              @color = 'g'
              
              if report_account_total_cost_hash["id"+doc['id'].to_s]
                  @total = report_account_total_cost_hash["id"+doc['id'].to_s].to_f
              else
                  @total = 0
              end
              
              @estimate = (@total.to_f/current_day.to_f) * last_day.to_f
              @account_object["total"] = @total.to_i
              @account_object["estimate"] = @estimate.to_i
              @account_object["target"] = doc["budget"].to_f
              
              @account_object["index"] = @total.to_f / doc["budget"].to_f
              
              @account_object["difference"] = doc["budget"].to_f - @estimate.to_f 
              @account_object["current_per_day"] = @total.to_f/current_day.to_f
              @account_object["req_per_day"] = (doc["budget"].to_f - @estimate.to_f)/(last_day.to_i - current_day.to_i) 
              
              
              if (doc["budget"].to_f - @estimate.to_f).to_i < 0
                  @color = 'r'
              end
              
              if (doc["budget"].to_f - @estimate.to_f).to_i >= 0
                  @color = 'y'
              end
              
              if (doc["budget"].to_f - @estimate.to_f).abs <= (doc["budget"].to_i * 0.05)
                  @color = 'g'
              end
              
              @account_object["color"] = @color
              @account << @account_object
          end
          # account[]
      
          (1..day_range).each do |i|
              
              @request_date_object = {}
              
              @impressions = 0
              @clicks = 0
              @ctr = 0
              @cost = 0
              @avg_cpc = 0
              @avg_pos = 0
               
              request_date =  @request_end_date.to_date - i.to_i.days
              request_date = request_date.strftime("%Y-%m-%d")
              
              # @logger.info request_date.to_s 

              
              if request_date_hash["date"+request_date.to_s+"display"]
                  @impressions = request_date_hash["date"+request_date.to_s+"display"]
              else
                  @impressions = 0
              end
              
              if request_date_hash["date"+request_date.to_s+"clicks"]
                  @clicks = request_date_hash["date"+request_date.to_s+"clicks"]
              else
                  @clicks = 0
              end
              
              if request_date_hash["date"+request_date.to_s+"total_cost"]
                  @cost = request_date_hash["date"+request_date.to_s+"total_cost"]
              else
                  @cost = 0
              end
              
              if request_date_hash["date"+request_date.to_s+"avg_position"]
                  @avg_pos = request_date_hash["date"+request_date.to_s+"avg_position"]
              else
                  @avg_pos = 0
              end
              
              if @avg_pos.to_i > 0
                  @avg_pos = @avg_pos.to_f / @impressions.to_f
              end
              
              @request_date_object["date"] = request_date
              @request_date_object["impressions"] = @impressions
              @request_date_object["clicks"] = @clicks.to_i
              @request_date_object["ctr"] = (@impressions.to_f/@clicks.to_f).to_f.round(2)
              @request_date_object["cost"] = @cost.to_f
              @avg_cpc = @cost.to_f / @clicks.to_f
              @request_date_object["avg_cpc"] = @avg_cpc.to_f
              
              @conversion_date = conversion_date_hash["date"+request_date.to_s]
              
              @request_date_object["conversion"] = @conversion_date.to_i
              @request_date_object["conversion_rate"] = (@conversion_date.to_f / @clicks.to_f) * 100
              @request_date_object["cpa"] = @cost.to_f / @conversion_date.to_f
              @request_date_object["revenue"] = request_date_hash["date"+request_date.to_s+"revenue"].to_f
              @request_date_object["profit"] = 0
              # @request_date_object["avg_pos"] = (@avg_pos.to_f / @impressions.to_f).to_f.round(2)
              @request_date_object["avg_pos"] = @avg_pos.to_f.round(2)
              
              @request_date << @request_date_object
              i = i + 1
          end
          
          @three_sixty_object["name"] = "360"
          @three_sixty_object["impressions"] = @three_sixty_impressions
          @three_sixty_object["clicks"] = @three_sixty_clicks.to_i
          
          @three_sixty_object["ctr"] = ((@three_sixty_clicks.to_f / @three_sixty_impressions.to_f) * 100).to_s+"$"
          
          @three_sixty_object["cost"] = @three_sixty_cost.to_f
          @three_sixty_avg_cpc = @three_sixty_cost.to_f / @three_sixty_clicks.to_f
          @three_sixty_object["avg_cpc"] = @three_sixty_avg_cpc.to_f
           
          if conversion_date_hash["type360"]
            @conversion_360_count = conversion_date_hash["type360"].to_i
          else
            @conversion_360_count = 0
          end
          
          @three_sixty_object["conversion"] = @conversion_360_count.to_i
          @three_sixty_object["conversion_rate"] = (@conversion_360_count.to_f / @three_sixty_clicks.to_f) * 100
          @three_sixty_object["cpa"] = @three_sixty_cost.to_f / @conversion_360_count.to_f
          @three_sixty_object["revenue"] = conversion_date_hash["revenue360"].to_f
          @three_sixty_object["profit"] = 0
          
          if @three_sixty_avg_pos.to_f > 0
              @three_sixty_avg_pos = @three_sixty_avg_pos.to_f / @three_sixty_impressions.to_f
          end
          @three_sixty_object["avg_pos"] = @three_sixty_avg_pos.to_f
          
          # ____________________________________________________________________________________________________________
          
          @sogou_object["name"] = "sogou"
          @sogou_object["impressions"] = @sogou_impressions
          @sogou_object["clicks"] = @sogou_clicks.to_i
          @sogou_object["ctr"] = ((@sogou_clicks.to_f / @sogou_impressions.to_f)*100).to_s+"$"
          @sogou_object["cost"] = @sogou_cost.to_f
          @sogou_avg_cpc = @sogou_cost.to_f / @sogou_clicks.to_f
          @sogou_object["avg_cpc"] = @sogou_avg_cpc.to_f
          
          if conversion_date_hash["typesogou"]
            @conversion_sogou_count = conversion_date_hash["typesogou"].to_i
          else
            @conversion_sogou_count = 0
          end
           
          @sogou_object["conversion"] = @conversion_sogou_count.to_i
          @sogou_object["conversion_rate"] = (@conversion_sogou_count.to_f / @sogou_clicks.to_f) * 100
          @sogou_object["cpa"] = @sogou_cost.to_f / @conversion_sogou_count.to_f
          @sogou_object["revenue"] = conversion_date_hash["revenuesogou"].to_f
          @sogou_object["profit"] = 0
          
          if @sogou_avg_pos.to_f > 0
              @sogou_avg_pos = @sogou_avg_pos.to_f / @sogou_impressions.to_f
          end
          @sogou_object["avg_pos"] = @sogou_avg_pos.to_f
          
          # ________________________________________________________________________________________________________________
          
          
          @baidu_object["name"] = "baidu"
          @baidu_object["impressions"] = @baidu_impressions
          @baidu_object["clicks"] = @baidu_clicks.to_i
          @baidu_object["ctr"] = ((@baidu_clicks.to_f / @baidu_impressions.to_f)*100).to_s+"$"
          @baidu_object["cost"] = @baidu_cost.to_f
          @baidu_avg_cpc = @baidu_cost.to_f / @baidu_clicks.to_f
          @baidu_object["avg_cpc"] = @baidu_avg_cpc.to_f
          
          if conversion_date_hash["typebaidu"]
            @conversion_baidu_count = conversion_date_hash["typebaidu"].to_i
          else
            @conversion_baidu_count = 0
          end
           
          @baidu_object["conversion"] = @conversion_baidu_count.to_i
          @baidu_object["conversion_rate"] = (@conversion_baidu_count.to_f / @baidu_clicks.to_f) * 100
          @baidu_object["cpa"] = @baidu_cost.to_f / @conversion_baidu_count.to_f
          @baidu_object["revenue"] = conversion_date_hash["revenuebaidu"].to_f
          @baidu_object["profit"] = 0
          
          if @baidu_avg_pos.to_f > 0
              @baidu_avg_pos = @baidu_avg_pos.to_f / @baidu_impressions.to_f
          end
          @baidu_object["avg_pos"] = @baidu_avg_pos.to_f
          
          
          # ________________________________________________________________________________________________________________
          
          
          @shenma_object["name"] = "shenma"
          @shenma_object["impressions"] = @shenma_impressions
          @shenma_object["clicks"] = @shenma_clicks.to_i
          @shenma_object["ctr"] = ((@shenma_clicks.to_f / @shenma_impressions.to_f)*100).to_s+"$"
          @shenma_object["cost"] = @shenma_cost.to_f
          @shenma_avg_cpc = @shenma_cost.to_f / @shenma_clicks.to_f
          @shenma_object["avg_cpc"] = @shenma_avg_cpc.to_f
          
          if conversion_date_hash["typeshenma"]
            @conversion_shenma_count = conversion_date_hash["typeshenma"].to_i
          else
            @conversion_shenma_count = 0
          end
           
          @shenma_object["conversion"] = @conversion_shenma_count.to_i
          @shenma_object["conversion_rate"] = (@conversion_shenma_count.to_f / @shenma_clicks.to_f) * 100
          @shenma_object["cpa"] = @shenma_cost.to_f / @conversion_shenma_count.to_f
          @shenma_object["revenue"] = conversion_date_hash["revenueshenma"].to_f
          @shenma_object["profit"] = 0
          
          if @shenma_avg_pos.to_f > 0
              @shenma_avg_pos = @shenma_avg_pos.to_f / @shenma_impressions.to_f
          end
          @shenma_object["avg_pos"] = @shenma_avg_pos.to_f
          
          
          
          if @channel_array.include?("sogou")
              @channels << @sogou_object
          end
          if @channel_array.include?("360")
              @channels << @three_sixty_object
          end
          if @channel_array.include?("baidu")
              @channels << @baidu_object
          end
          if @channel_array.include?("shenma")
              @channels << @shenma_object
          end
          
      end
      
      data = {:request_date => @request_date, :channels => @channels, :accounts => @account, :status => "true"}
      return render :json => data, :status => :ok
  end
  
  
  
  
  
  
  def getdashboarddetail
      
      # @logger.info "Search Dash Board Detail" +@now.to_s
      # session[:user_network_id_array] = nil 
      
      @skip_data = params[:start]
      @length = params[:length]
      
      session[:length] = params[:length]
      
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      @channel_array = params[:channel_array]
      @account_id_array = params[:account_array]
      
      if @channel_array.nil?
          @channel_array = []
      end
      
       
      if @end_date.nil?
          request_start_date = @today - 1.days
          @end_date = request_start_date.strftime("%Y-%m-%d")
      else
          session[:end_date] = @end_date.to_date
          @end_date = @end_date.to_date + 1.days
          @end_date = @end_date.strftime("%Y-%m-%d")
      end
      
      if @start_date.nil?
          request_start_date = @today - 8.days
          @start_date = request_start_date.strftime("%Y-%m-%d")
      else
          session[:start_date] = @start_date.to_date
          @start_date = @start_date.to_date
          @start_date = @start_date.strftime("%Y-%m-%d")
      end
      
       
      
      
      day_range = (@end_date.to_date - @start_date.to_date).to_i
      # day_range = day_range.to_i - @skip_day.to_i 
      
      
      current_day = @today.strftime("%d")
      last_day = Date.today.end_of_month.strftime("%d")
      first_date_of_this_month = Date.today.at_beginning_of_month.strftime("%Y-%m-%d")
      
      
      @user_network_id_array = []
      @user_network_array = []
      
      if session[:user_network_id_array].nil?
        
          @user_network = @db[:network_user].find('user' => session[:user_id].to_i)
          @db.close()
          
          @total_network_array = []
          
          @user_network.each do |user_network_d|
              @user_network_id_array << user_network_d["network_id"]
          end
          
          
          # @total_network_array = @db[:network].find('id' => { "$in" => @user_network_id_array}, 'type' => { "$in" => @channel_array})
          # @db.close()
          
          
          
          @total_network_array = @db[:network].find({ "$and" => [ {:id => { "$in" => @user_network_id_array}},{:type => { "$in" => @channel_array}} ] })
          @db.close()
    
          if @total_network_array.count.to_i > 0
              @user_network_id_array = []
              
               @total_network_array.each do |total_network_array_d|
                  @user_network_id_array << total_network_array_d["id"]
               end
          end
          
          session[:user_network_id_array] = @user_network_id_array.join(",")
      else
        
          if @account_id_array.nil?
             
              @user_network_id_array = session[:user_network_id_array].split(",")
              @user_network_id_array = @user_network_id_array.map(&:to_i)
              
              
              # @total_network_array = @db[:network].find('id' => { "$in" => @user_network_id_array}, 'type' => { "$in" => @channel_array})
              # @db.close()
              
              
              
              @total_network_array = @db[:network].find({ "$and" => [ {:id => { "$in" => @user_network_id_array}},{:type => { "$in" => @channel_array}} ] })
              @db.close()
              
          else
            
              @account_id_array = @account_id_array.map(&:to_i)
              @user_network_id_array = @account_id_array
              
              
              # @total_network_array = @db[:network].find('id' => { "$in" => @account_id_array}, 'type' => { "$in" => @channel_array})
              # @db.close()
              
              
              @total_network_array = @db[:network].find({ "$and" => [ {:id => { "$in" => @account_id_array}},{:type => { "$in" => @channel_array}} ] })
              @db.close()
              
              session[:user_network_id_array] = @user_network_id_array.join(",")
          end
        
      end
      
      @request_date = []
      @request_date_array = []
      
      (1..day_range).each do |i|
          request_date = @end_date.to_date - i.to_i.days
          request_date = request_date.strftime("%Y-%m-%d")
          
          @request_date_array << request_date
      end
      
     
      
      request_date_hash = {}
      
      
      
      @shenma_report_account = @db3[:shenma_report_account].find({ "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:display => { "$gt" => 0}},{:report_date => { "$in" => @request_date_array}} ] })
      @db3.close()
      
      if @shenma_report_account.count.to_i > 0 && @channel_array.include?("shenma")
          @shenma_report_account.each do |account|
              if request_date_hash["date"+account['report_date'].to_s+"display"]
                  request_date_hash["date"+account['report_date'].to_s+"display"] += account['display'].to_i
              else
                  request_date_hash["date"+account['report_date'].to_s+"display"] = account['display'].to_i
              end
          
              if request_date_hash["date"+account['report_date'].to_s+"clicks"]
                  request_date_hash["date"+account['report_date'].to_s+"clicks"] += account['clicks'].to_i
              else
                  request_date_hash["date"+account['report_date'].to_s+"clicks"] = account['clicks'].to_i
              end
              
              if request_date_hash["date"+account['report_date'].to_s+"total_cost"]
                  request_date_hash["date"+account['report_date'].to_s+"total_cost"] += account['total_cost'].to_f
              else
                  request_date_hash["date"+account['report_date'].to_s+"total_cost"] = account['total_cost'].to_f
              end
              
              
              if request_date_hash["date"+account['report_date'].to_s+"avg_position"]
                                          
                  if account['display'].to_f > 0 && account['avg_position'].to_f > 0
                      avg_pos = account["avg_position"].to_f * account["display"].to_f
                      request_date_hash["date"+account['report_date'].to_s+"avg_position"] += avg_pos.to_f
                  end
                  
              else
                  request_date_hash["date"+account['report_date'].to_s+"avg_position"] = account["avg_position"].to_f * account["display"].to_f
              end
          end
      end
      
      
      
      
      
      # @baidu_report_account = @db3[:baidu_report_account].find('network_id' => { "$in" => @user_network_id_array}, 'report_date' => { "$in" => @request_date_array}, 'display' => { "$gt" => 0})
      # @db3.close()
      
      
      
      @baidu_report_account = @db3[:baidu_report_account].find({ "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:display => { "$gt" => 0}},{:report_date => { "$in" => @request_date_array}} ] })
      @db3.close()
      
      if @baidu_report_account.count.to_i > 0 && @channel_array.include?("baidu")
          @baidu_report_account.each do |account|
              if request_date_hash["date"+account['report_date'].to_s+"display"]
                  request_date_hash["date"+account['report_date'].to_s+"display"] += account['display'].to_i
              else
                  request_date_hash["date"+account['report_date'].to_s+"display"] = account['display'].to_i
              end
          
              if request_date_hash["date"+account['report_date'].to_s+"clicks"]
                  request_date_hash["date"+account['report_date'].to_s+"clicks"] += account['clicks'].to_i
              else
                  request_date_hash["date"+account['report_date'].to_s+"clicks"] = account['clicks'].to_i
              end
              
              if request_date_hash["date"+account['report_date'].to_s+"total_cost"]
                  request_date_hash["date"+account['report_date'].to_s+"total_cost"] += account['total_cost'].to_f
              else
                  request_date_hash["date"+account['report_date'].to_s+"total_cost"] = account['total_cost'].to_f
              end
              
              
              if request_date_hash["date"+account['report_date'].to_s+"avg_position"]
                                          
                  if account['display'].to_f > 0 && account['avg_position'].to_f > 0
                      avg_pos = account["avg_position"].to_f * account["display"].to_f
                      request_date_hash["date"+account['report_date'].to_s+"avg_position"] += avg_pos.to_f
                  end
                  
              else
                  request_date_hash["date"+account['report_date'].to_s+"avg_position"] = account["avg_position"].to_f * account["display"].to_f
              end
          end
      end
      
      
      # @sogou_report_account = @db3[:sogou_report_account].find('network_id' => { "$in" => @user_network_id_array}, 'report_date' => { "$in" => @request_date_array}, 'display' => { "$gt" => 0})
      # @db3.close()
      
      @sogou_report_account = @db3[:sogou_report_account].find({ "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:display => { "$gt" => 0}},{:report_date => { "$in" => @request_date_array}} ] })
      @db3.close()
      
      if @sogou_report_account.count.to_i > 0 && @channel_array.include?("sogou")
          @sogou_report_account.each do |account|               
            
                if request_date_hash["date"+account['report_date'].to_s+"display"]
                    request_date_hash["date"+account['report_date'].to_s+"display"] += account['display'].to_i
                else
                    request_date_hash["date"+account['report_date'].to_s+"display"] = account['display'].to_i
                end
            
                if request_date_hash["date"+account['report_date'].to_s+"clicks"]
                    request_date_hash["date"+account['report_date'].to_s+"clicks"] += account['clicks'].to_i
                else
                    request_date_hash["date"+account['report_date'].to_s+"clicks"] = account['clicks'].to_i
                end
                
                if request_date_hash["date"+account['report_date'].to_s+"total_cost"]
                    request_date_hash["date"+account['report_date'].to_s+"total_cost"] += account['total_cost'].to_f
                else
                    request_date_hash["date"+account['report_date'].to_s+"total_cost"] = account['total_cost'].to_f
                end
                
                
                if request_date_hash["date"+account['report_date'].to_s+"avg_position"]
                                            
                    if account['display'].to_f > 0 && account['avg_position'].to_f > 0
                        avg_pos = account["avg_position"].to_f * account["display"].to_f
                        request_date_hash["date"+account['report_date'].to_s+"avg_position"] += avg_pos.to_f
                    end
                    
                else
                    request_date_hash["date"+account['report_date'].to_s+"avg_position"] = account["avg_position"].to_f * account["display"].to_f
                end
                         
          end
      end
      
      # @report_account_360 = @db3[:report_account_360].find('network_id' => { "$in" => @user_network_id_array}, 'report_date' => { "$in" => @request_date_array}, 'display' => { "$gt" => 0})
      
      
      @report_account_360 = @db3[:report_account_360].find({ "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:display => { "$gt" => 0}},{:report_date => { "$in" => @request_date_array}} ] })
      @db3.close()
      
      if @report_account_360.count.to_i > 0 && @channel_array.include?("360")
          @report_account_360.each do |account|
            
                if request_date_hash["date"+account['report_date'].to_s+"display"]
                    request_date_hash["date"+account['report_date'].to_s+"display"] += account['display'].to_i
                else
                    request_date_hash["date"+account['report_date'].to_s+"display"] = account['display'].to_i
                end
            
                if request_date_hash["date"+account['report_date'].to_s+"clicks"]
                    request_date_hash["date"+account['report_date'].to_s+"clicks"] += account['clicks'].to_i
                else
                    request_date_hash["date"+account['report_date'].to_s+"clicks"] = account['clicks'].to_i
                end
                
                if request_date_hash["date"+account['report_date'].to_s+"total_cost"]
                    request_date_hash["date"+account['report_date'].to_s+"total_cost"] += account['total_cost'].to_f
                else
                    request_date_hash["date"+account['report_date'].to_s+"total_cost"] = account['total_cost'].to_f
                end
                
                
                if request_date_hash["date"+account['report_date'].to_s+"avg_position"]
                                            
                    if account['display'].to_f > 0 && account['avg_position'].to_f > 0
                        avg_pos = account["avg_position"].to_f * account["display"].to_f
                        request_date_hash["date"+account['report_date'].to_s+"avg_position"] += avg_pos.to_f
                    end
                    
                else
                    request_date_hash["date"+account['report_date'].to_s+"avg_position"] = account["avg_position"].to_f * account["display"].to_f
                end
          end
      end
      
      
      if !@total_network_array.nil? && @total_network_array.count.to_i > 0
        
          (1..day_range).each do |i|
        
              @request_date_object = {}
              
              @impressions = 0
              @clicks = 0
              @ctr = 0
              @cost = 0
              @avg_cpc = 0
              @avg_pos = 0
              
              request_date = @end_date.to_date - i.to_i.days
              request_date = request_date - @skip_day.to_i.days
              
              request_date = request_date.strftime("%Y-%m-%d")
                   
              if request_date_hash["date"+request_date.to_s+"display"]
                  @impressions = request_date_hash["date"+request_date.to_s+"display"]
              else
                  @impressions = 0
              end
              
              if request_date_hash["date"+request_date.to_s+"clicks"]
                  @clicks = request_date_hash["date"+request_date.to_s+"clicks"]
              else
                  @clicks = 0
              end
              
              if request_date_hash["date"+request_date.to_s+"total_cost"]
                  @cost = request_date_hash["date"+request_date.to_s+"total_cost"].to_f
              else
                  @cost = 0
              end
              
              if request_date_hash["date"+request_date.to_s+"avg_position"]
                  @avg_pos = request_date_hash["date"+request_date.to_s+"avg_position"]
              else
                  @avg_pos = 0
              end
             
              
              # @request_date_object["date"] = request_date
              # @request_date_object["impressions"] = @impressions
              # @request_date_object["clicks"] = @clicks.to_i
              
              @ctr = (@clicks.to_f/@impressions.to_f)*100
              # @request_date_object["ctr"] = @ctr.to_f
              # @request_date_object["cost"] = @cost.to_i
              @avg_cpc = @cost.to_f / @clicks.to_f
              # @request_date_object["avg_cpc"] = @avg_cpc.to_f
              
              
              # @conversion_date = @db2[:conversion].find('company_id' => @user_company_id, 'date' => { '$gt' => request_date.to_s })
              conversion_request_start_date = request_date.to_s+" 00:00:00 CST"
              conversion_request_end_date = request_date.to_s+" 23:59:59 CST"
              
              
              @conversion_date = @db2[:conversion].find.aggregate([ 
                                                             { '$match' => { "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:company_id => @user_company_id.to_i}, {:date => { '$gte' => conversion_request_start_date.to_s }}, {:date => { '$lte' => conversion_request_end_date.to_s }}] } },
                                                             { '$group' => { '_id' => '$order_id' } }
                                                          ])
              @db2.close()

              
              
              
              # @conversion_date = @db2[:conversion].find({ "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:company_id => @user_company_id.to_i},{:date => { "$gte" => conversion_request_start_date.to_s}},{:date => { "$lte" => conversion_request_end_date.to_s}} ] } )
              # @db2.close()
              
              
              # @request_date_object["conversion"] = @conversion_date.count.to_i
              
              @conv_rate = (@conversion_date.count.to_f / @clicks.to_f) * 100
              # @request_date_object["conversion_rate"] = @conv_rate.to_f
              
              @cpa = @cost.to_f / @conversion_date.count.to_f
              # @request_date_object["cpa"] = @cpa
               
              
               
               
               
               
               
               
               
              # @all_conversion = @db2[:conversion].find.aggregate([ 
                                                           # { '$match' => { "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:company_id => @user_company_id.to_i},{:date => { "$gt" => conversion_request_start_date.to_s}},{:date => { "$lt" => conversion_request_end_date.to_s}} ] } },
                                                           # { '$group' => { '_id' => '$company_id', 'revenue' => { '$sum' => "$revenue" } } }
                                                        # ])
              # @db2.close()
              
              
              
              @all_conversion = @db2[:conversion].find.aggregate([ 
                                                           { '$match' => { "$and" => [ {:network_id => { "$in" => @user_network_id_array}},{:company_id => @user_company_id.to_i},{:date => { '$gt' => conversion_request_start_date.to_s }}, {:date => { '$lt' => conversion_request_end_date.to_s }}] } },
                                                           { '$group' => { '_id' => { 'commpany' => '$company_id',  'order_id' => '$order_id'}, 
                                                                           'count' => { '$sum' => 1 }, 'revenue' => { '$sum' => "$revenue" } } }
                                                        ])
              @db2.close()
              
              
              tmp_c = 0
              tmp_r = 0
              
              if @all_conversion.count.to_i > 0
                  @all_conversion.each do |all_conversion_arr|
                      tmp_c = tmp_c.to_i + 1
                      tmp_r = tmp_r.to_f + (all_conversion_arr['revenue'].to_f / all_conversion_arr['count'].to_f)
                  end
              end
              
             
               
              # @request_date_object["revenue"] = @all_conversion.first['revenue'].to_f
              # @request_date_object["profit"] = 0
              
              if @avg_pos.to_f > 0
                  @avg_pos = @avg_pos.to_f / @impressions.to_f
              end
              # @request_date_object["avg_pos"] = @avg_pos.to_f
              
              # @request_date << @request_date_object
              
              temp_array = [request_date, @impressions, @clicks, @ctr, @cost.to_f, @avg_cpc, @conversion_date.count.to_i, @conv_rate.to_f, @cpa.to_f ,tmp_r.to_f, 0, @avg_pos.to_f]
              @request_date << temp_array
          end
          
      end
      
      
      data = { :recordsTotal => @request_date.count.to_i, :recordsFiltered => @request_date.count.to_i, :data => @request_date.drop(@skip_data.to_i).first(@length.to_i)}
      return render :json => data, :status => :ok
      
  end
  
    

  # POST /homes
  # POST /homes.json
  def create
    @home = Home.new(home_params)

    respond_to do |format|
      if @home.save
        format.html { redirect_to @home, notice: 'Home was successfully created.' }
        format.json { render :show, status: :created, location: @home }
      else
        format.html { render :new }
        format.json { render json: @home.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /homes/1
  # PATCH/PUT /homes/1.json
  def update
    respond_to do |format|
      if @home.update(home_params)
        format.html { redirect_to @home, notice: 'Home was successfully updated.' }
        format.json { render :show, status: :ok, location: @home }
      else
        format.html { render :edit }
        format.json { render json: @home.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /homes/1
  # DELETE /homes/1.json
  def destroy
    @home.destroy
    respond_to do |format|
      format.html { redirect_to homes_url, notice: 'Home was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    
    # def saltkey
      # @password_salt = BCrypt::Engine.generate_salt      
    # end
    
    
    
    def set_home
      @home = Home.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def home_params
      params[:home]
    end
end
