require 'spec_helper'

module AnsibleQA
  module Checks
    context 'When ackrc is identical' do
      describe Ackrc do
        let(:ackrc) do
          AnsibleQA::Base.root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          AnsibleQA::Base.tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          Ackrc.new
        end

        it 'responds to check' do
          expect(ackrc.respond_to?('check')).to eq(true)
        end

        it 'runs check and does not raise_error' do
          expect { ackrc.check }.not_to raise_error
        end

      end
    end

    context 'When ackrc is not identical' do
      describe Ackrc do
        let(:ackrc) do
          AnsibleQA::Base.root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          AnsibleQA::Base.tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-invalid'))
          Ackrc.new
        end

        it 'runs check and raise error' do
          expect { ackrc.check }.not_to raise_error
        end

        it 'warns' do
          expect(ackrc).to receive(:warn).with(/File, .* is not identical/)
          ackrc.check
        end

      end
    end
  end
end