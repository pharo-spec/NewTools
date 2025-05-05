Extension { #name : 'AbstractFileReference' }

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectionCompressedItems [

	<inspectorPresentationOrder: 0 title: 'Compressed Items'>
	| items children root |
	root := (FileSystem zip: self) open workingDirectory.
	children := root directories , root files.
	items := self isRoot
		         ifTrue: [ children ]
		         ifFalse: [
			         children asOrderedCollection
				         addFirst: self parent;
				         yourself ].

	^ SpTablePresenter new
		  items: items;
		  addColumn: (SpCompositeTableColumn new
				   title: 'Name';
				   addColumn: (SpImageTableColumn evaluated: [ :each |
							    self iconNamed: (each isDirectory
										     ifTrue: [ #folder ]
										     ifFalse: [ #browse ]) ]);
				   addColumn: (SpStringTableColumn evaluated: [ :each |
							    self parent = each
								    ifTrue: [ '..' ]
								    ifFalse: [ each basename ] ]));
		  addColumn: (SpStringTableColumn new
				   title: 'Size';
				   evaluated: [ :each | each size ];
				   formatted: [ :size | size humanReadableSISizeString ]);
		  addColumn: (SpStringTableColumn new
				   title: 'Creation';
				   evaluated: [ :each | each creationTime ];
				   formatted: [ :time |
					   [
					   String streamContents: [ :s |
							   time printYMDOn: s.
							   s nextPut: Character space.
							   time printHMSOn: s ] ]
						   on: Error
						   do: [ 'N/A' translated ] ];
				   beSortable)
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectionCompressedItemsContext: aContext [ 
	
	aContext active: self isCompressedFile
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectionContents: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Contents'>
	| maxBytes buffer atEnd stringContents displayStream displayString contentPresenter toolbarPresenter |
	maxBytes := 10000.

	self binaryReadStreamDo: [ :stream |
			buffer := stream next: maxBytes.
			atEnd := stream atEnd ].

	displayString := [
		                 stringContents := ZnCharacterEncoder utf8
			                                   decodeBytes: buffer.
		                 atEnd
			                 ifTrue: [ stringContents ]
			                 ifFalse: [ stringContents , '  ... truncated ...' ] ]
		                 on: Error
		                 do: [
				                 displayStream := (String new: maxBytes * 5)
					                                  writeStream.
				                 buffer hexDumpOn: displayStream max: maxBytes.
				                 displayString := displayStream contents ].

	contentPresenter := aBuilder newCode
		                    withoutSyntaxHighlight;
		                    text: displayString;
		                    whenSubmitDo: [ :text |
				                    self
					                    ensureDelete;
					                    writeStreamDo: [ :s |
						                    s nextPutAll: text asString ] ];
		                    yourself.

	toolbarPresenter := aBuilder newToolbar.
	toolbarPresenter displayMode: aBuilder application toolbarDisplayMode.
	toolbarPresenter add: (toolbarPresenter newToolbarButton
			 icon: (aBuilder application iconNamed: #smallSave);
			 label: 'Save contents';
			 help: 'Save contents of file';
			 action: [
					 self
						 ensureDelete;
						 writeStreamDo: [ :s |
							 s nextPutAll: contentPresenter text asString ] ];
			 yourself).
	toolbarPresenter add: (toolbarPresenter newToolbarButton
			 icon: (aBuilder application iconNamed: #smallDelete);
			 label: 'Delete file';
			 help: 'Delete the file';
			 action: [
					 self ensureDelete.
					 contentPresenter delete ];
			 yourself).

	^ aBuilder newPresenter
		  layout: (SpBoxLayout newTopToBottom
				   add: (SpBoxLayout newLeftToRight
						    hAlignEnd;
						    add: toolbarPresenter;
						    yourself)
				   expand: false;
				   add: contentPresenter;
				   yourself);
		  yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectionContentsContext: aContext [ 
	
	aContext active: self isFile
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectionFuelContext: aContext [ 
	
	aContext active: self isFuel
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectionGif [
	<inspectorPresentationOrder: 0 title: 'Picture'>
	
	^ SpImagePresenter new
		image: (self binaryReadStreamDo: [ :stream | GIFReadWriter formFromStream: stream ]);
		yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectionGifContext: aContext [ 
	
	aContext active: self isImageGif
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectionItems [

	<inspectorPresentationOrder: 0 title: 'Items'>
	| items |
	items := self directories , self files.
	self isRoot ifFalse: [ items := items copyWithFirst: self parent ].

	^ SpTablePresenter new
		  beResizable;
		  items: items;
		  addColumn: (SpCompositeTableColumn new
				   title: 'Name';
				   width: 300;
				   addColumn: (SpImageTableColumn evaluated: [ :each |
							    each isDirectory
								    ifTrue: [ self iconNamed: #folder ]
								    ifFalse: [ self iconNamed: #browse ] ]) beNotExpandable;
				   addColumn: (SpStringTableColumn evaluated: [ :each |
							    (self isChildOf: each)
								    ifTrue: [ '..' ]
								    ifFalse: [ each basename ] ]);
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Size';
				   width: 100;
				   evaluated: [ :each | each size ];
				   formatted: [ :size | size humanReadableSISizeString ];
				   beSortable);
		  addColumn: (SpStringTableColumn new
				   title: 'Creation';
				   evaluated: [ :each | each creationTime ];
				   formatted: [ :time |
					   [
					   String streamContents: [ :s |
							   time printYMDOn: s.
							   s nextPut: Character space.
							   time printHMSOn: s ] ]
						   on: Error
						   do: [ 'N/A' translated ] ];
				   beSortable);
		  yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectionItemsContext: aContext [ 
	
	aContext active: self isDirectory
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectionJpeg [
	<inspectorPresentationOrder: 0 title: 'Picture'>
	
	^ SpImagePresenter new
		image: (self binaryReadStreamDo: [ :stream | ImageReadWriter formFromStream: stream ]);
		yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectionJpegContext: aContext [
	
	aContext active: self isImageJpeg
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectionPng [
	<inspectorPresentationOrder: 0 title: 'Picture'>
	
	^ SpImagePresenter new
		image: (self binaryReadStreamDo: [ :stream | PNGReadWriter formFromStream: stream ]);
		yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectionPngContext: aContext [ 
	
	aContext active: self isImagePng
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectionStScript [
	<inspectorPresentationOrder: 0 title: 'Script'>
	
	^ SpCodePresenter new 
		text: (self readStreamDo: #contents);
		whenSubmitDo: [ :text | 
			self writeStreamDo: [ :s | s nextPutAll: text string ] ];
		yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> inspectionStScriptContext: aContext [ 
	
	aContext active: self isScript
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> isCompressedFile [

	^ #('zip' 'jar' 'ear' 'war' 'mcz') includes: self extension
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> isFuel [

	^ self isFile and: [ self extension = 'fuel' ]
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> isImageGif [

	^ self isFile 
		and: [ self mimeTypes isNotNil 
		and: [ self mimeTypes first matches: ZnMimeType imageGif ] ]
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> isImageJpeg [

	^ self isFile 
		and: [ self mimeTypes isNotNil 
		and: [ self mimeTypes first matches: ZnMimeType imageJpeg ] ]
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> isImagePng [

	^ self isFile 
		and: [ self mimeTypes isNotNil 
		and: [ self mimeTypes first matches: ZnMimeType imagePng ] ]
]

{ #category : '*NewTools-Inspector-Extensions' }
AbstractFileReference >> isScript [
	
	^ self isFile and: [ self extension = 'st' ]
]
