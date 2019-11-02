require 'csv'
require 'fileutils'

desc "This task is called for importing CSV files into YesPanda database"
task :clean_overdue_records_dvt, [:filename] => :environment do
	puts 'Start the process deleting overdue records at ' + Time.now.to_s
	start_time = Time.now

	file_model_stage_name = "JHC-DVT"
	post = Post.find_by_title(file_model_stage_name)
	if !post.nil?
		puts "Deleting " + file_model_stage_name + " overdue records..."
		Report.delete_overdue_records_beta(file_model_stage_name)
		ReportMain.delete_overdue_records_beta(file_model_stage_name)
		ReportMini.delete_overdue_records_beta(file_model_stage_name)
	end
	
	file_model_stage_name = "JHD-DVT"
	post = Post.find_by_title(file_model_stage_name)
	if !post.nil?
		puts "Deleting " + file_model_stage_name + " overdue records..."
		Report.delete_overdue_records_beta(file_model_stage_name)
		ReportMain.delete_overdue_records_beta(file_model_stage_name)
		ReportMini.delete_overdue_records_beta(file_model_stage_name)
	end
	
	file_model_stage_name = "JHE-DVT"
	post = Post.find_by_title(file_model_stage_name)
	if !post.nil?
		puts "Deleting " + file_model_stage_name + " overdue records..."
		Report.delete_overdue_records_beta(file_model_stage_name)
		ReportMain.delete_overdue_records_beta(file_model_stage_name)
		ReportMini.delete_overdue_records_beta(file_model_stage_name)
	end
	
	file_model_stage_name = "JHF-DVT"
	post = Post.find_by_title(file_model_stage_name)
	if !post.nil?
		puts "Deleting " + file_model_stage_name + " overdue records..."
		Report.delete_overdue_records_beta(file_model_stage_name)
		ReportMain.delete_overdue_records_beta(file_model_stage_name)
		ReportMini.delete_overdue_records_beta(file_model_stage_name)
	end
	
	puts 'All deleting process completed at ' + Time.now.to_s
    end_time = Time.now
    puts "Time elapsed #{(end_time - start_time)} seconds"
end