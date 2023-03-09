---- MODULE nmt ----
EXTENDS 
    Integers,
    Sequences,
    Apalache,
    Variants,
    FiniteSets

\* basics
\*
\* @typeAlias: word = Seq(Int);
\* @typeAlias: value = $word;
\* @typeAlias: nodeId = Int;
\* @typeAlias: namespaceId = Int;
\* @typeAlias: nodeHash = {minNs: $namespaceId, maxNs: $namespaceId, hash: $word};
\* @typeAlias: inclusionProof = {start: Int, end: Int, nodes: Set($nodeId)};
\* @typeAlias: dataIndex = Int;
\* @typeAlias: dataItem = {value: $value, ns: $namespaceId};
\* @typeAlias: tree = {
\*    leaves: $nodeId -> $dataIndex,
\*    left: $nodeId -> $nodeId,
\*    right: $nodeId -> $nodeId,
\*    hashes: $nodeId -> $nodeHash,
\*    root: $nodeId
\*  };
nmt_aliases == TRUE



VARIABLES 
    \* @type: $tree;
    tree,
    \* @type: Seq($dataItem);
    data

\* Never calculating hashes in this spec: we assume that the merkle tree library provides 
\* a good way to calculate the hashes of the nodes.
\* The actual implementation of the function Hash
\* would calculate the hash recursively (from the root to available leaves)
\* 
\* @type: ($nodeId, Set($nodeId)) => $nodeHash;
Hash(node, proofNodes) == 
    
    LET 
    \* @type: $word;
    DUMMY_HASH_VALUE == <<1,1,1,1>> 
    IN
    IF node \in DOMAIN tree.leaves
    THEN
        LET dataItem == data[tree.leaves[node]] IN
        [
            hash |-> DUMMY_HASH_VALUE, 
            minNs |-> dataItem.ns,
            maxNs |-> dataItem.ns
        ]
    ELSE
        LET 
        leftChild == tree.left[node]
        rightChild == tree.right[node]
        IN
        [
            hash |-> DUMMY_HASH_VALUE,
            \* using the assumption that the leaveas are ordered by their namespace,
            \* so the left min would always be smaller
            minNs |-> tree.hashes[leftChild].minNs,
            \* using the assumption that the leaveas are ordered by their namespace,
            \* so the right max would always be bigger
            maxNs |-> tree.hashes[rightChild].minNs
        ]


RECURSIVE MerkleInclusion(_,_,_)


\* @type: (Set($nodeId), $nodeId, $word) => Bool;
MerkleInclusion(proofNodes, root, hashToCheckAgainst) ==
    \* if the root node is among supplied nodes for the proof, and if its hash
    \* matches what we expect, we can stop the recursion and conclude that the proof is valid
    \/ 
        /\ root \in proofNodes
        /\ hashToCheckAgainst = Hash(root, proofNodes).hash

    \* otherwise, if the root is not among proof nodes, we check if its hash can be recursively
    \* calculated (with its childre leading to some of the available proof nodes)
    \/ 
        /\ root \notin proofNodes
        \* ASSUMPTION: the tree is complete, so every node has both children 
        /\ root \in DOMAIN tree.left
        /\ root \in DOMAIN tree.right        
        /\ MerkleInclusion(proofNodes, tree.left[root], Hash(tree.left[root], proofNodes).hash)
        /\ MerkleInclusion(proofNodes, tree.right[root], Hash(tree.left[root], proofNodes).hash)

\* We check if the namespace is anywhere in the range of the proofNodes. If it is,
\* this indicates that the supplied data is not complete for the namespace.
\* (because some of it is under proofNodes, which are by definition not direct ancestors 
\* of the data leaf nodes)
\* 
\* @type: (Set($nodeId), $namespaceId) => Bool;
NamespaceCompleteness(proofNodes, namespace) ==
    ~ (\E node \in proofNodes: namespace \in tree.hashes[node].minNs..tree.hashes[node].maxNs)
    
    

\* @type: ($inclusionProof, Set($nodeId), $namespaceId, $nodeHash) => Bool;
CorrectHashes(proof, leafNodeIndices, namespace, rootHash) ==
    LET 
        all_merkle_nodes == proof.nodes \union leafNodeIndices
    IN
    /\ MerkleInclusion(all_merkle_nodes, tree.root, tree.hashes[tree.root].hash)
    /\ NamespaceCompleteness(proof.nodes, namespace)


\* @type: (Set($dataIndex), $namespaceId) => Bool;
CorrectNamespaceValue(dataIndices, namespace) == 
    LET 
        namespaceValues == {data[i].ns: i \in dataIndices}
    IN
    namespaceValues = {namespace}
    
SensibleStartEnd(startDataIndex, endDataIndex) ==
    /\ startDataIndex \in DOMAIN data
    /\ endDataIndex \in DOMAIN data
    /\ startDataIndex <= endDataIndex

\* @type: ($inclusionProof, $namespaceId, $nodeHash) => Bool;
VerifyInclusionProof(proof, namespace, rootHash) ==
    LET 
        tla_start == proof.start + 1
        tla_end == proof.end -1
        dataIndices == tla_start..tla_end
        \* leafNodesIndices == {nodeIndex \in DOMAIN tree.hashes: tree.leaves[nodeIndex] \in dataIndices }
        leafNodesIndices == {nodeIndex \in DOMAIN tree.hashes: tree.leaves[nodeIndex] \in dataIndices }
    IN   
    /\ SensibleStartEnd(tla_start, tla_end) 
    /\ CorrectNamespaceValue(dataIndices, namespace)
    /\ CorrectHashes(proof, leafNodesIndices, namespace, rootHash)
    





====