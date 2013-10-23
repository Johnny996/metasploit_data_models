require 'spec_helper'

describe Mdm::Authority do
  it_should_behave_like 'Metasploit::Model::Authority',
                        namespace_name: 'Mdm' do
    def seed_with_abbreviation(abbreviation)
      described_class.where(:abbreviation => abbreviation).first
    end
  end

  context 'associations' do
    it { should have_many(:module_instances).class_name('Mdm::Module::Instance').through(:module_references) }
    it { should have_many(:module_references).class_name('Mdm::Module::Reference').through(:references) }
    it { should have_many(:references).class_name('Mdm::Reference').dependent(:destroy) }
    it { should have_many(:vulns).class_name('Mdm::Vuln').through(:vuln_references) }
    it { should have_many(:vuln_references).class_name('Mdm::VulnReference').through(:references) }
  end

  context 'databases' do
    context 'columns' do
      it { should have_db_column(:abbreviation).of_type(:string).with_options(:null => false) }
      it { should have_db_column(:obsolete).of_type(:boolean).with_options(:default => false, :null => false)}
      it { should have_db_column(:summary).of_type(:string).with_options(:null => true) }
      it { should have_db_column(:url).of_type(:text).with_options(:null => true) }
    end

    context 'indices' do
      it { should have_db_index(:abbreviation).unique(true) }
      it { should have_db_index(:summary).unique(true) }
      it { should have_db_index(:url).unique(true) }
    end
  end

  context 'validations' do
    it { should validate_uniqueness_of(:abbreviation) }
  end
end