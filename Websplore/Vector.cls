VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Vector"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public X As Double
Public Y As Double

Public Sub Create(dX As Double, dY As Double)
    X = dX
    Y = dY
End Sub

Public Function Add(Q As Vector) As Vector
    Set Add = New Vector
    
    Add.X = X + Q.X
    Add.Y = Y + Q.Y
End Function

Public Function Subs(Q As Vector) As Vector
    Set Subs = New Vector
    
    Subs.X = X - Q.X
    Subs.Y = Y - Q.Y
End Function

Public Function Scalar(ByVal S As Double) As Vector
    Set Scalar = New Vector
    
    Scalar.X = X * S
    Scalar.Y = Y * S
End Function

Public Property Get ArrayOf() As Variant
    ArrayOf = Array(X, Y)
End Property

Public Property Get Normal() As Vector
    Set Normal = Scalar(1 / Size())
End Property

Public Function Cross(Q As Vector) As Vector
    Set Cross = New Vector
    Cross.X = Y * Q.X - X * Q.Y
    Cross.Y = X * Q.Y - Y * Q.X
    
    Set Cross = Cross.Scalar(1 / (Size * Q.Size))
End Function

Public Function Size() As Double
    Size = Sqr(X * X + Y * Y)
End Function

Public Property Get Perpendicular() As Vector
    Set Perpendicular = New Vector
    Perpendicular.X = -Y
    Perpendicular.Y = X
End Property

Public Function Equal(A As Vector) As Boolean
    If X = A.X And Y = A.Y Then
        Equal = True
    End If
End Function
