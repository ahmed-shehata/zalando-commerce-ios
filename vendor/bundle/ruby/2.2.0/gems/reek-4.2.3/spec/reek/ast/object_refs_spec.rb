require_relative '../../spec_helper'
require_lib 'reek/ast/object_refs'

RSpec.describe Reek::AST::ObjectRefs do
  let(:refs) { Reek::AST::ObjectRefs.new }

  context 'when empty' do
    it 'should report no refs to self' do
      expect(refs.references_to(:self)).to be_empty
    end
  end

  context 'with references to a, b, and a' do
    context 'with no refs to self' do
      before(:each) do
        refs.record_reference(name: :a)
        refs.record_reference(name: :b)
        refs.record_reference(name: :a)
      end

      it 'should report no refs to self' do
        expect(refs.references_to(:self)).to be_empty
      end

      it 'should report :a as the max' do
        expect(refs.most_popular).to include(:a)
      end

      it 'should not report self as the max' do
        expect(refs.self_is_max?).to eq(false)
      end

      context 'with one reference to self' do
        before(:each) do
          refs.record_reference(name: :self)
        end

        it 'should report 1 ref to self' do
          expect(refs.references_to(:self).size).to eq(1)
        end

        it 'should not report self among the max' do
          expect(refs.most_popular).to include(:a)
          expect(refs.most_popular).not_to include(:self)
        end

        it 'should not report self as the max' do
          expect(refs.self_is_max?).to eq(false)
        end
      end
    end
  end

  context 'with many refs to self' do
    before(:each) do
      refs.record_reference(name: :self)
      refs.record_reference(name: :self)
      refs.record_reference(name: :a)
      refs.record_reference(name: :self)
      refs.record_reference(name: :b)
      refs.record_reference(name: :a)
      refs.record_reference(name: :self)
    end

    it 'should report all refs to self' do
      expect(refs.references_to(:self).size).to eq(4)
    end

    it 'should report self among the max' do
      expect(refs.most_popular).to include(:self)
    end

    it 'should report self as the max' do
      expect(refs.self_is_max?).to eq(true)
    end
  end

  context 'when self is not the only max' do
    before(:each) do
      refs.record_reference(name: :a)
      refs.record_reference(name: :self)
      refs.record_reference(name: :self)
      refs.record_reference(name: :b)
      refs.record_reference(name: :a)
    end

    it 'should report all refs to self' do
      expect(refs.references_to(:self).size).to eq(2)
    end

    it 'should report self among the max' do
      expect(refs.most_popular).to include(:a)
      expect(refs.most_popular).to include(:self)
    end

    it 'should report self as the max' do
      expect(refs.self_is_max?).to eq(true)
    end
  end

  context 'when self is not among the max' do
    before(:each) do
      refs.record_reference(name: :a)
      refs.record_reference(name: :b)
      refs.record_reference(name: :a)
      refs.record_reference(name: :b)
    end

    it 'should report all refs to self' do
      expect(refs.references_to(:self).size).to eq(0)
    end

    it 'should not report self among the max' do
      expect(refs.most_popular).to include(:a)
      expect(refs.most_popular).to include(:b)
    end

    it 'should not report self as the max' do
      expect(refs.self_is_max?).to eq(false)
    end
  end
end
