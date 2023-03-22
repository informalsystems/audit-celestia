module basics{

    type BINARY = List[int]
    // hashes will be of type WORD
    type WORD = List[str]

    def binary(n: int) : BINARY =
        if (n == 0)
            [0]
        else
            range(0,n).foldl(
                [],
                (acc, i) => {
                    val c = n / 2^i
                    if (c > 0)
                        [c % 2].concat(acc)
                    else
                        acc
                }
            )
    def getFullTreeSize(lastNode : int) : int =
       if (lastNode == 0)
            1
        else
            2^length(binary(lastNode))
    
    def sum(list: List[int]) : int =
        list.foldl(0, (acc, i) => acc + i)
    
    def min(S: Set[int]) : int = 
        // val tentativeMin = chooseSome(S) ---> chooseSome is not supported yet
        val tentativeMin = -1
        S.fold(tentativeMin, (acc, i) => if ((acc == -1) or (i < acc)) i else acc)

    def listToSet(S: List[int]) : Set[int] = 
        S.foldl(Set(), (acc, i) => acc.union(Set(i)))


    def setToSortedList(S: Set[int]) : List[int] = 
        S.fold(
            [], 
            (acc, i) => acc.concat(
                [min(S.exclude(listToSet(acc)))]
                )
            )

    def max(S: Set[int]) : int = 
        // val tentativeMax = chooseSome(S) --> chooseSome not supported yet
        val tentativeMax = -1
        S.fold(tentativeMax, (acc, i) => if ((tentativeMax == -1) or (i > acc)) i else acc)
    
        
    def Hash(data: WORD) : WORD =
        data

    def reverse(L: List[x]) : List[x] =
        L.foldl([], (acc, i) => [i].concat(acc))

    def getWithDefault(mapX: int -> WORD, key: int, default: WORD) : WORD =
        if (mapX.keys().contains(key))
            mapX.get(key)
        else
            default
    }


module nmt {    
    import basics.*
    

    // ASSUMPTION: each tree is full and complete (2^n leaves at the bottom level)
    
    pure val MAX_POWER = 8
    pure val MAX_NAMESPACE_ID = 100

    var leaves_v : List[DATA_ITEM]

    type NODE_IDX = int

    type TREE = {
        leaves: NODE_IDX -> DATA_ITEM,        
        hashes: NODE_IDX -> NAMESPACE_HASH      
    }

    type NAMESPACE_HASH = {minNS: int, maxNS: int, hash: WORD}
    
    type PROOF = {start: int, end: int, supporting_hashes: List[NAMESPACE_HASH]}

    type DATA = (str, int, int)

    type DATA_ITEM  = {value: DATA, namespaceId: int}

    def getParentIdx(idx : NODE_IDX) : NODE_IDX =
        idx / 2

    def getLeftChildIdx(idx : NODE_IDX) : NODE_IDX =
        2 * idx

    def getRightChildIdx(idx : NODE_IDX) : NODE_IDX =
        2 * idx + 1

    def GenerateLeavesCorrectly(power: int, namespaceBordersSet : Set[int]) : List[DATA_ITEM] =
        // nondet power = oneOf(1.to(MAX_POWER))
        
        // val namespaceBordersSet = 1.to(2^(power-1) - 2).powerset().filter(x => size(x) > 0).oneOf()
        val namespaceBorders = concat(
            concat([0], setToSortedList(namespaceBordersSet)),
            [2^(power-1)]
        )
        

        val generated_leaves = range(0, length(namespaceBorders)-1).foldl(
            [],
            (acc, i) => 
                acc.concat(
                    range(namespaceBorders[i], namespaceBorders[i+1]).foldl(
                        [],
                        (acc2, j) => acc2.concat([{value: ("data",i,j), namespaceId: i*2}])
                        )
                    )
        )

        generated_leaves




    def BuildTree(leaves: List[DATA_ITEM]) : TREE = 
        val leaf_idx_start = 2^(length(binary(length(leaves))) - 1)
        val tree_leaves = range(0, length(leaves)).foldl(
            Map(),
            (acc, i) => acc.put(leaf_idx_start + i, leaves[i])
        )

