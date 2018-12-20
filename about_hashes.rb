require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutHashes < Neo::Koan
  def test_creating_hashes
    empty_hash = Hash.new
    assert_equal Hash, empty_hash.class
    assert_equal({}, empty_hash)
    assert_equal 0, empty_hash.size
  end

  def test_hash_literals
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.size
  end

  def test_accessing_hashes
    hash = { :one => "uno", :two => "dos" }
    assert_equal 'uno', hash[:one]
    assert_equal 'dos', hash[:two]
    assert_equal nil, hash[:doesnt_exist]
  end

  def test_accessing_hashes_with_fetch
    hash = { :one => "uno" }
    assert_equal 'uno', hash.fetch(:one)
    assert_raise(KeyError) do
      hash.fetch(:doesnt_exist)
    end

    # THINK ABOUT IT:
    #
    # Why might you want to use #fetch instead of #[] when accessing hash keys?

    # #[] returns nil whereas fetch returns a KeyError, which is a
    # more useful and informative error.
  end

  def test_changing_hashes
    hash = { :one => "uno", :two => "dos" }
    hash[:one] = "eins"

    expected = { :one => 'eins', :two => "dos" }
    assert_equal expected, hash

    # Bonus Question: Why was "expected" broken out into a variable
    # rather than used as a literal?

    # Because Ruby interprets { ... } as a block.
    # So, assert_equal { :one => "eins", :two => "dos" }, hash
    # would not have worked.
  end

  def test_hash_is_unordered
    hash1 = { :one => "uno", :two => "dos" }
    hash2 = { :two => "dos", :one => "uno" }

    assert_equal true, hash1 == hash2
  end

  def test_hash_keys
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.keys.size
    assert_equal true, hash.keys.include?(:one)
    assert_equal true, hash.keys.include?(:two)
    assert_equal Array, hash.keys.class
  end

  def test_hash_values
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.values.size
    assert_equal true, hash.values.include?("uno")
    assert_equal true, hash.values.include?("dos")
    assert_equal Array, hash.values.class
  end

  def test_combining_hashes
    hash = { "jim" => 53, "amy" => 20, "dan" => 23 }
    new_hash = hash.merge({ "jim" => 54, "jenny" => 26 })

    assert_equal true, hash != new_hash

    expected = { "jim" => 54, "amy" => 20, "dan" => 23, "jenny" => 26 }
    assert_equal true, expected == new_hash
  end

  def test_default_value
    hash1 = Hash.new
    hash1[:one] = 1

    assert_equal 1, hash1[:one]
    assert_equal nil, hash1[:two]

    hash2 = Hash.new("dos")
    hash2[:one] = 1

    assert_equal 1, hash2[:one]
    assert_equal 'dos', hash2[:two]
  end

  def test_default_value_is_the_same_object
    # Instantiate a new array with [] and set it as default.
    hash = Hash.new([])
  
    hash[:one] << "uno"
    # The :one key does not exist, so returned is [].
    # << equals to [].push('uno')
    # i.e. pushes 'uno' to the default (which is an array).
    hash[:two] << "dos"
    # The :two key does not exist, so returned is ['uno'] as default was updated.
    # << equals to ['uno'].push('dos')
    # i.e. pushes 'dos' to the default (which is an array).
    # https://stackoverflow.com/questions/35833583/why-does-the-test-default-value-is-the-same-object-in-about-hashes-rb-of-ruby-ko

    assert_equal ['uno', 'dos'], hash[:one]
    assert_equal ['uno', 'dos'], hash[:two]
    assert_equal ['uno', 'dos'], hash[:three]

    assert_equal true, hash[:one].object_id == hash[:two].object_id
  end

  def test_default_value_with_block
    hash = Hash.new {|hash, key| hash[key] = [] }

    hash[:one] << "uno"
    hash[:two] << "dos"

    assert_equal ['uno'], hash[:one]
    assert_equal ['dos'], hash[:two]
    assert_equal [], hash[:three]
  end
end
