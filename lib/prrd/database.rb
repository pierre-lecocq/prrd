# File: database.rb
# Time-stamp: <2014-09-22 20:50:47 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Database class for PRRD

module PRRD
  # PRRD Database class
  class Database
    # Accessors
    attr_accessor :path
    attr_accessor :start, :step
    attr_accessor :datasources, :archives

    # Constructor
    def initialize
      @datasources = []
      @archives = []
      @start = Time.now.to_i - 86_400
      @step = 300
    end

    # Does database file exist?
    def exists?
      File.exists? @path
    end

    # Check database existence
    def check_file
      fail 'Database path is missing' if  @path.nil? || !exists?
    end

    # Add a datasource
    # @param datasource [PRRD::Database::Datasource]
    def add_datasource(datasource)
      @datasources << datasource
    end

    # Add an archive
    # @param archive [PRRD::Database::Archive]
    def add_archive(archive)
      @archives << archive
    end

    # Create a database
    # @return [String]
    def create
      File.write @path, ''

      cmd = []
      cmd << "#{PRRD.bin} create #{@path}"
      cmd << "--start #{@start} --step #{@step}"

      fail 'Need datasources' if @datasources.empty?
      @datasources.map { |e| cmd << e.to_s }

      fail 'Need archives' if @archives.empty?
      @archives.map { |e| cmd << e.to_s }

      # Execute
      cmd = cmd.join ' '
      `#{cmd}`
      'Database created successfully' if $?.exitstatus == 0
    end

    # Update a database
    # @param timestamp [Integer]
    # @param values [Array]
    # @return [String]
    def update(timestamp = nil, *values)
      check_file
      timestamp ||= Time.now.to_i

      cmd = "#{PRRD.bin} update #{@path} #{timestamp}:#{values.join ':'}"

      # Execute
      `#{cmd}`
      'Database updated successfully' if $?.exitstatus == 0
    end
  end
end
