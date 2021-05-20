Extension { #name : #GlobalVariable }

{ #category : #'*NewTools-Spotter-Extensions' }
GlobalVariable >> spotterClassFor: aStep [
	<stSpotterOrder: 50>
	aStep listProcessor
			title: 'Class';
			allCandidates: [ { self value class }];
			itemIcon: #systemIcon;
			filter: StFilterSubstring
]

{ #category : #'*NewTools-Spotter-Extensions' }
GlobalVariable >> spotterForReferencesFor: aStep [
	<stSpotterOrder: 130>
	aStep listProcessor
			title: 'References';
			allCandidates: [ (SystemNavigation default allReferencesTo: self) collect: [:each | each compiledMethod] ];
			itemName: [ :method | method displayString ];
			filter: StFilterSubstring
]

{ #category : #'*NewTools-Spotter-Extensions' }
GlobalVariable >> stActDefault [
	self value inspect
]
