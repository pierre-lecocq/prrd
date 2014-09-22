#!/usr/bin/env ruby

# File: prrd_spec.rb
# Time-stamp: <2014-09-22 22:44:14 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: PRRD spec file

require_relative '../lib/prrd'
describe PRRD do
  describe 'VERSION' do
    it 'should return 0.2.0' do
      expect(PRRD::VERSION).to eql '0.2.0'
    end
  end
end
