class Scheduler::Reindexer < Scheduler::Base
  recurrence { daily }

  def perform
    containers = Rails.configuration.config[:admin][:api_containers]
    if containers.any?
      containers.each {|c| Syncer::Reindexer.perform_async c }
    end
  end
end