        val tree_leaves_hashes = range(0, length(leaves)).foldl(
            Map(),
            (acc, i) => 
            acc.put(leaf_idx_start + i, {minNS: leaves[i].namespaceId, maxNS: leaves[i].namespaceId, hash: Hash([leaves[i].value])})
        )

        val tree_hashes = reverse(range(1, leaf_idx_start)).foldl(
            tree_leaves_hashes,
            (acc, i) =>
            acc.put(
                i,
                {
                    minNS: acc.get(getLeftChildIdx(i)).minNS,
                    maxNS: acc.get(getRightChildIdx(i)).maxNS,
                    hash: Hash(
                        concat(
                            acc.get(getLeftChildIdx(i)).hash,
                            acc.get(getRightChildIdx(i)).hash
                        )
                    )
                }
            )  
        )

        {leaves: tree_leaves, hashes: tree_hashes}
    
    def CreateProofNamespace(namespaceId: int, tree: TREE): PROOF =
        val leavesStart = min(tree.leaves.keys())                
        val relevantLeavesKeys = tree.leaves.keys().fold(
            Set(),
            (acc, i) => 
                if (tree.leaves.get(i).namespaceId == namespaceId)
                    union(acc, Set(i))
                else
                    acc            
        )
        val start = min(relevantLeavesKeys)
        val end = max(relevantLeavesKeys)
        
        val binaryLeftLimitDistance = binary(start - leavesStart)
        val binaryRightLimitDistance = binary(2*start-1 - end)
        
        val left_hashes = range(0, length(binaryLeftLimitDistance)).foldl(
            [],
            (acc, i) =>
                if (binaryLeftLimitDistance[i] == 1)
                    acc.concat([tree.hashes[start/2^i - 1]])
                else
                    acc
        )

        val right_hashes = range(0, length(binaryRightLimitDistance)).foldl(
            [],
            (acc, i) =>
                if (binaryRightLimitDistance[i] == 1)
                    [tree.hashes[end/2^i + 1]].concat(acc)
                else
                    acc
        )
            

        {start: start, end: end+1, supporting_hashes: concat(left_hashes, right_hashes)}

       
    def SensibleStartEnd(start: int, end: int, leaves: List[DATA_ITEM]) : bool =
        and {
            start >= 0,            
            start < end
        }

        

    
    def CorrectNamespaceValue(proof: PROOF, namespaceId: int, leaves: List[DATA_ITEM]) : bool =
        val elementsWithWrongId = leaves.select(x => x.namespaceId != namespaceId)        
        length(elementsWithWrongId) == 0
        

    

    def pairwiseHash(dataList: List[WORD]) : List[WORD] =
        if (length(dataList) == 1)
            dataList
        else
            range(0, length(dataList)).foldl(
                [],
                (acc, i) => {
                    if (i % 2 == 0)
                        acc
                    else
                        acc.concat([Hash(concat(
                                dataList[i-1],
                                dataList[i]
                                ))])
                }
            )
        

    
    

    def mergeWithLeftAndRight(left: WORD, middle: List[WORD], right: WORD) : List[WORD] =
        val allTogether = concat(
                concat([left], middle), 
                [right]
                )
        allTogether.select(x => x != [])
       
    
    def MerkleRangeHash(proof: PROOF, leaves: List[DATA_ITEM]) : WORD =
        
        val fullTreeSize = getFullTreeSize(proof.end - 1)
        val binaryLeftLimitDistance = binary(proof.start)
        val binaryRightLimitDistance = binary(fullTreeSize - proof.end)

