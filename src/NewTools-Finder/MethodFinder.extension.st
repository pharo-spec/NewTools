Extension { #name : 'MethodFinder' }

{ #category : '*NewTools-Finder' }
MethodFinder >> methodFinderSendClass [

	^ MethodFinderSend
]

{ #category : '*NewTools-Finder' }
MethodFinder >> possibleSolutionsForInput: inputCollection [

	| sends |
	
	sends := OrderedCollection new.
	inputCollection permutationsDo: [ :permutation |
		| foundPermutationSends args receiver |
		args := permutation allButFirst.
		receiver := permutation first.
		foundPermutationSends := 
			(receiver evaluate class allSelectorsToTestInMethodFinderWithArity: inputCollection size - 1) collect: [ : method |
			                         self methodFinderSendClass
				                         receiver: receiver evaluate
				                         selector: method
				                         withArguments: (args collect: #evaluate) ].
		sends addAll: foundPermutationSends ].
	^ sends
]
