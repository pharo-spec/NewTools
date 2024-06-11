Extension { #name : 'FTTreeItem' }

{ #category : '*NewTools-ProfilerUI' }
FTTreeItem >> pathForItemSuchThat: aFullBlockClosure [

	children do: [ :each |
		(each pathForItemSuchThat: aFullBlockClosure)
		ifNotEmpty: [ :path | ^ path ] ].
	^ #()
]
