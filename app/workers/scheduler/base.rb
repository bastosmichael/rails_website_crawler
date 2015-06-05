class Scheduler::Base < Worker
  include Sidetiq::Schedulable
end
