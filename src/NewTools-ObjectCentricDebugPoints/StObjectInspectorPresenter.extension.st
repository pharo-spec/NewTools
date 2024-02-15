Extension { #name : 'StObjectInspectorPresenter' }

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StObjectInspectorPresenter >> breakInspectedObjectOnAccess [

	^ self inspectedObject breakOnReadWrite
]

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StObjectInspectorPresenter >> breakInspectedObjectOnRead [

	^ self inspectedObject breakOnRead
]

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StObjectInspectorPresenter >> breakInspectedObjectOnWrite [

	^ self inspectedObject breakOnWrite
]

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StObjectInspectorPresenter >> watchInspectedObjectAccess [

	^ self inspectedObject watchOnReadWrite
]

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StObjectInspectorPresenter >> watchInspectedObjectRead [

	^ self inspectedObject watchOnRead
]

{ #category : '*NewTools-ObjectCentricDebugPoints' }
StObjectInspectorPresenter >> watchInspectedObjectWrite [

	^ self inspectedObject watchOnWrite
]
