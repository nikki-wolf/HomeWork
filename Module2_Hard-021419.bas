Attribute VB_Name = "Module2"
Sub Stock()

Dim Yrchg, Prcchg As Long
Dim ticker As String



'Finding the no. of rows containing dataset
Max_row = Cells(ActiveSheet.Rows.Count, 1).End(xlUp).Row - 1
      
'constant labels
curr_tic = 2
row_fix = 2
col_Tic = 1
col_Open = 3
col_close = 6
col_Vol = 7
col_PrtTic = 9
col_PrtYrChg = 10
col_PrtPerChg = 11
col_PrtTotStVol = 12
col_PrtDescrip = 15
col_PrtMaxInc = 15
col_PrtMaxDec = 16
col_MaxTotVol = 17


'Headers
Cells(1, col_PrtTic).Value = "Ticker"
Cells(1, col_PrtDescrip + 1).Value = "Ticker"
Cells(1, col_PrtDescrip + 2).Value = "Value"

Cells(1, col_PrtYrChg).Value = "Yearly Change"
Cells(1, col_PrtPerChg).Value = "Percent Change"
Cells(1, col_PrtTotStVol).Value = "Total Stock Volume"

Cells(2, col_PrtDescrip).Value = "Greatest % Increase"
Cells(3, col_PrtDescrip).Value = "Greatest % Decrease"
Cells(4, col_PrtDescrip).Value = "Greatest Total Volume"

'initialization
ActiveSheet.Cells(curr_tic, col_PrtTic).Value = Cells(row_fix, col_Tic).Value
TotStVol = 0
Open_tic = Cells(row_fix, col_Open)
Yrchg = Cells(row_fix, col_Open) - Open_tic


For i = 0 To Max_row
 
    ticker = Cells(i + row_fix, 1).Value

    If (Cells(i + row_fix + 1, col_Tic).Value <> Cells(i + row_fix, col_Tic).Value) Then
        ActiveSheet.Cells(curr_tic, col_PrtTotStVol).Value = TotStVol
        ActiveSheet.Cells(curr_tic, col_PrtYrChg).Value = Yrchg
        ActiveSheet.Cells(curr_tic, col_PrtPerChg).Value = Perchg
        'format cells
        If Yrchg > 0 Then
            Cells(curr_tic, col_PrtYrChg).Interior.Color = RGB(0, 255, 0)
        Else
            Cells(curr_tic, col_PrtYrChg).Interior.Color = RGB(255, 0, 0)
        End If
        Cells(curr_tic, col_PrtPerChg).NumberFormat = "0.00%"
        
        ' assign new total volume and opening price
        TotStVol = ActiveSheet.Cells(i + row_fix + 1, col_Vol).Value
        Open_tic = Cells(i + row_fix + 1, col_Open)
        
        ' assign next tic and printing
        curr_tic = curr_tic + 1
        ActiveSheet.Cells(curr_tic, col_PrtTic).Value = _
                           Cells(i + row_fix + 1, col_Tic).Value
        ActiveSheet.Cells(curr_tic, col_PrtTotStVol + 1).Value = _
                           Cells(i + row_fix + 1, col_Tic).Value
    Else
        TotStVol = TotStVol + ActiveSheet.Cells(i + row_fix + 1, col_Vol).Value
        Close_tic = Cells(i + row_fix + 1, col_close)
        Yrchg = Close_tic - Open_tic
        If Open_tic <> 0 Then
            Perchg = Yrchg / Open_tic
        Else
            Perchg = 1
        End If

    End If
    
Next i
    
'finding the greatest and print
Dim MaxChg, MinChg, MaxTot As Double
Dim TicMaxChg, TicMinChg, TicMaxTot As String

MaxChg = Application.WorksheetFunction.Max(Range(Cells(2, col_PrtPerChg), _
         Cells(curr_tic, col_PrtPerChg)))
MinChg = Application.WorksheetFunction.Min(Range(Cells(2, col_PrtPerChg), _
         Cells(curr_tic, col_PrtPerChg)))
MaxTot = Application.WorksheetFunction.Max(Range(Cells(2, col_PrtTotStVol), _
         Cells(curr_tic, col_PrtTotStVol)))
          
TicMaxChg = WorksheetFunction.VLookup(MaxChg, Range(Cells(2, col_PrtPerChg), _
         Cells(curr_tic, col_PrtTotStVol + 1)), 3, False)
         
TicMinChg = WorksheetFunction.VLookup(MinChg, Range(Cells(2, col_PrtPerChg), _
         Cells(curr_tic, col_PrtTotStVol + 1)), 3, False)
         
TicMaxTot = WorksheetFunction.VLookup(MaxTot, Range(Cells(2, col_PrtTotStVol), _
         Cells(curr_tic, col_PrtTotStVol + 1)), 2, False)
         
Range(Cells(2, col_PrtTotStVol + 1), Cells(curr_tic, col_PrtTotStVol + 1)) = ""


Cells(row_fix, col_PrtDescrip + 1).Value = TicMaxChg
Cells(row_fix + 1, col_PrtDescrip + 1).Value = TicMinChg
Cells(row_fix + 2, col_PrtDescrip + 1).Value = TicMaxTot

Cells(row_fix, col_PrtDescrip + 2).Value = MaxChg
Cells(row_fix + 1, col_PrtDescrip + 2).Value = MinChg
Cells(row_fix + 2, col_PrtDescrip + 2).Value = MaxTot

'format cells
Cells(row_fix, col_PrtDescrip + 2).NumberFormat = "0.00%"
Cells(row_fix + 1, col_PrtDescrip + 2).NumberFormat = "0.00%"

End Sub
