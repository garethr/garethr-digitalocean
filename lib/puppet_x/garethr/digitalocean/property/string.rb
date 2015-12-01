module PuppetX
  module Garethr
    module DigitalOcean
      module Property
        class String < Puppet::Property
          validate do |value|
            fail 'Should not contains spaces' if value =~ /\s/
            fail 'Empty values are not allowed' if value == ''
          end
        end
      end
    end
  end
end
