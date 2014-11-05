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

  role :SourceAccount do
    def withdraw(amount)
      self.amount=self.amount-amount
      amount
    end
  end

  role :DestinationAccount do
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
      expect(subject.class).to eq bare_object.class
    end

    it "should be equal to wrapped object" do
      expect(subject).to eq bare_object
    end

    it "should respond_to additional methods" do
      expect(subject).to respond_to(:two_fields)
    end

    it "#two_fields should concatenate data objects two fields" do
      expect(subject.two_fields).to eq "#{bare_object.field_1} #{bare_object.field_2}"
    end

    it "#role_player should not respond_to additional methods" do
      expect(subject.role_player).to_not respond_to(:two_fields)
    end

    it "#in_role takes a block and returns the result" do
      two_fields = MyRole.played_by(bare_object) do |role|
        role.two_fields
      end
      expect(two_fields).to eq "#{bare_object.field_1} #{bare_object.field_2}"
    end

  end

  context "playing roles" do
    let(:role_class_1) do
      Class.new(RolePlaying::Role) do
        def role_1
        end
      end
    end
    let(:role_class_2) do
      Class.new(RolePlaying::Role) do
        def role_2
        end
      end
    end
    let(:player_class) do
      Class.new do
        def base
        end
      end
    end

    it "an array of roles can be applied using Array#played_by" do
      role = [role_class_1, role_class_2].played_by(player_class.new)
      expect(role).to respond_to(:role_1)
      expect(role).to respond_to(:role_2)
      expect(role).to respond_to(:base)
    end
  end

  context MoneyTransferring do

    role MoneyTransferring::SourceAccount do
      let(:original_amount) { 50 }
      let(:bare_account) {Account.new(original_amount)}
      subject { MoneyTransferring::SourceAccount.new(bare_account) }
      it "adds a withdraw method to data object" do
        expect(bare_account).to_not respond_to(:withdraw)
        expect(subject).to respond_to(:withdraw)
      end
      it "withdraws a specified amount" do
        subject.withdraw(10)
        expect(subject.amount).to eq original_amount-10
        expect(bare_account.amount).to eq original_amount-10
      end
    end

    role MoneyTransferring::DestinationAccount do
      let(:original_amount) { 50 }
      let(:bare_account) {Account.new(original_amount)}
      subject { MoneyTransferring::DestinationAccount.new(bare_account) }
      it "adds a deposit method to data object" do
        expect(bare_account).to_not respond_to(:deposit)
        expect(subject).to respond_to(:deposit)
      end
      it "deposits a specified amount" do
        subject.deposit(10)
        expect(subject.amount).to eq original_amount+10
        expect(bare_account.amount).to eq original_amount+10
      end
    end

    let(:original_source_account_amount) { 100 }
    let(:original_destination_account_amount) { 40 }
    let(:source_account) { Account.new(original_source_account_amount) }
    let(:destination_account) { Account.new(original_destination_account_amount) }
    let(:transfer_amount) { 50 }
    subject { MoneyTransferring.new(source_account, destination_account) }

    it "transfers a specified amount from a SourceAccount to a DestinationAccount" do
      expect(source_account.amount).to eq original_source_account_amount
      expect(destination_account.amount).to eq original_destination_account_amount
      subject.call(transfer_amount)
      expect(source_account.amount).to eq original_source_account_amount-transfer_amount
      expect(destination_account.amount).to eq original_destination_account_amount+transfer_amount
    end

  end
end