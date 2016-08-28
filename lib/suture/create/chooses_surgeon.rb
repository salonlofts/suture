require "suture/adapter/log"
require "suture/surgeon/observer"
require "suture/surgeon/auditor"
require "suture/surgeon/no_op"

module Suture
  class ChoosesSurgeon
    include Suture::Adapter::Log

    def choose(plan)
      if plan.record_calls
        if plan.new
          log_warn <<-MSG.gsub(/^ {12}/,'')
            Seam #{plan.name.inspect} has a :new code path defined, but because
            it is set to :record_calls, we will invoke the :old code path
            instead. If this is not what you intend, set :record_calls to false.
          MSG
        end
        Surgeon::Observer.new
      elsif plan.call_both
        Surgeon::Auditor.new
      else
        Surgeon::NoOp.new
      end
    end
  end
end
