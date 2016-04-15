@loan1 = Loan.create!(funded_amount: 100.0)
@loan2 = Loan.create!(funded_amount: 1000.0)
@payment1 = @loan1.payments.create(amount: 20.0, received: Date.today)