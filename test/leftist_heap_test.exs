defmodule LeftistHeapTest do
  use ExUnit.Case
  doctest LeftistHeap

  test "find min should return the smallest item" do
    heap = Enum.reduce([3,4,5,2,1,9,4,3], nil, &LeftistHeap.insert/2)
    assert 1 == LeftistHeap.find_min(heap)
  end

  test "delete min should return a new heap without the previous minimum" do
    heap = Enum.reduce([3,4,5,2,1], nil, &LeftistHeap.insert/2)
    assert 1 == LeftistHeap.find_min(heap)
    heap = LeftistHeap.delete_min(heap)
    assert 2 == LeftistHeap.find_min(heap)
    heap = LeftistHeap.delete_min(heap)
    assert 3 == LeftistHeap.find_min(heap)
  end

  test "should raise an exception when asked for min of empty heap" do
    assert_raise LeftistHeap.EmptyHeadException, fn ->
      LeftistHeap.find_min(nil)
    end
  end

  test "should raise an exception when asked to delete min of empty heap" do
    assert_raise LeftistHeap.EmptyHeadException, fn->
      LeftistHeap.delete_min(nil)
    end
  end

  test "is empty should do only be true for empty heaps" do
    not_empty = Enum.reduce([3,4,2], nil, &LeftistHeap.insert/2)
    assert !LeftistHeap.is_empty? not_empty

    assert LeftistHeap.is_empty? nil
  end

  test "should provide a from_list implementation" do
    list = [4, 5, 8, 2, 10, 4, 11]
    heap = LeftistHeap.from_list(list)
    assert LeftistHeap.find_min(heap) == 2
    heap = LeftistHeap.delete_min(heap)
    assert LeftistHeap.find_min(heap) == 4
  end

  @doc """
      (3)                         (4)
     /   \    --merged with--    /   \
   (5)   (6)                   (6)   (5)

          -- should result in --
            (3)
           /   \
         (4)   (5)
        /   \
      (5)   (6)
         \
         (6)
  """
  test "should maintain leftism while merging" do
    left_heap = %LeftistHeap{
      left: %LeftistHeap{item: 5},
      item: 3,
      rank: 1,
      right: %LeftistHeap{item: 6}
    }
    right_heap = %LeftistHeap{
      left: %LeftistHeap{item: 6},
      item: 4,
      rank: 1,
      right: %LeftistHeap{item: 5}
    }

    expected_result = %LeftistHeap{
      left: %LeftistHeap{
        left: %LeftistHeap{item: 5, rank: 1, right: %LeftistHeap{item: 6} },
        item: 4,
        rank: 1,
        right: %LeftistHeap{item: 6}
      },
      item: 3,
      rank: 1,
      right: %LeftistHeap{item: 5}
    }

    assert expected_result == LeftistHeap.merge(left_heap, right_heap)
  end
end
