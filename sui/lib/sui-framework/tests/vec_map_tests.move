// Copyright (c) 2022, Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

#[test_only]
module sui::vec_map_tests {
    use std::vector;
    use sui::vec_map::{Self, VecMap};

    #[test]
    #[expected_failure(abort_code = 0)]
    fun duplicate_key_abort() {
        let m = vec_map::empty();
        vec_map::insert(&mut m, 1, true);
        vec_map::insert(&mut m, 1, false);    
    }

    #[test]
    #[expected_failure(abort_code = 1)]
    fun nonexistent_key_get() {
        let m = vec_map::empty();
        vec_map::insert(&mut m, 1, true);
        let k = 2;
        let _v = vec_map::get(&m, &k);
    }

    #[test]
    #[expected_failure(abort_code = 1)]
    fun nonexistent_key_get_idx_or_abort() {
        let m = vec_map::empty();
        vec_map::insert(&mut m, 1, true);
        let k = 2;
        let _idx = vec_map::get_idx(&m, &k);
    }

    #[test]
    #[expected_failure(abort_code = 1)]
    fun nonexistent_key_get_entry_by_idx() {
        let m = vec_map::empty();
        vec_map::insert(&mut m, 1, true);
        let k = 2;
        let _idx = vec_map::get_idx(&m, &k);
    }

    #[test]
    #[expected_failure(abort_code = 2)]
    fun destroy_non_empty() {
        let m = vec_map::empty();
        vec_map::insert(&mut m, 1, true);
        vec_map::destroy_empty(m)
    }

    #[test]
    fun destroy_empty() {
        let m: VecMap<u64, u64> = vec_map::empty();
        assert!(vec_map::is_empty(&m), 0);
        vec_map::destroy_empty(m)
    }

    #[test]
    fun smoke() {
        let m = vec_map::empty();
        let i = 0;
        while (i < 10) {
            let k = i + 2;
            let v = i + 5;
            vec_map::insert(&mut m, k, v);
            i = i + 1;
        };
        assert!(!vec_map::is_empty(&m), 0);
        assert!(vec_map::size(&m) == 10, 1);
        let i = 0;
        // make sure the elements are as expected in all of the getter APIs we expose
        while (i < 10) {
            let k = i + 2;
            assert!(vec_map::contains(&m, &k), 2);
            let v = *vec_map::get(&m, &k);
            assert!(v == i + 5, 3);
            assert!(vec_map::get_idx(&m, &k) == i, 4);
            let (other_k, other_v) = vec_map::get_entry_by_idx(&m, i);
            assert!(*other_k == k, 5);
            assert!(*other_v == v, 6);
            i = i + 1;
        };
        // remove all the elements
        let (keys, values) = vec_map::into_keys_values(copy m);
        let i = 0;
        while (i < 10) {
            let k = i + 2;
            let (other_k, v) = vec_map::remove(&mut m, &k);
            assert!(k == other_k, 7);
            assert!(v == i + 5, 8);
            assert!(*vector::borrow(&keys, i) == k, 9);
            assert!(*vector::borrow(&values, i) == v, 10);

            i = i + 1;
        }
    }

}
