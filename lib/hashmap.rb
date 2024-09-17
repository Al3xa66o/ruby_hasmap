class HashMap
  include Enumerable
  attr_accessor :capacity, :bucket, :size

  IN_CAPACITY = 16
  LOAD_FACTOR = 0.75

  def initialize
    @size = 0
    @buckets = Array.new(IN_CAPACITY) { [] }
  end
  
  def hash(key)
    key.hash % @buckets.size
  end


  def each
    @buckets.each do |bucket|
      bucket.each do |pair|
        yield pair[0], pair[1]
      end
    end
  end


  def set(key, value)
  # takes two arguments, the first is a key and the second is a value that is assigned to this key. 
  # If a key already exists, then the old value is overwritten or we can say that we update the key’s value 
  # (e.g. Carlos is our key but it is called twice: once with value I am the old value., and once with value I am the new value.. 
  # From the logic stated above, Carlos should contain only the latter value)
    resize if @size >= (@buckets.size * LOAD_FACTOR)
    index = hash(key)
    bucket = @buckets[index]

    bucket.each do |pair|
      if pair[0] == key
        pair[1] = value
        return
      end
    end
    bucket << [key, value]
    @size += 1
  end

  def resize
    new_capacity = @buckets.size * 2
    new_bucket = Array.new(new_capacity) { [] }

    @buckets.each do |bucket|
      bucket.each do |pair|
        key, value = pair
        new_index = key.hash % new_capacity
        new_bucket[new_index] << [key, value]
      end
    end
    @buckets = new_bucket
  end

  
  def get(key)
  #takes one argument as a key and return the value that is assigned to the key, if the key is not found return nil
    index = hash(key)
    bucket = @buckets[index]

    bucket.each do |pair|
      if pair[0] == key
        return pair[1]
      end
    end
    nil
  end

  def has?(key)
    #takes a key as an argument and return true or false whether or not the key is inside the has map
    !get(key).nil?
  end

  def remove(key)
    #takes a key as an argument. If the given key is in the hash map, it should remove the entry with that key and return the deleted entry’s value. 
    #If the key isn’t in the hash map, it should return nil.
    index = hash(key)
    bucket = @buckets[index]

    bucket.each_with_index do |pair, idx|
      if pair[0] == key
        bucket.delete_at(idx)
        @size -= 1
        return true
      end
    end
    false 
  end

  def length
    #return the number of stored key in the hash map
    @size
  end

  def clear
    #remove all entries in the hash map
    @buckets = Array.new(IN_CAPACITY) { [] }
    @ize = 0
  end

  def keys
    #return an array containig all the value in the hash map
    result = []
    each do |key, _|
      result << key
    end
    result
  end

  def values
    #return an array containing all the value
    result = []
    each do |_, value|
      result << value
    end
    result
  end

  def entries
    #return an array that contain all the value pair(key, value) ex. [[first_key, first_value], [second_key, second_value]]
    result = []
    each do |key, value|
      result << [key, value]
    end
    result
  end

  def capacity
    @buckets.size
  end

end