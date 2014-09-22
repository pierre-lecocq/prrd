# File: database.rb
# Time-stamp: <2014-09-22 18:01:02 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Database class for PRRD

module PRRD
  class Database

    attr_accessor :path
    attr_accessor :start, :step
    attr_accessor :datasources, :archives

    def initialize
      @datasources = []
      @archives = []
      @start = Time.now.to_i - 86_400
      @step = 300
    end

    def add_datasource(datasource)
      @datasources << datasource
    end

    def add_archive(archive)
      @archives << archive
    end

    def exists?
      File.exists? @path
    end

    def check_file
      fail 'Database is missing' if  @path.nil? || !exists?
    end

    def create
      File.write @path, ''

      cmd = []
      cmd << "#{PRRD.bin} create #{@path}"
      cmd << "--start #{@start} --step #{@step}"

      fail 'Need datasources' if @datasources.empty?
      @datasources.map { |e| cmd << e.to_s }

      fail 'Need archives' if @archives.empty?
      @archives.map { |e| cmd << e.to_s }

      p cmd.join ' '
    end

    def update(timestamp = nil, *values)
      check_file
      timestamp ||= Time.now.to_i

      cmd = "#{PRRD.bin} update #{@path} #{timestamp}:#{values.join ':'}"

      p cmd
    end
  end
end
