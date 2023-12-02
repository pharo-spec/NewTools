Extension { #name : 'RBClassEnvironment' }

{ #category : '*NewTools-Scopes' }
RBClassEnvironment >> addPackage: aPackage [
	^ self
]

{ #category : '*NewTools-Scopes' }
RBClassEnvironment >> removePackage: aSymbol [
	^ self
]

{ #category : '*NewTools-Scopes' }
RBClassEnvironment >> asScopeNode [

	^ ScopeClassNode on: self
]
