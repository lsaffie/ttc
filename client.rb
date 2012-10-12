#!/usr/bin/env /Users/lsaffie/.rbenv/bin/ruby-local-exec

require 'httparty'
require 'json'

HTTP_SUCCESS = "200"

class Client
  include HTTParty
  base_uri 'timetracker.saffie.ca'
  basic_auth 'luis@saffie.ca', 'firetruck'
  url = "http://timetracker.saffie.ca"

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

def stop_task
  @client = Client.new
  tasks = @client.get_url('/customers/2/tasks.json')
  current = tasks.first["task"]

  #get last subtask
  subtasks = @client.get_url("/customers/2/tasks/#{current["id"]}/sub_times.json")
  current_subtask = subtasks.first["sub_time"]

  #stop last subtask
  Client.get("/customers/2/tasks/#{current["id"]}/sub_times/#{current_subtask["id"]}/stop")
end

command = ARGV[0]
task    = ARGV[1]


case command
when "start"
  create_task(task)
when "stop"
  stop_task
else
  puts "Usage: tt <add|stop> <task_name>"
end
