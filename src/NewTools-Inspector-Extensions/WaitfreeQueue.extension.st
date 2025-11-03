Extension { #name : 'WaitfreeQueue' }

{ #category : '*NewTools-Inspector-Extensions' }
WaitfreeQueue >> inspectionItemsOn: builder [
	<inspectorPresentationOrder: 910 title: 'Items'>
	| items |

	items := 	Array streamContents: [ :stream |
		| item count |

		item := dummy.
		count := 0.
		[ 
			item := item next. 
			item == dummy 
				ifFalse: [ stream nextPut: item object ]. 
			item isCircular 
		] whileFalse 
	].

	^ builder newList
		addStyle: 'stList';
		items: items;
		yourself
]
