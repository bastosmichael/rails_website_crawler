# class Scheduler::Clearer < Scheduler::Base
#   recurrence { daily }

#   def perform
#     Redis::List.new('visited').clear
#   end
# end
