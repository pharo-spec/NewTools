Extension { #name : #AbstractFileReference }

{ #category : #'*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectorContents [
	<inspectorPresentationOrder: 0 title: 'Contents' if: #isFile> 
	| maxBytes buffer atEnd stringContents displayStream displayString |
	
	maxBytes := 10000.
	
	self binaryReadStreamDo: [ :stream | 
		buffer := stream next: maxBytes.
		atEnd := stream atEnd ].
				
	displayString := [ 
			stringContents := ZnCharacterEncoder utf8 decodeBytes: buffer.
			atEnd 
				ifTrue: [ stringContents ]
				ifFalse: [ stringContents, '  ... truncated ...' ] ]
		on: Error 
		do: [ 
			displayStream := (String new: maxBytes * 5) writeStream.
			buffer hexDumpOn: displayStream max: maxBytes.
			displayString := displayStream contents ].
	
	^ SpCodePresenter new
		withoutSyntaxHighlight;
		text: displayString;
		yourself
]

{ #category : #'*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectorItems [
	<inspectorPresentationOrder: 0 title: 'Items' if: #isDirectory>
	| items |
	
	items := 	self directories, self files.
	self isRoot ifFalse: [ 
		items := items copyWithFirst: self parent ]. 

	^ SpTablePresenter new 
		items: items;
		addColumn: (SpCompositeTableColumn new 
			title: 'Name';
			addColumn: (SpImageTableColumn evaluated: [ :each |
				each isDirectory 
					ifTrue: [ self iconNamed: #glamorousFolder ] 
					ifFalse: [ self iconNamed: #glamorousBrowse ] ]) beNotExpandable;
			addColumn: (SpStringTableColumn evaluated: [ :each | 
				(self isChildOf: each) 
					ifTrue: [ '..' ] 
					ifFalse: [ each basename ]]);
			yourself);
		addColumn: (SpStringTableColumn 
			title: 'Size'
			evaluated: [ :each | 
				[ each humanReadableSize ]
					on: Error 
					do: [ 'N/A' translated ] ]);
		addColumn: (SpStringTableColumn 
			title: 'Creation'
			evaluated: [ :each | 
				[ String streamContents: [ :s | 
					each creationTime printYMDOn: s.
					s nextPut: Character space.
					each creationTime printHMSOn: s ]]
				on: Error 
				do: [ 'N/A' translated  ] ]);
		yourself
]

{ #category : #'*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectorStScript [
	<inspectorPresentationOrder: 0 
		title: 'Script' 
		if: '[ :each | each isFile and: [ each extension = ''st''] ]'>
	
	^ SpCodePresenter new 
		text: (self readStreamDo: #contents);
		yourself
]
