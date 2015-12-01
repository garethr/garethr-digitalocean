require 'puppet/coercion'

module PuppetX
  module Garethr
    module DigitalOcean
      module Property
        class Boolean < Puppet::Property
          def insync?(is)
            is.to_s == should.to_s
          end
          def unsafe_munge(value)
            Puppet::Coercion.boolean(value).to_s
          end
        end
      end
    end
  end
end
