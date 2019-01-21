class Api::V1::PlayerStatsController < ApplicationController
  include Pagination

  def index
    player_stats = PlayerStatQuery.new(params: clean_params).player_stats
                     .page(clean_params[:page] || 0)
                     .per(clean_params[:per_page] || DEFAULT_PAGE_SIZE)
                     .includes(:player, :game, :team)

    render json: {
      data: PlayerStatSerializer.render_as_hash(player_stats, view: :expanded)
    }.merge(pagination_data(player_stats))
  end

  private

  def clean_params
    @clean_params ||= params.permit(
      :player_ids,
      :game_ids,
      :seasons,
      :dates,
      :page,
      :per_page
    )
  end
end
