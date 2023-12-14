"
I announce when the profiling results tree changes root
"
Class {
	#name : 'ProfilerResultsTreeRootChangedAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'item'
	],
	#category : 'NewTools-ProfilerUI-Announcements',
	#package : 'NewTools-ProfilerUI',
	#tag : 'Announcements'
}

{ #category : 'accessing' }
ProfilerResultsTreeRootChangedAnnouncement >> item [

	^ item
]

{ #category : 'accessing' }
ProfilerResultsTreeRootChangedAnnouncement >> item: anObject [

	item := anObject
]
