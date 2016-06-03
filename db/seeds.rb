# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email
CreateCouponcodesService.new.call
puts 'CREATED PROMOTIONAL CODES'
video1 = Video.find_or_create_by!(title: 'Find Rubygems', level: 'beginner', description: 'Learn to find and evaluate Rubygems.', wistia: 'pc2jpdwzob')
video2 = Video.find_or_create_by!(title: 'What Are Rubygems?', level: 'free',  description: 'Learn how to add features in your website using Rubygems.', wistia: '5ixtput3r7')
video3 = Video.find_or_create_by!(title: 'XCode Command Line Tools', level: 'advanced',  description: 'Installing XCode Command Line Tools.', wistia: '5ixtput3r7')
