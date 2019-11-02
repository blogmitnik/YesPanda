require 'csv'
require 'fileutils'

desc "This task is called for importing CSV files into YesPanda database"
task :import_jhx_pvte, [:filename] => :environment do
	prefer_stages = ["JHC-PVTe", "JHD-PVTe", "JHE-PVTe", "JHF-PVTe"]
	prefer_stages.each do |prefer_stage|
		puts "Fetching CSV files from target folder..."
		imported_files = []
		imported_main_files = []
		imported_mini_files = []
	    duplicated_files = []
	    filtered_files = []
		filtered_csvs_from_base_and_latest_hour = []
	    no_row_files = []
	    filtered_csvs = []
	    check_filename_datetime = []
	    generate_dummy_xml = false
	    generate_dummy_main_xml = false
	    generate_dummy_min_xml = false
	    mounted_folder = '/Users/david/desktop/CSV_to_import/' + prefer_stage.split('-')[0]
	    # Define the folder of CSV files
		d = Dir.new(mounted_folder)
		#Dir.chdir(d)
		# This will recursively find all csv files in a given directory
		#csvs = d.entries.select {|csv| /^.+\.csv$/.match(csv)}
		#csvs = Dir[ File.join(d, '**', '*.csv') ].reject { |p| File.directory? p }
		prefered_date_hour = DateTime.parse(Time.now.to_s).strftime('%Y%m%d%H')
		prefered_filename = '*Sum-*' + prefered_date_hour.to_s + '*.csv'
		csvs = Dir[ File.join(d, '**', prefered_filename) ].reject { |p| File.directory? p }

		start_time = Time.now
		puts "Start auto importing process for " + prefer_stage + "at #{start_time}"

		#Only import today's CSV files
		date_today = DateTime.parse(Date.today.to_s).strftime('%Y%m%d')
		date_today_hour = DateTime.parse(Time.now.to_s).strftime('%H')
		date_yesterday = DateTime.parse((Date.today-1).to_s).strftime('%Y%m%d')
			
		csvs.select do |file|
			filename = File.basename(file).gsub('_', '-')
			file_date = filename[filename.index('20'), 8]
			file_hour = filename[filename.index('20')+8, 2]
			if filename.include? prefer_stage
				# If currnet hour is between 00~05, then keep CSV files of today(00am ~ 05am) and yesterday(06am ~ 23pm)
				if date_today_hour.to_i.between?(00, 05)
					if file_date.eql?(date_yesterday) && file_hour.to_i.between?(06, 23)
						filtered_csvs << file
					elsif file_date.eql?(date_today) && file_hour.to_i.between?(00, 05)
						filtered_csvs << file
					end
				# If currnet hour is between 06~23, then keep CSV files of today(06am ~ 23pm)
				elsif date_today_hour.to_i.between?(06, 23)
					if file_date.eql?(date_today) && file_hour.to_i.between?(06, 23)
						filtered_csvs << file
					end
				end
			end
		end

		# Get latest datetime stamp from csv filename lists
		filtered_csvs.select do |file|
			filename = File.basename(file).gsub('_', '-')
			file_datetime = filename[filename.index('20'), 12]
			check_filename_datetime << file_datetime
		end
		latest_datetime = check_filename_datetime.max

		filtered_csvs.select do |file|
			filename = File.basename(file).gsub('_', '-')
			if (filename.include? latest_datetime) || (filename.include? date_today + "0600")
				filtered_csvs_from_base_and_latest_hour << file
			end
		end

		filtered_csvs_from_base_and_latest_hour.select do |file|
			#filepath = File.absolute_path(file)
			filename = File.basename(file).gsub('_', '-')
			line_count = `wc -l "#{file}"`.strip.split(' ')[0].to_i - 1
	        # Check if csv file already existed (imported) in database
	        if YieldFile.exists?(file_name: filename)
	        	duplicated_files << file
	        	puts filename.to_s + ' duplicated!'
	        	next
	        # For now, we only accept importing 'Sum-All' and 'Sum-Config' files
	        elsif !filename.include? "Sum-"
	        	filtered_files << file
	        	next
	        # Do nothing when CSV files contain no row data
	        elsif line_count.equal? 0
	        	if (filename.include? "Sum-All") && (filename.include? latest_datetime)
	        		generate_dummy_xml = true
	        	elsif (filename.include? "Sum-Main") && (filename.include? latest_datetime)
	        		generate_dummy_main_xml = true
	        	elsif (filename.include? "Sum-Min") && (filename.include? latest_datetime)
	        		generate_dummy_min_xml = true
	        	end
	        	no_row_files << file
	        	next
	        else # Process the CSV files that we actually need
	        	trim_index1 = filename.index('20') + 12
	        	trim_index2 = filename.index('.csv')
	        	model_stage = filename[trim_index1, (trim_index2 - trim_index1)]

	        	if post = Post.find_by_title(model_stage)
	        		if (filename.include? "Sum-Main") && ((filename.include? latest_datetime) || (filename.include? date_today + "0600"))
		        		ReportMain.import_data(file, filename, post)
		        		# Check total imported row counts
		        		if file = YieldFile.find_by_file_name(filename)
		        			count = ReportMain.where(post_id: post, yield_file_id: file).count
		        			# Check if CSV row numbers equal to record numbers that imported to database
		        			if count.equal? file.total_row
				                imported_main_files << file
				                puts filename.to_s + ' successfully imported!'
				            else
				                # If row counts are not equal, rollback all the imported rows
				                file.destroy
				                puts 'Data lost while importing from ' + filename.to_s
				            end
				        end
			    	elsif (filename.include? "Sum-Min") && ((filename.include? latest_datetime) || (filename.include? date_today + "0600"))
		        		ReportMini.import_data(file, filename, post)
		        		# Check total imported row counts
		        		if file = YieldFile.find_by_file_name(filename)
		        			count = ReportMini.where(post_id: post, yield_file_id: file).count
		        			# Check if CSV row numbers equal to record numbers that imported to database
		        			if count.equal? file.total_row
				                imported_mini_files << file
				                puts filename.to_s + ' successfully imported!'
				            else
				                # If row counts are not equal, rollback all the imported rows
				                file.destroy
				                puts 'Data lost while importing from ' + filename.to_s
				            end
				        end
			    	elsif (filename.include? latest_datetime) || (filename.include? date_today + "0600") # For handling 'Sum-All' and 'Sum-Config' csv files
		        		Report.import_data(file, filename, post)
		        		# Check total imported row counts
		        		if file = YieldFile.find_by_file_name(filename)
		        			count = Report.where(post_id: post, yield_file_id: file).count
		        			# Check if CSV row numbers equal to record numbers that imported to database
		        			if count.equal? file.total_row
				                imported_files << file
				                puts filename.to_s + ' successfully imported!'
				            else
				                # If row counts are not equal, rollback all the imported rows
				                file.destroy
				                puts 'Data lost while importing from ' + filename.to_s
				            end
				        end
			    	end
			    else
			    	# Create Product and Post name, if it doesn't exist in database
		            product_name = model_stage[0, model_stage.index('-')]
		            unless product = Product.find_by_title(product_name)
		              product = Product.create(user_id: '1', title: product_name)
		            end
		            post = Post.create(user_id: '1', product_id: product.id, title: model_stage, published_at: Time.now)
		            # Then import yield records
		            if (filename.include? "Sum-Main") && ((filename.include? latest_datetime) || (filename.include? date_today + "0600"))
			            ReportMain.import_data(file, filename, post)
			            # Check total imported row counts
			            if file = YieldFile.find_by_file_name(filename)
			            	count = ReportMain.where(post_id: post, yield_file_id: file).count
			            	# Check if CSV row numbers equal to record numbers that imported to database
			            	if count.equal? file.total_row
			            		imported_files << file
			            		puts filename.to_s + ' successfully imported!'
			            	else
			            		# If row counts are not equal, rollback all the imported rows
			            		file.destroy
			            		puts 'Data lost while importing ' + filename.to_s
			            	end
			            end
			        elsif (filename.include? "Sum-Min") && ((filename.include? latest_datetime) || (filename.include? date_today + "0600"))
			            ReportMini.import_data(file, filename, post)
			            # Check total imported row counts
			            if file = YieldFile.find_by_file_name(filename)
			            	count = ReportMini.where(post_id: post, yield_file_id: file).count
			            	# Check if CSV row numbers equal to record numbers that imported to database
			            	if count.equal? file.total_row
			            		imported_files << file
			            		puts filename.to_s + ' successfully imported!'
			            	else
			            		# If row counts are not equal, rollback all the imported rows
			            		file.destroy
			            		puts 'Data lost while importing ' + filename.to_s
			            	end
			            end
			        elsif (filename.include? latest_datetime) || (filename.include? date_today + "0600") # For handling 'Sum-All' and 'Sum-Config' csv files
			            Report.import_data(file, filename, post)
			            # Check total imported row counts
			            if file = YieldFile.find_by_file_name(filename)
			            	count = Report.where(post_id: post, yield_file_id: file).count
			            	# Check if CSV row numbers equal to record numbers that imported to database
			            	if count.equal? file.total_row
			            		imported_files << file
			            		puts filename.to_s + ' successfully imported!'
			            	else
			            		# If row counts are not equal, rollback all the imported rows
			            		file.destroy
			            		puts 'Data lost while importing ' + filename.to_s
			            	end
			            end
			        end
	        	end
	        end
		end
		puts filtered_csvs.count.to_s + ' CSV files processed, ' + filtered_files.count.to_s + ' filtered, ' + duplicated_files.count.to_s + ' duplicated, ' + no_row_files.count.to_s + ' no row files, and ' + (imported_files.count + imported_main_files.count + imported_mini_files.count).to_s + ' files imported!'

	    
	    # Export XML files to specific local folder
	    if imported_files.count > 0
			Report.export_to_xml(prefer_stage)
		end
		if imported_main_files.count > 0
	    	ReportMain.export_to_xml(prefer_stage)
	    end
	    if imported_mini_files.count > 0
			ReportMini.export_to_xml(prefer_stage)
		end
		# Export blank XML files for no-row csv files
		if generate_dummy_xml
			Report.export_dummy_xml(prefer_stage, latest_datetime)
		end
		if generate_dummy_main_xml
			ReportMain.export_dummy_xml(prefer_stage, latest_datetime)
		end
		if generate_dummy_min_xml
			ReportMini.export_dummy_xml(prefer_stage, latest_datetime)
		end
		end_time = Time.now
		puts "Auto importing process for " + prefer_stage + " completed in #{(end_time - start_time)} seconds\n\n"
	end
end