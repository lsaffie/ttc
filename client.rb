#!/usr/bin/env /Users/lsaffie/.rbenv/bin/ruby-local-exec

require 'httparty'
require 'json'

HTTP_SUCCESS = "200"

class Client
  include HTTParty
  #base_uri 'timetracker.saffie.ca'
  base_uri 'localhost:3000'
  basic_auth 'luis@saffie.ca', 'firetruck'
  #url = "http://timetracker.saffie.ca"
  url = "http://localhost:3000"

  def get_url(url)
    response = Client.get(url)
    JSON.parse(response.body)
  end

  def post_url(url, data)
    Client.post(url, :body => data)
  end
end

def create_task(task_name)
  @client = Client.new
  response = @client.post_url('/customers/2/tasks', {:task => {:name => task_name}, :start => Time.now})
  if response.response.code == HTTP_SUCCESS
    puts "#{task_name} created successfully"
  else
    puts "error creating #{task_name}"
  end
end

def complete_all
  @client = Client.new
  @client.get_url('/customers/2/tasks/complete_all')
  ""
end

def status
  require 'time'
  @client = Client.new
  tasks = @client.get_url('/customers/2/tasks.json')
  current = tasks.first["task"]
  require 'ruby-debug'
  total = (Time.now - Time.parse(current["created_at"]))/60
  puts <<-EOS
    name: #{current["name"]}
    created_at: #{current["created_at"]}
    total: #{total.round} mins
  EOS
end

def stop_task
  @client = Client.new
  tasks = @client.get_url('/customers/2/tasks.json')
  current = tasks.first["task"]

  Client.get("/customers/2/tasks/#{current["id"]}/stop")
end

command = ARGV[0]
task    = ARGV[1]

case command
when "start"
  create_task(task)
when "stop"
  stop_task
when "complete_all"
  complete_all
when "status"
  status
else
  puts "Usage: tt <start|stop|current|complete_all> <task_name>"
end
