require 'spec_helper'


module AnsibleQA
  module Checks
    describe Base do
        let(:base) do
          AnsibleQA::Base.tmp_root_dir('spec/unit/fixtures/ansible-role-latest')
          AnsibleQA::Base.root_dir('spec/unit/fixtures/ansible-role-latest')
          Base.new('foo')
        end

      describe "#new" do
        it 'returns an object' do
          expect(base.class).to eq(AnsibleQA::Checks::Base)
        end

        it 'has zero warning' do
          expect(base.number_of_warnings).to eq(0)
        end

        it 'returns path to the file' do
          expect(base.path).to eq('foo')
        end
      end

      describe '.colorize' do
        let(:base) { Base.new('foo') }
        it 'returns colorized text in red' do
          expect(base.colorize('foo', 'red', 'black')).to eq "\033[40;31mfoo\033[0m"
        end
      end

      describe '.warn' do
        it 'increments number_of_warnings' do
          base.warn('foo')
          base.warn('foo')
          expect(base.number_of_warnings).to eq(2)
        end
      end

      context 'when file does not exist' do
        describe '.should_exist' do
          it 'warns `should exist`' do
            expect(base).to receive(:warn).with(/File `.*` should exist but not found/)
            base.should_exist
          end
        end
        describe '.must_exist' do
          it 'raises FileNotFound' do
            expect { base.must_exist }.to raise_error(FileNotFound, /File `.*` must exist but not found/)
          end
        end
      end

      context 'when file is identical' do

        let(:base) do
          AnsibleQA::Base::tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          AnsibleQA::Base::root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          Base.new('.ackrc')
        end

        describe '.should_be_identical' do
          it 'does not raise error' do
            expect { base.should_be_identical }.not_to raise_error
          end
        end

        describe '.must_be_identical' do
          it 'does not raise error' do
            expect { base.must_be_identical }.not_to raise_error
          end
        end

      end

      context 'when file is not identical' do

        let(:base) do
          AnsibleQA::Base::tmp_root_dir(Pathname.new('spec/unit/fixtures/ansible-role-latest'))
          AnsibleQA::Base::root_dir(Pathname.new('spec/unit/fixtures/ansible-role-invalid'))
          Base.new('.ackrc')
        end

        describe '.should_be_identical' do
          it 'does not raise error' do
            expect { base.should_be_identical }.not_to raise_error
          end
        end

        describe '.must_be_identical' do
          it 'raises error' do
            expect { base.must_be_identical }.to raise_error(SystemExit)
          end
        end

      end

      context 'when file exists' do

        let(:base) do
          AnsibleQA::Base.tmp_root_dir('spec/unit/fixtures/ansible-role-latest/')
          AnsibleQA::Base.root_dir('spec/unit/fixtures/ansible-role-latest/')
          Base.new('.ackrc')
        end

        describe '.must_exist' do
          it 'does not raise FileNotFound' do
            expect { base.must_exist }.not_to raise_error
          end
        end

        describe '.should_exist' do
          it 'dose not warn' do
            expect(base).not_to receive(:warn)
            base.should_exist
          end
        end
      end

      context 'when non-existent YAML file is given' do

        describe '.must_be_yaml' do

          it 'raise FileNotFound' do
            expect { base.must_be_yaml }.to raise_error(Errno::ENOENT)
          end
        end
      end

      context "when a valid yaml file is given" do
        describe '.must_be_yaml' do
          let(:base) do
            AnsibleQA::Base.tmp_root_dir('spec/unit/fixtures/ansible-role-latest/')
            AnsibleQA::Base.root_dir('spec/unit/fixtures/ansible-role-latest/')
            Base.new('tasks/install-FreeBSD.yml')
          end

          it 'returns an Array' do
            expect(base.must_be_yaml.class).to eq(Array)
          end
        end
      end

      context "when an invalid yaml file is given" do
        describe '.must_be_yaml' do
          let(:base) do
            AnsibleQA::Base.tmp_root_dir('spec/unit/fixtures/ansible-role-latest/')
            AnsibleQA::Base.root_dir('spec/unit/fixtures/ansible-role-invalid/')
            Base.new('invalid.yml')
          end

          it 'raises Psych::SyntaxError' do
            expect { base.must_be_yaml }.to raise_error(Psych::SyntaxError)
          end
        end
      end

    end
  end
end