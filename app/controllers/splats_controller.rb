class SplatsController < ApplicationController
  before_action :set_splat, only: [ :show, :edit, :update ]

  def index
    @splats = Splat.all
  end

  def new
    @splat = Splat.new
  end

  def edit
  end

  def update
    @splat.update(splat_params)

    redirect_to splat_path(@splat)
  end

  def create
    Splat.create! splat_params

    redirect_to splats_path
  end

  def show
  end

  private
    def splat_params
      params.require(:splat).permit(:title, :body, :color)
    end

    def set_splat
      @splat = Splat.find(params[:id])
    end
end
