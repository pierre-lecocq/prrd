# File: comment.rb
# Time-stamp: <2014-10-01 20:32:12 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Comment class for PRRD

module PRRD
  class Graph
    # PRRD Comment Line class
    class Comment < PRRD::Entity
      # Constructor
      def initialize(values = nil)
        @keys = [
          :text
        ]

        super values
      end

      # Transform to a COMMENT formatted string
      def to_s
        fail 'Empty comment object' if @data.empty?

        validate_presence :text

        "COMMENT:\"%s\"" % @data[:text]
      end
    end
  end
end
