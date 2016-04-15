require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let(:loan) { Loan.create!(funded_amount: 100.0)}
  describe 'payments#index' do
    it 'responds with 200' do
      get :index, {loan_id: loan.id}
      expect(response).to have_http_status(:ok)
    end

    context 'if the loan was not found' do
      it 'responds with a 404' do
        get :index, {loan_id: 20000}
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'payments#show' do
    let(:payment) { Payment.create!(received: Date.today, amount: 50.0, loan: loan)}
    it 'responds with 200' do
      get :show, {loan_id: loan.id, id: payment.id}
      expect(response).to have_http_status(:ok)
    end

    context 'if the loan was not found' do
      it 'responds with a 404' do
        get :show, {loan_id: 20000, id: 20000}
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'if the payment was not found' do
      it 'responds with a 404' do
        get :show, {loan_id: loan.id, id: 20000}
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'payments#create' do
    it 'responds with a 201' do
      put :create, {loan_id: loan.id, payment: {amount: 10.0, received: Date.today}}
      expect(response).to have_http_status(:created)
    end

    context 'if the payment was more than the balance' do
      it 'responds with a 400' do
        put :create, {loan_id: loan.id, payment: {amount: 1000.0, received: Date.today}}
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'if the payment was negative' do
      it 'responds with a 400' do
        put :create, {loan_id: loan.id, payment: {amount: -100000.0, received: Date.today}}
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

end
