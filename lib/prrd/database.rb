# File: database.rb
# Time-stamp: <2014-09-24 11:48:45 pierre>
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
      File.exist? @path
    end

    # Check database existence
    def check_file
      fail 'Database path is missing' if  @path.nil? || !exists?
    end

    # Add a datasource object
    # @param datasource [PRRD::Database::Datasource]
    def add_datasource(datasource)
      @datasources << datasource
    end

    # Add an archive object
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

      fail 'Datasources are missing' if @datasources.empty?
      @datasources.map { |e| cmd << e.to_s }

      fail 'Archives are missing' if @archives.empty?
      @archives.map { |e| cmd << e.to_s }

      # Execute
      cmd = cmd.join ' '
      puts cmd.gsub(' ', "\n\t") if PRRD.debug_mode
      `#{cmd}`

      'Database created successfully' if $CHILD_STATUS.nil?
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
      puts cmd.gsub(' ', "\n\t") if PRRD.debug_mode
      `#{cmd}`
      'Database updated successfully' if $CHILD_STATUS.nil?
    end
  end
end