        // create a mapping levelOfTheTree -> hash. This enables knowing which of the supporting_hashes
        // is used on which level of the tree (from the left side)
        val leftMap = range(0, length(binaryLeftLimitDistance)).foldl(
                Map(),
                (accMap, i) => 
                    // if the bit is 1, then climbing up the tree from the leaf requires this hash
                    if (binaryLeftLimitDistance[i] == 1) 
                        accMap.put(
                            // reversing: because the supporting nodes are given in-order, closer relatives of
                            // the leaf node will come the last
                            length(binaryLeftLimitDistance) - 1 - i, 
                            // adding the first unused of the supporting hashes (hence, key equals to the size of the growing map)
                            proof.supporting_hashes[size(accMap.keys())].hash
                            ) 
                    else 
                        accMap
            )
        // similarly to leftMap, the rightMap holds the mapping of the supporting leaves from the right side of the
        // range
        val rightMap = range(0, length(binaryRightLimitDistance)).foldl(
                Map(),
                (accMap, i) 
                => 
                if (binaryRightLimitDistance[i] == 1) 
                    accMap.put(
                        i, 
                        proof.supporting_hashes[sum(binaryLeftLimitDistance) + size(accMap.keys())].hash
                        ) 
                else 
                    accMap
            )

        val numLeavesUsed = sum(binaryLeftLimitDistance)+sum(binaryRightLimitDistance)
        

        // after the left and right maps are created, the remaining supporting hashes 
        // are the ones that are not used. They are necessarily on the right side of the leaf range
        // and can be treated as a proof path in a regular (non namespaced) Merkle tree
        val remainingSupportNodes = 
            if (numLeavesUsed == length(proof.supporting_hashes)) 
                [] 
            else 
                proof.supporting_hashes.slice(numLeavesUsed,length(proof.supporting_hashes))
        
        // height of the smallest tree which starts at the leaf index 0 and encompasses the whole range
        val treeHeight : int = 
            if (proof.end == 1) 1 else length(binary(proof.end-1)) + 1

        // a list of hashes of the leaves in the [start, end) range
        val leafHashes: List[WORD] = 
            leaves.foldl(
                [],
                (acc, leaf) => acc.append([leaf.value])
                )
        
        val propagatedHashes : List[WORD] = 
            // Fold over the levels of the tree, starting from the leaf level.
            // Progress to the next level by hashing pairs of hashes from the previous level.
            // Each level is half the size of the previous one until finally a list containing a single hash is returned. 
            range(0,treeHeight).foldl(
                leafHashes,
                (acc, i) => pairwiseHash( 
                    mergeWithLeftAndRight(
                        getWithDefault(leftMap, i, []),
                        acc,
                        getWithDefault(rightMap, i, [])
                    )
                )
            )  

        val partialTreeRootHash = pairwiseHash(propagatedHashes)[0]    

        // having computed the partialTreeRootHash, we can now treat the rest of the supporting hashes
        // as a regular Merkle inclusion proof and starting from the `partialTreeRootHash` chain the hashes
        // computation.
        val calculatedRootHash = remainingSupportNodes.foldl(
            partialTreeRootHash,
            (acc, levelHashes) => Hash(acc.append(levelHashes.hash[0]))
        )
        
        calculatedRootHash


    def Completeness(proof: PROOF, namespaceId: int) : bool = 
        val allSupportingNamespaceIds = 
            proof.supporting_hashes.foldl(
                Set(),
                (acc, el) => union(acc, el.minNS.to(el.maxNS))
            )
        
        not(allSupportingNamespaceIds.contains(namespaceId))


    def verifyInclusionProof(proof: PROOF, rootHash: NAMESPACE_HASH, namespaceId: int, leaves: List[DATA_ITEM]) : bool = {
        val dataIndices : List[int] = range(proof.start, proof.end)
        and {            
            SensibleStartEnd(proof.start, proof.end, leaves),            
            CorrectNamespaceValue(proof, namespaceId, leaves),            
            Completeness(proof, namespaceId),
            rootHash.hash == MerkleRangeHash(proof, leaves)
        }
    }
    

    
    action init = {
        // nondet power = oneOf(1.to(MAX_POWER))        
        val power = 4
        nondet namespaceBordersSet = 1.to(2^(power-1) - 2).powerset().filter(x => size(x) > 0).oneOf()
        leaves_v' = GenerateLeavesCorrectly(power, namespaceBordersSet)
        
    }

    action step = {
        leaves_v' = leaves_v
    }

    // action Next = false

    // val sth = true

}