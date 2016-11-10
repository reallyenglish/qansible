require "spec_helper"

class AnsibleQA
  class Check
    describe KitchenLocalYml do

      context "When .kitchen.yml is identical" do

        let(:instance) do
          AnsibleQA::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          AnsibleQA::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          KitchenLocalYml.new
        end

        describe ".check" do
          it "does not raise error" do
            expect { instance.check }.not_to raise_error
          end
        end
        describe ".check" do
          it "does not warn" do
            expect(instance).not_to receive(:warn)
          end
        end
      end
    end
  end
end