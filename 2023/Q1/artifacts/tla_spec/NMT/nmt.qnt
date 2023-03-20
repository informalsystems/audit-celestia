module nmt {

    

    // a representation of a word in the vocabulary
    type WORD = List[str]

    type NAMESPACE_HASH = {minNS: int, maxNS: int, hash: WORD}
    
    type PROOF = {start: int, end: int, supporting_hashes: List[NAMESPACE_HASH]}

    type DATA = str

    type DATA_ITEM  = {value: DATA, namespaceId: int}

    type BINARY = List[int]

    // var leaves: List[DATA_ITEM]
    
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

        


   
   
    
    
    
    
    // TODO: this is a stub
    def SensibleStartEnd(start: int, end: int) : bool =
        true

    // TODO: this is a stub
    def CorrectNamespaceValue(namespaceId: int, dataIndices: List[int]) : bool =
        true

    def getFullTreeSize(lastNode : int) : int =
       if (lastNode == 0)
            1
        else
            2^length(binary(lastNode))
    
    def sum(list: List[int]) : int =
        list.foldl(0, (acc, i) => acc + i)

    
        
    def Hash(data: WORD) : WORD =
        data

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
                        acc.concat([Hash(dataList[i-1].concat(dataList[i]))])
                }
            )
        

    def getWithDefault(mapX: int -> WORD, key: int, default: WORD) : WORD =
        if (mapX.keys().contains(key))
            mapX.get(key)
        else
            default

    def mergeWithLeftAndRight(left: WORD, middle: List[WORD], right: WORD) : List[WORD] =
       if (length(left) == 0 and length(right) == 0)
            middle
        else if (length(left) == 0)
            middle.concat([right])
        else if (length(right) == 0)
            [left].concat(middle)
        else
            [left].concat(middle).concat([right])

    // todo: this is a stub
    def MerkleInclusion(proof: PROOF, rootHash: WORD, leaves: List[DATA_ITEM]) : bool =
        
        val fullTreeSize = getFullTreeSize(proof.end - 1)
        val binaryLeftEndDistance = binary(proof.start)
        val binaryRightEndDistance = binary(fullTreeSize - proof.end)

        val leftMap = range(0, length(binaryLeftEndDistance)).foldl(
                Map(),
                (accMap, i) => 
                    if (binaryLeftEndDistance[i] == 1) 
                        accMap.put(
                            length(binaryLeftEndDistance) - 1 - i, 
                            proof.supporting_hashes[size(accMap.keys())].hash
                            ) 
                    else 
                        accMap
            )
        val rightMap = range(0, length(binaryRightEndDistance)).foldl(
                Map(),
                (accMap, i) 
                => 
                if (binaryRightEndDistance[i] == 1) 
                    accMap.put(
                        i, 
                        proof.supporting_hashes[sum(binaryLeftEndDistance) + size(accMap.keys())].hash
                        ) 
                else 
                    accMap
            )
        val leavesUsed = sum(binaryLeftEndDistance)+sum(binaryRightEndDistance)

        val remainingSupportNodes = 
            if (leavesUsed == length(proof.supporting_hashes)) 
                [] 
            else 
                proof.supporting_hashes.slice(leavesUsed,length(proof.supporting_hashes))
        
        val treeHeight = if (proof.end == 1) 1 else length(binary(proof.end)) + 1
        val leafHashes: List[WORD] = range(proof.start, proof.end).foldl(
            [],
            (acc, i) => acc.append([leaves[i-proof.start].value])
            )
        
        val propagatedHashes = range(0,treeHeight).foldl(
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

        val calculatedRootHash = remainingSupportNodes.foldl(
            partialTreeRootHash,
            (acc, levelHashes) => acc.append(levelHashes.hash[0])
        )
        
        calculatedRootHash == rootHash
    
    // TODO: this is a stub
    def Completeness(proof: PROOF, namespaceId: int) : bool = 
        true

    def verifyInclusionProof(proof: PROOF, rootHash: WORD, namespaceId: int) : bool = {
        val dataIndices : List[int] = range(proof.start, proof.end)
        and {            
            SensibleStartEnd(proof.start, proof.end),            
            CorrectNamespaceValue(namespaceId, dataIndices),
            // MerkleInclusion(proof, rootHash),
            Completeness(proof, namespaceId)
        }
    }
    
    
    // action Init = false

    // action Next = false

    // val sth = true

}