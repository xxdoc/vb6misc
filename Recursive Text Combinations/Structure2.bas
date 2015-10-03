Attribute VB_Name = "Structure"
Option Explicit

Public UniversalList As New Collection

Public Function CreateStructure2(oTree As ParseTree) As ListSet
    Set UniversalList = New Collection
    Set CreateStructure2 = EvaluateLevel0(oTree)
End Function

Private Function EvaluateLevel0(oTree As ParseTree) As ListSet
    Dim oItem As ParseTree
    
    Set EvaluateLevel0 = New ListSet

    For Each oItem In oTree(3).SubTree
        EvaluateLevel0.Members.Add EvaluateLevel1(oItem)
    Next
    
    If oTree(1).Index = 1 Then
        EvaluateLevel0.ListName = oTree(1).Text
        UniversalList.Add EvaluateLevel0
    End If
    If oTree(2).Index = 1 Then
        EvaluateLevel0.ListIndex = oTree(2).Text
    End If
    EvaluateLevel0.ListSetType = Additive
End Function

Private Function EvaluateLevel1(oTree As ParseTree) As ListSet
    Dim oItem As ParseTree
    
    Set EvaluateLevel1 = New ListSet

    For Each oItem In oTree(3).SubTree
        EvaluateLevel1.Members.Add EvaluateLevel2(oItem)
    Next
    
    If oTree(1).Index = 1 Then
        EvaluateLevel1.ListName = oTree(1).Text
        UniversalList.Members.Add EvaluateLevel1
    End If
    If oTree(2).Index = 1 Then
        EvaluateLevel1.ListIndex = oTree(2).Text
    End If
    
    EvaluateLevel1.ListSetType = Multiplicative
End Function

Private Function EvaluateLevel2(oTree As ParseTree) As ListSet
    Select Case oTree.Index
        Case 1 ' Bracketed
            Set EvaluateLevel2 = EvaluateLevel3(oTree(1))
        Case 2 ' identifier
            Set EvaluateLevel2 = New ListSet
            EvaluateLevel2.ListSetType = ListReference
            EvaluateLevel2.TextString = oTree.Text
        Case 3 'text
            Set EvaluateLevel2 = New ListSet
            EvaluateLevel2.ListSetType = Textual
            EvaluateLevel2.TextString = oTree.Text
    End Select
End Function

Private Function EvaluateLevel3(oTree As ParseTree) As ListSet
    Set EvaluateLevel3 = EvaluateLevel0(oTree(1))
End Function
