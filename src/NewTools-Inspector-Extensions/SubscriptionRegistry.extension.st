Extension { #name : 'SubscriptionRegistry' }

{ #category : '*NewTools-Inspector-Extensions' }
SubscriptionRegistry >> inspectionSubscriptions: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Subscriptions'>
	| table |

	^ (table :=  aBuilder newTable)
		addStyle: 'stList';
		items: self subscriptions asOrderedCollection;
		beMultipleSelection;
		addColumn: (SpStringTableColumn
			title: 'Subscriber'
			evaluated: [ :each | each subscriber asString ]);
		addColumn: (SpStringTableColumn
			title: 'Announcement'
			evaluated: [ :each | each announcementClass printString ]);
		addColumn: (SpStringTableColumn
			title: 'Kind'
			evaluated: [ :each | each className ]);
		addActionWith: [ :item | item
			name: 'Remove selected subscription(s)';
			action: [
				table selectedItems do: [ :each | self remove: each ].
				table items: self subscriptions asOrderedCollection ] ];
		yourself
]
