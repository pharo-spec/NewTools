Extension { #name : 'Object' }

{ #category : '*NewTools-Inspector' }
Object >> evaluatorInitialText: aStObjectContextPresenter [ 
	^ '{1}' format: { aStObjectContextPresenter model codeSnippet } 
]
