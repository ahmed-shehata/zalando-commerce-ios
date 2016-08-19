require_relative '../../spec_helper'
require_lib 'reek/smells/attribute'
require_relative 'smell_detector_shared'

RSpec.describe Reek::Smells::Attribute do
  let(:detector) { build(:smell_detector, smell_type: :Attribute) }

  it_should_behave_like 'SmellDetector'

  context 'with no attributes' do
    it 'records nothing' do
      src = <<-EOS
        class Klass
        end
      EOS
      expect(src).to_not reek_of(:Attribute)
    end
  end

  context 'with attributes' do
    it 'records nothing for attribute readers' do
      src = <<-EOS
        class Klass
          attr :my_attr
          attr_reader :my_attr2
        end
      EOS
      expect(src).to_not reek_of(:Attribute)
    end

    it 'records writer attribute' do
      src = <<-EOS
        class Klass
          attr_writer :my_attr
        end
      EOS
      expect(src).to reek_of(:Attribute, name: 'my_attr')
    end

    it 'does not record writer attribute if suppressed with a preceding code comment' do
      src = <<-EOS
        class Klass
          # :reek:Attribute
          attr_writer :my_attr
        end
      EOS
      expect(src).not_to reek_of(:Attribute)
    end

    it 'records attr_writer attribute in a module' do
      src = <<-EOS
        module Mod
          attr_writer :my_attr
        end
      EOS
      expect(src).to reek_of(:Attribute, name: 'my_attr')
    end

    it 'records accessor attribute' do
      src = <<-EOS
        class Klass
          attr_accessor :my_attr
        end
      EOS
      expect(src).to reek_of(:Attribute, name: 'my_attr')
    end

    it 'records attr defining a writer' do
      src = <<-EOS
        class Klass
          attr :my_attr, true
        end
      EOS
      expect(src).to reek_of(:Attribute, name: 'my_attr')
    end

    it "doesn't record protected attributes" do
      src = '
        class Klass
          protected
          attr_writer :attr1
          attr_accessor :attr2
          attr :attr3
          attr :attr4, true
          attr_reader :attr5
        end
      '
      expect(src).to_not reek_of(:Attribute)
    end

    it "doesn't record private attributes" do
      src = '
        class Klass
          private
          attr_writer :attr1
          attr_accessor :attr2
          attr :attr3
          attr :attr4, true
          attr_reader :attr5
        end
      '
      expect(src).to_not reek_of(:Attribute)
    end

    it 'records attr_writer defined in public section' do
      src = <<-EOS
        class Klass
          private
          public
          attr_writer :my_attr
        end
      EOS
      expect(src).to reek_of(:Attribute, name: 'my_attr')
    end

    it 'records attr_writer after switching visbility to public' do
      src = <<-EOS
        class Klass
          private
          attr_writer :my_attr
          public :my_attr
        end
      EOS
      expect(src).to reek_of(:Attribute, name: 'my_attr')
    end

    it 'resets visibility in new contexts' do
      src = '
        class Klass
          private
          attr_writer :attr1
        end

        class OtherKlass
          attr_writer :attr1
        end
      '
      expect(src).to reek_of(:Attribute)
    end

    it 'records attr_writer defining a class attribute' do
      src = <<-EOS
        class Klass
          class << self
            attr_writer :my_attr
          end
        end
      EOS
      expect(src).to reek_of(:Attribute, name: 'my_attr')
    end

    it 'does not record private class attributes' do
      src = <<-EOS
        class Klass
          class << self
            private
            attr_writer :my_attr
          end
        end
      EOS
      expect(src).not_to reek_of(:Attribute, name: 'my_attr')
    end

    it 'tracks visibility in metaclasses separately' do
      src = <<-EOS
        class Klass
          private
          class << self
            attr_writer :my_attr
          end
        end
      EOS
      expect(src).to reek_of(:Attribute, name: 'my_attr')
    end
  end
end
