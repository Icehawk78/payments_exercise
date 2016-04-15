class PaymentsController < ApplicationController
  before_action :set_loan

  def index
    render json: @loan.payments
  end

  def show
    @payment = Payment.where(id: params[:id]).first
    return render json: 'payment_not_found', status: :not_found if @payment.nil?
    # For some reason, the user is trying to access a payment from one loan but specifying a different loan.
    # This is a placeholder response for more rigorous authentication at a later point
    return render json: 'invalid_payment_for_loan', status: :bad_request if @payment.loan != @loan
    render json: @payment
  end

  def create
    @payment = @loan.payments.build(payment_params)

    return render json: 'missing_amount', status: :bad_request if @payment.amount.nil?
    return render json: 'negative_payment_amount', status: :bad_request if @payment.amount < 0.0
    return render json: 'payment_exceeds_budget', status: :bad_request if @loan.balance < 0.0
    @payment.save
    render json: @payment, status: :created
  end

  private

  def set_loan
    @loan = Loan.where(id: params[:loan_id]).first
    render json: 'loan_not_found', status: :not_found if (@loan.nil?)
  end

  # Ensure that a payment was passed, and strip everything but the date/amount
  def payment_params
    params.require(:payment).permit(:received, :amount)
  end
end
