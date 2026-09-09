"
This filter removes all changes that happened before the most recent image snapshot.
"
Class {
	#name : 'EpSinceLastSnapshotCodeChangeFilter',
	#superclass : 'EpFilter',
	#instVars : [
		'lastSnapshotNumber'
	],
	#category : 'NewTools-Epicea-Filters',
	#package : 'NewTools-Epicea',
	#tag : 'Filters'
}

{ #category : 'accessing' }
EpSinceLastSnapshotCodeChangeFilter class >> title [
	^'Since last snapshot'
]

{ #category : 'comparing' }
EpSinceLastSnapshotCodeChangeFilter >> = anObj [
	^self class = anObj class
]

{ #category : 'filtering' }
EpSinceLastSnapshotCodeChangeFilter >> accepts: anOmEntry [

	| localNumber |
	
	lastSnapshotNumber ifNil:[^true].
	anOmEntry content isCodeChange ifFalse: [ ^ false ].

	localNumber:=(anOmEntry tagAt: #self) localName asInteger . 
	^localNumber > lastSnapshotNumber
]

{ #category : 'accessing' }
EpSinceLastSnapshotCodeChangeFilter >> comment [
	^self class comment
]

{ #category : 'comparing' }
EpSinceLastSnapshotCodeChangeFilter >> hash [
	^self class hash
]

{ #category : 'filtering' }
EpSinceLastSnapshotCodeChangeFilter >> logBrowserModel: anEpLogBrowserModel [

	lastSnapshotNumber:= anEpLogBrowserModel log mostRecentSnaphotLocalNumber
]

{ #category : 'accessing' }
EpSinceLastSnapshotCodeChangeFilter >> title [
	
	^self class title
]
