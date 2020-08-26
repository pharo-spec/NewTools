"
I'm a reporter dedicated to size of the system.

```
SpSizeReporter new openWithSpec
```

"
Class {
	#name : #SpSizeReporter,
	#superclass : #SpReporter,
	#instVars : [
		'data'
	],
	#category : #'NewTools-SystemReporter'
}

{ #category : #accessing }
SpSizeReporter >> baselineClassLoc [
	^ data at: #baselineClassLoc ifAbsent: [ self computeLocs ]
]

{ #category : #accessing }
SpSizeReporter >> baselineClasses [

	^ data at: #baselineClasses
]

{ #category : #compute }
SpSizeReporter >> computeLocs [ 

	data at: #manifestClassLoc put:  (self manifestClasses inject: 0 into: [ :sum :each | sum + each linesOfCode]).
	data at: #testClassLoc put: (self testClasses inject: 0 into: [ :sum :each | sum + each linesOfCode]).
	data at: #baselineClassLoc put: (self baselineClasses inject: 0 into: [ :sum :each | sum + each linesOfCode]).
	data at: #imageClassLoc put: (self imageClasses inject: 0 into: [ :sum :each | sum + each linesOfCode]).
	data at: #effectiveClassLoc put: self imageClassLoc - self baselineClassLoc - self manifestClassLoc - self testClassLoc
]

{ #category : #accessing }
SpSizeReporter >> effectiveClassLoc [

	^ data at: #effectiveClassLoc  ifAbsent: [ self computeLocs ]
]

{ #category : #accessing }
SpSizeReporter >> effectiveClassPackages [

	^ data at: #effectiveClassPackages
]

{ #category : #accessing }
SpSizeReporter >> effectiveClasses [

	^ data at: #effectiveClasses
]

{ #category : #'building report' }
SpSizeReporter >> extent [

	^ 600@ 400
]

{ #category : #accessing }
SpSizeReporter >> imageClassLoc [ 
	^ data at: #imageClassLoc  ifAbsent: [ self computeLocs ]
]

{ #category : #accessing }
SpSizeReporter >> imageClassPackages [

	^ data at: #imageClassPackages
]

{ #category : #accessing }
SpSizeReporter >> imageClasses [

	^ data at: #imageClasses
]

{ #category : #initialization }
SpSizeReporter >> initialize [ 
	super initialize.
	data := Dictionary new. 
	data at: #imageClasses put: self class environment allClasses.
	data at: #imageClassPackages put: (self imageClasses collect: [ :each | each package ] as: Set).
	
	data at: #manifestClasses put: (self imageClasses select: [ :each | each isManifest ]).
	data at: #manifestClassPackages put: (self manifestClasses collect: [ :each | each package ] as: Set).
	
	data at: #testClasses put: (self imageClasses select: [ :each | each isTestCase ]).
	data at: #testClassPackages put: (self testClasses collect: [ :each | each package ] as: Set).
	
	data at: #baselineClasses put: (self imageClasses select: [:c | c name beginsWith: 'BaselineOf' ]).
	data at: #baselineClassPackages put: (self baselineClasses collect: [ :each | each package ] as: Set).
	
	data at: #effectiveClasses put: (self imageClasses reject: [ :c | c isManifest or: [ c isTestCase or: [ c name beginsWith: 'BaselineOf' ] ]]).
	data at: #effectiveClassPackages put: (self effectiveClasses collect: [ :each | each package ] as: Set).
	
	topicList selectIndex: 1.
]

{ #category : #accessing }
SpSizeReporter >> manifestClassLoc [

	^ data at: #manifestClassLoc  ifAbsent: [ self computeLocs ]
	
]

{ #category : #accessing }
SpSizeReporter >> manifestClasses [

	^ data at: #manifestClasses
]

{ #category : #utils }
SpSizeReporter >> printNumber: aNumber on: aStream [

	aNumber
		printSeparatedBy: Character space 
		every: 3
		signed: false
		on: aStream
]

{ #category : #'building report' }
SpSizeReporter >> reportLOC: aStream [

	self header: 'Number of LinesOfCode' on: aStream.
	aStream nextPutAll: '# for all classes: '.
	self printNumber: self imageClassLoc on: aStream.
	aStream cr.
	aStream nextPutAll: '# for manifest classes: '.
	self printNumber: self manifestClassLoc on: aStream.
	aStream cr.
	aStream nextPutAll: '# for test classes: '.
	self printNumber: self testClassLoc on: aStream.
	aStream cr.
	aStream nextPutAll: '# for baselines: '.
	self printNumber: self baselineClassLoc on: aStream.
	aStream cr.
	aStream nextPutAll: '# for effective classes: '.
	self printNumber: self imageClassLoc - self baselineClassLoc - self testClassLoc - self manifestClassLoc on: aStream.
	aStream cr.
	

]

{ #category : #'building report' }
SpSizeReporter >> reportNbClasses: aStream [

	self header: 'Number of classes' on: aStream.
	aStream nextPutAll: '# All classes '.
	self printNumber: self imageClasses size on: aStream.
	aStream cr; nextPutAll: '# Tests classes: '.
	self printNumber: self testClasses size on: aStream.
	aStream cr; nextPutAll: '# Manifest classes: '.
	self printNumber: self manifestClasses size on: aStream.
	aStream cr; nextPutAll: '# BaselineOf-s:  '.
	self printNumber: self baselineClasses size on: aStream.
	aStream cr; nextPutAll: '# Effective classes:  '.
	self printNumber: (self imageClasses size - self testClasses size - self manifestClasses size - self baselineClasses size) on: aStream.
		
		
]

{ #category : #'building report' }
SpSizeReporter >> reportNbTraits: aStream [
	| imageTraits |
	imageTraits := self class environment allTraits.
	self header: 'Number of traits' on: aStream.
	aStream 
		nextPutAll: imageTraits size asString; cr ;
		nextPutAll: 'not used: ' ;
		nextPutAll: (imageTraits count: [ :t | t users isEmpty ]) asString; cr

]

{ #category : #'building report' }
SpSizeReporter >> reportSmartInfo: aStream [

	self header: 'Smarter data' on: aStream.
	aStream nextPutAll: 'Analysis foreffective classes'.
	aStream cr.
	aStream nextPutAll: ' i.e., no test, baseline, manifest classes'.
	aStream cr.
	aStream nextPutAll: '# packages: '.
	self printNumber: self effectiveClassPackages size on: aStream.
	aStream cr.
	aStream nextPutAll: '# classes: '.
	self printNumber: self effectiveClasses size on: aStream.
	aStream cr.
	aStream nextPutAll: '# average number of classes per package: '.
	aStream print: (self effectiveClasses size / self effectiveClassPackages size) asFloat rounded.
	aStream cr.
	aStream nextPutAll: '# max number of classes in a package: '.
	aStream print: (self effectiveClassPackages asOrderedCollection max: [ :aPackage | aPackage definedClasses size]).
	aStream cr.
	aStream nextPutAll: '# average number of methods per classes: '.
	aStream print: ((self effectiveClasses inject: 0 into: [ :sum :c | sum + c numberOfMethods ]) / self effectiveClasses size) asFloat rounded.
]

{ #category : #accessing }
SpSizeReporter >> testClassLoc [

	^ data at: #testClassLoc ifAbsent: [ self computeLocs ]
	
]

{ #category : #accessing }
SpSizeReporter >> testClasses [

	^ data at: #testClasses
]

{ #category : #ui }
SpSizeReporter >> title [ 

	^ 'Size reporter'
]

{ #category : #'building report' }
SpSizeReporter >> topicSpec [
	| topics |
	topics := OrderedCollection new.
	topics addAll:  {
		#'# smart report' -> #reportSmartInfo: .
		#'# raw classes' -> #reportNbClasses:  .
		#'# raw traits' -> #reportNbTraits: .
		#'# raw LOC' -> #reportLOC:
		}.
	^ topics
		 
]
