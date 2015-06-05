class Scheduler::Reindexer < Scheduler::Base
  recurrence { weekly }

  def perform
    containers = Rails.configuration.config[:admin][:api_containers]
    if containers.any?
      containers.each {|c| Syncer::Reindexer.perform_async c }
    end
  end
end
