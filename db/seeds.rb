# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
CreateCouponcodesService.new.call
puts 'CREATED PROMOTIONAL CODES'
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email
video1 = Video.find_or_create_by!(level: 'advanced', wistia: 'ypjjllo02h')
video2 = Video.find_or_create_by!(level: 'free', wistia: 'lykvsxec8j')
video3 = Video.find_or_create_by!(level: 'beginner', wistia: 'zhrplosxxw')
video4 = Video.find_or_create_by!(level: 'beginner', wistia: '9q4w7nvzai')
video5 = Video.find_or_create_by!(level: 'free', wistia: 'cavh41izma')
