require_relative '../../spec_helper'
require_lib 'reek/context/module_context'
require_lib 'reek/context/root_context'

RSpec.describe Reek::Context::ModuleContext do
  it 'should report module name for smell in method' do
    expect('
      module Fred
        def simple(x) x + 1; end
      end
    ').to reek_of(:UncommunicativeParameterName, name: 'x')
  end

  it 'should not report module with empty class' do
    expect('
      # module for test
      module Fred
        # module for test
        class Jim; end; end').not_to reek
  end

  it 'should recognise global constant' do
    expect('
      # module for test
      module ::Global
        # module for test
        class Inside; end; end').not_to reek
  end

  describe '#track_visibility' do
    let(:context) { Reek::Context::ModuleContext.new(nil, double('exp1')) }
    let(:first_child) { Reek::Context::MethodContext.new(context, double('exp2', type: :def, name: :foo)) }
    let(:second_child) { Reek::Context::MethodContext.new(context, double('exp3', type: :def)) }

    it 'sets visibility on subsequent child contexts' do
      context.append_child_context first_child
      context.track_visibility :private, []
      context.append_child_context second_child
      expect(first_child.visibility).to eq :public
      expect(second_child.visibility).to eq :private
    end

    it 'sets visibility on specifically mentioned child contexts' do
      context.append_child_context first_child
      context.track_visibility :private, [first_child.name]
      context.append_child_context second_child
      expect(first_child.visibility).to eq :private
      expect(second_child.visibility).to eq :public
    end
  end
end
