VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3090
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3090
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   375
      Left            =   3120
      TabIndex        =   2
      Top             =   2160
      Width           =   1215
   End
   Begin VB.TextBox txtOutput 
      Height          =   285
      Left            =   180
      TabIndex        =   1
      Text            =   "Text2"
      Top             =   765
      Width           =   4395
   End
   Begin VB.TextBox txtInput 
      Height          =   285
      Left            =   180
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   180
      Width           =   4335
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
    txtOutput.Text = DecodeNumber(txtInput.Text)
End Sub

Private Sub Form_Load()
    InitialiseParser
End Sub
