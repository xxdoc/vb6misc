VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Relationship"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public FromPos As Position
Public ToPos As Position

Public DiagramRef As Diagram
Public PositionListRef As Collection

Public Colour As Long
Public Description As String
Public AngleIndex As Long
Public LinkType As LinkTypes

Public Enum LinkTypes
    Normal
    Cross1
    Cross2
    Bend1
    Bend2
End Enum

Public Sub RenderRelationship()
    DrawRelationship
End Sub

Public Sub ClearRelationship()
    DrawRelationship DiagramRef.BackColour
End Sub

Public Function WriteDef() As String
    WriteDef = FromPos.Reference & "|" & ToPos.Reference
End Function

Private Sub DrawRelationship(Optional lForeColour As Long = vbBlack)
    Const nSize As Single = 10
    Dim dAngle As Double
    
    Dim nRadius As Single
    Dim nHeight As Single
    
    Dim oVector As New Vector
    Dim oCentre As New Vector
    Dim oStart As New Vector
    Dim oEnd As New Vector
    Dim oCircle1 As New Vector
    Dim oCircle2 As New Vector
    
    Dim nAngle1 As Single
    Dim nAngle2 As Single
    
    Dim pi2 As Double
    Dim nAngle As Single
    
    nAngle = Array(0, 2, 4, 8, -8, -4, -2)(AngleIndex)
    pi2 = Atn(1) * 8
    dAngle = 160 * (Atn(1) * 8) / 360
    
    If lForeColour = 0 Then
        lForeColour = Colour
    End If

    oStart.Create FromPos.PosX + DiagramRef.sTopLeftX, FromPos.PosY + DiagramRef.sTopLeftY
    oEnd.Create ToPos.PosX + DiagramRef.sTopLeftX, ToPos.PosY + DiagramRef.sTopLeftY
    Set oVector = oEnd.Subs(oStart)
    
    If Not oStart.Equal(oEnd) Then
        If nAngle = 0 Then
            DiagramRef.ForeColor = lForeColour
            DiagramRef.DrawWidth = 14
            DiagramRef.Line (DiagramRef.sTopLeftX + FromPos.PosX, DiagramRef.sTopLeftY + FromPos.PosY)-(DiagramRef.sTopLeftX + ToPos.PosX, DiagramRef.sTopLeftY + ToPos.PosY)
            DiagramRef.DrawWidth = 1
            Set oCircle1 = oStart.Add(oVector.Normal.Scalar(5))
            Set oCircle2 = oEnd.Subs(oVector.Normal.Scalar(5))
            
'            DiagramRef.FillColor = DiagramRef.BackColor
'            DiagramRef.Circle (oCircle1.X, oCircle1.Y), FromPos.Radius, DiagramRef.BackColor
'            DiagramRef.Circle (oCircle2.X, oCircle2.Y), ToPos.Radius, DiagramRef.BackColor
        Else
            nRadius = (oVector.Size / Sin(pi2 / CDbl(Abs(nAngle) * 2))) / 2
            If (oVector.Size / 2) < nRadius Then
                nHeight = Sqr(nRadius ^ 2 - (oVector.Size / 2) ^ 2)
            Else
                nHeight = 0
            End If
            Set oCentre = oVector.Scalar(1 / 2).Add(oStart).Add(oVector.Perpendicular.Normal.Scalar(Sgn(nAngle) * nHeight))
            If nAngle > 0 Then
                nAngle2 = Atn2(-(oStart.Y - oCentre.Y), (oStart.X - oCentre.X))
                nAngle1 = Atn2(-(oEnd.Y - oCentre.Y), (oEnd.X - oCentre.X))
            Else
                nAngle1 = Atn2(-(oStart.Y - oCentre.Y), (oStart.X - oCentre.X))
                nAngle2 = Atn2(-(oEnd.Y - oCentre.Y), (oEnd.X - oCentre.X))
            End If
            
            DiagramRef.FillStyle = vbFSTransparent
            DiagramRef.DrawWidth = 14
            On Error Resume Next
            DiagramRef.Circle (oCentre.X, oCentre.Y), nRadius, lForeColour, nAngle1, nAngle2
            DiagramRef.FillStyle = vbFSSolid
            DiagramRef.DrawWidth = 1
        End If
    End If
End Sub

Private Function Atn2(ByVal Y As Double, ByVal X As Double) As Double
    Dim lSegment As Long
    Dim vOffset As Variant
    
    If X = 0 Then
        Atn2 = (2 + (1 - Sgn(Y))) * pi2 / 4
        Exit Function
    End If
    
    vOffset = Array(0, pi2 / 2, pi2 / 2, pi2)
    
    lSegment = (1 - Sgn(X) * Sgn(Y)) \ 2 + (1 - Sgn(Y))
    Atn2 = Atn(Y / X) + CDbl(vOffset(lSegment))
End Function
