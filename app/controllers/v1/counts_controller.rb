class V1::CountsController < V1::AccessController

  def count
    render json: { params[:container] + '-count' => Counts.instance.visible_counts(params[:container]) }.to_json
  end

  def mapping
    render json: { mapping: Sidekiq::Queue.new('mapper').size }.to_json
  end

  def processing
    render json: { processing: Sidekiq::Queue.new('scrimper').size }.to_json
  end

  def pending
    render json: { pending: Sidekiq::Queue.new('sitemapper').size * 50_000 }.to_json
  end

end
