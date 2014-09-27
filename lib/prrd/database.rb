# File: database.rb
# Time-stamp: <2014-09-27 10:08:32 pierre>
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
    def initialize(values = nil)
      @datasources = []
      @archives = []
      @start = Time.now.to_i - 86_400
      @step = 300

      unless values.nil?
        values.each do |k, v|
          m = "#{k}=".to_sym
          next unless respond_to? m
          send m, v
        end
      end
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

    # Add datasource objects
    # @param datasource [Array]
    def add_datasources(datasources)
      @datasources = datasources
    end

    # Add an archive object
    # @param archive [PRRD::Database::Archive]
    def add_archive(archive)
      @archives << archive
    end

    # Add archive objects
    # @param archives [Array]
    def add_archives(archives)
      @archives = archives
    end

    # Add an object
    # @param object [Object]
    def <<(object)
      if object.is_a? PRRD::Database::Datasource
        add_datasource object
      elsif object.is_a? PRRD::Database::Archive
        add_archive object
      else
        fail 'Can not add this kind of object in PRRD::Database'
      end
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
