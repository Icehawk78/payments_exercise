class Loan < ActiveRecord::Base
  has_many :payments

  # Current Balance = Funded Amount - SUM(Payments)
  def balance
    self.payments.map(&:amount).reduce(self.funded_amount, :-)
  end

  def as_json(options={})
    # Uncomment if you want to expose payments on the index/show endpoints for loans
    # super(include: [:payments], methods: :balance)
    super(methods: :balance)
  end
end
