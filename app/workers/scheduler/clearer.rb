class Scheduler::Clearer < Scheduler::Base
  recurrence { daily }

  def perform
    Redis::List.new('sampler_visited').clear
    Redis::List.new('spider_visited').clear
    Redis::List.new('spider_one_visited').clear
    Redis::List.new('spider_two_visited').clear
    Redis::List.new('spider_three_visited').clear
    Redis::List.new('spider_four_visited').clear
    Redis::List.new('spider_five_visited').clear
  end
end
