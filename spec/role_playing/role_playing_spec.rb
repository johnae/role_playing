require 'spec_helper'

class DataObject
  attr_accessor :field_1
  attr_accessor :field_2
  def initialize(field1, field2)
    self.field_1=field1
    self.field_2=field2
  end
end

class Account
  attr_accessor :amount
  def initialize(amount)
    self.amount = amount
  end
end

class MyRole < RolePlaying::Role
  def two_fields
    "#{field_1} #{field_2}"
  end
end

## a context/use case
class MoneyTransferring
  include RolePlaying::Context

  def initialize(from_account, to_account)
    @from_account = from_account
    @to_account = to_account
  end
  def call(amount)
    SourceAccount(@from_account) do |source_account|
      DestinationAccount(@to_account).deposit(source_account.withdraw(amount))
    end
  end

  role SourceAccount do
    def withdraw(amount)
      self.amount=self.amount-amount
      amount
    end
  end

  role DestinationAccount do
    def deposit(amount)
      self.amount=self.amount+amount
    end
  end

end

describe RolePlaying do
  role MyRole do
    let(:field_1) { 'Data' }
    let(:field_2) { 'Object' }
    let(:bare_object) { DataObject.new(field_1, field_2) }
    subject { MyRole.new(bare_object) }

    it "should be of same class as wrapped object" do
      subject.class.should == bare_object.class
    end

    it "should be equal to wrapped object" do
      subject.should == bare_object
    end

    it "should respond_to additional methods" do
      subject.should respond_to(:two_fields)
    end

    it "#two_fields should concatenate data objects two fields" do
      subject.two_fields.should == "#{bare_object.field_1} #{bare_object.field_2}"
    end

    it "#role_player should not respond_to additional methods" do
      subject.role_player.should_not respond_to(:two_fields)
    end

    it "#in_role takes a block and returns the result" do
      two_fields = bare_object.in_role(MyRole) do |role|
        role.two_fields
      end
      two_fields.should == "#{bare_object.field_1} #{bare_object.field_2}"
    end

  end

  context MoneyTransferring do

    role MoneyTransferring::SourceAccount do
      let(:original_amount) { 50 }
      let(:bare_account) {Account.new(original_amount)}
      subject { MoneyTransferring::SourceAccount.new(bare_account) }
      it "adds a withdraw method to data object" do
        bare_account.should_not respond_to(:withdraw)
        subject.should respond_to(:withdraw)
      end
      it "withdraws a specified amount" do
        subject.withdraw(10)
        subject.amount.should == original_amount-10
        bare_account.amount.should == original_amount-10
      end
    end

    role MoneyTransferring::DestinationAccount do
      let(:original_amount) { 50 }
      let(:bare_account) {Account.new(original_amount)}
      subject { MoneyTransferring::DestinationAccount.new(bare_account) }
      it "adds a deposit method to data object" do
        bare_account.should_not respond_to(:deposit)
        subject.should respond_to(:deposit)
      end
      it "deposits a specified amount" do
        subject.deposit(10)
        subject.amount.should == original_amount+10
        bare_account.amount.should == original_amount+10
      end
    end

    let(:original_source_account_amount) { 100 }
    let(:original_destination_account_amount) { 40 }
    let(:source_account) { Account.new(original_source_account_amount) }
    let(:destination_account) { Account.new(original_destination_account_amount) }
    let(:transfer_amount) { 50 }
    subject { MoneyTransferring.new(source_account, destination_account) }

    it "transfers a specified amount from a SourceAccount to a DestinationAccount" do
      source_account.amount.should == original_source_account_amount
      destination_account.amount.should == original_destination_account_amount
      subject.call(transfer_amount)
      source_account.amount.should == original_source_account_amount-transfer_amount
      destination_account.amount.should == original_destination_account_amount+transfer_amount
    end

  end
end