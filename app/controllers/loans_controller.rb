class LoansController < ApplicationController
  before_filter :set_loan, :only => [ :show ]

  def index
    render json: Loan.all
  end

  def show
    render json: @loan
  end

  private

  # Removed deprecated Loan.find call
  def set_loan
    @loan = Loan.where(id: params[:id]).first
    render json: 'not_found', status: :not_found if (@loan.nil?)
  end
end
