import logging

logging.basicConfig(level=logging.DEBUG)

def hash(data):
    return data

def _get_tree_height(node_index):
    if node_index == 0:
        return 1
    else:
        return node_index.bit_length() + 1

def verifyHash(start, end, data, support_node_hashes, root_hash):
    logging.debug(f"Verifying Merkle proof for range [{start}, {end})")
    # first power of two greater than or equal to end is the (sub-)tree size
    # (number of leaves)
    estimated_tree_height = _get_tree_height(end-1)
    estimated_tree_size = 2 ** (estimated_tree_height-1)
    logging.debug(f"height: {estimated_tree_height}, size: {estimated_tree_size}")
    # levels at which the proof nodes for start are (to the left)): 
    # - we consider how many leaves are there to the left of start
    # - its binary representation captures levels of the tree 
    #   (to the left) needed for the Merkle proof
    num_nodes_to_left = start - 1 + 1
    start_node_proof_levels = bin(num_nodes_to_left)[2:]

    # levels at which the proof nodes for end-1 are (to the right)
    num_nodes_to_right = estimated_tree_size - (end- 1 + 1) 
    end_node_proof_levels = bin(num_nodes_to_right)[2:]

    levels_dict_left = {}
    levels_dict_right = {}

    support_nodes_used = 0
    logging.debug(f"start levels: {start_node_proof_levels}, end levels: {end_node_proof_levels}")

    # we are iterating from the most significant digit downwards
    for digit_place, bit_repr in enumerate(start_node_proof_levels):
        level = len(start_node_proof_levels) - 1 - digit_place 
        if bit_repr == '1':
            levels_dict_left[level] = support_node_hashes[support_nodes_used]
            support_nodes_used += 1

    # now we are iterating from the least significant digit upwards
    for digit_place, bit_repr in enumerate(reversed(end_node_proof_levels)):
        level = digit_place
        if bit_repr == '1':
            levels_dict_right[level] = support_node_hashes[support_nodes_used]
            support_nodes_used += 1

    logging.debug(f"levels_dict_left = {levels_dict_left}, levels_dict_right={levels_dict_right}")
    
    # the dicts (levels_dict_left, levels_dict_right) contain for each level a unique
    # node that is needed to compute the root hash. 

    remaining_support_nodes = support_node_hashes[support_nodes_used:]
    logging.debug(f"remaining support nodes: {remaining_support_nodes}")


    existing_data_hashes = [hash(d) for d in data[start:end]]
    for level in range(estimated_tree_height-1):
        logging.debug(f"level: {level}")
        if level in levels_dict_left:
            existing_data_hashes = [levels_dict_left[level]] + existing_data_hashes
        if level in levels_dict_right:
            existing_data_hashes = existing_data_hashes + [levels_dict_right[level]]
        

        logging.debug(f"existing hashes = {existing_data_hashes}")

        # new_data will be the list of hashes for the next level
        new_data = []
        for i in range(0, len(existing_data_hashes), 2):
            logging.debug(f"hashing {existing_data_hashes[i]} + {existing_data_hashes[i + 1]}")
            new_data.append(hash(existing_data_hashes[i] + existing_data_hashes[i + 1]))
        
        existing_data_hashes = new_data
    
    current_hash = existing_data_hashes[0]
    logging.debug(f"now taking into account remaining support nodes: {remaining_support_nodes}")
    for node_hash in remaining_support_nodes:
        logging.debug(f"hashing {current_hash} + {node_hash}")
        current_hash = hash(current_hash + node_hash)

    logging.debug("root hash: " + current_hash)
    logging.debug(f"\n====\n\n")
    
    return root_hash == current_hash

        


data = ["h", "i", "j", "k", "l", "m", "n", "o"]

assert verifyHash(0,1,data, ["i", "e", "c"],"hiec") == True
assert verifyHash(1,3, data,["h", "k","c"], "hijkc") == True
assert verifyHash(3,5,data, ["d", "j", "m",  "g"],"djklmg") == True
assert verifyHash(5,8,data, ["b", "l"],"blmno") == True
assert verifyHash(2,3,data,["d","k","c"],"djkc") == True