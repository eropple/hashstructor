require 'spec_helper'

describe Hashstructor do
  it 'should do nothing with a no-member class' do
    require_relative "./test_classes/empty_class.rb"
  end

  it 'should handle the creation of attr_readers and attr_accessors' do
    require_relative "./test_classes/attr_class.rb"

    ret = AttrClass.new({
      shaq: 10,
      chuck: 5,
      kenny: 3
    })

    expect(ret.respond_to?(:shaq)).to eq(false)
    expect(ret.respond_to?(:shaq=)).to eq(false)
    expect(ret.respond_to?(:chuck)).to eq(true)
    expect(ret.respond_to?(:chuck=)).to eq(false)
    expect(ret.respond_to?(:kenny)).to eq(true)
    expect(ret.respond_to?(:kenny=)).to eq(true)
  end

  it 'should handle required members' do
    require_relative "./test_classes/required_class.rb"

    expect {
      RequiredClass.new({
        chuck: 5
      })
    }.to raise_error(Hashstructor::HashstructorError, /required members.+shaq/)

    ret = RequiredClass.new({
      shaq: 5
    })

    expect(ret.shaq).to eq(5)
    expect(ret.chuck).to eq(nil)
    expect(ret.kenny).to eq(11)
    expect(ret.ernie).to eq(false)
  end

  it 'should do the right thing for missing, non-required members' do
    require_relative "./test_classes/unrequired_class.rb"

    ret = UnrequiredClass.new({})

    expect(ret.shaq).to eq(nil)

    expect(ret.chuck.class).to eq(Array)
    expect(ret.chuck.length).to eq(0)
    expect(ret.kenny.class).to eq(Set)
    expect(ret.kenny.length).to eq(0)
    expect(ret.ernie.class).to eq(Hash)
    expect(ret.kenny.length).to eq(0)
  end

  it 'should handle normals' do
    require_relative "./test_classes/simple_normals.rb"

    ret = SimpleNormals.new({
      shaq: 5,
      chuck: 0.5,
      ernie: :wibble,
      kenny: "wobble"
    })

    expect(ret.shaq).to eq(5)
    expect(ret.chuck).to eq(0.5)
    expect(ret.ernie).to eq("wibble")
    expect(ret.kenny).to eq(:wobble)
  end

  it 'should handle boolean normals' do
    require_relative "./test_classes/bool_class.rb"

    expect {
      BoolClass.new({
        shaq: "derps"
      })
    }.to raise_error(Hashstructor::HashstructorError, /unknown value when parsing boolean/)

    [ "true", "t", "on", "yes" ].each do |t_val|
      ret = BoolClass.new({
        shaq: t_val
      })

      expect(ret.shaq).to eq(true)
    end

    [ "false", "f", "off", "no" ].each do |f_val|
      ret = BoolClass.new({
        shaq: f_val
      })

      expect(ret.shaq).to eq(false)
    end
  end

  it 'should handle arrays and sets' do
    require_relative "./test_classes/array_class.rb"

    ret = ArrayClass.new({
      shaq: [1, 2, 3],
      chuck: [4, 5, 6]
    })

    expect(ret.shaq).to be_an(Array)
    expect(ret.shaq).to include(1, 2, 3)

    expect(ret.chuck).to be_a(Set)
    expect(ret.chuck).to include(4, 5, 6)
  end

  it 'should accept a class with hashes' do
    require_relative "./test_classes/hash_class.rb"

    ret = HashClass.new({
      shaq: {
        "a" => 1,
        "b" => 2,
        "c" => 3
      },
      chuck: {
        :d => 4,
        :e => 5,
        :f => 6
      }
    })

    expect(ret.shaq).to be_a(Hash)
    expect(ret.shaq[:a]).to eq(1)
    expect(ret.shaq[:b]).to eq(2)
    expect(ret.shaq[:c]).to eq(3)

    expect(ret.chuck).to be_a(Hash)
    expect(ret.chuck["d"]).to eq(4)
    expect(ret.chuck["e"]).to eq(5)
    expect(ret.chuck["f"]).to eq(6)
  end

  it 'should support nested hashstructor objects' do
    require_relative "./test_classes/nested_objects.rb"

    ret = TopObject.new({
      shaq: {
        ernie: 1
      },
      chuck: [
        { ernie: 1 },
        { ernie: 2 },
        { ernie: 3 }
      ],
      kenny: {
        a: { ernie: 4 },
        b: { ernie: 5 },
        c: { ernie: 6 }
      }
    })

    expect(ret.shaq).to be_a(NestedObject)
    expect(ret.shaq.ernie).to eq(1)

    expect(ret.chuck).to be_a(Array)
    expect(ret.chuck[1]).to be_a(NestedObject)
    expect(ret.chuck[1].ernie).to eq(2)

    expect(ret.kenny).to be_a(Hash)
    expect(ret.kenny[:a]).to be_a(NestedObject)
    expect(ret.kenny[:a].ernie).to eq(4)

  end

end
