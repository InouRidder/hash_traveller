require 'pry'

class Hash
  class Traveller
    attr_reader :result
    attr_reader :query

    def initialize(attributes)
      @query = attributes[:query].to_sym
      @found = false
    end

    def result=(found_object)
      @result = found_object
      found!
    end

    def found!
      @found = true
    end

    def found?
      @found
    end

    def travel(hash)
      hash.each do |key, value|
        break if found?
        if value.is_a? Hash
          travel(value)
        end
        self.result = value if key.to_sym == query
      end
      result
    end
  end

  def find_value_for(query)
    Traveller.new(query: query).travel(self)
  end
end

RSpec.describe Hash do
  describe 'find_value_for' do

    it 'should return nil if key is not found' do
      test_hash = {
        zone: {
          before: 'cool'
        },
        second_zone: {
          cool_beans: 'beans!!',
          nested_third_zone: {
            dont_find: 'return me!'
          }
        }
      }

      expect(test_hash.find_value_for(:find_me)).to eq(nil)
    end

    it 'should return the value of the key at first level' do
      test_hash = {
        find_me: 'return me!'
      }

      expect(test_hash.find_value_for(:find_me)).to eq('return me!')
    end

    it 'should return the value of the key at any nested level' do
      test_hash = {
        zone: {
          before: 'cool',
          another: {
            value: 'key'
          }
        },
        second_zone: {
          cool_beans: 'beans!!',
          nested_third_zone: {
            find_me: 'return me!'
          }
        }
      }

      expect(test_hash.find_value_for(:find_me)).to eq('return me!')
    end
  end
end
